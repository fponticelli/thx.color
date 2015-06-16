package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;
using thx.error.NullArgument;

/**
Conventional limits are:
  L: 0/100
  A: -128/128
  B: -128/128
*/
@:access(thx.color.CieLCh)
@:access(thx.color.Xyz)
@:access(thx.color.Rgbx)
abstract CieLab(Array<Float>) {
  public static function create(l : Float, a : Float, b : Float)
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
      case 'cielab':
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

  public function darker(t : Float)
    return new CieLab([
      t.interpolate(l, 0),
      a,
      b
    ]);

  public function lighter(t : Float)
    return new CieLab([
      t.interpolate(l, 100),
      a,
      b
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

  @:op(A==B) public function equals(other : CieLab) : Bool
    return l.nearEquals(other.l) && a.nearEquals(other.a) && b.nearEquals(other.b);

  public function withLightness(lightness : Float)
    return new CieLab([lightness, a, b]);

  public function withA(newa : Float)
    return new CieLab([l, newa, b]);

  public function withB(newb : Float)
    return new CieLab([l, a, newb]);

  @:to public function toString() : String
    return 'CieLab(${l.roundTo(6)},${a.roundTo(6)},${b.roundTo(6)})';

  @:to public function toCieLCh() {
    var h = Floats.wrapCircular(Math.atan2(b, a) * 180 / Math.PI, 360),
        c = Math.sqrt(a * a + b * b);
    return new CieLCh([l, c, h]);
  }

  @:to public function toCmy()
    return toRgbx().toCmy();

  @:to public function toCmyk()
    return toRgbx().toCmyk();

  @:to public function toCubeHelix()
    return toRgbx().toCubeHelix();

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHcl() {
    var chroma = Math.sqrt(a * a + b * b),
        hue = Math.atan2(b, a) / Math.PI * 180;
    if(hue < 0) hue += 360;
    return Hcl.create(hue, chroma, l);
  }

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

  @:to public function toXyz() {
    var y = (l + 16) / 116,
        x = a / 500 + y,
        z = y - b / 200,
        p;

    p = Math.pow(y, 3);
    y = p > 0.008856 ? p : (y - 16 / 116) / 7.787;

    p = Math.pow(x, 3);
    x = p > 0.008856 ? p : (x - 16 / 116) / 7.787;

    p = Math.pow(z, 3);
    z = p > 0.008856 ? p : (z - 16 / 116) / 7.787;

    return new Xyz([95.047 * x, 100 * y, 108.883 * z]);
  }

  @:to public function toYxy()
    return toXyz().toYxy();

  inline function get_l() : Float
    return this[0];
  inline function get_a() : Float
    return this[1];
  inline function get_b() : Float
    return this[2];
}
