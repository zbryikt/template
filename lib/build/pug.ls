require! <[fs fs-extra pug path ./aux]>

cwd = path.resolve process.cwd!

main = do
  map: (list) ->
    list
      .filter -> /^src\/pug/.exec(it)
      .map -> {src: it, des: path.normalize(it.replace(/^src\/pug/, "static/").replace(/\.pug$/,".html"))}
  build: (list) ->
    list = @map list
    for {src,des} in list =>
      if !fs.exists-sync(src) or aux.newer(des, src) => continue
      try
        code = fs.read-file-sync src .toString!
        if /^\/\/- ?(module|view) ?/.exec(code) => continue
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        fs.write-file-sync des, pug.render code, {filename: src, basedir: path.join(cwd, 'src/pug/')}
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
