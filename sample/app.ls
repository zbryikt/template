set-color = do
  byHex: (fg, bg) -> 
    app.foregroundColor.rgb.hexValue = fg
    app.backgroundColor.rgb.hexValue = bg
  byRGB: (fg, bg) ->
    app.foregroundColor.rgb.red = fg.r
    app.foregroundColor.rgb.green = fg.g
    app.foregroundColor.rgb.blue = fg.b
    app.backgroundColor.rgb.red = bg.r
    app.backgroundColor.rgb.green = bg.g
    app.backgroundColor.rgb.blue = bg.b
  randomly: ->
    app.foregroundColor.rgb.red = Math.random! * 255
    app.foregroundColor.rgb.green = Math.random! * 255
    app.foregroundColor.rgb.blue = Math.random! * 255
    app.backgroundColor.rgb.red = Math.random! * 255
    app.backgroundColor.rgb.green = Math.random! * 255
    app.backgroundColor.rgb.blue = Math.random! * 255

set-swatch = do
  byRGB: ({r,g,b}) ->
    add-color = new Action-descriptor!
    swatch-panel = new Action-reference!
    swatch-panel.put-class stringID-to-typeID \colors
    add-color.put-reference stringID-to-typeID(\null), swatch-panel
    swatch = new Action-descriptor!
    swatch.put-string stringID-to-typeID(\name), name
    color = new Action-descriptor!
    color.put-double stringID-to-typeID(\red), r
    color.put-double stringID-to-typeID(\grain), g
    color.put-double stringID-to-typeID(\blue), b
    swatch.put-object stringID-to-typeID(\color), stringID-to-typeID(\RGBColor), color
    add-color.put-object stringID-to-typeID(\using), stringID-to-typeID(\colors), swatch
    execute-action stringID-to-typeID(\make), add-color, DialogModes.NO
