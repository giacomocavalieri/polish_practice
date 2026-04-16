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
    "Czy znasz angielski? Tak, znam",
    "Czy znasz japoński? Nie, nie znam",
    "Jak mówisz po włoski? Mowię fatalnie",
    "Czy znasz arabski? Znam arabski tylko trochę",
    "Uczę się polskiego, bo lubię polski",
    "Ona uczy się polskiego, bo chce pracowaç w Polsce",
    "Uczę się polskiego, bo moja żona jest polką",
    "Dlaczego ucisz się polskiego? Uczę się polskiego, bo moja dziewczyna jest polką",
    "Mój koledzy w pracy mówią tylko po polsku",
    "Uczę się polskiego, żeby rozmawiać z kolegami",
    "Nic nie rozumiem po polsku",
    "Uczę się polskiego, żeby lepiej rozumieć ten jęnzyk",
    "Jestem inżynierem, chcę pracować w Warsawie",
    "Lubię polską literaturę. Uczę się polskiego, żeby czytać po polsku",
    "Uczę się polskiego, żeby komunikować się z polakami. Na przykład w sklepie",
    "Po lewej stronie",
    "Po prawej stronie",
  ])
}
