adobe-extension-template
------------------------

* 開啟 unsigned extension 功能
  * open ~/Library/Preferences/com.adobe.CSXS.5.plist
  * add row: PlayerDebugMode <string> 1
* 在 extension 目錄下建立資料夾
  * ( ~/Library/Application Support/Adobe/CEP/extensions/<your-extension> )
* 準備 CSInterface.js, 要在 index.htm 含入 以操做 app.js

三個檔案
===============

* CSXS/manifest.xml -> extension 設定
  * ( 其中特別注意, 14.0 即 CC, 15.0 即 CC 2014, 此為最小值, 可用陣列表範圍 [14.0,14.9] )

```
HostList
  Host(Name="PHXS",Version="14.0")
  Host(Name="PHSP",Version="14.0")
RequiredRuntimeList: RequiredRuntime(Name="CSXS",Version="5.0")
```

* index.html (檔名在 manifest.xml 中可設定) - web/panel context
* app.js (檔名在 manifest.xml 中可設定) - app context

其它設定
===============
* 建立 .debug 於其中放下面的 xml 的話則可透過 localhost:<port> debug

```
<?xml version="1.0" encoding="UTF-8"?>
<ExtensionList><Extension Id="com.example.helloworld.extension">
  <HostList><Host Name="PHXS" Port="8088"/></HostList>
</Extension></ExtensionList>
```

* 若有安裝 npm package (於 node\_modules 下), 可於 web context 中直接 require. e.g.,

```
jade = require \jade
jade.render "doctype html"
# 於 index.html 中
```


* 若要使用 jQuery, 必須先設定 window.module = undefined;
