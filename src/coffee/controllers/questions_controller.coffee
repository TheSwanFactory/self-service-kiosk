class SwanKiosk.Controllers.QuestionsController extends SwanKiosk.Controller
  constructor: ->
    @layout = SwanKiosk.Components.layout
    super()

  index: ->
    [{
      tag: 'h1'
      contents: 'Questions'
    }]

  show: ->
    id = parseInt(@params.id, 10) || 0
    key = Object.keys(SwanKiosk.Config.questions)[id]
    question = new SwanKiosk.Interpreters.Question SwanKiosk.Config.questions[key]
    question.get()

