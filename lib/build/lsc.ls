require! <[fs fs-extra LiveScript path]>

cwd = path.resolve process.cwd!

main = do
  build: (list) ->
    for src in list =>
      if !/^src\/ls/.exec(src) => continue
      des = path.normalize(src.replace(/^src\/ls/, "static/js/").replace(/\.ls/,".js"))
      try
        code = fs.read-file-sync src .toString!
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        fs.write-file-sync des, LiveScript.compile(fs.read-file-sync(src)toString!,{bare:true})
        console.log "[BUILD] #src --> #des"
      catch
        console.log "[BUILD] #src failed: "
        console.log e.message
      return

module.exports = main

