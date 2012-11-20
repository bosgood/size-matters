index = (req, res) ->
    # debugger
    res.send("fetching url for shortened url: #{req.url}")

create = (req, res) ->
    # debugger
    res.send("shortening url for #{req.url}")

exports.index = index
exports.create = create