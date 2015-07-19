package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

/**
HSL (hue-saturation-lightness) is one of the most common cylindrical-coordinate
representations of points in an RGB color model. Developed in the 1970s for
computer graphics applications, HSL is used today in color pickers, in image
editing software, and less commonly in image analysis and computer vision.

The representation rearranges the geometry of RGB in an attempt to be more
intuitive and perceptually relevant than the cartesian (cube) representation,
by mapping the values into a cylinder loosely inspired by a traditional color
wheel. The angle around the central vertical axis corresponds to "hue" and the
distance from the axis corresponds to "saturation". These first two values give
the two schemes the 'H' and 'S' in its name. The height corresponds to a third
value, the system's representation of the perceived luminance in relation to the
saturation.
**/
@:access(thx.color.Rgbx)
@:access(thx.color.Hsla)
abstract Hsl(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;

  inline public static function create(hue : Float, saturation : Float, lightness : Float)
    return new Hsl([hue, saturation, lightness]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Hsl.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsl':
        new thx.color.Hsl(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Hsl
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function darker(t : Float)
    return new Hsl([
      hue,
      saturation,
      t.interpolate(lightness, 0)
    ]);

  public function lighter(t : Float)
    return new Hsl([
      hue,
      saturation,
      t.interpolate(lightness, 1)
    ]);

  public function interpolate(other : Hsl, t : Float)
    return new Hsl([
      t.interpolateAngle(hue, other.hue, 360),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness)
    ]);

  public function interpolateWidest(other : Hsl, t : Float)
    return new Hsl([
      t.interpolateAngleWidest(hue, other.hue, 360),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness)
    ]);

  public function min(other : Hsl)
    return create(hue.min(other.hue), saturation.min(other.saturation), lightness.min(other.lightness));

  public function max(other : Hsl)
    return create(hue.max(other.hue), saturation.max(other.saturation), lightness.max(other.lightness));

  public function normalize()
    return create(hue.wrapCircular(360), saturation.normalize(), lightness.normalize());

  public function rotate(angle : Float)
    return withHue(hue + angle);

  public function roundTo(decimals : Int)
    return create(hue.roundTo(decimals), saturation.roundTo(decimals), lightness.roundTo(decimals));

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

  public function withAlpha(alpha : Float)
    return new Hsla(this.concat([alpha]));

  public function withHue(newhue : Float)
    return new Hsl([newhue, saturation, lightness]);

  public function withLightness(newlightness : Float)
    return new Hsl([hue, saturation, newlightness]);

  public function withSaturation(newsaturation : Float)
    return new Hsl([hue, newsaturation, lightness]);

  public function toCss3() : String
    return toString();
  @:to public function toString() : String
    return 'hsl(${hue},${(saturation*100)}%,${(lightness*100)}%)';

  @:op(A==B) public function equals(other : Hsl) : Bool
    return nearEquals(other);

  public function nearEquals(other : Hsl, ?tolerance = Floats.EPSILON) : Bool
    return hue.nearEqualAngles(other.hue, null, tolerance) && saturation.nearEquals(other.saturation, tolerance) && lightness.nearEquals(other.lightness, tolerance);

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

  @:to public function toLuv()
    return toRgbx().toLuv();

  @:to public function toCmy()
    return toRgbx().toCmy();

  @:to public function toCmyk()
    return toRgbx().toCmyk();

  @:to public function toCubeHelix()
    return toRgbx().toCubeHelix();

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx()
    return new Rgbx([
      _c(hue + 120, saturation, lightness),
      _c(hue, saturation, lightness),
      _c(hue - 120, saturation, lightness)
    ]);

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toHsla()
    return withAlpha(1.0);

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz()
    return toRgbx().toXyz();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toRgbx().toYxy();

  inline function get_hue() : Float
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
