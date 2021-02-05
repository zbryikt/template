require! <[fs fs-extra livescript path colors uglify-js ./aux]>

main = do
  map: (list) ->
    list
      .filter -> /^src\/ls/.exec(it.file or it)
      .map (it) ->
        src = it.file or it
        mtime = it.mtime or Date.now!
        des = path.normalize(src.replace(/^src\/ls/, "static/js/").replace(/\.ls/,".js"))
        des-min = des.replace /\.js$/, '.min.js'
        {src, des, des-min, mtime: mtime}
  build: (list) ->
    list = @map list
    for {src,des, des-min,mtime} in list =>
      if !fs.exists-sync(src) or aux.newer(des, mtime) => continue
      try
        t1 = Date.now!
        code = fs.read-file-sync src .toString!
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        code = livescript.compile(fs.read-file-sync(src)toString!,{bare: true, header: false})
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

