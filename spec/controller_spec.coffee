describe 'SwanKiosk.Controller', ->
  controller = SwanKiosk.Controller
  ctrl       = null

  class MockController extends controller
    variable: []
    index: sinon.spy()
    valid: sinon.spy()
    _invalid: ->


  describe '#_getRoutes()', ->
    beforeEach -> ctrl = new MockController()
    routes = []
    beforeEach -> routes = ctrl._getRoutes()

    it 'does not show constructor', ->
      expect(routes).to.not.include 'constructor'

    it 'does not show _private methods', ->
      expect(routes).to.not.include '_invalid'

    it 'does not show variables', ->
      expect(routes).to.not.include 'variable'

    it 'does show public methods', ->
      expect(routes.sort()).to.deep.eq ['index', 'valid']

  describe '#_route()', ->
    it 'routes to action', ->
      ctrl = new MockController action: 'valid', id: '2'
      expect(ctrl.valid.called).to.eq true

    it 'routes to index otherwise', ->
      ctrl = new MockController()
      expect(ctrl.index.called).to.eq true
