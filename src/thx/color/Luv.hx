package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

/**
CIELUV is a color space adopted by the International Commission on Illumination
(CIE) in 1976, as a simple-to-compute transformation of the 1931 CIE XYZ color
space, but which attempted perceptual uniformity.

It is extensively used for applications such as computer graphics which deal
with colored lights. Although additive mixtures of different colored lights will
fall on a line in CIELUV's uniform chromaticity diagram (dubbed the CIE 1976
UCS), such additive mixtures will not, contrary to popular belief, fall along a
line in the CIELUV color space unless the mixtures are constant in lightness.
**/
@:access(thx.color.Rgbx)
@:access(thx.color.Lab)
@:access(thx.color.Xyz)
abstract Luv(Array<Float>) {
  public var l(get, never) : Float;
  public var u(get, never) : Float;
  public var v(get, never) : Float;

  inline public static function create(l : Float, u : Float, v : Float)
    return new Luv([l, u, v]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Luv.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
    case 'cieluv', 'luv':
        new thx.color.Luv(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Luv
    this = channels;

  public function interpolate(other : Luv, t : Float)
    return new Luv([
      t.interpolate(l, other.l),
      t.interpolate(u, other.u),
      t.interpolate(v, other.v)
    ]);

  public function min(other : Luv)
    return create(l.min(other.l), u.min(other.u), v.min(other.v));

  public function max(other : Luv)
    return create(l.max(other.l), u.max(other.u), v.max(other.v));

  public function normalize()
    return create(l.normalize(), u.clampSym(0.436), v.clampSym(0.615));

  public function roundTo(decimals : Int)
    return create(l.roundTo(decimals), u.roundTo(decimals), v.roundTo(decimals));

  public function withY(newy : Float)
    return new Luv([newy, u, v]);

  public function withU(newu : Float)
    return new Luv([l, newu, v]);

  public function withV(newv : Float)
    return new Luv([l, u, newv]);

  @:to public function toString() : String
    return 'cieluv(${l},${u},${v})';

  @:op(A==B) public function equals(other : Luv) : Bool
    return nearEquals(other);

  public function nearEquals(other : Luv, ?tolerance = Floats.EPSILON) : Bool
    return l.nearEquals(other.l, tolerance) && u.nearEquals(other.u, tolerance) && v.nearEquals(other.v, tolerance);

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

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

  @:to public function toYxy()
    return toRgbx().toYxy();

  @:to public function toXyz() {
    var l = l * 100,
        u = u * 100,
        v = v * 100,
        x = 9 * u / (9 * u - 16 * v + 12),
        y = 4 * v / (9 * u - 16 * v + 12),
        uPrime = (l == 0 ? 0 : u / (13 * l)) + Xyz.whiteReference.u * 100,
        vPrime = (l == 0 ? 0 : v / (13 * l)) + Xyz.whiteReference.v * 100,
        Y = l > 8 ?
              Xyz.whiteReference.y * 100 * Math.pow((l + 16)/116, 3) :
              Xyz.whiteReference.y * 100 * l * Math.pow(3/29, 3),
        X = Y * 9 * uPrime / (4 * vPrime),
        Z = Y * (12 - 3 * uPrime - 20 * vPrime) / (4 * vPrime);

    return new Xyz([X / 100, Y / 100, Z / 100]);
  }

  inline function get_l() : Float
    return this[0];
  inline function get_u() : Float
    return this[1];
  inline function get_v() : Float
    return this[2];
}
