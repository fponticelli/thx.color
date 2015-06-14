package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.Cmy)
@:access(thx.color.Rgbx)
abstract Cmyk(Array<Float>) {
  public var black(get, never): Float;
  public var cyan(get, never): Float;
  public var magenta(get, never): Float;
  public var yellow(get, never): Float;

  public static function create(cyan: Float, magenta: Float, yellow: Float, black: Float)
    return new Cmyk([
      cyan.normalize(),
      magenta.normalize(),
      yellow.normalize(),
      black.normalize()
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return Cmyk.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;
    return try switch info.name {
      case 'cmyk':
        new thx.color.Cmyk(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Cmyk
    this = channels;

  public function darker(t : Float)
    return new Cmyk([cyan, magenta, yellow, t.interpolate(black, 1)]);

  public function lighter(t : Float)
    return new Cmyk([cyan, magenta, yellow, t.interpolate(black, 0)]);

  public function interpolate(other : Cmyk, t : Float)
    return new Cmyk([
      t.interpolate(cyan,    other.cyan),
      t.interpolate(magenta, other.magenta),
      t.interpolate(yellow,  other.yellow),
      t.interpolate(black,   other.black)
    ]);

  public function withCyan(newcyan : Float)
    return new Cmyk([
      newcyan.normalize(),
      magenta,
      yellow,
      black
    ]);

  public function withMagenta(newmagenta : Float)
    return new Cmyk([
      cyan,
      newmagenta.normalize(),
      yellow,
      black
    ]);

  public function withYellow(newyellow : Float)
    return new Cmyk([
      cyan,
      magenta,
      newyellow.normalize(),
      black
    ]);

  public function withBlack(newblack : Float)
    return new Cmyk([
      cyan,
      magenta,
      yellow,
      newblack.normalize()
    ]);

  @:to public function toString() : String
    return 'cmyk(${cyan.roundTo(6)},${magenta.roundTo(6)},${yellow.roundTo(6)},${black.roundTo(6)})';

  @:op(A==B) public function equals(other : Cmyk) : Bool
    return cyan.nearEquals(other.cyan) && magenta.nearEquals(other.magenta) && yellow.nearEquals(other.yellow) && black.nearEquals(other.black);

  @:to public function toCieLab()
    return toRgbx().toCieLab();

  @:to public function toCieLCh()
    return toRgbx().toCieLCh();

  @:to public function toCmy()
    return new Cmy([
      black + (1 - black) * cyan,
      black + (1 - black) * magenta,
      black + (1 - black) * yellow
    ]);

  @:to public function toCubeHelix()
    return toRgbx().toCubeHelix();

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHcl()
    return toCieLab().toHcl();

  @:to public function toHsl()
    return toRgbx().toHsl();

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx()
    return new Rgbx([
      (1 - black) * (1 - cyan),
      (1 - black) * (1 - magenta),
      (1 - black) * (1 - yellow)
    ]);

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
  inline function get_black() : Float
    return this[3];

  @:to public function toXyz()
    return toRgbx().toXyz();

  @:to public function toYxy()
    return toRgbx().toYxy();
}
