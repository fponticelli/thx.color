import MiniCanvas;

import thx.color.*;
using thx.Iterators;
using thx.Arrays;
import thx.Ints;

class Demo {
  static function interpolations() {
    var left  : HSV = 'hsv(160deg,100%,63%)',
        right : HSV = 'hsv(345deg,88%,77%)';

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : RGB).interpolate(right, t))
      .display('interpolateRgb');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : CMY).interpolate(right, t))
      .display('interpolateCmy');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : CMYK).interpolate(right, t))
      .display('interpolateCmyk');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : Grey).interpolate(right, t))
      .display('interpolateGrey');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : HSL).interpolate(right, t))
      .display('interpolateHsl');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : HSV).interpolate(right, t))
      .display('interpolateHsv');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : CIELab).interpolate(right, t))
      .display('interpolateCielab');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : CIELCh).interpolate(right, t))
      .display('interpolateCielch');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : XYZ).interpolate(right, t))
      .display('interpolateXyz');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : RGBA return (left : Yxy).interpolate(right, t))
      .display('interpolateYxy');
  }

  public static function main() {
    interpolations();

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : RGBA
        return HSL.create(x * 360, 1, y))
      .display("rainbowHsl");

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : RGBA
        return CIELCh.create(65, y * 65, x * 360))
      .display("rainbowCielch");

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : RGBA
        return CIELab.create(40, x * 200 - 100, y * 200 - 100))
      .display("rainbowCielab");

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t) : RGBA
        return ('#ff0000' : RGB).darker(t))
      .display('darkerRgb');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t) : RGBA
        return ('#0000ff' : RGB).lighter(t))
      .display('lighterRgb');

    var c = MiniCanvas.create(900, 1200);
    colorTable(c.ctx, c.width, c.height);
    c.display('colorTable');
  }

  public static function colorTable(ctx, w, h) {
    var columns = 5,
        colors  = Color.names.keys().toArray().filter(function(n) return n.indexOf(' ') < 0),
        cellw   = w / columns,
        cellh   = h / Math.ceil(colors.length / columns);
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.font = '${Math.round(cellh*0.4)}px Verdana, sans-serif';
    colors.mapi(function(name, i) {
      var col   = i % columns,
        row   = Math.floor(i / columns),
        color = Color.names.get(name);

      ctx.fillStyle = color.toString();
      ctx.fillRect(col * cellw, row * cellh, cellw, cellh);

      ctx.fillStyle = color.toRGBX()
        .toPerceivedGrey()
        .contrast()
        .toRGB().toString();
      ctx.fillText(
        name,
        Math.round(col * cellw + cellw / 2) + 0.5,
        Math.round(row * cellh + cellh / 2) + 0.5,
        cellw);
    });
  }
}