import gleam/list
import gleam/option.{type Option, None, Some}

pub type Zip(a) {
  Zip(prev: List(a), active: Option(a), next: List(a))
}

pub fn from_list(items: List(a)) -> Zip(a) {
  Zip(prev: [], active: None, next: items)
}

pub fn next(zipper: Zip(a)) -> Zip(a) {
  case zipper {
    Zip(active: None, next: [], ..) -> zipper
    Zip(prev:, active: None, next: [new, ..next]) ->
      Zip(prev:, active: Some(new), next:)

    Zip(prev:, active: Some(active), next: []) ->
      Zip(prev: [active, ..prev], active: None, next: [])
    Zip(prev:, active: Some(active), next: [new, ..next]) ->
      Zip(prev: [active, ..prev], active: Some(new), next:)
  }
}

pub fn advance(zip: Zip(a), until should_stop: fn(a) -> Bool) -> Zip(a) {
  case zip {
    // We're at the beginning of the zipper and nothing has been selected yet.
    // So we need to advance to the first item, then we'll check if we can keep
    // going.
    Zip(active: None, next: [_, ..], ..) ->
      advance(next(zip), until: should_stop)
    // We've reached the end of the zipper, we can't advance any further.
    Zip(active: None, next: [], ..) -> zip
    // We check if we can advance, if we can't we return the active zipper
    Zip(active: Some(active), ..) ->
      case should_stop(active) {
        False -> advance(next(zip), until: should_stop)
        True -> zip
      }
  }
}

pub fn active(zip: Zip(a)) -> Result(a, Nil) {
  case zip.active {
    Some(value) -> Ok(value)
    None -> Error(Nil)
  }
}

pub fn map_active(zip: Zip(a), fun: fn(a) -> a) -> Zip(a) {
  case zip {
    Zip(active: Some(active), ..) -> Zip(..zip, active: Some(fun(active)))
    Zip(active: None, ..) -> zip
  }
}

pub fn fold(zip: Zip(a), acc: acc, fun: fn(acc, Bool, a) -> acc) -> acc {
  let Zip(prev:, active:, next:) = zip
  let acc =
    list.reverse(prev)
    |> list.fold(acc, fn(acc, item) { fun(acc, False, item) })

  let acc = case active {
    Some(active) -> fun(acc, True, active)
    None -> acc
  }

  list.fold(next, acc, fn(acc, item) { fun(acc, False, item) })
}

pub fn replace_active(zip: Zip(a), value: a) -> Zip(a) {
  case zip {
    Zip(active: None, ..) -> zip
    Zip(active: Some(_), ..) -> Zip(..zip, active: Some(value))
  }
}

pub fn reset(zip: Zip(a)) -> Zip(a) {
  let Zip(prev:, active:, next:) = zip
  let next = case active {
    Some(active) -> list.reverse(prev) |> list.append([active, ..next])
    None -> list.reverse(prev) |> list.append(next)
  }
  Zip(prev: [], active: None, next:)
}
