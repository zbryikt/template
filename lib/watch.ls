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
      .on \unlink, (~> @unlink it)
    console.log "[WATCHER] watching src for file change".cyan
  depend:
    on: {}
    # add dependency: a depends on b
    add: (a, b) -> if !(a in @on[][b]) => @on[][b].push a
  handle: {}
  on: (type, cb) -> @handle[][type].push cb
  pending: {}
  unlink: (f) -> 
    ret = /\.(.+)$/.exec(f)
    k = if !ret => "" else ret.1
    @handle[]["unlink.#k"].map (cb) -> cb [f]
    @update f
  update-debounced: debounce ->
    # get pending files and handle them
    [list, cat, @pending] = [[k for k of @pending], {}, {}]
    list = list
      .map (f) ~> [f, (ret = /\.(.+)$/.exec(f))]
      .map -> cat[][if it.1 => it.1.1 else ""].push it.0
    for k,v of cat => @handle[]["build.#k"].map (cb) -> cb v
  update: (f) ->
    try
      f = f.split(path.sep).join('/')
      # fetch pre-dependency, and put in pending
      list = if Array.isArray(f) => f else [f]
      list ++= list.map(~> @depend.on[it]).reduce(((a,b) -> a ++ b), [])
      list.map ~> @pending{}[it][f] = true
      @update-debounced!
    catch e
      console.log "[WATCHER] Update failed with following information: ".red
      console.log e

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
    parser.affect(n).map -> files[][it].push n
  builder.build [k for k of files], files

watch.on \build.pug, process(PugTree, pug)
watch.on \build.styl, process(StylusTree, stylus)
watch.on \build.ls, -> lsc.build it
watch.on \unlink.pug, -> pug.unlink it
watch.on \unlink.styl, -> stylus.unlink it
watch.on \unlink.ls, -> lsc.unlink it

module.exports = watch
