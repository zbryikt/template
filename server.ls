t1 = Date.now!
require! <[fs ./lib/server ./lib/watch ./api/index]>

# try using packages such as yargs?
if /\.json$/.exec(process.argv.2 or '') => cfgfile = process.argv.2
if !cfgfile => cfgfile = 'config.json'

main = do
  opt: {api: index, start-time: t1}
  set-opt: (o) -> @opt <<< o
  init: ->
    server.init @opt
    watch.init @opt

if require.main == module =>
  if fs.exists-sync(cfgfile) =>
    config = JSON.parse(fs.read-file-sync cfgfile .toString!)
    main.set-opt config
  main.init!

module.exports = main
