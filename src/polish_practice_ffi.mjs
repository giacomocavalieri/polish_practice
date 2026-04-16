export function do_read(message, on_start, on_end) {
  const synthesis = window.speechSynthesis;
  if (!synthesis) return;

  const spoken_message = new SpeechSynthesisUtterance(message);
  spoken_message.lang = "PL-pl";
  spoken_message.onstart = () => on_start();
  spoken_message.onend = () => on_end();
  spoken_message.onerror = () => on_end();
  synthesis.speak(spoken_message);
  return undefined;
}

export function do_capture_document_keys(call) {
  window.onkeydown = (event) => {
    if (!event.ctrlKey && !event.shiftKey && !event.metaKey) {
      call(event.key);
    }
  };
  return undefined;
}

export function do_stop_reading() {
  window.speechSynthesis.cancel();
  return undefined;
}
