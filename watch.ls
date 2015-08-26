require! <[chokidar fs-extra path jade stylus express]>
require! 'uglify-js': uglify, LiveScript: lsc
fs = fs-extra

RegExp.escape = -> it.replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"
cwd = path.resolve process.cwd!
cwd-re = new RegExp RegExp.escape "#cwd#{if cwd[* - 1]=='/' => "" else \/}"

styl-tree = do
  down-hash: {}
  up-hash: {}
  parse: (filename) ->
    dir = path.dirname(filename)
    ret = fs.read-file-sync filename .toString!split \\n .map(-> /^ *@import (.+)/.exec it)filter(->it)map(->it.1)
    ret = ret.map -> path.join(dir, it.replace(/(\.styl)?$/, ".styl"))
    @down-hash[filename] = ret
    for it in ret => if not (filename in @up-hash.[][it]) => @up-hash.[][it].push filename
  find-root: (filename) ->
    work = [filename]
    ret = []
    while work.length > 0
      f = work.pop!
      if @up-hash.[][f].length == 0 => ret.push f
      else work ++= @up-hash[f]
    ret

mkdir-recurse = (f) ->
  if fs.exists-sync f => return
  parent = path.dirname(f)
  if !fs.exists-sync parent => mkdir-recurse parent
  fs.mkdir-sync f

ftype = ->
  switch
  | /\.ls$/.exec it => "ls"
  | /\.styl/.exec it => "styl"
  | /\.jade$/.exec it => "jade"
  | otherwise => "other"

update-file = ->
  src = if it.0 != \/ => path.join(cwd,it) else it
  src = src.replace path.join(cwd,\/), ""
  [type,cmd,des] = [ftype(src), "",""]

  if type == \other => 
    if /^manifest.json/.exec(src) =>
      try
        des = src.replace(/^/, 'dist/')
        desdir = path.dirname(des)
        if !fs.exists-sync(desdir) or !fs.stat-sync(desdir).is-directory! => mkdir-recurse desdir
        fs.copy-sync src, des
        console.log "[COPY ] #src --> #des"
      catch
        console.log "[COPY ] #src failed: \n", e.message
    else if /^manifest.xml$/.exec(src) =>
      try
        des = src.replace(/^/, 'dist/CSXS/')
        desdir = path.dirname(des)
        if !fs.exists-sync(desdir) or !fs.stat-sync(desdir).is-directory! => mkdir-recurse desdir
        fs.copy-sync src, des
        console.log "[COPY ] #src --> #des"
      catch
        console.log "[COPY ] #src failed: \n", e.message
    else if /^.debug$/.exec(src) =>
      try
        des = src.replace(/^/, 'dist/')
        desdir = path.dirname(des)
        if !fs.exists-sync(desdir) or !fs.stat-sync(desdir).is-directory! => mkdir-recurse desdir
        fs.copy-sync src, des
        console.log "[COPY ] #src --> #des"
      catch
        console.log "[COPY ] #src failed: \n", e.message
    else if /^assets\//.exec(src) =>
      try
        des = src.replace(/^assets/, 'dist/assets')
        desdir = path.dirname(des)
        if !fs.exists-sync(desdir) or !fs.stat-sync(desdir).is-directory! => mkdir-recurse desdir
        fs.copy-sync src, des
        console.log "[COPY ] #src --> #des"
      catch
        console.log "[COPY ] #src failed: \n", e.message
    return
  if type == \ls =>
    if /src\/ls/.exec src =>
      des = src.replace(/^src\/ls/, 'dist/js').replace(/\.ls$/, '.js')
      desdir = path.dirname(des)
      if !fs.exists-sync(desdir) or !fs.stat-sync(desdir).is-directory! => mkdir-recurse desdir
      try
        config = fs.read-file-sync(\config.ls).toString! + \\n
        result = uglify.minify(lsc.compile(config + fs.read-file-sync(src)toString!,{bare:true}),{fromString:true}).code
        fs.write-file-sync des, result
        console.log "[BUILD] #src --> #des"
      catch
        console.log "[BUILD] #src failed: \n", e.message
      return

  if type == \styl =>
    if /(basic|vars)\.styl$/.exec it => return
    try
      styl-tree.parse src
      srcs = styl-tree.find-root src
    catch
      console.log "[BUILD] #src failed: \n", e.message

    console.log "[BUILD] recursive from #src:"
    for src in srcs
      try
        des = src.replace(/^src\/styl/, "dist/css").replace(/\.styl$/, ".css")
        stylus fs.read-file-sync(src)toString!
          .set \filename, src
          .define 'index', (a,b) ->
            a = (a.string or a.val).split(' ')
            return new stylus.nodes.Unit(a.indexOf b.val)
          .render (e, css) ->
            if e =>
              console.log "[BUILD]   #src failed: "
              console.log "  >>>", e.name
              console.log "  >>>", e.message
            else => 
              mkdir-recurse path.dirname(des)
              fs.write-file-sync des, css
              console.log "[BUILD]   #src --> #des"
      catch
        console.log "[BUILD]   #src failed: "
        console.log e.message

  if type == \jade => 
    des = src.replace(/^src\/jade/,"dist").replace(/\.jade$/, ".html")

    config = lsc.compile(fs.read-file-sync(\config.ls).toString!, {bare:true})
    eval(config)
    try 
      desdir = path.dirname(des)
      if !fs.exists-sync(desdir) or !fs.stat-sync(desdir).is-directory! => mkdir-recurse desdir
      fs.write-file-sync des, jade.render (fs.read-file-sync src .toString!),{filename: src, basedir: path.join(cwd), config: {} <<< config}
      console.log "[BUILD] #src --> #des"
    catch
      console.log "[BUILD] #src failed: "
      console.log e.message
    return 

white-list = [/^\.debug$/]
ignore-list = [/^server.ls$/, /library.jade$/, /^\.[^/]+/, /node_modules/, /\.swp$/, /^dist\//]
ignore-func = (f) ->
  if !f => return 0
  f = f.replace(cwd-re, "")replace(/^\.\/+/, "")
  if white-list.filter(->it.exec f)length => return 0
  ignore-list.filter(-> it.exec f.replace(cwd-re, "")replace(/^\.\/+/, ""))length
watcher = chokidar.watch \., ignored: ignore-func, persistent: true
  .on \add, update-file
  .on \change, update-file

app = express!
app.use \/, express.static(path.join(__dirname, 'dist'))
server = app.listen 9999, -> console.log "Listening at http://localhost:#{server.address!port}"
