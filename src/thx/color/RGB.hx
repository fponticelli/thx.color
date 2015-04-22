package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Ints;
using thx.Strings;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract RGB(Int) from Int to Int {
  public static function create(red : Int, green : Int, blue : Int)
    return new RGB(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));

  public static function createf(red : Float, green : Float, blue : Float)
    return create((red * 255).round(), (green * 255).round(), (blue * 255).round());

  @:from public static function fromString(color : String) : Null<RGB> {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        RGB.fromInts(ColorParser.getInt8Channels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  @:from public static function fromInts(arr : Array<Int>) {
    arr.resize(3);
    return create(arr[0], arr[1], arr[2]);
  }

  inline public function new(rgb : Int) : RGB
    this = rgb;

  public var red(get, never)   : Int;
  public var green(get, never) : Int;
  public var blue(get, never)  : Int;

  public function darker(t : Float)
    return toRGBX().darker(t).toRGB();

  public function lighter(t : Float)
    return toRGBX().lighter(t).toRGB();

  public function interpolate(other : RGB, t : Float)
    return toRGBX().interpolate(other.toRGBX(), t).toRGB();

  public function withAlpha(alpha : Int)
    return RGBA.fromInts([red, green, blue, alpha]);

  public function withRed(newred : Int)
    return RGB.fromInts([newred, green, blue]);

  public function withGreen(newgreen : Int)
    return RGB.fromInts([red, newgreen, blue]);

  public function withBlue(newblue : Int)
    return RGB.fromInts([red, green, newblue]);

  public function toCSS3() : String
    return 'rgb($red,$green,$blue)';

  @:to public function toString() : String
    return toHex();

  public function toHex(prefix = "#")
    return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : RGB) : Bool
    return red == other.red && green == other.green && blue == other.blue;

  @:to public function toCIELab()
    return toRGBX().toCIELab();

  @:to public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to public function toCMY()
    return toRGBX().toCMY();

  @:to public function toCMYK()
    return toRGBX().toCMYK();

  @:to public function toGrey()
    return toRGBX().toGrey();

  @:to public function toHSL()
    return toRGBX().toHSL();

  @:to public function toHSV()
    return toRGBX().toHSV();

  @:to public function toRGBX()
    return RGBX.fromInts([red, green, blue]);

  @:to public function toRGBA()
    return withAlpha(255);

  @:to public function toRGBXA()
    return toRGBA().toRGBXA();

  @:to public function toYxy()
    return toRGBX().toYxy();

  @:to public function toXYZ()
    return toRGBX().toXYZ();

  function get_red() : Int
    return (this >> 16) & 0xFF;
  function get_green() : Int
    return (this >> 8) & 0xFF;
  function get_blue() : Int
    return this & 0xFF;
}