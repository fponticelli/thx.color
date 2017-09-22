package thx.color;

using thx.Arrays;
import thx.Floats;
import thx.Ints;
using thx.Strings;
import thx.color.parse.ColorParser;

/**
A version of `Rgbx` with an additional `alpha` channel for transparency.
**/
@:access(thx.color.Rgbx)
abstract Rgbxa(Array<Float>) {
  inline public static function create(red: Float, green: Float, blue: Float, alpha: Float): Rgbxa
    return new Rgbxa([red,green,blue,alpha]);

  @:from public static function fromFloats(arr: Array<Float>) {
    arr = arr.resized(4);
    return Rgbxa.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromInts(arr: Array<Int>) {
    arr = arr.resized(4);
    return Rgbxa.create(arr[0] / 255.0, arr[1] / 255.0, arr[2] / 255.0, arr[3] / 255.0);
  }

  @:from public static function fromInt(value: Int) {
    var rgba: Rgba = value;
    return create(rgba.red / 255, rgba.green / 255, rgba.blue / 255, rgba.alpha / 255);
  }

  @:from public static function fromString(color: String) {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        thx.color.Rgbx.fromFloats(ColorParser.getFloatChannels(info.channels, 3, [HexMode, HexMode, HexMode])).toRgbxa();
      case 'rgba':
        thx.color.Rgbxa.fromFloats(ColorParser.getFloatChannels(info.channels, 4, [HexMode, HexMode, HexMode, NaturalMode]));
      case 'hexa':
        thx.color.Rgbxa.fromFloats(ColorParser.getFloatChannels(info.channels, 4, [HexMode, HexMode, HexMode, HexMode]));
      case _:
        null;
    } catch(e: Dynamic) null;
  }

  inline function new(channels: Array<Float>): Rgbxa
    this = channels;

  public var red(get, never): Int;
  public var green(get, never): Int;
  public var blue(get, never): Int;
  public var alpha(get, never): Int;
  public var redf(get, never): Float;
  public var greenf(get, never): Float;
  public var bluef(get, never): Float;
  public var alphaf(get, never): Float;
  public var inSpace(get, never): Bool;

  public function combineColor(other: Rgbx): Rgbx
    return new Rgbx([
      (1 - alphaf) * other.redf   + alphaf * redf,
      (1 - alphaf) * other.greenf + alphaf * greenf,
      (1 - alphaf) * other.bluef  + alphaf * bluef
    ]);

  public function darker(t: Float)
    return toRgbx().darker(t).withAlpha(alpha);

  public function lighter(t: Float)
    return toRgbx().lighter(t).withAlpha(alpha);

  public function transparent(t: Float)
    return new Rgbxa([
      redf,
      greenf,
      bluef,
      Floats.interpolate(t, alphaf, 0)
    ]);

  public function opaque(t: Float)
    return new Rgbxa([
      redf,
      greenf,
      bluef,
      Floats.interpolate(t, alphaf, 1)
    ]);

  public function interpolate(other: Rgbxa, t: Float)
    return new Rgbxa([
      Floats.interpolate(t, redf, other.redf),
      Floats.interpolate(t, greenf, other.greenf),
      Floats.interpolate(t, bluef, other.bluef),
      Floats.interpolate(t, alphaf, other.alphaf)
    ]);

  public function normalize()
    return new Rgbx([
      Floats.normalize(redf),
      Floats.normalize(greenf),
      Floats.normalize(bluef),
      Floats.normalize(alphaf)
    ]);

  public function roundTo(decimals: Int)
    return create(Floats.roundTo(redf, decimals), Floats.roundTo(greenf, decimals), Floats.roundTo(bluef, decimals), Floats.roundTo(alphaf, decimals));

  public function withAlpha(newalpha: Float)
    return new Rgbxa([red, green, blue, newalpha]);

  public function withRed(newred: Int)
    return new Rgbxa([newred, green, blue, alphaf]);

  public function withGreen(newgreen: Int)
    return new Rgbxa([red, newgreen, blue, alphaf]);

  public function withBlue(newblue: Int)
    return new Rgbxa([red, green, newblue, alphaf]);

  public function toCss3(): String
    return toString();

  @:to public function toString(): String
    return 'rgba(${(redf*100)}%,${(greenf*100)}%,${(bluef*100)}%,${alphaf})';

  public function toHex(prefix = "#"): String
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other: Rgbxa): Bool
    return nearEquals(other);

  public function nearEquals(other: Rgbxa, ?tolerance = Floats.EPSILON): Bool
    return Floats.nearEquals(redf, other.redf, tolerance) && Floats.nearEquals(greenf, other.greenf, tolerance) && Floats.nearEquals(bluef, other.bluef, tolerance) && Floats.nearEquals(alphaf, other.alphaf, tolerance);

  @:to public function toHsla(): Hsla
    return toRgbx().toHsl().withAlpha(alphaf);

  @:to public function toHsva(): Hsva
    return toRgbx().toHsv().withAlpha(alphaf);

  @:to public function toRgb(): Rgb
    return toRgbx().toRgb();

  @:to public function toRgbx(): Rgbx
    return new Rgbx(this.slice(0,3));

  @:to public function toRgba(): Rgba
    return Rgba.fromFloats([redf, greenf, bluef, alphaf]);

  @:to public function toArgb(): Argb
    return Argb.fromFloats([alphaf, redf, greenf, bluef]);

  function get_red(): Int
    return Math.round(redf * 255);
  function get_green(): Int
    return Math.round(greenf * 255);
  function get_blue(): Int
    return Math.round(bluef * 255);
  function get_alpha(): Int
    return Math.round(alphaf * 255);

  inline function get_redf(): Float
    return this[0];
  inline function get_greenf(): Float
    return this[1];
  inline function get_bluef(): Float
    return this[2];
  inline function get_alphaf(): Float
    return this[3];

  function get_inSpace(): Bool
    return redf >= 0 && redf <= 1 && greenf >= 0 && greenf <= 1 && bluef >= 0 && bluef <= 1 && alphaf >= 0 && alphaf <= 1;
}
