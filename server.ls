t1 = Date.now!
require! <[fs ./lib/server ./lib/watch ./api/index]>

main = do
  opt: {port: 3000, api: index, start-time: t1}
  set-opt: (o) -> @opt <<< o
  init: ->
    server.init @opt
    watch.init @opt

if require.main == module =>
  if fs.exists-sync('config.json') =>
    config = JSON.parse(fs.read-file-sync 'config.json' .toString!)
    main.set-opt config
  main.init!

module.exports = main
