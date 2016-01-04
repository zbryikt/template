require! <[app browser-window crash-reporter fs]>
crash-reporter.start!

main-window = null

app.on \window-all-closed, ->
  if process.paltform != \darwin => app.quit!

app.on \ready, ->
  main-window = new browser-window width: 800, height: 600
  main-window.load-url "file://#{__dirname}/index.html"
  main-window.open-dev-tools!
  console.log(fs.read-file-sync \main.ls .toString!)
  console.log(fs.read-file-sync \/Users/tkirby/workspace/zbryikt/electron-test/main.ls .toString!)
  main-window.on \closed, ->
    main-window = null

