package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.CMY)
@:access(thx.color.RGBX)
abstract CMYK(Array<Float>) {
  public var black(get, never): Float;
  public var cyan(get, never): Float;
  public var magenta(get, never): Float;
  public var yellow(get, never): Float;

  public static function create(cyan: Float, magenta: Float, yellow: Float, black: Float) : CMYK
    return new CMYK([
      cyan.normalize(),
      magenta.normalize(),
      yellow.normalize(),
      black.normalize()
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return CMYK.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) : CMYK {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;
    return try switch info.name {
      case 'cmyk':
        new thx.color.CMYK(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CMYK
    this = channels;

  inline public function darker(t : Float) : CMYK
    return new CMYK([cyan, magenta, yellow, t.interpolate(black, 1)]);

  inline public function lighter(t : Float) : CMYK
    return new CMYK([cyan, magenta, yellow, t.interpolate(black, 0)]);

  public function interpolate(other : CMYK, t : Float) : CMYK
    return new CMYK([
      t.interpolate(cyan,    other.cyan),
      t.interpolate(magenta, other.magenta),
      t.interpolate(yellow,  other.yellow),
      t.interpolate(black,   other.black)
    ]);

  public function withCyan(newcyan : Float)
    return new CMYK([
      newcyan.normalize(),
      magenta,
      yellow,
      black
    ]);

  public function withMagenta(newmagenta : Float)
    return new CMYK([
      cyan,
      newmagenta.normalize(),
      yellow,
      black
    ]);

  public function withYellow(newyellow : Float)
    return new CMYK([
      cyan,
      magenta,
      newyellow.normalize(),
      black
    ]);

  public function withBlack(newblack : Float)
    return new CMYK([
      cyan,
      magenta,
      yellow,
      newblack.normalize()
    ]);

  @:to inline public function toString() : String
    return 'cmyk($cyan,$magenta,$yellow,$black)';

  @:op(A==B) public function equals(other : CMYK) : Bool
    return cyan == other.cyan && magenta == other.magenta && yellow == other.yellow && black == other.black;

  @:to inline public function toCIELab() : CIELab
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh() : CIELCh
    return toRGBX().toCIELCh();

  @:to public function toCMY() : CMY
    return new CMY([
      black + (1 - black) * cyan,
      black + (1 - black) * magenta,
      black + (1 - black) * yellow
    ]);

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
      (1 - black) * (1 - cyan),
      (1 - black) * (1 - magenta),
      (1 - black) * (1 - yellow)
    ]);

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
  inline function get_black() : Float
    return this[3];

  @:to inline public function toXYZ() : XYZ
    return toRGBX().toXYZ();

  @:to inline public function toYxy() : Yxy
    return toRGBX().toYxy();
}