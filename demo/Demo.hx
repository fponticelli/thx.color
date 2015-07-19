import MiniCanvas;

import thx.color.*;
import thx.color.palettes.*;
using thx.Iterators;
using thx.Iterables;
using thx.Functions;
using thx.Arrays;
import thx.Ints;

class Demo {
  static function interpolations() {
    var left  : Hsv = 'hsv(160deg,100%,63%)',
        right : Hsv = 'hsv(345deg,88%,77%)';

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Rgb).interpolate(right, t))
      .display('interpolateRgb');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Cmy).interpolate(right, t))
      .display('interpolateCmy');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Cmyk).interpolate(right, t))
      .display('interpolateCmyk');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return ((left : CubeHelix).interpolate(right, t) : Rgbxa).normalize())
      .display('interpolateCubeHelix');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return ((left : CubeHelix).interpolateWidest(right, t) : Rgbxa).normalize())
      .display('interpolateCubeHelixWidest');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Grey).interpolate(right, t))
      .display('interpolateGrey');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Hsl).interpolate(right, t))
      .display('interpolateHsl');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Hsl).interpolateWidest(right, t))
      .display('interpolateHslWidest');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Hsv).interpolate(right, t))
      .display('interpolateHsv');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Hsv).interpolateWidest(right, t))
      .display('interpolateHsvWidest');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Lab).interpolate(right, t))
      .display('interpolateCielab');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return ((left : LCh).interpolate(right, t) : Rgbxa).normalize())
      .display('interpolateCielch');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return ((left : LCh).interpolateWidest(right, t) : Rgbxa).normalize())
      .display('interpolateCielchWidest');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Xyz).interpolate(right, t))
      .display('interpolateXyz');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgbxa return (left : Yxy).interpolate(right, t))
      .display('interpolateYxy');
  }

  public static function main() {
    interpolations();

    var t = Rgbxa.create(0, 0, 0, 0);

    MiniCanvas.create(400, 20)
      .checkboard()
      .gradientHorizontal(function(t) : Rgbxa
        return Temperature.create(1000 + t * 15000))
      .display("temperature");

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : Rgbxa
        return Hsl.create(x * 360, 1, y))
      .display("rainbowHsl");

    MiniCanvas.create(200, 200)
      .checkboard()
      .box(function(x : Float, y : Float) : Rgbxa
        return LCh.create(80, y * 134, x * 360))
      .display("rainbowCielch");

    MiniCanvas.create(200, 200)
      .checkboard()
      .box(function(x : Float, y : Float) : Rgbxa
        return Lab.create(60, x * 200 - 100, y * 200 - 100))
      .display("rainbowCielab");

    MiniCanvas.create(200, 200)
      .checkboard()
      .box(
        function(x : Float, y : Float) : Rgbxa
          return Xyz.create(0.5, x, 1.09 * y))
      .display("xyzChromaticityDiagram");

    MiniCanvas.create(200, 200)
      .checkboard()
      .box(
        function(x : Float, y : Float) : Rgbxa
          return Yxy.create(0.075, 0.15 + 0.85 * x, 0.06 + 0.94 * y))
      .display("yxyChromaticityDiagram");

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t) : Rgbxa
        return ('#ff0000' : Rgb).darker(t))
      .display('darkerRgb');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t) : Rgbxa
        return ('#0000ff' : Rgb).lighter(t))
      .display('lighterRgb');

    var c = MiniCanvas.create(900, 1200);
    colorTable(c.ctx, c.width, c.height);
    c.display('colorTable');

    colorBoundaries();
    ral();
  }

  public static function colorTable(ctx, w, h) {
    var columns = 5,
        colors  = Web.names.keys().toArray().filter(function(n) return n.indexOf(' ') < 0),
        cellw   = w / columns,
        cellh   = h / Math.ceil(colors.length / columns);
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.font = '${Math.round(cellh*0.4)}px Verdana, sans-serif';
    colors.mapi(function(name, i) {
      var col   = i % columns,
          row   = Math.floor(i / columns),
          color = Web.names.get(name);
      ctx.fillStyle = color.toString();
      ctx.fillRect(col * cellw, row * cellh, cellw, cellh);

      ctx.fillStyle = color.toRgbx()
        .toPerceivedGrey()
        .contrast()
        .toRgb().toString();
      ctx.fillText(
        name,
        Math.round(col * cellw + cellw / 2) + 0.5,
        Math.round(row * cellh + cellh / 2) + 0.5,
        cellw);
    });
  }

  public static function colorBoundaries() {
    var colors  = Web.names.keys().toArray().filter(function(n) return n.indexOf(' ') < 0),
        color   = Web.grey,
        min = {
          rgbx: (color : Rgbx),
          rgb:  (color : Rgb),
          lab:  (color : Lab),
          lch:  (color : LCh),
          cmy:  (color : Cmy),
          cmyk: (color : Cmyk),
          ch:   (color : CubeHelix),
          g:    (color : Grey),
          hsl:  (color : Hsl),
          hsv:  (color : Hsv),
          xyz:  (color : Xyz),
          yuv:  (color : Yuv),
          yxy:  (color : Yxy)
        },
        max = {
          rgbx: (color : Rgbx),
          rgb:  (color : Rgb),
          lab:  (color : Lab),
          lch:  (color : LCh),
          cmy:  (color : Cmy),
          cmyk: (color : Cmyk),
          ch:   (color : CubeHelix),
          g:    (color : Grey),
          hsl:  (color : Hsl),
          hsv:  (color : Hsv),
          xyz:  (color : Xyz),
          yuv:  (color : Yuv),
          yxy:  (color : Yxy)
        };
    colors.map(function(name) {
      var color = Web.names.get(name);

      min.rgbx = (color : Rgbx).min(min.rgbx);
      min.rgb =  (color : Rgb).min(min.rgb);
      min.lab =  (color : Lab).min(min.lab);
      min.lch =  (color : LCh).min(min.lch);
      min.cmy =  (color : Cmy).min(min.cmy);
      min.cmyk = (color : Cmyk).min(min.cmyk);
      min.ch =   (color : CubeHelix).min(min.ch);
      min.g =    (color : Grey).min(min.g);
      min.hsl =  (color : Hsl).min(min.hsl);
      min.hsv =  (color : Hsv).min(min.hsv);
      min.xyz =  (color : Xyz).min(min.xyz);
      min.yuv =  (color : Yuv).min(min.yuv);
      min.yxy =  (color : Yxy).min(min.yxy);

      max.rgbx = (color : Rgbx).max(max.rgbx);
      max.rgb =  (color : Rgb).max(max.rgb);
      max.lab =  (color : Lab).max(max.lab);
      max.lch =  (color : LCh).max(max.lch);
      max.cmy =  (color : Cmy).max(max.cmy);
      max.cmyk = (color : Cmyk).max(max.cmyk);
      max.ch =   (color : CubeHelix).max(max.ch);
      max.g =    (color : Grey).max(max.g);
      max.hsl =  (color : Hsl).max(max.hsl);
      max.hsv =  (color : Hsv).max(max.hsv);
      max.xyz =  (color : Xyz).max(max.xyz);
      max.yuv =  (color : Yuv).max(max.yuv);
      max.yxy =  (color : Yxy).max(max.yxy);
    });

    trace('range: ${min.rgbx.roundTo(2)} -> ${max.rgbx.roundTo(2)}');
    trace('range: ${min.rgb} -> ${max.rgb}');
    trace('range: ${min.lab.roundTo(2)} -> ${max.lab.roundTo(2)}');
    trace('range: ${min.lch.roundTo(2)} -> ${max.lch.roundTo(2)}');
    trace('range: ${min.cmy.roundTo(2)} -> ${max.cmy.roundTo(2)}');
    trace('range: ${min.cmyk.roundTo(2)} -> ${max.cmyk.roundTo(2)}');
    trace('range: ${min.ch.roundTo(2)} -> ${max.ch.roundTo(2)}');
    trace('range: ${min.g.roundTo(2)} -> ${max.g.roundTo(2)}');
    trace('range: ${min.hsl.roundTo(2)} -> ${max.hsl.roundTo(2)}');
    trace('range: ${min.hsv.roundTo(2)} -> ${max.hsv.roundTo(2)}');
    trace('range: ${min.xyz.roundTo(2)} -> ${max.xyz.roundTo(2)}');
    trace('range: ${min.yuv.roundTo(2)} -> ${max.yuv.roundTo(2)}');
    trace('range: ${min.yxy.roundTo(2)} -> ${max.yxy.roundTo(2)}');
  }

  public static function ral() {
    var colors = Ral.codes.keys().map.fn({
          code  : _,
          name  : Ral.codes.get(_),
          color : Ral.names.get(_)
        });
    var container = js.Browser.document.createElement("div");
    container.style.float = "left";
    container.style.fontFamily = "monospace";
    js.Browser.document.body.appendChild(container);
    colors.map.fn({
      var div = js.Browser.document.createElement("div");
      var hsl : Hsl = _.color;
      div.style.backgroundColor = hsl.toCss3();
      div.style.padding = "4px 8px";
      if(hsl.lightness < 0.5)
        div.style.color = "#ffffff";
      div.innerHTML = '${_.code}: ${_.name}, ${_.color}';
      container.appendChild(div);
    });
  }
}
