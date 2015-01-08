class SwanKiosk.Controllers.QuestionsController extends SwanKiosk.Controller
  layout:         SwanKiosk.Components.layout
  storeKey:       'question.answers'
  lowIndex:       0
  defaultAnswers: -> {}
  selectedClass:  'selected'

  # Callbacks

  _afterInitialize: ->
    @store   = new SwanKiosk.Store.LocalStorage
    @config  = SwanKiosk.Config
    @answers = @store.getObject(@storeKey) || @defaultAnswers()

  # Routes

  routes: ['show', 'results']

  show: ->
    @id = parseInt(@params.id, 10) || @lowIndex
    @questions = @config.questions
    question = @questions[@id]
    if question?
      @questionKey = question.key
      @answer = @answers[@questionKey]
      new SwanKiosk.Interpreters.Question question, @answer
    else
      page.redirect '/questions/results'

  results: ->
    new SwanKiosk.Interpreters.Results @answers

  # Actions

  selectOption: (element, event) ->
    $answer = $ element
    $answer.siblings().removeClass @selectedClass
    $answer.addClass @selectedClass
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
    @id > 0

  startOver: (element, event) ->
    @clearAnswers()
    page.redirect "/questions/#{@lowIndex}"

  clearAnswers: ->
    @store.set @storeKey, @defaultAnswers()

