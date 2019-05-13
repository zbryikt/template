require! <[./DocTree]>

pug = new DocTree do
  parser: (c) ->
    ret = c
      .split \\n
      .map -> /\s*(extend|include)\s+(.+)$/.exec(it)
      .filter -> it
      .map -> it.2
    return ret

module.exports = pug
