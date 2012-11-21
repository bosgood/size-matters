###
size-matters
Description: Sample URL shortener based on Node and MongoLab
Author: Brad Osgood
Date: Nov 21 2012
License: MIT
###

secrets = require './secrets'

getDb = () ->
    require('mongojs').connect(secrets.databaseUrl, ['urls'])

module.exports = getDb()