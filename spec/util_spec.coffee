describe 'SwanKiosk.Utils', ->
  utils = SwanKiosk.Utils

  describe '.getFunction()', ->
    describe 'call', ->
      it 'should call function in context', ->
        context = method: sinon.spy()
        utils.getFunction 'method', context, true
        expect(context.method.called).to.eq true

    describe 'do not call', ->
      it 'should return function', ->
        changed = false
        context = method: -> changed = true
        func = utils.getFunction 'method', context
        expect(func).to.eql context.method
        func.call()
        expect(changed).to.eq true
