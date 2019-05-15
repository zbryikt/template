require! <[chokidar path ./tree/PugTree ./tree/StylusTree ./build/pug ./build/stylus ./build/lsc]>

PugTree.set-root \src/pug
StylusTree.set-root \src/styl

watch = do
  ignores: [/^\./]
  init: ->
    cfg = do
      persistent: true
      ignored: (f) ~> !@ignores.map(-> it.exec(path.basename f)).length
    @watcher = chokidar.watch <[src static]>, cfg
      .on \add, (~> @update it)
      .on \change, (~> @update it)
    console.log "[WATCHER] watching src for file change".cyan
  depend:
    on: {}
    # add dependency: a depends on b
    add: (a, b) -> if !(a in @on[][b]) => @on[][b].push a

  handle: {}
  on: (type, cb) -> @handle[][type].push cb
  update: (f) ->
    list = if Array.isArray(f) => f else [f]
    list ++= list.map(~> @depend.on[it]).reduce(((a,b) -> a ++ b), [])
    list
      .map (f) ~> [f, (ret = /\.(.+)$/.exec(f))]
      .filter -> it.1
      .map (v) ~> @handle[][v.1.1].map (cb) -> cb v.0

watch.on \pug, (n) ->
  PugTree.parse n
    .map (f) -> watch.depend.add n, f
  list = PugTree.affect n
  pug.build list

watch.on \styl, (n) ->
  StylusTree.parse n
    .map (f) -> watch.depend.add n, f
  list = StylusTree.affect n
  stylus.build list

watch.on \ls, -> lsc.build [it]

module.exports = watch
