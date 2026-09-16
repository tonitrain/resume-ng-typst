#let delimiter = " | "

#let array-to-str(a, delimiter: delimiter) = {
   a.join(delimiter)
}

#let resume-contacts(contact) = {
   set align(center)
   array-to-str(contact)
}

#let resume-heading(title) = {
  show heading.where(level: 1): set block(above: 0pt, below: 0pt)
  set text(top-edge: "bounds", bottom-edge: "bounds")
  heading(level: 1, title)
}

// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  title: "",
  author: (),
  contacts: (),
  avatar: none,
  avatar-height: 4.0cm,
  header-left: none,
  header-section: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: author.name, title: title)
  set page(
    /// Margins of the page
    margin: (x: 1cm, y: 0.5cm),
  )
    
  // set text(font: "Linux Libertine", lang: "en")
  set text(font: "Songti SC", lang: "zh")
    
  // Title row.
  if avatar != none and header-section != none {
    // Share the first section row with the photo, ending just above its rule.
    block(
      width: 100%,
      above: 0pt,
      below: 5pt,
      inset: (bottom: 1pt),
      stroke: (bottom: 1pt),
      breakable: false,
      sticky: true,
    )[
      #grid(
        columns: (1fr, auto),
        column-gutter: 0.5cm,
        block(width: 100%, height: avatar-height)[
          #align(center)[
            #block(text(weight: 700, 1.7em, author.name))
            #resume-contacts(contacts)
          ]
          #if header-left != none {
            v(0.1cm)
            header-left
          }
          #v(1fr)
          #resume-heading(header-section)
        ],
        image(avatar, height: avatar-height),
      )
    ]
  } else if avatar == none {
    align(center)[
      #block(text(weight: 700, 1.7em, author.name))
    ]

    resume-contacts(contacts)
  } else if header-left != none {
    grid(
      columns: (1fr, auto),
      column-gutter: 0.8cm,
      [
        #align(center)[
          #block(text(weight: 700, 1.7em, author.name))
          #resume-contacts(contacts)
        ]
        #v(0.1cm)
        #header-left
      ],
      align(right)[
        #image(avatar, height: avatar-height)
      ],
    )
  } else {
    grid(
      columns: (1fr, auto, 1fr),
      column-gutter: 0.5cm,
      [],
      align(center)[
        #block(text(weight: 700, 1.7em, author.name))
        #resume-contacts(contacts)
      ],
      align(right)[
        #image(avatar, height: avatar-height)
      ],
    )
  }

  if avatar == none and header-section != none {
    resume-section(header-section)
  }

  // Main body.
  set par(justify: true)

  body
}

#let format-date(date) = {
  if type(date) == datetime [date.display()] 
  else if type(date) == str and date.len() == 0 [今] 
  else if type(date) == str {
    date
  } else {
    // todo panic
  }
}

#let resume-date(start, end: "") = {
  if start == "" and end == "" {
    "" 
  } else {
    format-date(start) + " " + $dash.en$ + " " + format-date(end)
  }
}

#let resume-item(left:"", right:"", body) = {
  text(size: 12pt, place(end, right))
  text(size: 12pt, left)
  linebreak()
  body
}

#let resume-education(university: "", degree: "", school: "", start: "", end: "", body) = {
  let left = (strong(university), school, degree)
  let right = resume-date(start, end: end);
  
  resume-item(
    left: array-to-str(left),
    right: right,
    body
  )
}

#let resume-work(company: "", duty: "", start: "", end: "", body) = {
  let left = (strong(company), duty)
  let right = resume-date(start, end: end)

  resume-item(
    left: array-to-str(left),
    right: right,
    body
  )
}

#let resume-project(title: "", duty: "", start: "", end: "", body) = {
  let left = (strong(title), duty)
  let right = resume-date(start, end: end)

  resume-item(
    left: array-to-str(left),
    right: right,
    body
  )
}

#let resume-section(title) = {
  block(
    width: 100%,
    above: 6pt,
    below: 5pt,
    inset: (bottom: 2pt),
    stroke: (bottom: 1pt),
    breakable: false,
    sticky: true,
  )[
    #resume-heading(title)
  ]
}
