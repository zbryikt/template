require! <[fs]>
aux = do
  newer: (f1, f2) ->
    if !fs.exists-sync(f1) => return false
    if !fs.exists-sync(f2) => return true
    (fs.stat-sync(f1).mtime - fs.stat-sync(f2).mtime) > 0

module.exports = aux
