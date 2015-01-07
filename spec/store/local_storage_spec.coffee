describe 'SwanKiosk.Store.LocalStorage', ->
  store = new SwanKiosk.Store.LocalStorage
  beforeEach -> localStorage.clear()

  describe '#set()', ->
    it 'sets properly', ->
      store.set 'key', 'value'
      expect(localStorage['key']).to.eq 'value'

    it 'sets many', ->
      store.set sleigh: 'ride', kiosk: 'monitor'
      expect(store.get 'sleigh').to.eq 'ride'
      expect(store.get 'kiosk').to.eq 'monitor'

  describe '#setMany()', ->
    it 'works', ->
      store.setMany key: 'lock', rain: 'deer'
      expect(localStorage['key']).to.eq 'lock'
      expect(localStorage['rain']).to.eq 'deer'

  describe '#get()', ->
    it 'gets properly', ->
      localStorage['get'] = 'get'
      expect(store.get 'get').to.eq 'get'

    it 'gets many', ->
      store.set base: 'ball', card: 'collector'
      expect(store.get ['base', 'card']).to.eql ['ball', 'collector']

  describe '#getMany()', ->
    it 'works', ->
      store.set 'this', 'that'
      store.set 'that', 'this'
      expect(store.get ['this', 'that']).to.eql ['that', 'this']

  describe '#getObject()', ->
    it 'works', ->
      obj = {king: 'queen', prince: 'princess'}
      store.set obj: obj
      expect(store.getObject 'obj').to.eql obj
