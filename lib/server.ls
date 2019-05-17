require! <[express path colors]>

server = do
  init: (opt) ->
    @app = app = express!
    app.set 'view engine', \pug
    app.use \/, express.static \static
    if opt.api => opt.api @
    console.log "[Server] Express Initialized in #{app.get \env} Mode".green
    server = app.listen opt.port, -> console.log "[SERVER] listening on port #{server.address!port}".cyan

module.exports = server
