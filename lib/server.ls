require! <[express path @plotdb/colors i18next-http-middleware open @plotdb/srcbuild/dist/view/pug ./i18n ./logger]>

server = do
  init: (opt = {}) ->
    @log = opt.logger or logger
    i18n(opt.i18n)
      .then (i18n) ~>
        @app = app = express!
        cwd = path.resolve(opt.feroot or '.')

        if i18n => app.use i18next-http-middleware.handle i18n, {ignoreRoutes: <[]>}

        # we precompile all view pug into .view folder, which can be used by our custom pug view engine.
        app.engine 'pug', pug({
          logger: @log
          i18n: i18n,
          viewdir: path.join(cwd, '.view')
          srcdir: path.join(cwd, 'src/pug')
          desdir: path.join(cwd, 'static')
        })
        app.set 'view engine', 'pug'
        app.set 'views', path.join(cwd, 'src/pug/')
        app.locals.viewdir = path.join(cwd, '.view/')
        app.locals.basedir = app.get \views

        if opt.api => opt.api @
        app.use \/, express.static path.join(cwd, \static)
        @log.info "express initialized in #{app.get \env} mode".green

        (res, rej) <~ new Promise _
        server = app.listen opt.port, (e) ~>
          delta = if opt.start-time => "( takes #{Date.now! - opt.start-time}ms )" else ''
          if e => return rej(e)
          @log.info "listening on port #{server.address!port} #delta".cyan
          if opt.open => open "http://localhost:#{server.address!port}"
          res server

      .then ->

module.exports = server
