package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Ints;
using thx.Strings;
import thx.color.parse.ColorParser;

/**
A version of `Rgbx` with an additional `alpha` channel for transparency.
**/
@:access(thx.color.Rgbx)
abstract Rgbxa(Array<Float>) {
  inline public static function create(red : Float, green : Float, blue : Float, alpha : Float) : Rgbxa
    return new Rgbxa([red,green,blue,alpha]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return Rgbxa.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromInts(arr : Array<Int>) {
    arr.resize(4);
    return Rgbxa.create(arr[0] / 255.0, arr[1] / 255.0, arr[2] / 255.0, arr[3] / 255.0);
  }

  @:from public static function fromInt(value : Int) {
    var rgba : Rgba = value;
    return create(rgba.red / 255, rgba.green / 255, rgba.blue / 255, rgba.alpha / 255);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        thx.color.Rgbx.fromFloats(ColorParser.getFloatChannels(info.channels, 3, true)).toRgbxa();
      case 'rgba':
        thx.color.Rgbxa.fromFloats(ColorParser.getFloatChannels(info.channels, 4, true));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Rgbxa
    this = channels;

  public var red(get, never) : Int;
  public var green(get, never) : Int;
  public var blue(get, never) : Int;
  public var alpha(get, never) : Int;
  public var redf(get, never) : Float;
  public var greenf(get, never) : Float;
  public var bluef(get, never) : Float;
  public var alphaf(get, never) : Float;
  public var inSpace(get, never) : Bool;

  public function combineColor(other : Rgbx) : Rgbx
    return new Rgbx([
      (1 - alphaf) * other.redf   + alphaf * redf,
      (1 - alphaf) * other.greenf + alphaf * greenf,
      (1 - alphaf) * other.bluef  + alphaf * bluef
    ]);

  public function darker(t : Float)
    return toRgbx().darker(t).withAlpha(alpha);

  public function lighter(t : Float)
    return toRgbx().lighter(t).withAlpha(alpha);

  public function transparent(t : Float)
    return new Rgbxa([
      redf,
      greenf,
      bluef,
      t.interpolate(alphaf, 0)
    ]);

  public function opaque(t : Float)
    return new Rgbxa([
      redf,
      greenf,
      bluef,
      t.interpolate(alphaf, 1)
    ]);

  public function interpolate(other : Rgbxa, t : Float)
    return new Rgbxa([
      t.interpolate(redf, other.redf),
      t.interpolate(greenf, other.greenf),
      t.interpolate(bluef, other.bluef),
      t.interpolate(alphaf, other.alphaf)
    ]);

  public function normalize()
    return new Rgbx([
      redf.normalize(),
      greenf.normalize(),
      bluef.normalize(),
      alphaf.normalize()
    ]);

  public function roundTo(decimals : Int)
    return create(redf.roundTo(decimals), greenf.roundTo(decimals), bluef.roundTo(decimals), alphaf.roundTo(decimals));

  public function withAlpha(newalpha : Float)
    return new Rgbxa([red, green, blue, newalpha]);

  public function withRed(newred : Int)
    return new Rgbxa([newred, green, blue, alpha]);

  public function withGreen(newgreen : Int)
    return new Rgbxa([red, newgreen, blue, alpha]);

  public function withBlue(newblue : Int)
    return new Rgbxa([red, green, newblue, alpha]);

  public function toCss3() : String
    return toString();

  @:to public function toString() : String
    return 'rgba(${(redf*100)}%,${(greenf*100)}%,${(bluef*100)}%,${alphaf})';

  public function toHex(prefix = "#") : String
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : Rgbxa) : Bool
    return nearEquals(other);

  public function nearEquals(other : Rgbxa, ?tolerance = Floats.EPSILON) : Bool
    return redf.nearEquals(other.redf, tolerance) && greenf.nearEquals(other.greenf, tolerance) && bluef.nearEquals(other.bluef, tolerance) && alphaf.nearEquals(other.alphaf, tolerance);

  @:to public function toHsla()
    return toRgbx().toHsl().withAlpha(alpha);

  @:to public function toHsva()
    return toRgbx().toHsv().withAlpha(alpha);

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgbx()
    return new Rgbx(this.slice(0,3));

  @:to public function toRgba()
    return Rgba.fromFloats([redf, greenf, bluef, alphaf]);

  function get_red() : Int
    return (redf   * 255).round();
  function get_green() : Int
    return (greenf * 255).round();
  function get_blue() : Int
    return (bluef  * 255).round();
  function get_alpha() : Int
    return (alphaf * 255).round();

  inline function get_redf() : Float
    return this[0];
  inline function get_greenf() : Float
    return this[1];
  inline function get_bluef() : Float
    return this[2];
  inline function get_alphaf() : Float
    return this[3];

  function get_inSpace() : Bool
    return redf >= 0 && redf <= 1 && greenf >= 0 && greenf <= 1 && bluef >= 0 && bluef <= 1 && alphaf >= 0 && alphaf <= 1;
}
