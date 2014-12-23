package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.CIELAB)
@:access(thx.color.CIELCH)
@:access(thx.color.XYZ)
@:access(thx.color.RGBX)
abstract CIELCH(Array<Float>) {
  public var l(get, never) : Float;
  public var c(get, never) : Float;
  public var h(get, never) : Float;

  @:from public static function fromString(color : String) : CIELCH {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielch':
        new thx.color.CIELCH(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public static function fromFloats(l : Float, c : Float, h : Float) : CIELCH
    return new CIELCH([l, c, h]);

  inline function new(channels : Array<Float>) : CIELCH
    this = channels;

  @:to public function toCIELAB() : CIELAB {
    var hradi = h * (Math.PI / 180),
        a = Math.cos(hradi) * c,
        b = Math.sin(hradi) * c;
    return new CIELAB([l, a, b]);
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
    return toCIELAB().toRGBX();

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ() : RGBX
    return toCIELAB().toXYZ();

  inline public function toString() : String
    return 'CIELCH($l,$c,$h)';

  @:op(A==B) public function equals(other : CIELCH) : Bool
    return l == other.l && c == other.c && h == other.h;

  inline function get_l() : Float
    return this[0];
  inline function get_c() : Float
    return this[1];
  inline function get_h() : Float
    return this[2];
}