class SwanKiosk.Controllers.QuestionsController extends SwanKiosk.Controller
  layout: SwanKiosk.Components.layout

  # Routes

  routes: ['index', 'show', 'results']

  index: ->
    [{
      tag: 'h1'
      contents: 'Questions'
    }]

  show: ->
    @id =  parseInt(@params.id, 10) || 1
    @questionKey = Object.keys(SwanKiosk.Config.questions)[@id - 1]
    question = SwanKiosk.Config.questions[@questionKey]
    if question?
      new SwanKiosk.Interpreters.Question question
    else
      page.redirect '/questions/results'

  results: ->
    new SwanKiosk.Interpreters.Results SwanKiosk.Store.answers

  # Actions

  selectOption: (element, event) ->
    $answer = $ element
    $answer.siblings().removeClass 'selected'
    $answer.addClass 'selected'
    @answer = $answer.attr 'value'

  nextQuestion: (element, event) ->
    @storeAnswer()
    page.redirect "/questions/#{@id + 1}"

  storeAnswer: ->
    SwanKiosk.Store.answers ?= {}
    SwanKiosk.Store.answers[@questionKey] = @answer

  prevQuestion: (element, event) ->
    page.redirect "/questions/#{@id - 1}"

  startOver: (element, event) ->
    SwanKiosk.Store.answers = {}
    page.redirect '/questions/1'

