require! <[fs fs-extra LiveScript path colors uglify-js ./aux]>

cwd = path.resolve process.cwd!

main = do
  map: (list) ->
    list
      .filter -> /^src\/ls/.exec(it)
      .map (src) ->
        des = path.normalize(src.replace(/^src\/ls/, "static/js/").replace(/\.ls/,".js"))
        des-min = des.replace /\.js$/, '.min.js'
        {src, des, des-min}
  build: (list) ->
    list = @map list
    for {src,des, des-min} in list =>
      if !fs.exists-sync(src) or aux.newer(des, src) => continue
      try
        t1 = Date.now!
        code = fs.read-file-sync src .toString!
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        code = LiveScript.compile(fs.read-file-sync(src)toString!,{bare:true})
        code-min = uglify-js.minify(code).code
        fs.write-file-sync des, code
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

