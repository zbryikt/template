require! <[./DocTree]>

styl = new DocTree do
  parser: (c) ->
    ret = c
      .split \\n
      .map -> /\s*(@import)\s+(.+)$/.exec(it)
      .filter -> it
      .map -> it.2.replace(/'/g, '').replace(/(\.styl)?$/, '.styl')
      .map -> it
    return ret

module.exports = styl
