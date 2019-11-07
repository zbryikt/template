require! <[fs fs-extra LiveScript stylus path colors uglify-js uglifycss ./aux debounce.js]>

cwd = path.resolve process.cwd!

bundle = {css: {}, js: {}}
task = {css: {}, js: {}}
bundle-file = "bundle.json"

build = ({name, list, type}) ->
  t1 = Date.now!
  outdir = "static/#type/pack/"
  outfile = path.join(outdir, "#name.#type")
  outfilemin = path.join(outdir, "#name.min.#type")
  Promise.resolve!
    .then -> new Promise (res, rej) -> fs-extra.ensure-dir outdir, -> res!
    .then ->
      Promise.all list.map((f) -> new Promise (res, rej) ->
        fs.read-file(f, (e,b) -> if e => rej e else res b.toString!))
    .then (list) ->
      normal = list.join('')
      minified = list
        .map (code) -> 
          if type == \js => uglify-js.minify(code).code
          else if type == \css => uglifycss.processString(code, uglyComments: true)
          else code
        .join('')
      Promise.all [
        new Promise (res, rej) -> fs.write-file outfile, normal, (e, b) -> res b
        new Promise (res, rej) -> fs.write-file outfilemin, minified, (e, b) -> res b
      ]
    .then ->
      return do
        type: type, name: name
        elapsed: Date.now! - t1
        size: fs.stat-sync(outfile).size
        size-min: fs.stat-sync(outfilemin).size

batch = debounce 500, ->
  promises = []
  for type of task =>
    for name of task[type] =>
      out = "static/#type/pack/#name.#type"
      # out file is not newer than watched files? rebuild!
      if aux.newer(bundle-file, [out], true) or (task[type][name].length and !aux.newer(out, task[type][name])) =>
        promises.push build({type, name, list: bundle[type][name]})
  task := {css: {}, js: {}}
  Promise.all promises
    .then (list) ->
      for info in list =>
        {type,name,size,size-min,elapsed} = info
        console.log "[BUILD] bundle static/#type/pack/#name.#type ( #size bytes / #{elapsed}ms )"
        console.log "[BUILD] bundle static/#type/pack/#name.min.#type ( #size-min bytes / #{elapsed}ms )"


main = do
  map: (list) ->
  build: (list) ->
    if bundle-file in list =>
      try
        bundle := JSON.parse(fs.read-file-sync bundle-file .toString!)
        for type of bundle => for n,l of bundle[type] => bundle[type][n] = l.map -> path.join(\static,it)
      catch e
        console.log e
        return
    for type of bundle =>
      for n,l of bundle[type] =>
        if !task[type][n] => task[type][n] = []
        for file in list => if file in l => task[type][n].push file
    batch!

  unlink: (list) ->

module.exports = main
