require! <[fs path]>

cwd = path.resolve process.cwd!

DocTree = (opt={})->
  @ <<< opt: opt, depend: by: {}, on: {}
  @ <<< root: opt.root or cwd, type: opt.type
  if opt.parser => @parser = opt.parser
  @

DocTree.prototype = Object.create(Object.prototype) <<< do
  set-root: -> @root = it
  parse: (f) ->
    if !fs.exists-sync(f) => return []
    content = fs.read-file-sync f .toString!
    dir = path.dirname path.relative(@root, f)
    if !@parser => return
    @depend.by[f] = ret = @parser content
      .map ~> path.join(@root, path.normalize(if it.0 == \/ => it else path.join(dir, it)))
    ret.map ~> @depend.on[][it].push f
    ret

  affect: (list) ->
    if !Array.isArray(list) => list = [list]
    [ret, visited] = [{}, {}]
    list.map -> ret[it] = true
    while list.length
      f = path.normalize(path.relative @root, path.join(@root, list.pop!))
      if !visited[f] and @depend.on[f] =>
        list ++= @depend.on[f]
        @depend.on[f].map -> ret[it] = true
      visited[f] = true
    return [k for k of ret]

module.exports = DocTree
