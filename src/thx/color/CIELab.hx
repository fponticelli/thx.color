package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
import thx.color.parse.ColorParser;
using thx.core.error.NullArgument;

@:access(thx.color.CIELCh)
@:access(thx.color.XYZ)
@:access(thx.color.RGBX)
abstract CIELab(Array<Float>) {
  public var l(get, never) : Float;
  public var a(get, never) : Float;
  public var b(get, never) : Float;

  public static function create(l : Float, a : Float, b : Float)
    return new CIELab([l, a, b]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return CIELab.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielab':
        CIELab.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CIELab
    this = channels;

  public function distance(other : CIELab)
    return (l - other.l) * (l - other.l) +
           (a - other.a) * (a - other.a) +
           (b - other.b) * (b - other.b);

  public function interpolate(other : CIELab, t : Float)
    return new CIELab([
      t.interpolate(l, other.l),
      t.interpolate(a, other.a),
      t.interpolate(b, other.b)
    ]);

  public function darker(t : Float)
    return new CIELab([
      t.interpolate(l, 0),
      a,
      b
    ]);

  public function lighter(t : Float)
    return new CIELab([
      t.interpolate(l, 100),
      a,
      b
    ]);

  public function match(palette : Iterable<CIELab>) {
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

  @:op(A==B) public function equals(other : CIELab) : Bool
    return l == other.l && a == other.a && b == other.b;

  public function withLightness(lightness : Float)
    return new CIELab([lightness, a, b]);

  public function withA(newa : Float)
    return new CIELab([l, newa, b]);

  public function withB(newb : Float)
    return new CIELab([l, a, newb]);

  @:to public function toString() : String
    return 'CIELab($l,$a,$b)';

  @:to public function toCIELCh() {
    var h = Floats.wrapCircular(Math.atan2(b, a) * 180 / Math.PI, 360),
        c = Math.sqrt(a * a + b * b);
    return new CIELCh([l, c, h]);
  }

  @:to inline public function toCMY()
    return toRGBX().toCMY();

  @:to inline public function toCMYK()
    return toRGBX().toCMYK();

  @:to inline public function toGrey()
    return toRGBX().toGrey();

  @:to inline public function toHSL()
    return toRGBX().toHSL();

  @:to inline public function toHSV()
    return toRGBX().toHSV();

  @:to inline public function toRGB()
    return toRGBX().toRGB();

  @:to inline public function toRGBX()
    return toXYZ().toRGBX();

  @:to inline public function toRGBXA()
    return toRGBX().toRGBXA();

  @:to public function toXYZ() {
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

    return new XYZ([95.047 * x, 100 * y, 108.883 * z]);
  }

  @:to inline public function toYxy()
    return toXYZ().toYxy();

  inline function get_l() : Float
    return this[0];
  inline function get_a() : Float
    return this[1];
  inline function get_b() : Float
    return this[2];
}