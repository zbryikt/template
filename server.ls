t1 = Date.now!
require! <[fs path yargs]>

lib = path.dirname fs.realpathSync __filename

server = require "#lib/lib/server"
watch = require "#lib/lib/watch"
api = require "#lib/api/index"

# legacy support. remove this in future version.
if /\.json$/.exec(process.argv.2 or '') => cfgfile = process.argv.2
else
  argv = yargs
    .option \root, do
      alias: \r
      description: "root directory"
      type: \string
    .option \config, do
      alias: \c
      description: "config json"
      type: \string
    .help \help
    .alias \help, \h
    .check (argv, options) -> return true
    .argv
  root = argv.r
  cfgfile = argv.c or \config.json

# legacy support. remove this in future version.
if !cfgfile => cfgfile = 'config.json'

main = do
  opt: {api: api, start-time: t1}
  set-opt: (o) -> @opt <<< o
  init: ->
    server.init @opt
    watch.init @opt

if require.main == module =>
  if fs.exists-sync(cfgfile) =>
    config = JSON.parse(fs.read-file-sync cfgfile .toString!)
    main.set-opt config
  if root? => process.chdir root
  main.init!

module.exports = main
