describe.only 'SwanKiosk.Store', ->
  store = SwanKiosk.Store

  describe 'construction', ->
    storage = new store()

    it 'exists', ->
      expect(storage instanceof store).to.eq true

  describe 'methods (implemented and useless)', ->
    storage = new store()
    shouldDefine = (method) ->
      it method, ->
        expect(storage[method]).to.throw /not been defined/

    shouldDefine 'get'
    shouldDefine 'set'
