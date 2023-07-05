#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 10.00002pt
#let large-size = 11.74988pt

#let datathinking(
  title: none,
  authors: (),
  abstract: [],
  body,
) = {
  // Formats the author's names in a list with commas and a
  // final "and".
  let names = authors.map(author => author.name)
  let author-string = if authors.len() == 2 {
    names.join(" and ")
  } else {
    names.join(", ", last: ", and ")
  }

  // Set document metadata.
  set document(title: title, author: names)

  // Set and show rules from before.
  //...
  show link: underline

  // Configure citation and bibliography styles.
  set cite(style: "chicago-author-date", brackets: true)
  set bibliography(style: "apa", title: "references")

  // FIGURES
  show figure: it => {
    set align(left)
    show: pad.with(x: 13pt)
    v(12.5pt, weak: true)

    // Display the figure's body.
    it.body

    // Display the figure's caption.
    if it.has("caption") {
      // Gap defaults to 17pt.
      v(if it.has("gap") { it.gap } else { 17pt }, weak: true)
      smallcaps[figure]
      if it.numbering != none {
        [ #smallcaps[#counter(figure).display(it.numbering)]]
      }
      [. ] 
      it.caption
    }
    v(15pt, weak: true)
  }

  show heading: it => [
    #set align(left)
    #set text(12pt, weight: "regular")
    #block(smallcaps(it.body))
  ]

  // Configure headings.
  set heading(numbering: "1.")
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    // Level 1 headings are centered and smallcaps.
    // The other ones are run-in.
    set text(size: normal-size, weight: 400)
    if it.level == 1 {
      set align(center)
      set text(size: normal-size)
      smallcaps[
        #v(15pt, weak: true)
        #number
        #it.body
        #v(normal-size, weak: true)
      ]
      counter(figure.where(kind: "theorem")).update(0)
    } else {
      v(11pt, weak: true)
      number
      let styled = if it.level == 2 { strong } else { emph }
      styled(it.body + [. ])
      h(7pt, weak: true)
    }
  }

  // PAGE NUMBERING
  set text(8pt)
  set page(
  footer: [
    #align(right)[
    #counter(page).display(
      "1 of I",
      both: true,
    )
    ]
  ]
  )


  set align(center)
  text(17pt, weight: "bold", title)

  let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => [
      #author.name \
      #author.affiliation \
      #link("mailto:" + author.email)
    ]),
  )
  set align(left)
  set pad(x: 60pt)
  par(justify: true)[
    #block(
    fill: luma(230),
    inset: 8pt,
    radius: 4pt,
    smallcaps[project abstract.  ] + abstract,
  )    
    //#abstract
  ]
  set align(left)
  columns(2, body)
}