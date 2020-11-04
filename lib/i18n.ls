require! <[chokidar i18next i18next-fs-backend i18next-http-middleware]>

ret = (opt) ->
  if !opt.i18n or (opt.i18n.enabled? and !opt.i18n.enabled) => return Promise.resolve!

  options = {
    lng: <[zh-TW]>, fallbackLng: \zh-TW, preload: <[zh-TW]>
    ns: 'default', defaultNS: \default, fallbackNS: \default
    initImmediate: false
    backend: loadPath: 'locales/{{lng}}/{{ns}}.yaml'
  } <<< (opt.i18n or {})

  return i18next
    .use i18next-fs-backend
    .use i18next-http-middleware.LanguageDetector
    .init options
    .then ->
      watcher = chokidar.watch <[locales]>, do
        persistent: true
        ignored: (f) ~> /\/\./.exec(f)
      watcher
        .on \add, (~> i18next.reloadResources(options.lng))
        .on \change, (~> i18next.reloadResources(options.lng))
        .on \unlink, (~> i18next.reloadResources(options.lng))

      return i18next
  # to reload certain resources
  # i18next.reloadResources <[zh-tw]>

module.exports = ret

