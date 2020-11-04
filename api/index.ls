({app}) <- (-> module.exports = it) _

# app.get \/api-test, (req, res) -> res.send "api is working"

app.get \/view-test, (req, res) -> res.render 'view.pug', {}
