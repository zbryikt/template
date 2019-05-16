require! <[fs fs-extra LiveScript path colors]>

cwd = path.resolve process.cwd!

main = do
  map: (list) ->
    list
      .filter -> /^src\/ls/.exec(it)
      .map -> {src: it, des: path.normalize(it.replace(/^src\/ls/, "static/js/").replace(/\.ls/,".js"))}
  build: (list) ->
    list = @map list
    for {src,des} in list =>
      if !fs.exists-sync(src) => continue
      try
        code = fs.read-file-sync src .toString!
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        fs.write-file-sync des, LiveScript.compile(fs.read-file-sync(src)toString!,{bare:true})
        console.log "[BUILD] #src --> #des"
      catch
        console.log "[BUILD] #src failed: ".red
        console.log e.message.toString!red
    return
  unlink: (list) ->
    list = @map list
    for {src,des} in list =>
      fs.unlink-sync des
      console.log "[BUILD] #src --> #des deleted.".yellow


module.exports = main

