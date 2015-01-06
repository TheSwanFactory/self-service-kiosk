class SwanKiosk.Controllers.IndexController extends SwanKiosk.Controller
  index: ->
    [{
      tag: 'h1'
      contents: 'Index'
    },
    {
      tag: 'a'
      href: '/questions/0'
      contents: 'Start Questions'
    }]
