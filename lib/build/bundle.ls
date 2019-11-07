require! <[fs fs-extra LiveScript stylus path colors uglify-js uglifycss ./aux]>

cwd = path.resolve process.cwd!

bundle = {css: {}, js: {}}

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
          if type == \js => uglify-js.minify(code,{fromString:true}).code
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

main = do
  map: (list) ->
  build: (list) ->
    if \bundle.json in list =>
      bundle := JSON.parse(fs.read-file-sync 'bundle.json' .toString!)
      for type of bundle => for n,l of bundle[type] => bundle[type][n] = l.map -> "static/#it"
    task = {css: {}, js: {}}
    for type of bundle =>
      for n,l of bundle[type] =>
        task[type][n] = []
        for file in list => if file in l => task[type][n].push file
    promises = []
    for type of task =>
      for name of task[type] =>
        out = "static/#type/pack/#name.#type"
        # out file is not newer than watched files? rebuild!
        if aux.newer("bundle.json", [out], true) or (task[type][name].length and !aux.newer(out, task[type][name])) =>
          promises.push build({type, name, list: bundle[type][name]})
    Promise.all promises
      .then (list) ->
        for info in list =>
          {type,name,size,size-min,elapsed} = info
          console.log "[BUILD] bundle static/#type/pack/#name.#type ( #size bytes / #{elapsed}ms )"
          console.log "[BUILD] bundle static/#type/pack/#name.min.#type ( #size-min bytes / #{elapsed}ms )"

  unlink: (list) ->

module.exports = main
