require! <[express path colors ./view]>

server = do
  init: (opt) ->
    @app = app = express!

    # we precompile all view pug into .view folder, which can be used by our custom pug view engine.
    app.engine 'pug', view
    app.set 'view engine', 'pug'
    app.set 'views', path.join(__dirname, './src/pug/')
    app.locals.viewdir = path.join(__dirname, './.view/')
    app.locals.basedir = app.get \views

    app.set 'view engine', \pug
    app.use \/, express.static \static
    if opt.api => opt.api @
    console.log "[Server] Express Initialized in #{app.get \env} Mode".green
    server = app.listen opt.port, ->
      delta = if opt.start-time => "( takes #{Date.now! - opt.start-time}ms )" else ''
      console.log "[SERVER] listening on port #{server.address!port} #delta".cyan

module.exports = server
