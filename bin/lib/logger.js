// Generated by LiveScript 1.6.0
var colors, logger;
colors = require('colors');
logger = {};
[['info', 'green'], ['warn', 'yellow'], ['error', 'red']].map(function(n){
  return logger[n[0]] = function(){
    var args, res$, i$, to$;
    res$ = [];
    for (i$ = 0, to$ = arguments.length; i$ < to$; ++i$) {
      res$.push(arguments[i$]);
    }
    args = res$;
    args = [n[0].toUpperCase()[n[1]] + "\t: [server]"].concat(args);
    return console[n[0]].apply(console, args);
  };
});
module.exports = logger;