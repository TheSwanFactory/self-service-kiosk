utils = SwanKiosk.Utils

SwanKiosk.Layout.handledAttributes.events = (events, element) ->
  for name, func of events
    method = utils.getFunction func, this
    func = (event) -> method.call(this, element, event)
    element.addEventListener name, func.bind(this)

