require! <[chokidar path debounce.js ./tree/PugTree ./tree/StylusTree ./build/pug ./build/stylus ./build/lsc]>

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
  pending: {}
  update: (f) ->
    # fetch pre-dependency, and put in pending
    list = if Array.isArray(f) => f else [f]
    list ++= list.map(~> @depend.on[it]).reduce(((a,b) -> a ++ b), [])
    list.map ~> @pending[it] = true
    _ = debounce ~>
      # get pending files and handle them
      [list,cat, @pending] = [[k for k,v of @pending], {}, {}]
      list = list
        .map (f) ~> [f, (ret = /\.(.+)$/.exec(f))]
        .filter -> it.1
        .map -> cat[][it.1.1].push it.0
      for k,v of cat => @handle[][k].map (cb) -> cb v
    _!

# Process Wrapper 
#  - list: candidate files
#  - for each n in list:
#      parse n ( what files n depends on? )
#      add dependency of n ( n depends on f )
#      list affected files from n.
process = (parser, builder) -> (list) ->
  files = {}
  for n in list =>
    parser.parse n .map (f) -> watch.depend.add n, f
    parser.affect(n).map -> files[it] = true
  builder.build [k for k of files]

watch.on \pug, process(PugTree, pug)
watch.on \stylus, process(StylusTree, stylus)
watch.on \ls, -> lsc.build if Array.isArray(it) => it else [it]

module.exports = watch
