package thx.color;

using thx.core.Floats;
using thx.core.Nulls;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.CMYK)
abstract CMY(Array<Float>) {
  public var cyan(get, never): Float;
  public var magenta(get, never): Float;
  public var yellow(get, never): Float;

  public static function create(cyan: Float, magenta: Float, yellow: Float) : CMY
    return new CMY([
      cyan.normalize(),
      magenta.normalize(),
      yellow.normalize()
    ]);

  @:from public static function fromFloats(arr : Array<Float>)
    return CMY.create(arr[0].or(0), arr[1].or(0), arr[2].or(0));

  @:from public static function fromString(color : String) : CMY {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;
    return try switch info.name {
      case 'cmy':
        new thx.color.CMY(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CMY
    this = channels;

  public function interpolate(other : CMY, t : Float) : CMY
    return new CMY([
      t.interpolate(cyan,    other.cyan),
      t.interpolate(magenta, other.magenta),
      t.interpolate(yellow,  other.yellow)
    ]);

  @:to inline public function toString() : String
    return 'cmy($cyan,$magenta,$yellow)';

  @:op(A==B) public function equals(other : CMY) : Bool
    return cyan == other.cyan && magenta == other.magenta && yellow == other.yellow;

  @:to inline public function toCIELab() : CIELab
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh() : CIELCh
    return toRGBX().toCIELCh();

  @:to public function toCMYK() : CMYK {
    var k = cyan.min(magenta).min(yellow);
    if(k == 1)
      return new CMYK([0,0,0,1]);
    else
      return new CMYK([
        (cyan - k)    / (1 - k),
        (magenta - k) / (1 - k),
        (yellow - k)  / (1 - k),
        k
      ]);
  }

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSL() : HSL
    return toRGBX().toHSL();

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX
    return new RGBX([
      1 - cyan,
      1 - magenta,
      1 - yellow
    ]);

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ() : XYZ
    return toRGBX().toXYZ();

  @:to inline public function toYxy() : Yxy
    return toRGBX().toYxy();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
}