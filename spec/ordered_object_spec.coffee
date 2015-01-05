describe 'OrderedObject', ->
  obj     = null
  options = null

  createObject = -> obj = new OrderedObject(options)

  describe 'constructor', ->
    describe 'valid', ->
      it 'works', ->
        options = {}
        expect(createObject).to.not.throw()

    describe 'invalid', ->
      it 'throws', ->
        options = []
        expect(createObject).to.throw()

  describe 'methods', ->
    before -> options = {}
    beforeEach createObject

    describe '#push()', ->
      it 'adds a key/value pair', ->
        obj.push 'key', 'value'
        expect(obj._keys[0]).to.eq 'key'
        expect(obj._values[0]).to.eq 'value'

      it 'removes old key/value pair and adds new', ->
        obj.push 'key',  'value'
        obj.push 'some', 'thing'
        obj.push 'key',  'newValue'
        expect(obj.get 'key').to.eq 'newValue'
        expect(obj._keys[0]).to.eq 'some'

    describe '#unshift()', ->
      before -> options = {key: 'value'}

      it 'adds a key/value pair at the beginning', ->
        obj.unshift 'other', 'val'
        expect(obj._keys[0]).to.eq 'other'
        expect(obj._values[0]).to.eq 'val'

    describe '#remove()', ->
      it 'removes a key/value pair', ->
        obj.set key: 'value'
        expect(obj.get 'key').to.eq 'value'
        obj.remove 'key'
        expect(obj.get 'key').to.eq undefined

    describe '#get()', ->
      before -> options = {key: 'value'}

      it 'gets value when a value exists', ->
        expect(obj.get('key')).to.eq 'value'

      it 'gets undefined when a value does not exist', ->
        expect(obj.get('nope')).to.eq undefined

    describe '#set()', ->
      before -> options = {key: 'value'}

      it 'sets whole object', ->
        obj.set other: 'newValue'
        expect(obj.get 'key').to.eq undefined
        expect(obj.get 'other').to.eq 'newValue'

  describe 'export', ->
    before -> options = {key: 'value'}
    beforeEach createObject

    it 'can be converted back to an object', ->
      expect(obj.toObject()).to.deep.eq options
