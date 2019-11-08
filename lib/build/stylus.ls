require! <[fs fs-extra stylus path uglifycss ./aux]>

cwd = path.resolve process.cwd!

main = do
  map: (list) ->
    list
      .filter -> /^src\/styl/.exec(it)
      .map (src) ->
        des = path.normalize(src.replace(/^src\/styl/, "static/css/").replace(/\.styl/,".css"))
        des-min = des.replace /\.css$/, '.min.css'
        {src, des, des-min }
  build: (list, caused-by) ->
    list = @map list
    for {src,des,des-min} in list =>
      if !fs.exists-sync(src) or aux.newer(des, [src] ++ (caused-by[src] or [])) => continue
      try
        t1 = Date.now!
        code = fs.read-file-sync src .toString!
        if /^\/\/- ?(module) ?/.exec(code) => continue
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        stylus code
          .set \filename, src
          .render (e, css) ->
            if e => throw e
            code-min = uglifycss.processString(css, uglyComments: true)
            fs.write-file-sync des, css
            fs.write-file-sync des-min, code-min
            t2 = Date.now!
            console.log "[BUILD] #src --> #des / #des-min ( #{t2 - t1}ms )"
      catch
        console.log "[BUILD] #src failed: ".red
        console.log e.message.toString!red
    return
  unlink: (list) ->
    list = @map list
    for {src,des,des-min} in list =>
      if fs.exists-sync des =>
        fs.unlink-sync des
        console.log "[BUILD] #src --> #des deleted.".yellow
      if fs.exists-sync des-min =>
        fs.unlink-sync des-min
        console.log "[BUILD] #src --> #des-min deleted.".yellow

module.exports = main
