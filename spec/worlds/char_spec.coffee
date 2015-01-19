describe.only 'Swan.CharWorld', ->
  World    = Swan.CharWorld
  world    = null
  contents = null

  beforeEach -> world = new World(contents)

  it 'is a world', ->
    expect(world).to.be.an.instanceof Swan.World

  describe 'constructor', ->
    before -> contents = 'a'

    it 'contents sets body to a char', ->
      expect(world.body()).to.eq 'a'

    describe 'many chars', ->
      before -> contents = 'ba'

      it 'sets body to first char', ->
        expect(world.body()).to.eq 'b'

