require! <[chokidar path ./tree/PugTree ./tree/StylusTree ./build/pug ./build/stylus ./build/lsc]>

PugTree.set-root \src/pug
StylusTree.set-root \src/styl

watch = do
  ignores: [/^\./]
  init: ->
    cfg = do
      persistent: true
      ignored: (f) ~> !@ignores.map(-> it.exec(path.basename f)).length
    @watcher = chokidar.watch \src, cfg
      .on \add, (~> @update it)
      .on \change, (~> @update it)
    console.log "[WATCHER] watching src for file change".cyan
  handle: {}
  on: (type, cb) -> @handle[][type].push cb
  update: (f) ->
    if !(ret = /\.(.+)$/.exec(f)) => return
    @handle[][ret.1].map (cb) -> cb f

watch.on \pug, ->
  PugTree.parse it
  list = PugTree.affect it
  pug.build list

watch.on \styl, ->
  StylusTree.parse it
  list = StylusTree.affect it
  stylus.build list

watch.on \ls, ->
  lsc.build [it]

module.exports = watch
