package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
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

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return CMY.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;
    return try switch info.name {
      case 'cmy':
        new thx.color.CMY(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CMY
    this = channels;

  public function interpolate(other : CMY, t : Float)
    return new CMY([
      t.interpolate(cyan,    other.cyan),
      t.interpolate(magenta, other.magenta),
      t.interpolate(yellow,  other.yellow)
    ]);

  public function withCyan(newcyan : Float)
    return new CMY([
      newcyan.normalize(),
      magenta,
      yellow
    ]);

  public function withMagenta(newmagenta : Float)
    return new CMY([
      cyan,
      newmagenta.normalize(),
      yellow
    ]);

  public function withYellow(newyellow : Float)
    return new CMY([
      cyan,
      magenta,
      newyellow.normalize()
    ]);

  @:to public function toString() : String
    return 'cmy($cyan,$magenta,$yellow)';

  @:op(A==B) public function equals(other : CMY) : Bool
    return cyan.nearEquals(other.cyan) && magenta.nearEquals(other.magenta) && yellow.nearEquals(other.yellow);

  @:to public function toCIELab()
    return toRGBX().toCIELab();

  @:to public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to public function toCMYK() {
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
      1 - cyan,
      1 - magenta,
      1 - yellow
    ]);

  @:to public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to public function toXYZ() : XYZ
    return toRGBX().toXYZ();

  @:to public function toYxy() : Yxy
    return toRGBX().toYxy();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
}