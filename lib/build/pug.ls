require! <[fs fs-extra pug path]>

cwd = path.resolve process.cwd!

main = do
  build: (list) ->
    for src in list =>
      if !/^src\/pug/.exec(src) => continue
      des = path.normalize(src.replace(/^src\/pug/, "static/").replace(/\.pug$/,".html"))
      try
        code = fs.read-file-sync src .toString!
        if /^\/\/- ?(module|view) ?/.exec(code) => return
        desdir = path.dirname(des)
        fs-extra.ensure-dir-sync desdir
        fs.write-file-sync des, pug.render code, {filename: src, basedir: path.dirname(path.join(cwd, src))}
        console.log "[BUILD] #src --> #des"
      catch
        console.log "[BUILD] #src failed: "
        console.log e.message
      return

module.exports = main
