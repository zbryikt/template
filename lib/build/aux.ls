require! <[fs]>
aux = do
  newer: (f1, files) ->
    if !fs.exists-sync(f1) => return false
    files = if Array.isArray(files) => files else [files]
    return files.length == files
      .filter (f2) -> !fs.exists-sync(f2) or (fs.stat-sync(f1).mtime - fs.stat-sync(f2).mtime) > 0
      .length

module.exports = aux
