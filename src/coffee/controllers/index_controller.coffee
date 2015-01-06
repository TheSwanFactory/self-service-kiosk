class SwanKiosk.Controllers.IndexController extends SwanKiosk.Controller
  index: ->
    $('body').html SwanKiosk.Layout.build
      contents:
        tag: 'h1'
        contents: 'Index'
