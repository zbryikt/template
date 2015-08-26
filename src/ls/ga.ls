_gaq = _gaq or []
do ->
  _gaq.push <[_setAccount UA-XXXXXXXX-1]>
  _gaq.push <[_trackPageview]>
  _gaq.push [\_trackEvent, \extension, \popup]
  ga = document.createElement(\script)
  ga.type = \text/javascript
  ga.async = true
  ga.src = \https://ssl.google-analytics.com/ga.js
  s = document.getElementsByTagName(\script).0
  s.parentNode.insertBefore ga, s

