package thx.color;

using thx.core.Floats;
using thx.core.Nulls;
using thx.core.Strings;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract RGB(Int) from Int to Int {
  @:from public static function fromString(color : String) : Null<RGB> {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        thx.color.RGB.fromArray(ColorParser.getInt8Channels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  public static function createf(red : Float, green : Float, blue : Float) : RGB
    return create((red * 255).round(), (green * 255).round(), (blue * 255).round());

  inline public static function fromArray(arr : Array<Int>) : RGB
    return create(arr[0].or(0), arr[1].or(0), arr[2].or(0));

  inline public static function create(red : Int, green : Int, blue : Int) : RGB
    return new RGB(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));

  inline public function new(rgb : Int) : RGB
    this = rgb;

  public var red(get, never)   : Int;
  public var green(get, never) : Int;
  public var blue(get, never)  : Int;

  public function darker(t : Float) : RGB
    return toRGBX().darker(t).toRGB();

  public function lighter(t : Float) : RGB
    return toRGBX().lighter(t).toRGB();

  public function interpolate(other : RGB, t : Float) : RGB
    return toRGBX().interpolate(other.toRGBX(), t);

  inline public function withAlpha(alpha : Int) : RGBXA
    return RGBA.fromInts(red, green, blue, alpha);

  inline public function toCSS3() : String
    return 'rgb($red,$green,$blue)';

  @:to inline public function toString() : String
    return toHex();

  public function toHex(prefix = "#")
    return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : RGB) : Bool
    return red == other.red && green == other.green && blue == other.blue;

  @:to inline public function toCIELab() : CIELab
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh() : CIELCh
    return toRGBX().toCIELCh();

  @:to public function toCMY() : CMY
    return toRGBX().toCMY();

  @:to public function toCMYK() : CMYK
    return toRGBX().toCMYK();

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSL() : HSL
    return toRGBX().toHSL();

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGBX() : RGBX
    return RGBX.fromInts(red, green, blue);

  @:to inline public function toRGBA() : RGBA
    return withAlpha(255);

  @:to inline public function toRGBXA() : RGBXA
    return toRGBA().toRGBXA();

  @:to public function toYxy() : Yxy
    return toRGBX().toXYZ();

  @:to public function toXYZ() : XYZ
    return toRGBX().toXYZ();

  inline function get_red() : Int
    return (this >> 16) & 0xFF;
  inline function get_green() : Int
    return (this >> 8) & 0xFF;
  inline function get_blue() : Int
    return this & 0xFF;
}