describe 'SwanKiosk', ->
  sk = SwanKiosk

  class SwanKiosk.Controllers.MockController
    index: ->
  mock = SwanKiosk.Controllers.MockController

  describe 'Controllers', ->
    controllers = sk.Controllers

    describe '._find()', ->
      it 'finds controller', ->
        expect(controllers._find 'mock').to.eq mock
        expect(controllers._find 'MOCK').to.eq mock

  describe 'methods', ->
    describe '.create()', ->
      it 'creates an instance', ->
        expect(sk.create mock, {}).to.be.instanceof mock

    describe '.singleton()', ->
      it 'creates and accesses a singleton', ->
        instance = sk.singleton mock
        instance.variable = 'hello'
        expect(sk.singleton(mock).variable).to.eq 'hello'
