package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Functions;
using thx.Strings;
import thx.color.parse.ColorParser;

/**
A version of `Rgb` with an additional channel for `alpha`.

`Rgba` uses an `Int` as the underlying type.
**/
abstract Rgba(Int) from Int to Int {
  inline public static function create(red : Int, green : Int, blue : Int, alpha : Int) : Rgba
    return ((red & 0xFF) << 24) | ((green & 0xFF) << 16) | ((blue & 0xFF) << 8) | ((alpha & 0xFF) << 0);

  @:from public static function fromFloats(arr : Array<Float>) : Rgba {
    var ints = arr.resize(4).map.fn((_ * 255).round());
    return create(ints[0], ints[1], ints[2], ints[3]);
  }

  @:from public static function fromInt(rgba : Int) : Rgba
    return rgba;

  @:from public static function fromInts(arr : Array<Int>) : Rgba {
    arr.resize(4);
    return create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) : Null<Rgba> {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        Rgb.fromInts(ColorParser.getInt8Channels(info.channels, 3)).toRgba();
      case 'rgba':
        Rgba.create(
          ColorParser.getInt8Channel(info.channels[0]),
          ColorParser.getInt8Channel(info.channels[1]),
          ColorParser.getInt8Channel(info.channels[2]),
          Math.round(ColorParser.getFloatChannel(info.channels[3]) * 255)
        );
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public function new(rgba : Int) : Rgba
    this = rgba;

  public var red(get, never)   : Int;
  public var green(get, never) : Int;
  public var blue(get, never)  : Int;
  public var alpha(get, never)  : Int;

  public function combineColor(other : Rgb) : Rgb {
    var a = alpha / 255;
    return Rgb.fromInts([
      Math.round((1 - a) * other.red   + a * red),
      Math.round((1 - a) * other.green + a * green),
      Math.round((1 - a) * other.blue  + a * blue)
    ]);
  }

  public function darker(t : Float) : Rgba
    return toRgbxa().darker(t).toRgba();

  public function lighter(t : Float) : Rgba
    return toRgbxa().lighter(t).toRgba();

  public function transparent(t : Float) : Rgba
    return toRgbxa().transparent(t).toRgba();

  public function opaque(t : Float)
    return toRgbxa().opaque(t).toRgba();

  public function interpolate(other : Rgba, t : Float)
    return toRgbxa().interpolate(other.toRgbxa(), t).toRgba();

  public function withAlpha(newalpha : Int)
    return Rgba.fromInts([red, green, blue, newalpha]);

  public function withAlphaf(newalpha : Float)
    return Rgba.fromInts([red, green, blue, Math.round(255 * newalpha)]);

  public function withRed(newred : Int)
    return Rgba.fromInts([newred, green, blue]);

  public function withGreen(newgreen : Int)
    return Rgba.fromInts([red, newgreen, blue]);

  public function withBlue(newblue : Int)
    return Rgba.fromInts([red, green, newblue]);

  @:to public function toHsla()
    return toRgbxa().toHsla();

  @:to public function toHsva()
    return toRgbxa().toHsva();

  @:to public function toRgb() : Rgb
    return Rgb.create(red, green, blue);

  @:to public function toRgbx() : Rgbx
    return Rgbx.fromInts([red, green, blue]);

  @:to public function toRgbxa() : Rgbxa
    return Rgbxa.fromInts([red, green, blue, alpha]);

  public function toCss3() : String
    return toString();

  @:to public function toString() : String
    return 'rgba($red,$green,$blue,${alpha/255})';

   public function toHex(prefix = "#")
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : Rgba) : Bool
    return red == other.red && alpha == other.alpha && green == other.green && blue == other.blue;

  inline function get_alpha() : Int
    return this & 0xFF;
  inline function get_red() : Int
    return (this >> 24) & 0xFF;
  inline function get_green() : Int
    return (this >> 16) & 0xFF;
  inline function get_blue() : Int
    return (this >> 8) & 0xFF;
}
