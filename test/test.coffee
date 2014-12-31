expect = chai.expect

describe 'Dependencies', ->
  it 'has loDash', ->
    expect(typeof _).to.not.eq 'undefined'

describe 'Layout', ->
  layout  = SwanKiosk.Layout
  built   = ''
  options = {}

  describe '.build()', ->
    it 'creates a tag with contents', ->
      built = layout.build tag: 'div', contents: 'hello'
      expect(built).to.eq('<div>hello</div>')

  describe '.buildContents()', ->
    options = {}
    beforeEach -> built = layout.buildContents(options)

    describe 'string', ->
      before -> options.contents = '<b>content</b>'

      it 'adds string', ->
        expect(built).to.contain 'content'

      it 'escapes string', ->
        expect(built).to.not.contain('<b>')

      describe 'rawHtml', ->
        before -> options.rawHtml = true

        it 'does not escape', ->
          expect(built).to.contain('<b>')

    describe 'array', ->
      before -> options.contents = [{tag: 'p', contents: 'hello'}]

      it 'renders multiple items', ->
        expect(built).to.eq '<p>hello</p>'

  describe '.buildAttributes()', ->
    options = {}
    beforeEach -> built = layout.buildAttributes(options)

    describe 'options', ->
      describe 'special attributes', ->
        before ->
          layout.specialAttributes.forEach (option) ->
            options[option] = 'value'

        it "does not set special attributes as HTML attributes", ->
          expect(built).to.eq ''

      describe 'attributes', ->
        describe 'simple strings', ->
          before -> options = {class: 'classy', id: 'object'}

          it 'sets properly', ->
            expect(built).to.include('class="classy" id="object"')

        describe 'data', ->
          before -> options = {data_title: 'title'}

          it 'sets properly', ->
            expect(built).to.include 'data-title="title"'

        describe 'style', ->
          before -> options = {style: {max_width: '500px'}}

          it 'sets style', ->
            expect(built).to.include('style="max-width:')
