describe 'SwanKiosk.Controller', ->
  controller = SwanKiosk.Controller
  ctrl       = null

  controller::bodySelector = fixtureSelector

  class MockController extends controller
    variable: []
    index: sinon.spy()
    valid: sinon.spy()
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
      expect(routes.sort()).to.deep.eq ['index', 'valid']

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

  describe '#_render()', ->
    # patch controller body to make changes inside our fixture
    beforeEach -> ctrl = new MockController()

    it 'adds content to fixtureDiv', ->
      ctrl._render '<div id="myTestDiv"></div>'
      expect(fixtureDiv.find('#myTestDiv').length).to.eq 1
