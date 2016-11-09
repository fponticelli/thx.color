package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Ints;
using thx.Functions;
using thx.Strings;
import thx.color.parse.ColorParser;

/**
A version of `Rgb` with an additional channel for `alpha` at the beginning.

`Argb` uses an `Int` as the underlying type.
**/
abstract Argb(Int) from Int {
  inline public static function create(alpha: Int, red: Int, green: Int, blue: Int): Argb
    return ((alpha & 0xFF) << 24) | ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0);

  @:from public static function fromFloats(arr: Array<Float>): Argb {
    var ints = arr.resized(4).map.fn((_ * 255).round());
    return create(ints[0], ints[1], ints[2], ints[3]);
  }

  @:from public static function fromInt(argb: Int): Argb
    return argb;

  @:from public static function fromInts(arr: Array<Int>): Argb {
    arr = arr.resized(4);
    return create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color: String): Null<Argb> {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'argb':
        Argb.create(
          ColorParser.getInt8Channel(info.channels[0]),
          ColorParser.getInt8Channel(info.channels[1]),
          ColorParser.getInt8Channel(info.channels[2]),
          ColorParser.getInt8Channel(info.channels[3])
        );
      case _:
        null;
    } catch(e: Dynamic) null;
  }

  inline public function new(argb: Int): Argb
    this = argb;

  public var red(get, never)  : Int;
  public var green(get, never): Int;
  public var blue(get, never) : Int;
  public var alpha(get, never) : Int;

  public function combineColor(other: Rgb): Rgb {
    var a = alpha / 255;
    return Rgb.fromInts([
      Math.round((1 - a) * other.red   + a * red),
      Math.round((1 - a) * other.green + a * green),
      Math.round((1 - a) * other.blue  + a * blue)
    ]);
  }

  public function darker(t: Float): Argb
    return toRgbxa().darker(t).toArgb();

  public function lighter(t: Float): Argb
    return toRgbxa().lighter(t).toArgb();

  public function transparent(t: Float): Argb
    return toRgbxa().transparent(t).toArgb();

  public function opaque(t: Float)
    return toRgbxa().opaque(t).toArgb();

  public function interpolate(other: Argb, t: Float)
    return toRgbxa().interpolate(other.toRgbxa(), t).toArgb();

  public function withAlpha(newalpha: Int): Argb
    return Argb.create(newalpha, red, green, blue);

  public function withAlphaf(newalpha: Float): Argb
    return Argb.create(Math.round(255 * newalpha), red, green, blue);

  public function withRed(newred: Int): Argb
    return Argb.create(alpha, newred, green, blue);

  public function withGreen(newgreen: Int): Argb
    return Argb.create(alpha, red, newgreen, blue);

  public function withBlue(newblue: Int): Argb
    return Argb.create(alpha, red, green, newblue);

  @:to public function toHsla(): Hsla
    return toRgbxa().toHsla();

  @:to public function toHsva(): Hsva
    return toRgbxa().toHsva();

  @:to public function toRgb(): Rgb
    return Rgb.create(red, green, blue);

  @:to public function toRgba(): Rgba
    return Rgba.create(red, green, blue, alpha);

  @:to public function toRgbx(): Rgbx
    return Rgbx.fromInts([red, green, blue]);

  @:to public function toRgbxa(): Rgbxa
    return Rgbxa.fromInts([red, green, blue, alpha]);

  @:to public function toString(): String
    return 'argb($alpha,$red,$green,$blue)';

  public function toHex(prefix = "#")
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other: Argb): Bool
    return red == other.red && alpha == other.alpha && green == other.green && blue == other.blue;

  public function toInt(): Int
    return this;

  inline function get_alpha(): Int
    return (this >> 24) & 0xFF;
  inline function get_red(): Int
    return (this >> 16) & 0xFF;
  inline function get_green(): Int
    return (this >> 8) & 0xFF;
  inline function get_blue(): Int
    return this & 0xFF;
}
