describe.only 'SwanKiosk.Router', ->
  router  = SwanKiosk.Router
  options = null

  beforeEach -> router.init(options)
  afterEach -> location.hash = ''

  describe '.init()', ->
    it 'has a currentPath', ->
      expect(router.currentPath()).to.eq ''

  describe '.currentPath()', ->
    it 'matches current hash', ->
      location.hash = '/questions/2'
      expect(router.currentPath()).to.eq '/questions/2'

  describe '.add()', ->
    it 'adds a string', ->
      router.add('path', ->)
      expect(router.routes[0].route).to.eq 'path'

    it 'adds a regex', ->
      router.add(/path/, ->)
      expect(router.routes[0].route).to.eql /path/

    it 'fails with other types', ->
      expect(-> router.add(1, ->)).to.throw()

  describe '.route()', ->
    context 'string', ->
      it 'calls function', ->
        callback = sinon.spy()

        router.add 'path', callback
        router.route 'path'

        expect(callback.called).to.eq true

  describe '.hashChange()', ->

