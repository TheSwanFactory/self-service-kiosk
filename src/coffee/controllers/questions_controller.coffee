class SwanKiosk.Controllers.QuestionsController extends SwanKiosk.Controller
  layout: SwanKiosk.Components.layout

  index: ->
    [{
      tag: 'h1'
      contents: 'Questions'
    }]

  show: ->
    @id = parseInt(@params.id, 10) || 0
    @questionKey = Object.keys(SwanKiosk.Config.questions)[@id]
    question = SwanKiosk.Config.questions[@questionKey]
    if question?
      new SwanKiosk.Interpreters.Question question
    else
      page '/questions/results'

  results: ->
    console.log 'helo!'
    console.log SwanKiosk.Store.answers
    {
      tag: 'pre'
      rawHtml: true
      contents: JSON.stringify(SwanKiosk.Store.answers || {})
    }

  _selectOption: (value, event) ->
    $answer = $ event.target
    $answer.siblings().removeClass 'selected'
    $answer.addClass 'selected'
    @answer = value

  _nextQuestion: ->
    @_storeAnwer()

  _storeAnwer: ->
    SwanKiosk.Store.answers ?= {}
    SwanKiosk.Store.answers[@questionKey] = @answer
    page "/questions/#{@id + 1}"

  _prevQuestion: ->

  _startOver: ->
    SwanKiosk.Store.answers = {}
    page '/questions/0'

