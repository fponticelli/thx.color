package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Ints;
using thx.Strings;
import thx.color.parse.ColorParser;

@:access(thx.color.Hsla)
@:access(thx.color.Hsva)
@:access(thx.color.Rgba)
@:access(thx.color.Rgbx)
abstract Rgbxa(Array<Float>) {
  public static function create(red : Float, green : Float, blue : Float, alpha : Float) : Rgbxa
    return new Rgbxa([red,green,blue,alpha]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return Rgbxa.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromInts(arr : Array<Int>) {
    arr.resize(4);
    return Rgbxa.create(arr[0] / 255, arr[1] / 255, arr[2] / 255, arr[3] / 255);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        thx.color.Rgbx.fromFloats(ColorParser.getFloatChannels(info.channels, 3)).toRgbxa();
      case 'rgba':
        thx.color.Rgbxa.fromFloats(ColorParser.getFloatChannels(info.channels, 4));
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
      bluef.normalize(),
      greenf.normalize(),
      alphaf.normalize()
    ]);

  public function withAlpha(newalpha : Float)
    return new Rgbxa([red, green, blue, newalpha.normalize()]);

  public function withRed(newred : Int)
    return new Rgbxa([newred.normalize(), green, blue, alpha]);

  public function withGreen(newgreen : Int)
    return new Rgbxa([red, newgreen.normalize(), blue, alpha]);

  public function withBlue(newblue : Int)
    return new Rgbxa([red, green, newblue.normalize(), alpha]);

  public function toCss3() : String
    return toString();

  @:to public function toString() : String
    return 'rgba(${(redf*100).roundTo(6)}%,${(greenf*100).roundTo(6)}%,${(bluef*100).roundTo(6)}%,${alphaf.roundTo(6)})';

  public function toHex(prefix = "#") : String
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : Rgbxa) : Bool
    return redf.nearEquals(other.redf) && greenf.nearEquals(other.greenf) && bluef.nearEquals(other.bluef) && alphaf.nearEquals(other.alphaf);

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
    return (alphaf  * 255).round();

  inline function get_redf() : Float
    return this[0];
  inline function get_greenf() : Float
    return this[1];
  inline function get_bluef() : Float
    return this[2];
  inline function get_alphaf() : Float
    return this[3];
}