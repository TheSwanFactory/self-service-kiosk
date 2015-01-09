describe 'SwanKiosk.World', ->
  it 'call/pipe', ->
    src    = new SwanKiosk.Data {key: 'value'}
    center = (dictionary) ->
      class:    'centered'
      contents: dictionary
    layout = new SwanKiosk.Transform (world) ->
      world.value.title = 'layout!'

    pipeline = src.pipe(center).pipe(layout)
    result   = pipeline.call()

    expect(result).to.eql
      class:    'centered'
      contents: {key: 'value'}
      title:    'layout!'
