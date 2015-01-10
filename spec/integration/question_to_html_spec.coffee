describe 'Question to HTML', ->
  interpreter = SwanKiosk.Interpreters.Question
  layout      = SwanKiosk.Layout
  question =
    title:  'Gender',
    why:    'This helps us better extimate your health risks'
    select: {M: 'Male', F: 'Female', other: 'Other'}
  beforeEach ->
    built = (new interpreter question).pipe(layout.build)
    fixtureDiv.html built

  it 'builds header', ->
    header = fixtureDiv.find('.header')
    expect(header.length).to.not.eq 0
    expect(header.find('.question > *').text()).to.eq question.title

  it 'builds body', ->
    body = fixtureDiv.find('.body')
    expect(body.length).to.not.eq 0
    expect(body.find('.answer').length).to.eq 3

  it 'builds navigation', ->
    nav = fixtureDiv.find '.navigation'
    expect(nav.length).to.not.eq 0

