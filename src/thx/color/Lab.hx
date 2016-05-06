package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;
using thx.error.NullArgument;

/**
A Lab color space is a color-opponent space with dimension L for lightness and
a and b for the color-opponent dimensions, based on nonlinearly compressed
(e.g. CIE XYZ color space) coordinates. The terminology originates from the
three dimensions of the Hunter 1948 color space, which are L, a, and b.
The difference between the original Hunter and CIE color coordinates is that
the CIE coordinates are based on a cube root transformation of the color data,
while the Hunter coordinates are based on a square root transformation.

The L*a*b* color space includes all perceivable colors, which means that its
gamut exceeds those of the RGB and CMYK color models. One of the most important
attributes of the L*a*b*-model is device independence. This means that the
colors are defined independent of their nature of creation or the device they
are displayed on.

The L*a*b* color space is used when graphics for print have to be converted from
RGB to CMYK, as the L*a*b* gamut includes both the RGB and CMYK gamut.
Also it is used as an interchange format between different devices as for its
device independency. The space itself is a three-dimensional Real number space,
that contains an infinite possible representations of colors.

The lightness, L*, represents the darkest black at L* = 0, and the brightest
white at L* = 100. The color channels, a* and b*, will represent true neutral
gray values at a* = 0 and b* = 0. The red/green opponent colors are represented
along the a* axis, with green at negative a* values and red at positive a*
values. The yellow/blue opponent colors are represented along the b* axis, with
blue at negative b* values and yellow at positive b* values. The scaling and
limits of the a* and b* axes run in the range of ±100 or -128 to +127.
**/
@:access(thx.color.LCh)
@:access(thx.color.Hcl)
@:access(thx.color.Xyz)
abstract Lab(Array<Float>) {
  inline public static function create(l : Float, a : Float, b : Float)
    return new Lab([l, a, b]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Lab.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'lab', 'l*a*b*', 'cielab':
        Lab.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Lab
    this = channels;

  public var l(get, never) : Float;
  public var a(get, never) : Float;
  public var b(get, never) : Float;

  public function distance(other : Lab)
    return (l - other.l) * (l - other.l) +
           (a - other.a) * (a - other.a) +
           (b - other.b) * (b - other.b);

  public function interpolate(other : Lab, t : Float)
    return new Lab([
      t.interpolate(l, other.l),
      t.interpolate(a, other.a),
      t.interpolate(b, other.b)
    ]);

  public function match(palette : Iterable<Lab>) {
    palette.throwIfEmpty();
    var dist = Math.POSITIVE_INFINITY,
        closest = null;
    for(color in palette) {
      var ndist = distance(color);
      if(ndist < dist) {
        dist = ndist;
        closest = color;
      }
    }
    return closest;
  }

  public function min(other : Lab)
    return create(l.min(other.l), a.min(other.a), b.min(other.b));

  public function max(other : Lab)
    return create(l.max(other.l), a.max(other.a), b.max(other.b));

  public function roundTo(decimals : Int)
    return create(l.roundTo(decimals), a.roundTo(decimals), b.roundTo(decimals));

  @:op(A==B) public function equals(other : Lab) : Bool
    return nearEquals(other);

  public function nearEquals(other : Lab, ?tolerance = Floats.EPSILON) : Bool
    return l.nearEquals(other.l, tolerance) && a.nearEquals(other.a, tolerance) && b.nearEquals(other.b, tolerance);

  public function withL(newl : Float)
    return new Lab([newl, a, b]);

  public function withA(newa : Float)
    return new Lab([l, newa, b]);

  public function withB(newb : Float)
    return new Lab([l, a, newb]);

  @:to public function toString() : String
    return 'lab(${l},${a},${b})';

  @:to public function toLCh() {
    var h = Math.atan2(b, a) * 180 / Math.PI,
        c = Math.sqrt(a * a + b * b);
    return new LCh([l, c, h]);
  }

  @:to public function toLuv()
    return toRgbx().toLuv();

  @:to public function toCmy()
    return toRgbx().toCmy();

  @:to public function toCmyk()
    return toRgbx().toCmyk();

  @:to public function toCubeHelix()
    return toRgbx().toCubeHelix();

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHsl()
    return toRgbx().toHsl();

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx()
    return toXyz().toRgbx();

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz() {
    function f(t) {
      if(t > (6 / 29))
        return Math.pow(t, 3);
      else
        return 3 * (6 / 29) * (6 / 29) * (t - 4 / 29);
    }

    var x = Xyz.whiteReference.x * f( 1 / 116 * (l + 16) + 1 / 500 * a),
        y = Xyz.whiteReference.y * f( 1 / 116 * (l + 16)),
        z = Xyz.whiteReference.z * f( 1 / 116 * (l + 16) - 1 / 200 * b);

    return new Xyz([x, y, z]);
  }

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toXyz().toYxy();

  inline function get_l() : Float
    return this[0];
  inline function get_a() : Float
    return this[1];
  inline function get_b() : Float
    return this[2];
}
