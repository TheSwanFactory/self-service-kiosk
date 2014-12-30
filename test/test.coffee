expect = require('chai').expect
app    = require('../client/assets/coffee/app')
layout = require('../client/assets/coffee/layout')

describe 'Layout', ->
  describe '.build()', ->
    built = layout.build tag: 'div', contents: 'hello'

    it 'creates a tag', ->
      expect(built).to.contain('<div>')
      expect(built).to.contain('hello')
