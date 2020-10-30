require! <[fs path pug stylus LiveScript]>
reload = require("require-reload")(require)

pug-extapi = do
  filters: do
    'lsc': (text, opt) -> return LiveScript.compile(text,{bare:true})
    'stylus': (text, opt) ->
       stylus(text)
         .set \filename, 'inline'
         .define 'index', (a,b) ->
           a = (a.string or a.val).split(' ')
           return new stylus.nodes.Unit(a.indexOf b.val)
         .render!

pug-cached = {}
log = (f, opt, t, type, cache) ->
  f = f.replace(opt.basedir, '')
  console.log "[VIEW] #{f} served in #{t}ms (#type#{if cache =>' cached' else ''})"
engine = (f, opt, cb) ->
  lc = {}
  if opt.settings.env == \development => lc.dev = true
  if opt.settings['view cache'] => lc.cache = true
  {viewdir, basedir} = opt
  pc = path.join(viewdir, f.replace(basedir, '').replace(/\.pug$/, '.js'))
  try
    t1 = Date.now!
    ret = if !lc.cache => reload(pc)
    else (if pug-cached[pc] => that else pug-cached[pc] = require(pc))
    ret = ret(opt)
    t2 = Date.now!
    if lc.dev => log f, opt, t2 - t1, \precompiled, lc.cache
    cb null, ret
  catch e 
    try
      t1 = Date.now!
      (e, b) <- fs.read-file f, _
      if e => throw new Error(e)
      ret = (pug.render b, ({} <<< opt <<< {filename: f, cache: lc.cache, basedir} <<< pug-extapi))
      t2 = Date.now!
      if lc.dev => log f, opt, t2 - t1, 'from pug', lc.cache
      cb null, ret
    catch e
      if lc.dev => console.log "[VIEW] #{f.replace(opt.basedir, '')} serve failed."
      cb e, null

module.exports = engine
