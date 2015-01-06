# requires page.js

defaultRoute = (ctx) ->
  controller = SwanKiosk.Controllers._find ctx.params.controller || 'index'
  return notFound() unless controller
  SwanKiosk.create controller, ctx.params

notFound = ->
  $('body').html '404d!'

page '/:controller/:action?/:id?', defaultRoute
page '', defaultRoute
page '*', notFound
