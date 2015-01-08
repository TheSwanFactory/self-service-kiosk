class SwanKiosk.Interpreters.Results extends SwanKiosk.Interpreter
  config = SwanKiosk.Config

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
      contents: _.map(@dictionary, @answerRow, this)
    }]

  answerRow: (value, key) ->
    question = _.find config.questions, key: key
    {
      tag: 'tr'
      contents: [{
        tag: 'td'
        contents: question?.title
      }
      {
        tag: 'td'
        contents: @getAnswer(question, value)
      }]
    }

  getAnswer: (question, value) ->
    if question? && 'select' of question
      question.select[value]
    else
      value
