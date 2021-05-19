// Generated by LiveScript 1.6.0
var express, path, colors, i18nextHttpMiddleware, open, pug, i18n, logger, server;
express = require('express');
path = require('path');
colors = require('colors');
i18nextHttpMiddleware = require('i18next-http-middleware');
open = require('open');
pug = require('@plotdb/srcbuild/dist/view/pug');
i18n = require('./i18n');
logger = require('./logger');
server = {
  init: function(opt){
    var this$ = this;
    opt == null && (opt = {});
    this.log = opt.logger || logger;
    return i18n(opt.i18n).then(function(i18n){
      var app, cwd;
      this$.app = app = express();
      cwd = process.cwd();
      if (i18n) {
        app.use(i18nextHttpMiddleware.handle(i18n, {
          ignoreRoutes: []
        }));
      }
      app.engine('pug', pug({
        logger: this$.log,
        i18n: i18n,
        viewdir: '.view',
        srcdir: 'src/pug',
        desdir: 'static'
      }));
      app.set('view engine', 'pug');
      app.set('views', path.join(cwd, './src/pug/'));
      app.locals.viewdir = path.join(cwd, './.view/');
      app.locals.basedir = app.get('views');
      if (opt.api) {
        opt.api(this$);
      }
      app.use('/', express['static']('static'));
      this$.log.info(("express initialized in " + app.get('env') + " mode").green);
      return new Promise(function(res, rej){
        var server;
        return server = app.listen(opt.port, function(e){
          var delta;
          delta = opt.startTime ? "( takes " + (Date.now() - opt.startTime) + "ms )" : '';
          if (e) {
            return rej(e);
          }
          this$.log.info(("listening on port " + server.address().port + " " + delta).cyan);
          if (opt.open) {
            open("http://localhost:" + server.address().port);
          }
          return res(server);
        });
      });
    }).then(function(){});
  }
};
module.exports = server;