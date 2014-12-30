expect = require('chai').expect
require('../client/assets/coffee/app')
require('../client/assets/coffee/layout')

describe 'Layout', ->
  layout = SwanKiosk.Layout
  describe '.build()', ->
    built = layout.build tag: 'div', contents: 'hello'

    it 'creates a tag', ->
      expect(built).to.contain('<div>')
      expect(built).to.contain('hello')
