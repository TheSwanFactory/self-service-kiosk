SwanKiosk.Utils =
  dasherize: (string) ->
    string.replace /[^a-zA-Z0-9]/g, '-'
