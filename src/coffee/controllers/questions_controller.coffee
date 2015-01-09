class SwanKiosk.Controllers.QuestionsController extends SwanKiosk.Controller
  layout:         SwanKiosk.Components.layout
  storeKey:       'question.answers'
  lowIndex:       0
  defaultAnswers: -> {}
  selectedClass:  'selected'

  # Callbacks

  _beforeAction: ->
    @setStore()
    @setConfig()
    @setQuestions()
    @setId()
    @setAnswers()
    @setQuestion()

  # Helpers

  setStore: ->
    @store = new SwanKiosk.Store.LocalStorage

  setConfig: ->
    @config = SwanKiosk.Config

  setId: ->
    @id = parseInt(@params.id, 10) || @lowIndex

  setQuestions: ->
    @questions = @config.questions

  setAnswers: ->
    @answers = @store.getObject(@storeKey) || @defaultAnswers()

  setQuestion: ->
    @question = @questions[@id]
    return unless @question?
    @checkPassWhenClause()

  checkPassWhenClause: ->
    whenClause = @question.when
    pass = true
    if whenClause?
      for key, value of whenClause
        if @answers[key] != value
          pass = false
          break
    unless pass
      @id++
      @setQuestion()


  # Routes

  routes: ['show', 'results']

  show: ->
    if @question?
      @questionKey = @question.key
      @answer = @answers[@questionKey]
      new SwanKiosk.Interpreters.Question @question, @answer
    else
      page.redirect '/questions/results'

  results: ->
    new SwanKiosk.Interpreters.Results @answers

  # Page Actions

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

