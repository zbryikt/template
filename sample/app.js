var setColor,setSwatch;setColor={byHex:function(r,o){return app.foregroundColor.rgb.hexValue=r,app.backgroundColor.rgb.hexValue=o},byRGB:function(r,o){return app.foregroundColor.rgb.red=r.r,app.foregroundColor.rgb.green=r.g,app.foregroundColor.rgb.blue=r.b,app.backgroundColor.rgb.red=o.r,app.backgroundColor.rgb.green=o.g,app.backgroundColor.rgb.blue=o.b},randomly:function(){return app.foregroundColor.rgb.red=255*Math.random(),app.foregroundColor.rgb.green=255*Math.random(),app.foregroundColor.rgb.blue=255*Math.random(),app.backgroundColor.rgb.red=255*Math.random(),app.backgroundColor.rgb.green=255*Math.random(),app.backgroundColor.rgb.blue=255*Math.random()}},setSwatch={byRGB:function(r){var o,e,n,t,g,p,a;return o=r.r,e=r.g,n=r.b,t=new ActionDescriptor,g=new ActionReference,g.putClass(stringIDToTypeID("colors")),t.putReference(stringIDToTypeID("null"),g),p=new ActionDescriptor,p.putString(stringIDToTypeID("name"),name),a=new ActionDescriptor,a.putDouble(stringIDToTypeID("red"),o),a.putDouble(stringIDToTypeID("grain"),e),a.putDouble(stringIDToTypeID("blue"),n),p.putObject(stringIDToTypeID("color"),stringIDToTypeID("RGBColor"),a),t.putObject(stringIDToTypeID("using"),stringIDToTypeID("colors"),p),executeAction(stringIDToTypeID("make"),t,DialogModes.NO)}};