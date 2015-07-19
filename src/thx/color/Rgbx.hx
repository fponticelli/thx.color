package thx.color;

using thx.Arrays;
using thx.Ints;
using thx.Floats;
using thx.Strings;
import thx.color.parse.ColorParser;
import thx.color.CubeHelix.*;

/**
`Rgbx` stores its three channels into three floats allowing for a very high
resolution.
**/
@:access(thx.color.Cmy)
@:access(thx.color.Cmyk)
@:access(thx.color.CubeHelix)
@:access(thx.color.Hsl)
@:access(thx.color.Hsv)
@:access(thx.color.Rgbxa)
@:access(thx.color.Xyz)
@:access(thx.color.Yuv)
abstract Rgbx(Array<Float>) {
  inline public static function create(red : Float, green : Float, blue : Float)
    return new Rgbx([red, green, blue]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Rgbx.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromInts(arr : Array<Int>) {
    arr.resize(3);
    return Rgbx.create(arr[0] / 255.0, arr[1] / 255.0, arr[2] / 255.0);
  }

  @:from public static function fromInt(value : Int) {
    var rgb : Rgb = value;
    return create(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        Rgbx.fromFloats(ColorParser.getFloatChannels(info.channels, 3, true));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Rgbx
    this = channels;

  public var red(get, never) : Int;
  public var green(get, never) : Int;
  public var blue(get, never) : Int;
  public var redf(get, never) : Float;
  public var greenf(get, never) : Float;
  public var bluef(get, never) : Float;
  public var inSpace(get, never) : Bool;

  public function darker(t : Float)
    return new Rgbx([
      t.interpolate(redf, 0),
      t.interpolate(greenf, 0),
      t.interpolate(bluef, 0),
    ]);

  public function lighter(t : Float)
    return new Rgbx([
      t.interpolate(redf, 1),
      t.interpolate(greenf, 1),
      t.interpolate(bluef, 1),
    ]);

  public function interpolate(other : Rgbx, t : Float)
    return new Rgbx([
      t.interpolate(redf, other.redf),
      t.interpolate(greenf, other.greenf),
      t.interpolate(bluef, other.bluef)
    ]);

  public function min(other : Rgbx)
    return create(redf.min(other.redf), greenf.min(other.greenf), bluef.min(other.bluef));

  public function max(other : Rgbx)
    return create(redf.max(other.redf), greenf.max(other.greenf), bluef.max(other.bluef));

  public function normalize()
    return new Rgbx([
      redf.normalize(),
      greenf.normalize(),
      bluef.normalize()
    ]);

  public function roundTo(decimals : Int)
    return create(redf.roundTo(decimals), greenf.roundTo(decimals), bluef.roundTo(decimals));

  public function toCss3() : String
    return toString();

  @:to public function toString() : String
    return 'rgb(${(redf*100)}%,${(greenf*100)}%,${(bluef*100)}%)';

  public function toHex(prefix = "#") : String
    return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : Rgbx) : Bool
    return nearEquals(other);

  public function nearEquals(other : Rgbx, ?tolerance = Floats.EPSILON)
    return redf.nearEquals(other.redf, tolerance) && greenf.nearEquals(other.greenf, tolerance) && bluef.nearEquals(other.bluef, tolerance);

  public function withAlpha(alpha : Float)
    return new Rgbxa(this.concat([alpha]));

  public function withRed(newred : Int)
    return new Rgbx([newred, green, blue]);

  public function withGreen(newgreen : Int)
    return new Rgbx([red, newgreen, blue]);

  public function withBlue(newblue : Int)
    return new Rgbx([red, green, newblue]);

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

  @:to public function toLuv()
    return toXyz().toLuv();

  @:to public function toCmy() : Cmy
    return new Cmy([
      1 - redf,
      1 - greenf,
      1 - bluef
    ]);

  @:to public function toCmyk() {
    var c = 0.0, y = 0.0, m = 0.0, k;
    if (redf + greenf + bluef == 0) {
      k = 1.0;
    } else {
      k = 1 - redf.max(greenf).max(bluef);
      c = (1 - redf - k)   / (1 - k);
      m = (1 - greenf - k) / (1 - k);
      y = (1 - bluef - k)  / (1 - k);
    }
    return new Cmyk([c, m, y, k]);
  }

  @:to inline public function toCubeHelix()
    return toCubeHelixWithGamma(1);

  public function toCubeHelixWithGamma(gamma : Float) {
    var l = (BC_DA * bluef + ED * redf - EB * greenf) / (BC_DA + ED - EB),
        bl = bluef - l,
        k = (E * (greenf - l) - C * bl) / D,
        lgamma = Math.pow(l, gamma),
        // try/catch is for PHP
        s = try Math.sqrt(k * k + bl * bl) / (E * lgamma * (1 - lgamma)) catch(e : Dynamic) 0.0, // NaN if lgamma=0 or lgamma=1
        h = try s != 0 ? Math.atan2(k, bl) / Math.PI * 180 - 120 : Math.NaN catch(e : Dynamic) 0.0;
    if(Math.isNaN(s)) s = 0;
    if(Math.isNaN(h)) h = 0;
    if (h < 0) h += 360;
    return new CubeHelix([h, s, l, 1]);
  }

  @:to public function toGrey()
    return new Grey(redf * .2126 + greenf * .7152 + bluef * .0722);

  public function toPerceivedGrey()
    return new Grey(redf * .299 + greenf * .587 + bluef * .114);

  public function toPerceivedAccurateGrey()
    return new Grey(Math.pow(redf, 2) * .241 + Math.pow(greenf, 2) * .691 + Math.pow(bluef, 2) * .068);

  @:to public function toHsl() {
    var min = redf.min(greenf).min(bluef),
        max = redf.max(greenf).max(bluef),
        delta = max - min,
        h,
        s,
        l = (max + min) / 2;
#if php
    if (delta.nearZero())
#else
    if (delta == 0.0)
#end
      s = h = 0.0;
    else {
      s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
      if (redf == max)
        h = (greenf - bluef) / delta + (greenf < blue ? 6 : 0);
      else if (greenf == max)
        h = (bluef - redf) / delta + 2;
      else
        h = (redf - greenf) / delta + 4;
      h *= 60;
    }
    return new Hsl([h, s, l]);
  }

  @:to public function toHsv() {
    var min = redf.min(greenf).min(bluef),
        max = redf.max(greenf).max(bluef),
        delta = max - min,
        h : Float,
        s : Float,
        v : Float = max;
    if (delta != 0)
      s = delta / max;
    else {
      s = 0;
      h = -1;
      return new Hsv([h, s, v]);
    }

    if (redf == max)
      h = (greenf - bluef) / delta;
    else if (greenf == max)
      h = 2 + (bluef - redf) / delta;
    else
      h = 4 + (redf - greenf) / delta;

    h *= 60;
    if (h < 0)
      h += 360;
    return new Hsv([h, s, v]);
  }

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toRgb()
    return Rgb.createf(redf, greenf, bluef);

  @:to public function toRgbxa()
    return withAlpha(1.0);

  @:to public function toTemperature() {
    var t : Float = 0,
        rgb,
        epsilon = 0.4,
        minT : Float = 1000,
        maxT : Float = 40000;
    while (maxT - minT > epsilon) {
      t = (maxT + minT) / 2;
      rgb = Temperature.temperatureToRgbx(t);
      if ((rgb.bluef / rgb.redf) >= (bluef / redf)) {
        maxT = t;
      } else {
        minT = t;
      }
    }
    return new Temperature(t);
  }

  @:to public function toXyz() {
    var r = redf,
        g = greenf,
        b = bluef;

    r = r > 0.04045 ? Math.pow(((r + 0.055) / 1.055), 2.4) : r / 12.92;
    g = g > 0.04045 ? Math.pow(((g + 0.055) / 1.055), 2.4) : g / 12.92;
    b = b > 0.04045 ? Math.pow(((b + 0.055) / 1.055), 2.4) : b / 12.92;

    return new Xyz([
      r * 0.4124564 + g * 0.3575761 + b * 0.1804375,
      r * 0.2126729 + g * 0.7151522 + b * 0.0721750,
      r * 0.0193339 + g * 0.1191920 + b * 0.9503041
    ]);
  }

  @:to public function toYuv() {
    var r = redf,
        g = greenf,
        b = bluef,
        y =  0.299   * r + 0.587   * g + 0.114   * b,
        u = -0.14713 * r - 0.28886 * g + 0.436   * b,
        v =  0.615   * r - 0.51499 * g - 0.10001 * b;
    return new Yuv([y, u, v]);
  }

  @:to public function toYxy()
    return toXyz().toYxy();

  function get_red() : Int
    return (redf   * 255).round();
  function get_green() : Int
    return (greenf * 255).round();
  function get_blue() : Int
    return (bluef  * 255).round();

  inline function get_redf() : Float
    return this[0];
  inline function get_greenf() : Float
    return this[1];
  inline function get_bluef() : Float
    return this[2];

  function get_inSpace() : Bool
    return redf >= 0 && redf <= 1 && greenf >= 0 && greenf <= 1 && bluef >= 0 && bluef <= 1;
}
