package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

/**
`CMY` is a subtractive color space and is the complementar to `Rgbx`.
**/
@:access(thx.color.Rgbx)
@:access(thx.color.Cmyk)
abstract Cmy(Array<Float>) {
  public var cyan(get, never): Float;
  public var magenta(get, never): Float;
  public var yellow(get, never): Float;

  inline public static function create(cyan: Float, magenta: Float, yellow: Float) : Cmy
    return new Cmy([cyan, magenta, yellow]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Cmy.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;
    return try switch info.name {
      case 'cmy':
        new thx.color.Cmy(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Cmy
    this = channels;

  public function interpolate(other : Cmy, t : Float)
    return new Cmy([
      t.interpolate(cyan,    other.cyan),
      t.interpolate(magenta, other.magenta),
      t.interpolate(yellow,  other.yellow)
    ]);

  public function min(other : Cmy)
    return create(cyan.min(other.cyan), magenta.min(other.magenta), yellow.min(other.yellow));

  public function max(other : Cmy)
    return create(cyan.max(other.cyan), magenta.max(other.magenta), yellow.max(other.yellow));

  public function normalize()
    return create(cyan.normalize(), magenta.normalize(), yellow.normalize());

  public function roundTo(decimals : Int)
    return create(cyan.roundTo(decimals), magenta.roundTo(decimals), yellow.roundTo(decimals));

  public function withCyan(newcyan : Float)
    return new Cmy([newcyan, magenta, yellow]);

  public function withMagenta(newmagenta : Float)
    return new Cmy([cyan, newmagenta, yellow]);

  public function withYellow(newyellow : Float)
    return new Cmy([cyan, magenta, newyellow]);

  @:to public function toString() : String
    return 'cmy(${cyan},${magenta},${yellow})';

  @:op(A==B) public function equals(other : Cmy) : Bool
    return nearEquals(other);

  public function nearEquals(other : Cmy, ?tolerance = Floats.EPSILON) : Bool
    return cyan.nearEquals(other.cyan, tolerance) && magenta.nearEquals(other.magenta, tolerance) && yellow.nearEquals(other.yellow, tolerance);

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

  @:to public function toLuv()
    return toRgbx().toLuv();

  @:to public function toCmyk() {
    var k = cyan.min(magenta).min(yellow);
    if(k == 1)
      return new Cmyk([0,0,0,1]);
    else
      return new Cmyk([
        (cyan - k)    / (1 - k),
        (magenta - k) / (1 - k),
        (yellow - k)  / (1 - k),
        k
      ]);
  }

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
      1 - cyan,
      1 - magenta,
      1 - yellow
    ]);

  @:to public function toRgbxa() : Rgbxa
    return toRgbx().toRgbxa();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz() : Xyz
    return toRgbx().toXyz();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy() : Yxy
    return toRgbx().toYxy();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
}
