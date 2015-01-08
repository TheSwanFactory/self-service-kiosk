SwanKiosk.Utils =
  dasherize: (string) ->
    string.replace /[^a-zA-Z0-9]/g, '-'

  getFunction: (expression, context = this, call = false) ->
    if typeof expression == 'string'
      functionName = "this.#{expression}"
      expression = (-> eval functionName).call(context)
    if call && typeof expression == 'function'
      expression = expression.call context
    expression
