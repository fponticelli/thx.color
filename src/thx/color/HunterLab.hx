package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;
using thx.error.NullArgument;

/**
A uniform color scale devised by Hunter in 1958 for use in a color difference
meter. It is based on Hering's opponent-colors theory of vision.
**/
@:access(thx.color.LCh)
@:access(thx.color.Xyz)
abstract HunterLab(Array<Float>) {
  inline public static function create(l : Float, a : Float, b : Float)
    return new HunterLab([l, a, b]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return HunterLab.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
    case 'hunterlab':
        HunterLab.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : HunterLab
    this = channels;

  public var l(get, never) : Float;
  public var a(get, never) : Float;
  public var b(get, never) : Float;

  public function distance(other : HunterLab)
    return (l - other.l) * (l - other.l) +
           (a - other.a) * (a - other.a) +
           (b - other.b) * (b - other.b);

  public function interpolate(other : HunterLab, t : Float)
    return new HunterLab([
      t.interpolate(l, other.l),
      t.interpolate(a, other.a),
      t.interpolate(b, other.b)
    ]);

  public function match(palette : Iterable<HunterLab>) {
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

  public function min(other : HunterLab)
    return create(l.min(other.l), a.min(other.a), b.min(other.b));

  public function max(other : HunterLab)
    return create(l.max(other.l), a.max(other.a), b.max(other.b));

  public function roundTo(decimals : Int)
    return create(l.roundTo(decimals), a.roundTo(decimals), b.roundTo(decimals));

  @:op(A==B) public function equals(other : HunterLab) : Bool
    return nearEquals(other);

  public function nearEquals(other : HunterLab, ?tolerance = Floats.EPSILON) : Bool
    return l.nearEquals(other.l, tolerance) && a.nearEquals(other.a, tolerance) && b.nearEquals(other.b, tolerance);

  public function withL(newl : Float)
    return new HunterLab([newl, a, b]);

  public function withA(newa : Float)
    return new HunterLab([l, newa, b]);

  public function withB(newb : Float)
    return new HunterLab([l, a, newb]);

  @:to public function toString() : String
    return 'hunterlab(${l},${a},${b})';

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

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
    var x = (a / 17.5) * (l / 10.0),
        l10 = l / 10.0,
        y = l10 * l10,
        z = (b / 7.0) * (l / 10.0);

    return new Xyz([(x + y) / 1.02, y, -(z - y) / 0.847]);
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
