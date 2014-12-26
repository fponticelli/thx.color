package thx.color;

using thx.core.Floats;
using thx.core.Nulls;
using thx.core.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.HSVA)
abstract HSV(Array<Float>) {
  public var hue(get, never) : Float;
  public var huef(get, never) : Float;
  public var saturation(get, never) : Float;
  public var value(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float)
    return new HSV([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1)
    ]);

  @:from public static function fromString(color : String) : HSV {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsv':
        new thx.color.HSV(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public static function fromFloats(arr : Array<Float>) : HSV
    return HSV.create(arr[0].or(0), arr[1].or(0), arr[2].or(0));

  inline function new(channels : Array<Float>) : HSV
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : HSV, t : Float) : HSV
    return new HSV([
      // TODO circular interpolation
      t.interpolate(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value)
    ]);

  public function rotate(angle : Float)
    return HSV.create(hue + angle, saturation, value);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  inline public function toString() : String
    return 'hsv($huef,${saturation*100}%,${value*100}%)';

  @:op(A==B) public function equals(other : HSV) : Bool
    return hue == other.hue && saturation == other.saturation && value == other.value;

  @:to inline public function toCIELab() : CIELab
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh() : CIELCh
    return toRGBX().toCIELCh();

  @:to inline public function toCMY() : CMY
    return toRGBX().toCMY();

  @:to inline public function toCMYK() : CMYK
    return toRGBX().toCMYK();

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSL() : HSL
    return toRGBX().toHSL();

  @:to inline public function toHSVA() : HSVA
    return withAlpha(1.0);

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX {
    if(saturation == 0)
      return new RGBX([value, value, value]);

    var r : Float, g : Float, b : Float, i : Int, f : Float, p : Float, q : Float, t : Float;
    var h = hue / 60;

    i = Math.floor(h);
    f = h - i;
    p = value * (1 - saturation);
    q = value * (1 - f * saturation);
    t = value * (1 - (1 - f) * saturation);

    switch(i){
      case 0: r = value; g = t; b = p;
      case 1: r = q; g = value; b = p;
      case 2: r = p; g = value; b = t;
      case 3: r = p; g = q; b = value;
      case 4: r = t; g = p; b = value;
      default: r = value; g = p; b = q; // case 5
    }

    return new RGBX([r, g, b]);
  }

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ() : XYZ
    return toRGBX().toXYZ();

  @:to inline public function toYxy() : Yxy
    return toRGBX().toYxy();

  inline public function withAlpha(alpha : Float) : HSVA
    return new HSVA(this.concat([alpha]));

  inline function get_hue() : Float
    return this[0];
  inline function get_huef() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_value() : Float
    return this[2];
}