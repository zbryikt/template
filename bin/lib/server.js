// Generated by LiveScript 1.3.1
(function(){
  var express, path, colors, view, server;
  express = require('express');
  path = require('path');
  colors = require('colors');
  view = require('./view');
  server = {
    init: function(opt){
      var app, cwd, server;
      this.app = app = express();
      cwd = process.cwd();
      app.engine('pug', view);
      app.set('view engine', 'pug');
      app.set('views', path.join(cwd, './src/pug/'));
      app.locals.viewdir = path.join(cwd, './.view/');
      app.locals.basedir = app.get('views');
      app.set('view engine', 'pug');
      if (opt.api) {
        opt.api(this);
      }
      app.use('/', express['static']('static'));
      console.log(("[Server] Express Initialized in " + app.get('env') + " Mode").green);
      return server = app.listen(opt.port, function(){
        var delta;
        delta = opt.startTime ? "( takes " + (Date.now() - opt.startTime) + "ms )" : '';
        return console.log(("[SERVER] listening on port " + server.address().port + " " + delta).cyan);
      });
    }
  };
  module.exports = server;
}).call(this);