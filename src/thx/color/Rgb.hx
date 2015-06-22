package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Ints;
using thx.Strings;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbx)
abstract Rgb(Int) from Int to Int {
  inline public static function create(red : Int, green : Int, blue : Int)
    return new Rgb(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));

    inline public static function createf(red : Float, green : Float, blue : Float)
    return create((red * 255).round(), (green * 255).round(), (blue * 255).round());

  @:from public static function fromString(color : String) : Null<Rgb> {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'rgb':
        Rgb.fromInts(ColorParser.getInt8Channels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  @:from public static function fromInts(arr : Array<Int>) {
    arr.resize(3);
    return create(arr[0], arr[1], arr[2]);
  }

  inline public function new(rgb : Int) : Rgb
    this = rgb;

  public var red(get, never)   : Int;
  public var green(get, never) : Int;
  public var blue(get, never)  : Int;

  public function darker(t : Float)
    return toRgbx().darker(t).toRgb();

  public function lighter(t : Float)
    return toRgbx().lighter(t).toRgb();

  public function interpolate(other : Rgb, t : Float)
    return toRgbx().interpolate(other.toRgbx(), t).toRgb();

  public function min(other : Rgb)
    return create(red.min(other.red), green.min(other.green), blue.min(other.blue));

  public function max(other : Rgb)
    return create(red.max(other.red), green.max(other.green), blue.max(other.blue));

  public function withAlpha(alpha : Int)
    return Rgba.fromInts([red, green, blue, alpha]);

  public function withRed(newred : Int)
    return Rgb.fromInts([newred, green, blue]);

  public function withGreen(newgreen : Int)
    return Rgb.fromInts([red, newgreen, blue]);

  public function withBlue(newblue : Int)
    return Rgb.fromInts([red, green, newblue]);

  public function toCss3() : String
    return 'rgb($red,$green,$blue)';

  @:to public function toString() : String
    return toHex();

  public function toHex(prefix = "#")
    return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

  @:op(A==B) public function equals(other : Rgb) : Bool
    return red == other.red && green == other.green && blue == other.blue;

  @:to public function toCieLab()
    return toXyz().toCieLab();

  @:to public function toCieLCh()
    return toCieLab().toCieLCh();

  @:to public function toCieLuv()
    return toRgbx().toCieLuv();

  @:to public function toCmy()
    return toRgbx().toCmy();

  @:to public function toCmyk()
    return toRgbx().toCmyk();

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

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toRgbx()
    return Rgbx.fromInts([red, green, blue]);

  @:to public function toRgba()
    return withAlpha(255);

  @:to public function toRgbxa()
    return toRgba().toRgbxa();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toRgbx().toYxy();

  @:to public function toXyz()
    return toRgbx().toXyz();

  function get_red() : Int
    return (this >> 16) & 0xFF;
  function get_green() : Int
    return (this >> 8) & 0xFF;
  function get_blue() : Int
    return this & 0xFF;
}
