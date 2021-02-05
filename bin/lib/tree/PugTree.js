// Generated by LiveScript 1.6.0
var DocTree, pug, path, pugbuild, pugtree;
DocTree = require('./DocTree');
pug = require('pug');
path = require('path');
pugbuild = require("../build/pug");
pugtree = new DocTree({
  parser: function(c, f){
    /* use pug dependencies tracking */
    var cwd, ret2, e, ret;
    cwd = path.resolve(process.cwd());
    try {
      ret2 = pug.compileClientWithDependenciesTracked(c, import$({
        basedir: path.join(cwd, path.dirname(f)),
        filename: f
      }, pugbuild.extapi));
      return ret2.dependencies.map(function(it){
        return it.replace(cwd, '../..');
      });
    } catch (e$) {
      e = e$;
      try {
        return ret = c.split('\n').map(function(it){
          return /\s*(extend|include)\s+(.+)$/.exec(it);
        }).filter(function(it){
          return it;
        }).map(function(it){
          return it[2];
        });
      } catch (e$) {
        e = e$;
        return [];
      }
    }
  }
});
module.exports = pugtree;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}