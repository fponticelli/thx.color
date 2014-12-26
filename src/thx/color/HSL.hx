package thx.color;

using thx.core.Tuple;
using thx.core.Floats;
using thx.core.Nulls;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.HSLA)
abstract HSL(Array<Float>) {
  public var hue(get, never) : Float;
  public var huef(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float)
    return new HSL([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) : HSL
    return HSL.create(arr[0].or(0), arr[1].or(0), arr[2].or(0));

  @:from public static function fromString(color : String) : HSL {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsl':
        new thx.color.HSL(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : HSL
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function darker(t : Float) : HSL
    return new HSL([
      hue,
      saturation,
      t.interpolate(lightness, 0)
    ]);

  public function lighter(t : Float) : HSL
    return new HSL([
      hue,
      saturation,
      t.interpolate(lightness, 1)
    ]);

  public function interpolate(other : HSL, t : Float) : HSL
    return new HSL([
      // TODO circular interpolation
      t.interpolate(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness)
    ]);

  public function rotate(angle : Float)
    return HSL.create(hue + angle, saturation, lightness);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  inline public function withAlpha(alpha : Float) : HSLA
    return new HSLA(this.concat([alpha]));

  inline public function toCSS3() : String
    return toString();
  inline public function toString() : String
    return 'hsl(${huef},${saturation*100}%,${lightness*100}%)';

  @:op(A==B) public function equals(other : HSL) : Bool
    return hue == other.hue && saturation == other.saturation && lightness == other.lightness;

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

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX
    return new RGBX([
      _c(hue + 120, saturation, lightness),
      _c(hue, saturation, lightness),
      _c(hue - 120, saturation, lightness)
    ]);

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to inline public function toHSLA() : HSLA
    return withAlpha(1.0);

  @:to inline public function toXYZ() : XYZ
    return toRGBX().toXYZ();

  @:to inline public function toYxy() : Yxy
    return toRGBX().toYxy();

  inline function get_hue() : Float
    return this[0];
  inline function get_huef() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_lightness() : Float
    return this[2];

  // Based on D3.js by Michael Bostock
  static function _c(d : Float, s : Float, l : Float) : Float {
    var m2 = l <= 0.5 ? l * (1 + s) : l + s - l * s,
      m1 = 2 * l - m2;

    d = d.wrapCircular(360);
    if (d < 60)
      return m1 + (m2 - m1) * d / 60;
    else if (d < 180)
      return m2;
    else if (d < 240)
      return m1 + (m2 - m1) * (240 - d) / 60;
    else
      return m1;
  }
}