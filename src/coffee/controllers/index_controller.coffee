class SwanKiosk.Controllers.IndexController extends SwanKiosk.Controller
  index: ->
    $('body').html @params.id
