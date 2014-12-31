expect = require('chai').expect
require('../client/assets/coffee/app')
require('../client/assets/coffee/layout')

describe 'Layout', ->
  layout   = SwanKiosk.Layout
  built    = ''
  contents = ''

  describe '.build()', ->
    beforeEach ->
      built = layout.build(tag: 'div', contents: contents)

    it 'creates a tag', ->
      expect(built).to.contain('<div>')

    describe 'contents', ->
      describe 'string', ->
        before -> contents = 'my content'

        it 'adds raw string', ->
          expect(built).to.contain('content')
