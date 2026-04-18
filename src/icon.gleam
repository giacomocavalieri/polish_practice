import lustre/attribute.{type Attribute, attribute}
import lustre/element.{type Element}
import lustre/element/svg

pub fn play(attributes: List(Attribute(msg))) -> Element(msg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 640 640"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("icon"),
      ..attributes
    ],
    [
      svg.path([
        attribute(
          "d",
          "M187.2 100.9C174.8 94.1 159.8 94.4 147.6 101.6C135.4 108.8 128 121.9 128 136L128 504C128 518.1 135.5 531.2 147.6 538.4C159.7 545.6 174.8 545.9 187.2 539.1L523.2 355.1C536 348.1 544 334.6 544 320C544 305.4 536 291.9 523.2 284.9L187.2 100.9z",
        ),
      ]),
    ],
  )
}

pub fn eye(attributes: List(Attribute(msg))) -> Element(msg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 640 640"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("icon"),
      ..attributes
    ],
    [
      svg.path([
        attribute(
          "d",
          "M320 96C239.2 96 174.5 132.8 127.4 176.6C80.6 220.1 49.3 272 34.4 307.7C31.1 315.6 31.1 324.4 34.4 332.3C49.3 368 80.6 420 127.4 463.4C174.5 507.1 239.2 544 320 544C400.8 544 465.5 507.2 512.6 463.4C559.4 419.9 590.7 368 605.6 332.3C608.9 324.4 608.9 315.6 605.6 307.7C590.7 272 559.4 220 512.6 176.6C465.5 132.9 400.8 96 320 96zM176 320C176 240.5 240.5 176 320 176C399.5 176 464 240.5 464 320C464 399.5 399.5 464 320 464C240.5 464 176 399.5 176 320zM320 256C320 291.3 291.3 320 256 320C244.5 320 233.7 317 224.3 311.6C223.3 322.5 224.2 333.7 227.2 344.8C240.9 396 293.6 426.4 344.8 412.7C396 399 426.4 346.3 412.7 295.1C400.5 249.4 357.2 220.3 311.6 224.3C316.9 233.6 320 244.4 320 256z",
        ),
      ]),
    ],
  )
}

pub fn pause(attributes: List(Attribute(msg))) -> Element(msg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 640 640"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("icon"),
      ..attributes
    ],
    [
      svg.path([
        attribute(
          "d",
          "M176 96C149.5 96 128 117.5 128 144L128 496C128 522.5 149.5 544 176 544L240 544C266.5 544 288 522.5 288 496L288 144C288 117.5 266.5 96 240 96L176 96zM400 96C373.5 96 352 117.5 352 144L352 496C352 522.5 373.5 544 400 544L464 544C490.5 544 512 522.5 512 496L512 144C512 117.5 490.5 96 464 96L400 96z",
        ),
      ]),
    ],
  )
}

pub fn circle_check(attributes: List(Attribute(msg))) -> Element(msg) {
  svg.svg(
    [
      attribute("viewBox", "0 0 640 640"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.class("icon"),
      ..attributes
    ],
    [
      svg.path([
        attribute(
          "d",
          "M320 576C178.6 576 64 461.4 64 320C64 178.6 178.6 64 320 64C461.4 64 576 178.6 576 320C576 461.4 461.4 576 320 576zM438 209.7C427.3 201.9 412.3 204.3 404.5 215L285.1 379.2L233 327.1C223.6 317.7 208.4 317.7 199.1 327.1C189.8 336.5 189.7 351.7 199.1 361L271.1 433C276.1 438 282.9 440.5 289.9 440C296.9 439.5 303.3 435.9 307.4 430.2L443.3 243.2C451.1 232.5 448.7 217.5 438 209.7z",
        ),
      ]),
    ],
  )
}
