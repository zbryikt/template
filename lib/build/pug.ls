require! <[fs fs-extra pug LiveScript stylus path js-yaml marked ./aux]>

cwd = path.resolve process.cwd!

md-options = html: {breaks: true, renderer: new marked.Renderer!}
marked.set-options md-options.html

pug-extapi = do
  filters: do
    'lsc': (text, opt) -> return LiveScript.compile(text,{bare:true})
    'stylus': (text, opt) ->
       stylus(text)
         .set \filename, 'inline'
         .define 'index', (a,b) ->
           a = (a.string or a.val).split(' ')
           return new stylus.nodes.Unit(a.indexOf b.val)
         .render!
    'md': (text, opt) -> marked text
  md: marked
  yaml: -> js-yaml.safe-load fs.read-file-sync it
  yamls: (dir) ->
    ret = fs.readdir-sync dir
      .map -> "#dir/#it"
      .filter -> /\.yaml$/.exec(it)
      .map ->
        try
          js-yaml.safe-load(fs.read-file-sync it)
        catch e
          console.log "[ERROR@#it]: ", e
    return ret


main = do
  map: (list) ->
    list
      .filter -> /^src\/pug/.exec(it)
      .map -> {src: it, des: path.normalize(it.replace(/^src\/pug/, "static/").replace(/\.pug$/,".html"))}
  # handy function to custom build quickly with the same configuration of server watcher.
  compile: (src,opt = {}) ->
    pug.compile(
      fs.read-file-sync(src).toString!,
      {filename: src, basedir: path.join(cwd, 'src/pug/')} <<< pug-extapi <<< opt
    )
  build: (list) ->
    list = @map list
    for {src,des} in list =>
      if !fs.exists-sync(src) or aux.newer(des, src) => continue
      code = fs.read-file-sync src .toString!
      try
        t1 = Date.now!
        if /^\/\/- ?module ?/.exec(code) => continue

        desv = des.replace('static/', '.view/').replace(/\.html$/, '.js')
        if fs.exists-sync(src) and !aux.newer(desv, src) =>
          desvdir = path.dirname(desv)
          fs-extra.ensure-dir-sync desvdir
          ret = pug.compileClient code, {filename: src, basedir: path.join(cwd, 'src/pug/')} <<< pug-extapi
          ret = """ (function() { #ret; module.exports = template; })() """
          fs.write-file-sync desv, ret
          t2 = Date.now!
          console.log "[BUILD] #src --> #desv ( #{t2 - t1}ms )"

        if !(/^\/\/- ?(view|module) ?/.exec(code)) =>
          desdir = path.dirname(des)
          fs-extra.ensure-dir-sync desdir
          fs.write-file-sync des, pug.render code, {filename: src, basedir: path.join(cwd, 'src/pug/')} <<< pug-extapi
          t2 = Date.now!
          console.log "[BUILD] #src --> #des ( #{t2 - t1}ms )"

      catch
        console.log "[BUILD] #src failed: ".red
        console.log e.message.toString!red
    return
  unlink: (list) ->
    list = @map list
    for {src,des} in list =>
      try
        if fs.exists-sync des =>
          fs.unlink-sync des
          console.log "[BUILD] #src --> #des deleted.".yellow
        des = des.replace('static/', '.view/').replace(/\.html$/, '.js')
        if fs.exists-sync des =>
          fs.unlink-sync des
          console.log "[BUILD] #src --> #des deleted.".yellow
      catch e
        console.log e
  extapi: pug-extapi

module.exports = main
