index = (req, res) ->
    # debugger
    res.send("fetching url for shortened url: #{req.url}")

exports.index = index