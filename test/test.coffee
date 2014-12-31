expect = chai.expect

describe 'Layout', ->
  layout   = SwanKiosk.Layout
  built    = ''
  contents = ''
  options  = {}

  describe '.build()', ->
    beforeEach ->
      built = layout.build(_.extend(tag: 'div', contents: contents, options))

    it 'creates a tag', ->
      expect(built).to.match(/^\<div\>/)
      expect(built).to.match(/\<\/div\>$/)

    describe 'contents', ->
      describe 'string', ->
        before -> contents = '<b>content</b>'

        it 'adds string', ->
          expect(built).to.contain 'content'

        it 'escapes string', ->
          expect(built).to.not.contain('<b>')

        describe 'rawHtml', ->
          before -> options = {rawHtml: true}

          it 'does not escape', ->
            expect(built).to.contain('<b>')

      describe 'array', ->
        before -> contents = [{tag: 'p', contents: 'hello'}]

        it 'renders multiple items', ->
          expect(built).to.contain('<div>')
          expect(built).to.contain('<p>')
          expect(built).to.contain('hello')

