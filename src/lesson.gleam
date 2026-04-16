pub type Lesson {
  Lesson(name: String, sentences: List(String))
}

pub fn all() -> List(Lesson) {
  [one(), two(), three()]
}

fn one() -> Lesson {
  Lesson("Lekcjia 1", sentences: [
    "Jak masz na imię?",
    "Mam na imię Marek, mieszkam w Krakowie",
    "Gdzie teraz mieszkasz? Teraz mieszkam w Polsce",
    "Skąd jesteś? Jestem z Włoch",
    "Jak się nazywasz? Nazywam się Marek Nowak",
  ])
}

fn two() -> Lesson {
  Lesson("Lekcjia 2", sentences: [
    "Jak się masz? Mam się dobrze, a ty?",
    "Co słychać? Niezbyt dobrze, a u ciebie?",
    "Ile masz lat? Mam dwadzieścia osiem lat",
    "Ile masz lat? Mam pięćdzieściąt cztery lata",
    "Jaki masz adres? Mój adres to ulica Nowa 4",
    "Jaki pan ma numer telefonu? Mój numer telefonu to 6 0 8 8 1 7 2 2 1",
    "Proszę powtórzyć",
    "Proszę przeczytać tekst",
    "Proszę posłuchać",
    "Proszę napisać",
    "Proszę zrobić pracę domową",
    "Czy pan rozumie? Tak rozumiem",
    "Co to znaczy 'x'",
    "Jak powiedzieć po polsku 'thank you'?",
    "Marek, czy rozumiesz polski? Tak, nieźle rozumiem",
    "Wiem to, ale nie pamiętam!",
    "On świetnie zna hiszpański i portugalski",
    "Adrian jeszcze nie mówi po polsku",
    "Ona uczy się polskiego, bo chce studiować w Polsce",
    "Adrian i Ivan mieszkają w Polsce",
    "Marek i Kasia znają trochę niemiecki",
  ])
}

fn three() -> Lesson {
  Lesson("Lekcjia 3", sentences: [
    "Mam na imię Kasia, jestem z Polsce i mieszkam w Krakowie. Mam 25 lat, mówię po angielsku",
  ])
}
