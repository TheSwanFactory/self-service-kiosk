describe.only 'SwanKiosk.World', ->
  src    = null
  center = (dictionary) ->
    class:    'centered'
    contents: dictionary

  beforeEach -> src = new SwanKiosk.World(key: 'value')

  it 'center works', ->
    dict = {key: 'value'}
    expect(center dict).to.eql
      class:    'centered'
      contents: {key: 'value'}

  it 'two stage pipe', ->
    pipeline = src.pipe center
    result   = pipeline.call()

    expect(result).to.eql
      class:    'centered'
      contents: {key: 'value'}

  it 'call/pipe', ->
    layout = new SwanKiosk.Transform (world) ->
      world.value.title = 'layout!'

    pipeline = src.pipe(center).pipe(layout)
    result   = pipeline.call()

    expect(result).to.eql
      class:    'centered'
      contents: {key: 'value'}
      title:    'layout!'
