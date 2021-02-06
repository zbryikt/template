require! <[./DocTree pug path]>
pugbuild = require "../build/pug"

pugtree = new DocTree do
  parser: (c, f) ->
    /* use pug dependencies tracking */
    cwd = path.resolve path.join(process.cwd!, @root)
    try
      ret = pug.compileClientWithDependenciesTracked(
        c,
        {basedir: path.join(cwd,path.dirname f), filename: f} <<< pugbuild.extapi
      )
      return ret.dependencies.map(-> it.replace cwd, '/../..')
    catch e
      try
        ret = c
          .split \\n
          .map -> /\s*(extend|include)\s+(.+)$/.exec(it)
          .filter -> it
          .map -> it.2
      catch e
        return []


module.exports = pugtree
