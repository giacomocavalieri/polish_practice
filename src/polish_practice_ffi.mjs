export function do_read(message, on_start, on_end) {
  const synthesis = window.speechSynthesis;
  if (!synthesis) return;

  const spoken_message = new SpeechSynthesisUtterance(message);
  spoken_message.lang = "pl-PL";
  spoken_message.onstart = () => on_start();
  spoken_message.onend = () => on_end();
  synthesis.cancel();
  synthesis.speak(spoken_message);
  synthesis.resume();
  return undefined;
}

export function do_stop_reading() {
  window.speechSynthesis.cancel();
}

export function do_pause_reading() {
  window.speechSynthesis.pause();
}

export function do_resume_reading() {
  window.speechSynthesis.resume();
}
