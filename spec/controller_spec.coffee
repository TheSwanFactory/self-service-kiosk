describe 'SwanKiosk.Controller', ->
  controller = SwanKiosk.Controller
  ctrl       = null

  controller::bodySelector = fixtureSelector

  class MockController extends controller
    variable: 'variable'
    index: sinon.spy()
    valid: sinon.spy()
    real_action: -> @variable
    _invalid: ->

  describe '#_getRoutes()', ->
    routes = []
    beforeEach -> routes = (new MockController())._getRoutes()

    it 'does not show constructor', ->
      expect(routes).to.not.include 'constructor'

    it 'does not show _private methods', ->
      expect(routes).to.not.include '_invalid'

    it 'does not show variables', ->
      expect(routes).to.not.include 'variable'

    it 'does show public methods', ->
      expect(routes.sort()).to.deep.eq ['index', 'real_action', 'valid']

  describe '#_route()', ->
    setup = (options = {}) -> ctrl = new MockController(options)

    it 'routes to action', ->
      setup action: 'valid', id: '2'
      ctrl._route()
      expect(ctrl.valid.called).to.eq true

    it 'routes to index otherwise', ->
      setup()
      ctrl._route()
      expect(ctrl.index.called).to.eq true

    it 'renders contents', ->
      setup()
      ctrl._route 'real_action'
      expect(fixtureDiv.html()).to.contain ctrl.variable

  describe '#_render()', ->
    beforeEach -> ctrl = new MockController()

    it 'renders through layout engine', ->
      ctrl._render contents: 'hello'
      expect(fixtureDiv.find('*').length).to.eq 1

    it 'does not double render', ->
      ctrl._render contents: 'goodbye'
      ctrl._render contents: 'hello'
      expect(fixtureDiv.html()).to.not.contain 'hello'

  describe '#_renderPlain()', ->
    beforeEach -> ctrl = new MockController()

    it 'adds content to fixtureDiv', ->
      ctrl._renderPlain '<div id="myTestDiv"></div>'
      expect(fixtureDiv.find('#myTestDiv').length).to.eq 1

    it 'does not double render', ->
      ctrl._renderPlain contents: 'goodbye'
      ctrl._renderPlain contents: 'hello'
      expect(fixtureDiv.html()).to.not.contain 'hello'
