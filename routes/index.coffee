###
size-matters
Description: Sample URL shortener based on Node and MongoLab
Author: Brad Osgood
Date: Nov 21 2012
License: MIT
###

uuid = require 'node-uuid'

db = require '../db'

# Redirects to the full URL associated with the requested short URL
go = (req, resp) ->
    loadUrl(req, resp,
        (url, shortUrl) ->
            resp.redirect(url.fullUrl)
        (err, shortUrl) ->
            resp.send("failed to find entry for url: #{shortUrl}")
    )

# Returns the full URL a shortened URL points to
read = (req, resp) ->
    loadUrl(req, resp,
        (url, shortUrl) ->
            resp.send("\"#{url.shortUrl}\" points to: #{url.fullUrl}")
        (err, shortUrl) ->
            resp.send("failed to fetch shortened url \"#{shortUrl}\"")
    )

loadUrl = (req, resp, onSuccess, onError) ->
    shortUrl = req.params[0]
    db.urls.find
        shortUrl: shortUrl
    , (err, urls) ->
        if err or urls.length == 0
            onError(err, shortUrl)
        else
            onSuccess(urls[0], shortUrl)

# Shortens URLs into 8 strings of alphanumeric digits
create = (req, resp) ->
    # Generate a random octet
    shortUrl = uuid.v4()[...8]
    fullUrl = req.params[0]
    db.urls.save
        fullUrl: fullUrl
        shortUrl: shortUrl
    , (err, saved) ->
        if (err or not saved)
            resp.send("error shortening url \"#{fullUrl}\"")
        else
            resp.send("shortened url \"#{fullUrl}\" to \"#{shortUrl}\"")

# Dumps all URL mappings
dump = (req, resp) ->
    db.urls.find (err, urls) ->
        respContent = 'found urls:<ul>'
        for url in urls
            respContent += "<li>url: target=#{url.fullUrl} shortened=#{url.shortUrl}</li>"
        respContent += "</ul>"
        resp.send(respContent)

exports.read = read
exports.create = create
exports.dump = dump
exports.go = go
