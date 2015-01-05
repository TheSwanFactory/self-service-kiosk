describe.only 'SwanKiosk.Router', ->
  router = SwanKiosk.Router

  afterEach -> location.hash = ''

  describe '.init()', ->
    options = {}
    beforeEach -> router.init(options)

    it 'has a currentPath', ->
      expect(router.currentPath()).to.eq ''

  describe '.currentPath()', ->
    it 'matches current hash', ->
      location.hash = 'hello'
      expect(router.currentPath()).to.eq 'hello'
