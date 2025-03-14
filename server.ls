t1 = Date.now!
require! <[fs path yargs @plotdb/colors @plotdb/srcbuild]>

lib = path.dirname fs.realpathSync __filename

server = require "#lib/lib/server"
api = require "#lib/api/index"

# TODO legacy support. remove this in future version.
if /\.json$/.exec(process.argv.2 or '') => cfgfile = process.argv.2
else
  argv = yargs
    .option \root, do
      alias: \r
      description: "root directory"
      type: \string
    .option \mix-asset, do
      alias: \m
      description: "mix asset with pug folder"
      type: \string
    .option \config, do
      alias: \c
      description: "config json"
      type: \string
    .option \port, do
      alias: \p
      description: "port to listen"
      type: \number
    .option \open, do
      alias: \o
      description: "open browser on startup"
      type: \bool
    .help \help
    .alias \help, \h
    .check (argv, options) -> return true
    .argv
  root = argv.r
  cfgfile = argv.c or \config.json # TODO legacy default value. set to null in future version.
  do-open = argv.o
  port = argv.p

# TODO legacy support. remove this in future version.
if !cfgfile => cfgfile = 'config.json'

main = do
  opt: {api: api, start-time: t1}
  set-opt: (o) -> @opt <<< o
  init: ->
    server.init @opt
      .then ~> srcbuild.i18n(@opt.i18n)
      .then (i18n) ~>
        srcbuild.lsp({
          bundle: {configFile: 'bundle.json'}
          asset: {
            srcdir: \src/pug, desdir: \static
            ext: argv.m.split(',') if argv.m and argv.m != "true"
          } if argv.m
        } <<< (@opt.lsp or {}) <<< {base: '.', i18n})

if require.main == module =>
  if fs.exists-sync(cfgfile) =>
    config = JSON.parse(fs.read-file-sync cfgfile .toString!)
    main.set-opt config
  if do-open? => main.set-opt {open: do-open}
  if port? => main.set-opt {port}
  if root? => process.chdir root
  main.init!

module.exports = main
