package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
using thx.core.Strings;
import thx.color.parse.ColorParser;

abstract RGBA(Int) from Int to Int {
  public static function create(red : Int, green : Int, blue : Int, alpha : Int) : RGBA
    return ((alpha & 0xFF) << 24) | ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0);

  @:from public static function fromFloats(arr : Array<Float>) : RGBA {
    var ints = arr.resize(4).pluck((_ * 255).round());
    return create(ints[0], ints[1], ints[2], ints[3]);
  }

  @:from public static function fromInt(rgba : Int) : RGBA
    return rgba;

  @:from public static function fromInts(arr : Array<Int>) : RGBA {
    arr.resize(4);
    return create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) : Null<RGBA> {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        RGB.fromInts(ColorParser.getInt8Channels(info.channels, 3)).toRGBA();
      case 'rgba':
        RGBA.create(
          ColorParser.getInt8Channel(info.channels[0]),
          ColorParser.getInt8Channel(info.channels[1]),
          ColorParser.getInt8Channel(info.channels[2]),
          Math.round(ColorParser.getFloatChannel(info.channels[3]) * 255)
        );
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public function new(rgba : Int) : RGBA
    this = rgba;

  public var red(get, never)   : Int;
  public var green(get, never) : Int;
  public var blue(get, never)  : Int;
  public var alpha(get, never)  : Int;

  public function darker(t : Float) : RGBA
    return toRGBXA().darker(t).toRGBA();

  public function lighter(t : Float) : RGBA
    return toRGBXA().lighter(t).toRGBA();

  public function transparent(t : Float) : RGBA
    return toRGBXA().transparent(t).toRGBA();

  public function opaque(t : Float)
    return toRGBXA().opaque(t).toRGBA();

  public function interpolate(other : RGBA, t : Float)
    return toRGBXA().interpolate(other.toRGBXA(), t).toRGBA();

  public function withAlpha(newalpha : Int)
    return RGBA.fromInts([red, green, blue, newalpha]);

  public function withRed(newred : Int)
    return RGBA.fromInts([newred, green, blue]);

  public function withGreen(newgreen : Int)
    return RGBA.fromInts([red, newgreen, blue]);

  public function withBlue(newblue : Int)
    return RGBA.fromInts([red, green, newblue]);

  @:to public function toHSLA()
    return toRGBXA().toHSLA();

  @:to public function toHSVA()
    return toRGBXA().toHSVA();

  @:to public function toRGB() : RGB
    return RGB.create(red, green, blue);

  @:to public function toRGBX() : RGBX
    return RGBX.fromInts([red, green, blue]);

  @:to public function toRGBXA() : RGBXA
    return RGBXA.fromInts([red, green, blue, alpha]);

  public function toCSS3() : String
    return toString();

  @:to public function toString() : String
    return 'rgba($red,$green,$blue,${alpha/255})';

   public function toHex(prefix = "#")
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : RGBA) : Bool
    return red == other.red && alpha == other.alpha && green == other.green && blue == other.blue;

  inline function get_alpha() : Int
    return (this >> 24) & 0xFF;
  inline function get_red() : Int
    return (this >> 16) & 0xFF;
  inline function get_green() : Int
    return (this >> 8) & 0xFF;
  inline function get_blue() : Int
    return this & 0xFF;
}