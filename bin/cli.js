#!/usr/bin/env node
// Generated by LiveScript 1.6.0
var t1, fs, path, yargs, colors, srcbuild, lib, server, api, cfgfile, argv, root, doOpen, port, main, config;
t1 = Date.now();
fs = require('fs');
path = require('path');
yargs = require('yargs');
colors = require('colors');
srcbuild = require('@plotdb/srcbuild');
lib = path.dirname(fs.realpathSync(__filename));
server = require(lib + "/lib/server");
api = require(lib + "/api/index");
if (/\.json$/.exec(process.argv[2] || '')) {
  cfgfile = process.argv[2];
} else {
  argv = yargs.option('root', {
    alias: 'r',
    description: "root directory",
    type: 'string'
  }).option('config', {
    alias: 'c',
    description: "config json",
    type: 'string'
  }).option('port', {
    alias: 'p',
    description: "port to listen",
    type: 'number'
  }).option('open', {
    alias: 'o',
    description: "open browser on startup",
    type: 'bool'
  }).help('help').alias('help', 'h').check(function(argv, options){
    return true;
  }).argv;
  root = argv.r;
  cfgfile = argv.c || 'config.json';
  doOpen = argv.o;
  port = argv.p;
}
if (!cfgfile) {
  cfgfile = 'config.json';
}
main = {
  opt: {
    api: api,
    startTime: t1
  },
  setOpt: function(o){
    return import$(this.opt, o);
  },
  init: function(){
    var this$ = this;
    return server.init(this.opt).then(function(){
      return srcbuild.i18n(this$.opt.i18n);
    }).then(function(i18n){
      return srcbuild.lsp({
        base: '.',
        i18n: i18n
      });
    });
  }
};
if (require.main === module) {
  if (fs.existsSync(cfgfile)) {
    config = JSON.parse(fs.readFileSync(cfgfile).toString());
    main.setOpt(config);
  }
  if (doOpen != null) {
    main.setOpt({
      open: doOpen
    });
  }
  if (port != null) {
    main.setOpt({
      port: port
    });
  }
  if (root != null) {
    process.chdir(root);
  }
  main.init();
}
module.exports = main;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
