import MiniCanvas;

import thx.color.*;
using thx.core.Iterators;
using thx.core.Arrays;
import thx.core.Ints;

class Demo {
  static function interpolations() {
    var left  : HSV = 'hsv(160deg,100%,63%)',
        right : HSV = 'hsv(345deg,88%,77%)';

    MiniCanvas.gradient('interpolatergb',
      function(t : Float) : RGB return (left : RGB).interpolate(right, t));

    MiniCanvas.gradient('interpolatecmy',
      function(t : Float) : RGB return (left : CMY).interpolate(right, t));

    MiniCanvas.gradient('interpolatecmyk',
      function(t : Float) : RGB return (left : CMYK).interpolate(right, t));

    MiniCanvas.gradient('interpolategrey',
      function(t : Float) : RGB return (left : Grey).interpolate(right, t));

    MiniCanvas.gradient('interpolatehsl',
      function(t : Float) : RGB return (left : HSL).interpolate(right, t));

    MiniCanvas.gradient('interpolatehsv',
      function(t : Float) : RGB return (left : HSV).interpolate(right, t));

    MiniCanvas.gradient('interpolatecielab',
      function(t : Float) : RGB return (left : CIELab).interpolate(right, t));

    MiniCanvas.gradient('interpolatecielch',
      function(t : Float) : RGB return (left : CIELCh).interpolate(right, t));

    MiniCanvas.gradient('interpolatexyz',
      function(t : Float) : RGB return (left : XYZ).interpolate(right, t));

    MiniCanvas.gradient('interpolateyxy',
      function(t : Float) : RGB return (left : Yxy).interpolate(right, t));
  }

  public static function main() {
    interpolations();

    MiniCanvas.boxGradient("rainbowhsl",
      function(x : Float, y : Float) : RGB {
        return HSL.create(x * 360, 1, y);
      });

    MiniCanvas.boxGradient("rainbowcielch",
      function(x : Float, y : Float) : RGB {
        return CIELCh.create(65, y * 65, x * 360);
      });

    MiniCanvas.boxGradient("rainbowcielab",
      function(x : Float, y : Float) : RGB {
        return CIELab.create(40, x * 200 - 100, y * 200 - 100);
      });

    MiniCanvas.gradient('darkerrgb',
      (function() {
        var left : RGB = '#ff0000';
        return left.darker;
      })());

    MiniCanvas.gradient('lighterrgb',
      (function() {
        var left : RGB = '#0000ff';
        return left.lighter;
      })());

    MiniCanvas.create('colortable', 900, 1200, colorTable);
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