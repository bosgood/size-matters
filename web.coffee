###
size-matters
Description: Sample URL shortener based on Node and MongoLab
Author: Brad Osgood
Date: Nov 21 2012
License: MIT
###

path    = require 'path'
express = require 'express'
http    = require 'http'
routes  = require './routes'

cfg =
    port: 8081
    host: '127.0.0.1'

app = express()
app.configure () ->
    app.set('port', process.env.PORT or cfg.port)
    app.set('views', "#{__dirname}/views")
    app.set('view engine', 'html')
    app.use(express.favicon())
    app.use(express.logger('dev'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', () ->
  app.use(express.errorHandler())

## Verbs ##

# Dump - dumps all mappings
app.get '/dump', routes.dump

# Read - examine the value of a mapping
app.get /^\/read\/(.*?)$/, routes.read

# URL - create and utilize mappings
url_plus_any_string = /^\/url\/(.*?)$/
app.get url_plus_any_string, routes.go
app.post url_plus_any_string, routes.create

http.createServer(app).listen(app.get('port'), () ->
  console.log("Express server listening on port #{app.get('port')}")
)
