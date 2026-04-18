import gleam/dynamic/decode
import gleam/list
import icon
import lesson.{type Lesson}
import lustre
import lustre/attribute.{type Attribute}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import zip.{type Zip}

pub fn main() -> Nil {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "body", Nil)
  Nil
}

// ------ MODEL ----------------------------------------------------------------

type Model {
  Model(
    lessons: Zip(#(Lesson, LessonState)),
    hide_sentence: Bool,
    speaking: SpeakingState,
  )
}

type LessonState {
  NotStarted
  Loading
  Started(current_sentence: String, rest: List(String))
  Completed
}

type SpeakingState {
  NeverStarted
  Paused
  Playing
  Finished
}

fn init(_nil: Nil) -> #(Model, Effect(Message)) {
  let model =
    Model(
      speaking: NeverStarted,
      hide_sentence: True,
      lessons: lesson.all()
        |> list.map(fn(lesson) { #(lesson, NotStarted) })
        |> zip.from_list(),
    )
  #(model, effect.none())
}

/// Returns the titles of all the model's lessons, in the same order with which
/// they were created.
fn lesson_titles(model: Model) -> List(String) {
  zip.fold(model.lessons, [], fn(acc, _selected, item) {
    let #(lesson, _lesson_state) = item
    [lesson.name, ..acc]
  })
  |> list.reverse
}

/// Replaces the state of the currently active lesson (if any) with the given
/// one.
fn set_lesson_state(model: Model, state: LessonState) -> Model {
  let lessons =
    zip.map_active(model.lessons, fn(active) {
      let #(lesson, _state) = active
      #(lesson, state)
    })

  Model(..model, lessons:)
}

/// This changes the active lesson to the one with the given title (if any),
/// its state is not changed at all, the lesson is just made active, so if you
/// want to shuffle it again if have to make sure you do!
fn select_lesson(model: Model, titled title: String) -> Model {
  let lessons =
    zip.reset(model.lessons)
    |> zip.advance(until: fn(item) {
      let #(lesson, _lesson_state) = item
      lesson.name == title
    })

  Model(..model, hide_sentence: True, lessons:)
}

/// If there's an active started lesson, this goes to the next sentence that
/// needs studying. If there's no sentences left in the lesson, then it is
/// marked as complete.
fn advance_to_next_sentence(model: Model) -> Model {
  let lessons =
    zip.map_active(model.lessons, fn(active) {
      let #(lesson, state) = active
      case state {
        // There's no sentence to advance to. Nothing changes.
        NotStarted | Loading | Completed -> active
        // We've ran out of sentences, the lesson is complete!
        Started(rest: [], ..) -> #(lesson, Completed)
        // There's another sentence, we advance to that.
        Started(rest: [next, ..rest], ..) -> {
          #(lesson, Started(current_sentence: next, rest:))
        }
      }
    })

  Model(..model, hide_sentence: True, lessons:)
}

/// Returns true if the currently active lesson needs some shuffling before it
/// can be studied. This is the case if the lesson has not started yet,
/// shuffling is not needed if the lesson is only partly complete and there's
/// still guesses to have!
fn active_lesson_needs_shuffling(model: Model) -> Bool {
  case zip.active(model.lessons) {
    // There's no active lesson at all!
    Error(_) -> False
    // The lesson is loading already, or is being completed, no need to shuffle
    // it again.
    Ok(#(_lesson, Loading)) -> False
    Ok(#(_lesson, Started(..))) -> False
    // The lesson hasn't started yet, or was completed. We have to shuffle its
    // sentences so they're in a new unpredictable order.
    Ok(#(_lesson, NotStarted)) -> True
    Ok(#(_lesson, Completed)) -> True
  }
}

// ------ UPDATE ---------------------------------------------------------------

type Message {
  LessonSentencesShuffled(sentences: List(String))
  UserClickedStartOverButton
  UserPickedLesson(String)
  UserClickedBack
  SynthesisStartedReading
  SynthesisFinishedReading
  UserClickedPauseButton
  UserClickedPlayButton
  UserClickedAdvanceButton
  UserClickedShowButton
}

fn update(model: Model, message: Message) -> #(Model, Effect(Message)) {
  case message {
    // The lesson's sentences are ready to be displayed in a random order, it
    // should never happen that there's no sentence at all, in that case we just
    // do nothing.
    LessonSentencesShuffled(sentences: []) -> #(model, effect.none())
    LessonSentencesShuffled(sentences: [current_sentence, ..rest]) -> {
      let model = set_lesson_state(model, Started(current_sentence:, rest:))
      let effect = read_current_sentence(model)
      #(model, effect)
    }

    // We need to go back to the main menu if a lesson is selected.
    UserClickedBack -> {
      let model = Model(..model, lessons: zip.reset(model.lessons))
      let effect = stop_reading()
      #(model, effect)
    }

    // The user has chosen a lesson from the picker, we need to set it as the
    // active one.
    UserPickedLesson(lesson) -> {
      let model = select_lesson(model, titled: lesson)
      case active_lesson_needs_shuffling(model) {
        // If the lesson needs shuffling we shuffle it and wait for the shuffle
        // to be complete.
        True -> {
          let model = set_lesson_state(model, Loading)
          let effect = shuffle_lesson_sentences(model)
          #(model, effect)
        }
        // Otherwise we just resume the lesson from where it stopped, reading
        // the current sentence.
        False -> {
          let effect = read_current_sentence(model)
          #(model, effect)
        }
      }
    }

    // If the user decides to start over we need to reshuffle the current
    // lesson's sentences, while we do that the lesson will be "Loading".
    UserClickedStartOverButton -> {
      let model = set_lesson_state(model, Loading)
      let effect = shuffle_lesson_sentences(model)
      #(model, effect)
    }

    UserClickedShowButton -> {
      let model = Model(..model, hide_sentence: False)
      #(model, effect.none())
    }

    // When we advance to the next sentence we make sure we start reading that
    // right away.
    UserClickedAdvanceButton -> {
      let model = advance_to_next_sentence(model)
      let model = Model(..model, speaking: NeverStarted)
      let effect = read_current_sentence(model)
      #(model, effect)
    }

    // When the speech synthesis actually starts or ends talking we'll receive
    // a message.
    SynthesisStartedReading -> {
      let model = Model(..model, speaking: Playing)
      #(model, effect.none())
    }
    SynthesisFinishedReading -> {
      let model = Model(..model, speaking: Finished)
      #(model, effect.none())
    }

    // Depending if we're playing already or not we might have to start speaking
    // from scratch, or just resume the current sentence.
    UserClickedPlayButton -> {
      let new_model = Model(..model, speaking: Playing)
      let effect = case model.speaking {
        NeverStarted | Finished -> read_current_sentence(model)
        Paused -> resume_reading()
        Playing -> effect.none()
      }
      #(new_model, effect)
    }

    UserClickedPauseButton -> {
      let model = Model(..model, speaking: Paused)
      #(model, pause_reading())
    }
  }
}

// ------EFFECTS ---------------------------------------------------------------

/// Effect to shuffle the sentences of the currently active lesson, so that they
/// can be presentend in a random order.
fn shuffle_lesson_sentences(model: Model) -> Effect(Message) {
  case zip.active(model.lessons) {
    Error(_) -> effect.none()
    Ok(#(lesson, _)) -> {
      use dispatch <- effect.from
      LessonSentencesShuffled(list.shuffle(lesson.sentences))
      |> dispatch
    }
  }
}

/// Effect that uses the speech synthesis API to read the current sentence of
/// the currently active lesson out loud.
fn read_current_sentence(model: Model) -> Effect(Message) {
  case zip.active(model.lessons) {
    Ok(#(_, NotStarted)) | Ok(#(_, Completed)) | Error(_) | Ok(#(_, Loading)) ->
      effect.none()
    Ok(#(_, Started(current_sentence:, ..))) -> {
      use dispatch <- effect.from
      do_read(
        current_sentence,
        on_start: fn() { dispatch(SynthesisStartedReading) },
        on_end: fn() { dispatch(SynthesisFinishedReading) },
      )
    }
  }
}

@external(javascript, "./polish_practice_ffi.mjs", "do_read")
fn do_read(
  sentence: String,
  on_start on_start: fn() -> a,
  on_end on_end: fn() -> b,
) -> Nil

fn pause_reading() -> Effect(Message) {
  use _dispatch <- effect.from
  do_pause_reading()
}

@external(javascript, "./polish_practice_ffi.mjs", "do_pause_reading")
fn do_pause_reading() -> Nil

fn resume_reading() -> Effect(Message) {
  use _dispatch <- effect.from
  do_resume_reading()
}

@external(javascript, "./polish_practice_ffi.mjs", "do_resume_reading")
fn do_resume_reading() -> Nil

fn stop_reading() -> Effect(Message) {
  use _dispatch <- effect.from
  do_stop_reading()
}

@external(javascript, "./polish_practice_ffi.mjs", "do_stop_reading")
fn do_stop_reading() -> Nil

// ------ VIEW -----------------------------------------------------------------

fn view(model: Model) -> Element(Message) {
  case zip.active(model.lessons) {
    Error(_) -> intro_view(model)
    Ok(#(lesson, state)) -> lesson_view(model, lesson, state)
  }
}

/// This shows a little introductory explanation and a picker to select a lesson
/// and start practicing it.
fn intro_view(model: Model) -> Element(Message) {
  html.main([attribute.class("stack large")], [
    html.h1([], [html.text("Polish practice")]),
    html.div([attribute.class("stack regular")], [
      html.p([], [
        html.text(
          "
Hello! This is a website to help me with Polish listening.
Each lesson consists of a series of sentences, listen to a sentence and try and
understand its meaning.
Once you're done you can press the space bar to reveal it and go to the next
one.",
        ),
      ]),
      lesson_picker(model),
    ]),
  ])
}

fn lesson_picker(model: Model) -> Element(Message) {
  let first_option =
    html.option(
      [attribute.selected(True), attribute.disabled(True)],
      "pick a lesson",
    )
  let lesson_options =
    list.map(lesson_titles(model), fn(title) {
      html.option([attribute.value(title)], title)
    })

  html.select([event.on_change(UserPickedLesson)], [
    first_option,
    ..lesson_options
  ])
}

/// This is finally showing something interesting! We will be displaying the
/// currently active lesson, the sentence to guess and some controls.
fn lesson_view(
  model: Model,
  lesson: Lesson,
  state: LessonState,
) -> Element(Message) {
  html.div([attribute.class("stack large")], [
    html.div([attribute.class("stack extra-small")], [
      html.nav([], [
        html.a([event.on_click(UserClickedBack)], [
          html.text("← back"),
        ]),
      ]),
      html.h1([], [html.text(lesson.name)]),
    ]),
    html.main([], [
      case state {
        NotStarted -> panic as "trying to show a lesson that hasn't started"
        Loading -> html.p([], [html.text("Preparing the lesson...")])
        Completed -> html.p([], [html.text("Well done!")])
        Started(current_sentence:, ..) -> sentence_card(current_sentence, model)
      },
    ]),
  ])
}

fn sentence_card(sentence: String, model: Model) -> Element(Message) {
  let text = case model.hide_sentence {
    True -> "listen and repeat"
    False -> sentence
  }

  let playback_button = case model.speaking {
    NeverStarted | Paused | Finished ->
      icon_button(icon.play, UserClickedPlayButton)
    Playing -> icon_button(icon.pause, UserClickedPauseButton)
  }
  let flip_button = case model.hide_sentence {
    False -> icon_button(icon.circle_check, UserClickedAdvanceButton)
    True -> icon_button(icon.eye, UserClickedShowButton)
  }

  html.div(
    [
      attribute.class("card with-sidebar"),
      attribute.classes([#("unrevealed", model.hide_sentence)]),
      case model.speaking {
        Playing -> attribute.class("blocked")
        NeverStarted | Paused | Finished -> attribute.none()
      },
    ],
    [
      html.p([], [html.text(text)]),
      html.div([attribute.class("stack inline extra-small")], [
        playback_button,
        flip_button,
      ]),
    ],
  )
}

fn icon_button(
  icon: fn(List(Attribute(msg))) -> Element(msg),
  message: msg,
) -> Element(msg) {
  icon([
    attribute.tabindex(0),
    attribute.role("button"),
    attribute.class("large"),
    event.on_click(message),
    event.on("keydown", {
      use key <- decode.field("key", decode.string)
      case key {
        " " | "Enter" -> decode.success(message)
        _ -> decode.failure(message, "key")
      }
    }),
  ])
}
