package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.CIELCh)
@:access(thx.color.XYZ)
@:access(thx.color.RGBX)
abstract CIELab(Array<Float>) {
  public var l(get, never) : Float;
  public var a(get, never) : Float;
  public var b(get, never) : Float;

  @:from public static function fromString(color : String) : CIELab {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielab':
        new thx.color.CIELab(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public static function fromFloats(l : Float, a : Float, b : Float) : CIELab
    return new CIELab([l, a, b]);

  inline function new(channels : Array<Float>) : CIELab
    this = channels;

  @:to public function toCIELCh() : CIELCh {
    var h = Floats.wrapCircular(Math.atan2(b, a) * 180 / Math.PI, 360),
        c = Math.sqrt(a * a + b * b);
    return new CIELCh([l, c, h]);
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
    return 'CIELab($l,$a,$b)';

  @:op(A==B) public function equals(other : CIELab) : Bool
    return l == other.l && a == other.a && b == other.b;

  inline function get_l() : Float
    return this[0];
  inline function get_a() : Float
    return this[1];
  inline function get_b() : Float
    return this[2];
}