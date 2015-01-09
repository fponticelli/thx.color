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

  public static function create(cyan: Float, magenta: Float, yellow: Float, black: Float)
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

  @:from public static function fromString(color : String) {
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

  public function darker(t : Float)
    return new CMYK([cyan, magenta, yellow, t.interpolate(black, 1)]);

  public function lighter(t : Float)
    return new CMYK([cyan, magenta, yellow, t.interpolate(black, 0)]);

  public function interpolate(other : CMYK, t : Float)
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

  @:to public function toString() : String
    return 'cmyk($cyan,$magenta,$yellow,$black)';

  @:op(A==B) public function equals(other : CMYK) : Bool
    return cyan.nearEquals(other.cyan) && magenta.nearEquals(other.magenta) && yellow.nearEquals(other.yellow) && black.nearEquals(other.black);

  @:to public function toCIELab()
    return toRGBX().toCIELab();

  @:to public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to public function toCMY()
    return new CMY([
      black + (1 - black) * cyan,
      black + (1 - black) * magenta,
      black + (1 - black) * yellow
    ]);

  @:to public function toGrey()
    return toRGBX().toGrey();

  @:to public function toHSL()
    return toRGBX().toHSL();

  @:to public function toHSV()
    return toRGBX().toHSV();

  @:to public function toRGB()
    return toRGBX().toRGB();

  @:to public function toRGBA()
    return toRGBXA().toRGBA();

  @:to public function toRGBX()
    return new RGBX([
      (1 - black) * (1 - cyan),
      (1 - black) * (1 - magenta),
      (1 - black) * (1 - yellow)
    ]);

  @:to public function toRGBXA()
    return toRGBX().toRGBXA();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
  inline function get_black() : Float
    return this[3];

  @:to public function toXYZ()
    return toRGBX().toXYZ();

  @:to public function toYxy()
    return toRGBX().toYxy();
}