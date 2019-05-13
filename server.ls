require! <[./lib/server ./lib/watch ./api/index]>
server.init {port: 3000, api: index}
watch.init!
