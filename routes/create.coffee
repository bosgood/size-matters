create = (req, res) ->
    # debugger
    res.send("shortening url for #{req.url}")

exports.create = create