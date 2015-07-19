package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

/**
The CMYK color model (process color, four color) is a subtractive color model,
used in color printing, and is also used to describe the printing process
itself. CMYK refers to the four inks used in some color printing: cyan, magenta,
yellow, and key (black). Though it varies by print house, press operator,
press manufacturer, and press run, ink is typically applied in the order of the
abbreviation.

Values for all the channels should be included in the `0`, `1` range.
**/
@:access(thx.color.Cmy)
@:access(thx.color.Rgbx)
abstract Cmyk(Array<Float>) {
  public var black(get, never): Float;
  public var cyan(get, never): Float;
  public var magenta(get, never): Float;
  public var yellow(get, never): Float;

  inline public static function create(cyan: Float, magenta: Float, yellow: Float, black: Float)
    return new Cmyk([cyan, magenta, yellow, black]);

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
        new thx.color.Cmyk(ColorParser.getFloatChannels(info.channels, 4, false));
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

  public function min(other : Cmyk)
    return create(cyan.min(other.cyan), magenta.min(other.magenta), yellow.min(other.yellow), black.min(other.black));

  public function max(other : Cmyk)
    return create(cyan.max(other.cyan), magenta.max(other.magenta), yellow.max(other.yellow), black.max(other.black));

  public function normalize()
    return create(
      cyan.normalize(),
      magenta.normalize(),
      yellow.normalize(),
      black.normalize()
    );

  public function roundTo(decimals : Int)
    return create(cyan.roundTo(decimals), magenta.roundTo(decimals), yellow.roundTo(decimals), black.roundTo(decimals));

  public function withCyan(newcyan : Float)
    return new Cmyk([newcyan, magenta, yellow, black]);

  public function withMagenta(newmagenta : Float)
    return new Cmyk([cyan, newmagenta, yellow, black]);

  public function withYellow(newyellow : Float)
    return new Cmyk([cyan, magenta, newyellow, black]);

  public function withBlack(newblack : Float)
    return new Cmyk([cyan, magenta, yellow, newblack]);

  @:to public function toString() : String
    return 'cmyk(${cyan},${magenta},${yellow},${black})';

  @:op(A==B) public function equals(other : Cmyk) : Bool
    return nearEquals(other);

  public function nearEquals(other : Cmyk, ?tolerance = Floats.EPSILON) : Bool
    return cyan.nearEquals(other.cyan, tolerance) && magenta.nearEquals(other.magenta, tolerance) && yellow.nearEquals(other.yellow, tolerance) && black.nearEquals(other.black, tolerance);

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

  @:to public function toLuv()
    return toRgbx().toLuv();

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

  @:to public function toHsl()
    return toRgbx().toHsl();

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

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

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz()
    return toRgbx().toXyz();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toRgbx().toYxy();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
  inline function get_black() : Float
    return this[3];
}
