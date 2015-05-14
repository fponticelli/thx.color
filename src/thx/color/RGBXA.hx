package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Ints;
using thx.Strings;
import thx.color.parse.ColorParser;

@:access(thx.color.HSLA)
@:access(thx.color.HSVA)
@:access(thx.color.RGBA)
@:access(thx.color.RGBX)
abstract RGBXA(Array<Float>) {
  public static function create(red : Float, green : Float, blue : Float, alpha : Float) : RGBXA
    return new RGBXA([red.normalize(),green.normalize(),blue.normalize(),alpha.normalize()]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return RGBXA.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromInts(arr : Array<Int>) {
    arr.resize(4);
    return RGBXA.create(arr[0] / 255, arr[1] / 255, arr[2] / 255, arr[3] / 255);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        thx.color.RGBX.fromFloats(ColorParser.getFloatChannels(info.channels, 3)).toRGBXA();
      case 'rgba':
        thx.color.RGBXA.fromFloats(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : RGBXA
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
    return toRGBX().darker(t).withAlpha(alpha);

  public function lighter(t : Float)
    return toRGBX().lighter(t).withAlpha(alpha);

  public function transparent(t : Float)
    return new RGBXA([
      redf,
      greenf,
      bluef,
      t.interpolate(alphaf, 0)
    ]);

  public function opaque(t : Float)
    return new RGBXA([
      redf,
      greenf,
      bluef,
      t.interpolate(alphaf, 1)
    ]);

  public function interpolate(other : RGBXA, t : Float)
    return new RGBXA([
      t.interpolate(redf, other.redf),
      t.interpolate(greenf, other.greenf),
      t.interpolate(bluef, other.bluef),
      t.interpolate(alphaf, other.alphaf)
    ]);

  public function withAlpha(newalpha : Float)
    return new RGBXA([red, green, blue, newalpha.normalize()]);

  public function withRed(newred : Int)
    return new RGBXA([newred.normalize(), green, blue, alpha]);

  public function withGreen(newgreen : Int)
    return new RGBXA([red, newgreen.normalize(), blue, alpha]);

  public function withBlue(newblue : Int)
    return new RGBXA([red, green, newblue.normalize(), alpha]);

  public function toCSS3() : String
    return toString();

  @:to public function toString() : String
    return 'rgba(${(redf*100).roundTo(6)}%,${(greenf*100).roundTo(6)}%,${(bluef*100).roundTo(6)}%,${alphaf.roundTo(6)})';

  public function toHex(prefix = "#") : String
    return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : RGBXA) : Bool
    return redf.nearEquals(other.redf) && greenf.nearEquals(other.greenf) && bluef.nearEquals(other.bluef) && alphaf.nearEquals(other.alphaf);

  @:to public function toHSLA()
    return toRGBX().toHSL().withAlpha(alpha);

  @:to public function toHSVA()
    return toRGBX().toHSV().withAlpha(alpha);

  @:to public function toRGB()
    return toRGBX().toRGB();

  @:to public function toRGBX()
    return new RGBX(this.slice(0,3));

  @:to public function toRGBA()
    return RGBA.fromFloats([redf, greenf, bluef, alphaf]);

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