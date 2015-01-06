# requires page.js

defaultRoute = (ctx) ->
  controller = SwanKiosk.Controllers._find ctx.params.controller
  return notFound() unless controller
  SwanKiosk.Create controller, ctx.params

notFound = ->
  $('body').html '404d!'

page '/:controller/:action/:id', defaultRoute
page '*', notFound
