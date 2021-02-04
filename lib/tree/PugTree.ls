require! <[./DocTree pug path]>
pugbuild = require "../build/pug"

pugtree = new DocTree do
  parser: (c, f) ->
    /* use pug dependencies tracking */
    /*
    cwd = path.resolve process.cwd!
    ret2 = pug.compileClientWithDependenciesTracked(
      c,
      {basedir: path.join(cwd,path.dirname f), filename: f} <<< pugbuild.extapi
    )
    return ret2.dependencies.map(-> it.replace cwd, '../..')
    */
    /* old, manual approach */
    ret = c
      .split \\n
      .map -> /\s*(extend|include)\s+(.+)$/.exec(it)
      .filter -> it
      .map -> it.2

module.exports = pugtree
