import * as $gleam from "./gleam.mjs";

export function new_(language) {
  let recognition = null;

  try {
    recognition = new SpeechRecognition();
  } catch {
    try {
      recognition = new webkitSpeechRecognition();
    } catch {}
  }

  if (recognition === null) {
    return $gleam.Result$Error(undefined);
  } else {
    recognition.lang = language;
    recognition.interimResults = true;
    recognition.onerror = (event) => {
      console.log(event);
    };
    return $gleam.Result$Ok(recognition);
  }
}

export function start(recognition) {
  try {
    recognition.start();
  } catch {}
  return undefined;
}

export function stop(recognition) {
  try {
    recognition.stop();
  } catch {}
  return undefined;
}

export function on_start(recognition, fun) {
  recognition.onstart = (_) => fun();
  return undefined;
}

export function on_end(recognition, fun) {
  recognition.onend = (_) => fun();
  return undefined;
}

export function on_result(recognition, fun) {
  recognition.onresult = (event) => {
    console.log(event);
    const result = event.results[0]?.[0]?.transcript;
    if (result) fun(result);
  };
  return undefined;
}
