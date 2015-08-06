# global variable 'config' loaded by watcher

eventhub = do
  handlers: {}
  listen: (name, handle) ->
    @handlers[][name].push handle
    if @init => @init!
  trigger: (name, value) -> for item in (@handlers[name] or []) => item(value)
  init: ->
    @init = null
    (req, sender, res) <~ chrome.runtime.onMessage.addListener
    if !@handlers[req.type] => return
    for handler in @handlers[req.type] => handler req, sender, res
