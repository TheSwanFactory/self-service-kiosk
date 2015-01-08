SwanKiosk.Layout.handledAttributes.events = (events, element) ->
  for name, func of events
    if typeof func != 'function'
      str = "this.#{func}"
      func = (event) -> eval(str).call(this, element, event)
    element.addEventListener name, func.bind(this)

