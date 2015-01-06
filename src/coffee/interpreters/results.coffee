class SwanKiosk.Interpreters.Results extends SwanKiosk.Interpreter
  get: ->
    class: 'body'
    contents:
      class: 'grid-container'
      contents: @table()

  table: ->
    tag: 'table'
    class: 'results'
    contents: [{
      tag: 'thead'
      contents:
        tag: 'tr'
        contents: [{
          tag: 'th'
          contents: 'Question'
        }
        {
          tag: 'th'
          contents: 'Answer'
        }]
    }
    {
      tag: 'tbody'
      contents: _.map(@dictionary, @answerRow)
    }]

  answerRow: (value, key) ->
    tag: 'tr'
    contents: [{
      tag: 'td'
      contents: SwanKiosk.Config.questions[key].title
    }
    {
      tag: 'td'
      contents: SwanKiosk.Config.questions[key].select[value]
    }]
