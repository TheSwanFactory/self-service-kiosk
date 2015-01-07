class SwanKiosk.Interpreter extends SwanKiosk.World

class SwanKiosk.Interpreters.Question extends SwanKiosk.Interpreter
  why: 'Why are we asking this question?'

  constructor: (@dictionary, @answer) ->
    super @dictionary

  header:     -> @_header     ?= @interpretHeader()
  body:       -> @_body       ?= @interpretBody()
  navigation: -> @_navigation ?= @interpretNavigation()

  get: -> [@header(), @body(), @navigation()]

  questionOption: (option, value) ->
    tag:      'a'
    class:    "answer #{'selected' if value == @answer}"
    contents: option
    value:    value
    events:
      click: 'selectOption'

  interpretHeader: ->
    class:    'header'
    contents: [{
      class: 'question'
      contents: {tag: 'h1', contents: @dictionary.title}
    }, SwanKiosk.Components.verticalCenter({
      class:    'why-wrapper',
      contents: {tag: 'a', class: 'why', contents: @why, title: @dictionary.why}
    })]

  interpretBody: ->
    options = _.map @dictionary.select, @questionOption, this
    {
      class:    'body'
      contents: SwanKiosk.Components.center(options)
    }

  interpretNavigation: ->
    prevOptions =
      class: 'previous'
      events:
        click: 'prevQuestion'
    nextOptions =
      class: 'next'
      events:
        click: 'nextQuestion'
    class:    'navigation',
    contents: [{
      class:    'start-over'
      contents:
        tag: 'a'
        contents: 'Start Over'
        events:
          click: 'startOver'
    }, {
      class:    'change-page',
      contents: [
        SwanKiosk.Components.link 'Previous', prevOptions
        SwanKiosk.Components.link 'Next',     nextOptions
      ]
    }]
