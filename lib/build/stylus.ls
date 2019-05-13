require! <[fs fs-extra stylus path]>

cwd = path.resolve process.cwd!

main = do
  build: (list) ->
    for src in list =>
      if !/^src\/styl/.exec(src) => continue
      des = path.normalize(src.replace(/^src\/styl/, "static/css/").replace(/\.styl/,".css"))
      try
        code = fs.read-file-sync src .toString!
        if /^\/\/- ?(module) ?/.exec(code) => return
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
        console.log "[BUILD] #src failed: "
        console.log e.message
      return

module.exports = main
