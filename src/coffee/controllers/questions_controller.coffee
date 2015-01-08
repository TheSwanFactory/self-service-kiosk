class SwanKiosk.Controllers.QuestionsController extends SwanKiosk.Controller
  layout: SwanKiosk.Components.layout
  storeKey: 'question.answers'

  # Callbacks

  _afterInitialize: ->
    @store   = new SwanKiosk.Store.LocalStorage
    @config  = SwanKiosk.Config
    @answers = @store.getObject(@storeKey) || {}

  # Routes

  routes: ['index', 'show', 'results']

  index: ->
    [{
      tag: 'h1'
      contents: 'Questions'
    }]

  show: ->
    @id =  parseInt(@params.id, 10) || 1
    @questions = @config.questions
    @questionKey = Object.keys(@questions)[@id - 1]
    question = @questions[@questionKey]
    @answer = @answers[@questionKey]
    if question?
      new SwanKiosk.Interpreters.Question question, @answer
    else
      page.redirect '/questions/results'

  results: ->
    new SwanKiosk.Interpreters.Results @answers

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
    @answers[@questionKey] = @answer
    @store.set @storeKey, @answers

  prevQuestion: (element, event) ->
    page.redirect "/questions/#{@id - 1}"

  hasPreviousQuestion: ->
    @id > 1

  startOver: (element, event) ->
    @clearAnswers()
    page.redirect '/questions/1'

  clearAnswers: ->
    @store.set @storeKey, {}

