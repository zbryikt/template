# global variable 'config' loaded by wathcer

eventhub = do
  emit: (data = {}, cb = (->)) ->
    chrome.tabs.query {active:true,currentWindow:true}, (tabs) -> chrome.tabs.sendMessage tabs[0].id, data, cb
