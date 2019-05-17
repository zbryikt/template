require! <[fs fs-extra stylus path ./aux]>

cwd = path.resolve process.cwd!

main = do
  map: (list) ->
    list
      .filter -> /^src\/styl/.exec(it)
      .map -> {src: it, des: path.normalize(it.replace(/^src\/styl/, "static/css/").replace(/\.styl/,".css"))}
  build: (list) ->
    list = @map list
    for {src,des} in list =>
      if !fs.exists-sync(src) or aux.newer(des, src) => continue
      try
        code = fs.read-file-sync src .toString!
        if /^\/\/- ?(module) ?/.exec(code) => continue
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        stylus code
          .set \filename, src
          .define 'index', (a,b) ->
            a = (a.string or a.val).split(' ')
            return new stylus.nodes.Unit(a.indexOf b.val)
          .render (e, css) ->
            if e => throw e
            fs.write-file-sync des, css
            console.log "[BUILD] #src --> #des"
      catch
        console.log "[BUILD] #src failed: ".red
        console.log e.message.toString!red
    return
  unlink: (list) ->
    list = @map list
    for {src,des} in list => if fs.exists-sync des =>
      fs.unlink-sync des
      console.log "[BUILD] #src --> #des deleted.".yellow

module.exports = main
