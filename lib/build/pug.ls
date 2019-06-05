require! <[fs fs-extra pug path js-yaml markdown ./aux]>

cwd = path.resolve process.cwd!

pug-extapi = do
  md: -> markdown.markdown.toHTML it
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
  build: (list) ->
    list = @map list
    for {src,des} in list =>
      if !fs.exists-sync(src) or aux.newer(des, src) => continue
      try
        code = fs.read-file-sync src .toString!
        if /^\/\/- ?(module|view) ?/.exec(code) => continue
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        fs.write-file-sync des, pug.render code, {filename: src, basedir: path.join(cwd, 'src/pug/')} <<< pug-extapi
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
