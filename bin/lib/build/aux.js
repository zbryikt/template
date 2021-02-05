// Generated by LiveScript 1.6.0
var fs, aux;
fs = require('fs');
aux = {
  newer: function(f1, files, strict){
    var mtime;
    files == null && (files = []);
    strict == null && (strict = false);
    if (!fs.existsSync(f1)) {
      return false;
    }
    if (typeof files === 'number') {
      mtime = files;
      return strict
        ? fs.statSync(f1).mtime - mtime > 0
        : fs.statSync(f1).mtime - mtime >= 0;
    }
    files = Array.isArray(files)
      ? files
      : [files];
    return files.length === files.filter(function(f2){
      if (strict) {
        return !fs.existsSync(f2) || fs.statSync(f1).mtime - fs.statSync(f2).mtime > 0;
      } else {
        return !fs.existsSync(f2) || fs.statSync(f1).mtime - fs.statSync(f2).mtime >= 0;
      }
    }).length;
  }
};
module.exports = aux;