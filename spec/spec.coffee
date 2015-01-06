expect = chai.expect

# setup fixture div
$ ->
  window.fixtureDiv = $("#fixture")
afterEach ->
  fixtureDiv.empty()

# disable page
page = (->)

describe 'Dependencies', ->
  it 'has loDash', ->
    expect(typeof _).to.not.eq 'undefined'

  it 'has jQuery', ->
    expect(typeof $).to.not.eq 'undefined'
