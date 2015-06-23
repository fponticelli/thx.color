package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;
using thx.error.NullArgument;

/**

**/
@:access(thx.color.CieLCh)
@:access(thx.color.Hcl)
@:access(thx.color.Xyz)
abstract CieLab(Array<Float>) {
  inline public static function create(l : Float, a : Float, b : Float)
    return new CieLab([l, a, b]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return CieLab.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielab', 'lab':
        CieLab.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CieLab
    this = channels;

  public var l(get, never) : Float;
  public var a(get, never) : Float;
  public var b(get, never) : Float;

  public function distance(other : CieLab)
    return (l - other.l) * (l - other.l) +
           (a - other.a) * (a - other.a) +
           (b - other.b) * (b - other.b);

  public function interpolate(other : CieLab, t : Float)
    return new CieLab([
      t.interpolate(l, other.l),
      t.interpolate(a, other.a),
      t.interpolate(b, other.b)
    ]);

  public function match(palette : Iterable<CieLab>) {
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

  public function min(other : CieLab)
    return create(l.min(other.l), a.min(other.a), b.min(other.b));

  public function max(other : CieLab)
    return create(l.max(other.l), a.max(other.a), b.max(other.b));

  public function roundTo(decimals : Int)
    return create(l.roundTo(decimals), a.roundTo(decimals), b.roundTo(decimals));

  @:op(A==B) public function equals(other : CieLab) : Bool
    return nearEquals(other);

  public function nearEquals(other : CieLab, ?tolerance = Floats.EPSILON) : Bool
    return l.nearEquals(other.l, tolerance) && a.nearEquals(other.a, tolerance) && b.nearEquals(other.b, tolerance);

  public function withL(newl : Float)
    return new CieLab([newl, a, b]);

  public function withA(newa : Float)
    return new CieLab([l, newa, b]);

  public function withB(newb : Float)
    return new CieLab([l, a, newb]);

  @:to public function toString() : String
    return 'cielab(${l},${a},${b})';

  @:to public function toCieLCh() {
    var h = Math.atan2(b, a) * 180 / Math.PI,
        c = Math.sqrt(a * a + b * b);
    return new CieLCh([l, c, h]);
  }

  @:to public function toCieLuv()
    return toRgbx().toCieLuv();

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
