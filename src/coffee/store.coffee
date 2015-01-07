notDefined = (method) -> "#{method} has not been defined"

# this is a dummy class to define the interface
class SwanKiosk.Store
  get: -> throw new Error notDefined('get')
  set: -> throw new Error notDefined('set')
