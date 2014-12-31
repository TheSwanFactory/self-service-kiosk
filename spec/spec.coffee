expect = chai.expect

describe 'Dependencies', ->
  it 'has loDash', ->
    expect(typeof _).to.not.eq 'undefined'
