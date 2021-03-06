require! <[fs fs-extra chokidar path @loadingio/debounce.js]>
require! <[./i18n]>
require! <[./tree/PugTree ./tree/StylusTree ./build/pug ./build/stylus ./build/lsc ./build/aux ./build/bundle]>

PugTree.set-root \src/pug
StylusTree.set-root \src/styl

watch = do
  ignores: [/^\..*\.swp$/]
  init: (opt={}) ->
    i18n(opt.i18n)
      .then (i18n) ~>
        pug.opt({i18n})
        cfg = do
          persistent: true
          ignored: (f) ~> @ignores.filter(-> it.exec(f)).length
        if opt.{}watcher.ignores => @ignores = opt.{}watcher.ignores
        @ignores = @ignores.map -> new RegExp(it)
        @watcher = chokidar.watch <[src static]>, cfg
          .on \add, (~> @update it)
          .on \change, (~> @update it)
          .on \unlink, (~> @unlink it)
        @assets opt.assets or []
        console.log "[WATCHER] watching src for file change".cyan

  custom: ({files, update, unlink, ignored}) ->
    w = chokidar.watch files, {persistent: true} <<< (if ignored => {ignored} else {})
    w.on \add, -> update it
    w.on \change, -> update it
    w.on \unlink, -> unlink it

  assets: (assets = []) ->
    modpath = \node_modules
    while modpath.length < 50 =>
      if fs.exists-sync(modpath) => break
      modpath = path.join('..', modpath)
    if !fs.exists-sync(modpath) => return console.log "[ASSETS] node_modules dir not found.".red

    desdir = (f) -> path.join(\static/assets, path.relative(modpath, path.dirname(f)), \..)
    add = (src) ->
      des = path.join(desdir(src), path.basename(src))
      if !aux.newer(src, [des]) => return
      fs-extra.ensure-dir-sync desdir(src)
      fs-extra.copy-file-sync src, des
      console.log "[ASSETS] #src -> #des "
    remove = (src) ->
      des = path.join(desdir(src), path.basename(src))
      if !fs.exists-sync(des) => return
      fs.unlink-sync des
      console.log "[ASSETS] #src -> #des deleted.".yellow

    chokidar.watch assets.map(-> "#modpath/#it/dist/"), {persistent: true}
      .on \add, add
      .on \change, add
      .on \unlink, remove
    
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
    @handle[]["unlink.#k"].map (cb) -> cb [{file: f}]
    @handle[]["unlink"].map (cb) -> cb [{file: f}]
    @update f
  update-debounced: debounce 100, ->
    # get pending files and handle them
    list = []
    for k,v of @pending => list.push {file: k, mtime: Math.max.apply(Math, [t for f,t of v])}
    [@pending, cat] = [{}, {}]
    for item in list =>
      ret = /\.([^.]+)$/.exec(item.file)
      cat[][if ret => ret.1 else ''].push item
    for k,v of cat => @handle[]["build.#k"].map (cb) -> cb v
    @handle[]["build"].map (cb) -> cb list

  update: (f) ->
    try
      f = f.split(path.sep).join('/')
      # fetch pre-dependency, and put in pending
      list = if Array.isArray(f) => f else [f]
      list = (list ++ list.map(~> @depend.on[it]).reduce(((a,b) -> a ++ b), [])).filter(->it)
      list.map ~> if fs.exists-sync(f) => @pending{}[it][f] = fs.stat-sync(f).mtime
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
    parser.parse n .map (f) -> watch.depend.add n.file, f
    parser.affect(n).map -> files[][it].push n
  list = []
  for k,v of files =>
    list.push do
      file: k
      mtime: Math.max.apply(Math, v.map(-> it.mtime))
  builder.build list, files

watch.on \build.pug, process(PugTree, pug)
watch.on \build.styl, process(StylusTree, stylus)
watch.on \build.ls, -> lsc.build it
watch.on \unlink.pug, -> pug.unlink it
watch.on \unlink.styl, -> stylus.unlink it
watch.on \unlink.ls, -> lsc.unlink it

watch.custom do
  files: <[static bundle.json]>
  ignored: (f) ~> watch.ignores.filter(-> it.exec(f)).length or /static\/(js|css)\/pack\//.exec(f)
  update: -> bundle.build [{file: it}]
  unlink: -> bundle.unlink [{file: it}]

module.exports = watch
