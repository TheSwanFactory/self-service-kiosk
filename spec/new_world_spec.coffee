describe.only 'Swan.World', ->
  World    = Swan.World
  world    = null
  contents = null

  beforeEach -> world = new World contents

  describe 'properties', ->
    describe '#set()', ->
      it 'sets a proprety directly on the world', ->
        world.set 'foo', 'bar'
        expect(world.foo).to.eq 'bar'

    describe '#get()', ->
      it 'gets a property directly on the world', ->
        world.foo = 'bar'
        expect(world.get 'foo').to.eq 'bar'

  describe 'Scope', ->
    it 'has up property', ->
      expect(world.up).to.not.eq undefined

    it 'looks up missing properties in parent', ->
      parent = new World
      parent.set 'key', 'value'
      world = new World {}, parent
      expect(world.get 'key').to.eq 'value'

    it 'uses GOD object is up is null', ->
      expect(world.up()).to.eq GOD

    it 'fails gracefully if property not defined anywhere', ->
      expect(-> world.foo).to.not.throw()
      expect(-> world.get 'foo').to.not.throw()

    describe 'Sub', ->
      beforeEach -> world.sub {}

      it 'spawns sub worlds', ->
        expect(world.subs()[0]).to.not.eq null

      it 'those sub worlds have itself as up', ->
        expect(world.subs()[0].up()).to.eql world

      it 'has subs property', ->
        expect(world.subs).to.not.throw()
        expect(world.subs()).to.eql [world.subs()[0]]

  describe 'Class methods', ->
    describe 'array_sub', ->
      beforeEach -> World.array_sub ['this', 'that']

      it 'creates a sub', ->
        expect(world.subs()[0]).to.be.an.instanceof World

  describe 'Body', ->
    it 'is an array', ->
      expect(world.get 'body').to.eql []

    describe '#push()', ->
      it 'adds to body', ->
        world.push 'word'
        expect(world.get 'body').to.eql ['word']

  describe 'Invocation', ->
    it 'has do method', ->
      expect(world.do).to.not.throw()

    it 'has done method', ->
      expect(world.done).to.not.throw()

    it 'default do method appends to subs', ->
      contents = {key: 'value'}
      world.do contents
      sub = world.subs()[0]
      expect(sub).to.be.an.instanceof World
      expect(sub.get 'key').to.eq 'value'

  describe 'Enumeration', ->
    runner = null

    beforeEach ->
      world.sub {key: 'value'}
      world.sub {foo: 'bar'}
      runner = new World
      runner.set 'do', sinon.spy()

    it 'has each property', ->
      expect(world.each).to.not.eq undefined

    it 'calls do on passed world with each member of subs', ->
      world.each runner
      expect(runner.do.called).to.eq true
      expect(runner.do.args[0]).to.eql [world, world.subs()[0]]
      expect(runner.do.args[1]).to.eql [world, world.subs()[1]]

    it 'call done on passed world after all subs', ->
      world.set 'done', sinon.spy()
      world.each runner
      expect(world.done.calledOnce).to.eq true

    it 'does the same for each_prop', ->
      world.set 'done', sinon.spy()
      world.each_prop runner
      expect(world.done.calledOnce).to.eq true

    it 'has fold property which starts with any initial value', ->
      expect(world.fold).to.not.eq undefined

  describe 'Examples', ->
    it 'tokenizer', ->
      class Tokenizer extends World
        constructor: (@_out) ->

        do: (world) ->

      s = World.string_sub "This string"
      env = new World()
      t = new Tokenizer(env) # sets out
      s.each t
      expect(env.body).to.eql ["This", "string"]

# Scoped Worlds Abstraction Notation
# Ih the actual SWAN language there will be syntax
# for many of these things.
# But for now, everything is a property of some World (or GOD)
# There are no keywords. no built-ins that are always accessible
# You can only access items in your scope
# And if your parent blocks GOD you can't even access that
#
# The reason is THE hard problem of computatin is 'effect'
# Who gets to change What (and When)

# This implies that the truth about anything lives in
# precisely one place in the hierarchy.
# Thus you need robust and flexible mechanism for creating and
# accessing proxies/tunnels with appropiate permissions.
