package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.CIELCH)
@:access(thx.color.XYZ)
@:access(thx.color.RGBX)
abstract CIELAB(Array<Float>) {
  public var l(get, never) : Float;
  public var a(get, never) : Float;
  public var b(get, never) : Float;

  @:from public static function fromString(color : String) : CIELAB {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielab':
        new thx.color.CIELAB(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public static function fromFloats(l : Float, a : Float, b : Float) : CIELAB
    return new CIELAB([l, a, b]);

  inline function new(channels : Array<Float>) : CIELAB
    this = channels;

  @:to public function toCIELCH() : CIELCH {
    var h = Floats.wrapCircular(Math.atan2(b, a) / Math.PI * 180, 360),
        c = Math.sqrt(a * a + b * b);
    return new CIELCH([l, c, h]);
  }

  @:to inline public function toCMYK() : CMYK
    return toRGBX().toCMYK();

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX
    return toXYZ().toRGBX();

  @:to public function toXYZ() : XYZ {
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

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  inline public function toString() : String
    return 'CIELAB($l,$a,$b)';

  @:op(A==B) public function equals(other : CIELAB) : Bool
    return l == other.l && a == other.a && b == other.b;

  inline function get_l() : Float
    return this[0];
  inline function get_a() : Float
    return this[1];
  inline function get_b() : Float
    return this[2];
}