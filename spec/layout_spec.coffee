describe 'SwanKiosk.Layout', ->
  layout  = SwanKiosk.Layout

  describe '.build()', ->
    built   = null
    options = {}
    it 'creates a tag with contents', ->
      built = layout.build tag: 'div', contents: 'hello'
      expect(built.tagName.toLowerCase()).to.eq 'div'
      expect(built.textContent).to.eq 'hello'

    it 'creates an empty div with no arguments', ->
      built = layout.build()
      expect(built.tagName.toLowerCase()).to.eq 'div'
      expect(built.textContent).to.eq ''

    it 'creates an empty div with empty arguments', ->
      built = layout.build {}
      expect(built.tagName.toLowerCase()).to.eq 'div'
      expect(built.textContent).to.eq ''

  describe '.buildTag()', ->
    built   = null
    options = {}
    beforeEach -> built = layout.buildTag(options)

    describe 'empty', ->
      before -> options = {}

      it 'creates an empty element', ->
        expect(built.textContent).to.eq ''

    describe 'no tag', ->
      before -> options = {contents: 'hello'}

      it 'sets default tag', ->
        expect(built.tagName.toLowerCase()).to.eq layout.defaultTag

    describe 'array', ->
      before -> options = [{contents: 'hello'}, {contents: 'friend'}]

      it 'builds a set of tags', ->
        expect(built.children.length).to.eq 2

    describe 'string', ->
      before -> options = 'hello'

      it 'builds contents', ->
        expect(built.outerHTML).to.eq '<div>hello</div>'

  describe '.buildContents()', ->
    built   = null
    element = document.createElement 'div'
    options = {}
    beforeEach -> built = layout.buildContents(element, options)

    describe 'string', ->
      before -> options.contents = '<b>content</b>'

      it 'adds string', ->
        expect(built.textContent).to.contain 'content'

      it 'escapes string', ->
        expect(built.textContent).to.not.contain('<b>')

      describe 'rawHtml', ->
        before -> options.rawHtml = true

        it 'does not escape', ->
          expect(built.textContent).to.contain('<b>')

    describe 'array', ->
      before -> options = {contents: [{tag: 'p', contents: 'hello'}]}

      it 'renders multiple items', ->
        expect(built[0].outerHTML).to.eq '<p>hello</p>'

    describe 'object', ->
      before -> options.contents = {tag: 'p', contents: 'hello'}

      it 'renders the child', ->
        expect(built[0].outerHTML).to.eq '<p>hello</p>'

  describe '.buildAttributes()', ->
    built   = null
    options = {}
    element = null
    beforeEach ->
      element = document.createElement 'div'
      built = layout.buildAttributes(element, options)

    describe 'options', ->
      describe 'special attributes', ->
        before ->
          layout.specialAttributes.forEach (option) ->
            options[option] = 'value'

        it "does not set special attributes as HTML attributes", ->
          layout.specialAttributes.forEach (option) ->
            expect(element.getAttribute option).to.eq null

      describe 'attributes', ->
        describe 'simple strings', ->
          before -> options = {class: 'classy', id: 'object'}

          it 'sets properly', ->
            expect(element.getAttribute 'class').to.eq 'classy'
            expect(element.getAttribute 'id').to.eq 'object'

        describe 'data', ->
          before -> options = {data_title: 'title'}

          it 'sets properly', ->
            expect(element.getAttribute 'data-title').to.eq 'title'

        describe 'style', ->
          before -> options = {style: {max_width: '500px'}}

          it 'sets style', ->
            expect(element.getAttribute 'style').to.include('max-width:')

  describe '.buildSingleAttribute()', ->
    options =
      simple: 'string'
      style:  {max_width: '500px'}
      json:   {key: 'val'}
    attribute      = null
    attributeValue = null
    built          = null
    element        = document.createElement 'div'
    beforeEach ->
      built = layout.buildSingleAttribute(element, options)(attribute)
      attributeValue = element.getAttribute attribute

    describe 'simple string', ->
      before -> attribute = 'simple'

      it 'builds attribute', ->
        expect(attributeValue).to.eq 'string'

    describe 'json', ->
      before -> attribute = 'json'

      it 'builds attribute', ->
        expect(attributeValue).to.eq JSON.stringify(options.json)

  describe 'handled attributes', ->
    element = document.createElement 'div'
    context = null
    object  = {}
    layout.handledAttributes.mock = -> context = this

    it 'uses appropriate context', ->
      layout.context = object
      layout.buildHandledAttributes element, {mock: ''}
      expect(context).to.eql object

  describe '.addEventListeners()', ->
    element = document.createElement 'div'
    events  = {click: sinon.spy()}
    beforeEach -> layout.handledAttributes.events events, element

    it 'adds events properly', ->
      evt = document.createEvent 'HTMLEvents'
      evt.initEvent 'click', true, true # event type,bubbling,cancelable
      element.dispatchEvent evt
      expect(events.click.called).to.eq true

  describe '.buildStyleAttribute()', ->
    element = document.createElement 'div'
    style = {max_width: '500px', background_color: 'white', 'min-width': '10px'}
    built = null
    beforeEach -> built = layout.handledAttributes.style(style, element)

    it 'builds attribute', ->
      expect(element.getAttribute 'style').to.eq(
        'max-width: 500px;background-color: white;min-width: 10px;'
      )
