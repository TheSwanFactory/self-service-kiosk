describe.only 'SwanKiosk.Interpreter', ->
  interpreter = SwanKiosk.Interpreter

  it 'creates an empty json object', ->
    expect(interpreter.interpret {}).to.deep.eq {}
    expect(interpreter.interpret()).to.deep.eq {}

  describe 'question', ->
    question_interpreter = SwanKiosk.Interpreters.Question
    built       = {}
    dictionary  = {}
    beforeEach  -> built = question_interpreter(dictionary)

    describe 'overall', ->
      before ->
        dictionary =
          title: 'Do you have dry eyes?'
          why:   'just because'
          select:
            yes: 'Yes'
            no:  'No'

      it 'is', ->
        console.log JSON.stringify(built, null, 4)

    describe 'header', ->
      header = null
      before     -> dictionary = {title: 'What is your name?', why: 'because'}
      beforeEach -> header = _.find(built, class: 'header')

      it 'creates header object', ->
        question = _.find(header.contents, class: 'question')
        expect(question.contents.contents).to.eq dictionary.title

      it 'creates why object', ->
        wrapper = _(header.contents).last()
        why = wrapper.contents
        expect(why.contents.title).to.eq dictionary.why
