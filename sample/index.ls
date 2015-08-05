csInterface = new CSInterface!
window.setColor = -> 
  csInterface.evalScript("setColor.randomly()")
  csInterface.evalScript("setSwatch.byRGB({r:255,g:0,b:0})")

