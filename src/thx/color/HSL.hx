package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
using thx.core.Tuple;
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

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return HSL.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
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

  public function darker(t : Float)
    return new HSL([
      hue,
      saturation,
      t.interpolate(lightness, 0)
    ]);

  public function lighter(t : Float)
    return new HSL([
      hue,
      saturation,
      t.interpolate(lightness, 1)
    ]);

  public function interpolate(other : HSL, t : Float)
    return new HSL([
      t.interpolateAngle(hue, other.hue, 360),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness)
    ]);

  public function rotate(angle : Float)
    return withHue(hue + angle);

  public function split(spread = 144.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function square()
    return tetrad(90);

  public function tetrad(angle : Float)
    return new Tuple4(
      rotate(0),
      rotate(angle),
      rotate(180),
      rotate(180 + angle)
    );

  public function triad()
    return new Tuple3(
      rotate(-120),
      rotate(0),
      rotate(120)
    );

  inline public function withAlpha(alpha : Float)
    return new HSLA(this.concat([alpha.normalize()]));

  inline public function withHue(newhue : Float)
    return new HSL([newhue.normalize(), saturation, lightness]);

  inline public function withLightness(newlightness : Float)
    return new HSL([hue, saturation, newlightness.normalize()]);

  inline public function withSaturation(newsaturation : Float)
    return new HSL([hue, newsaturation.normalize(), lightness]);

  inline public function toCSS3() : String
    return toString();
  inline public function toString() : String
    return 'hsl(${huef},${saturation*100}%,${lightness*100}%)';

  @:op(A==B) public function equals(other : HSL) : Bool
    return hue == other.hue && saturation == other.saturation && lightness == other.lightness;

  @:to inline public function toCIELab()
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to inline public function toCMY()
    return toRGBX().toCMY();

  @:to inline public function toCMYK()
    return toRGBX().toCMYK();

  @:to inline public function toGrey()
    return toRGBX().toGrey();

  @:to inline public function toHSV()
    return toRGBX().toHSV();

  @:to inline public function toRGB()
    return toRGBX().toRGB();

  @:to inline public function toRGBX()
    return new RGBX([
      _c(hue + 120, saturation, lightness),
      _c(hue, saturation, lightness),
      _c(hue - 120, saturation, lightness)
    ]);

  @:to inline public function toRGBXA()
    return toRGBX().toRGBXA();

  @:to inline public function toHSLA()
    return withAlpha(1.0);

  @:to inline public function toXYZ()
    return toRGBX().toXYZ();

  @:to inline public function toYxy()
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