class SwanKiosk.Interpreter extends SwanKiosk.World

class SwanKiosk.Interpreters.Question extends SwanKiosk.Interpreter
  why: 'Why are we asking this question?'

  header:     -> @_header     ?= @interpretHeader()
  body:       -> @_body       ?= @interpretBody()
  navigation: -> @_navigation ?= @interpretNavigation()

  get: -> [@header(), @body(), @navigation()]

  questionOption: (option, value) ->
    {tag: 'a', class: 'answer', contents: option, value: value}

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
    options = _.map @dictionary.select, @questionOption
    {
      class:    'body'
      contents: SwanKiosk.Components.center(options)
    }

  interpretNavigation: ->
    class:    'navigation',
    contents: [{
      class:    'start-over'
      contents: {tag: 'a', contents: 'Start Over'}
    }, {
      class:    'change-page',
      contents: [
        SwanKiosk.Components.link('Previous', class: 'previous')
        SwanKiosk.Components.link('Next',     class: 'next')
      ]
    }]
