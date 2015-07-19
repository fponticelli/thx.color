package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

/**
HSV (hue-saturation-value) is one of the most common cylindrical-coordinate
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
@:access(thx.color.Hsva)
abstract Hsv(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var value(get, never) : Float;

  inline public static function create(hue : Float, saturation : Float, value : Float)
    return new Hsv([hue, saturation, value]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Hsv.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsv':
        new thx.color.Hsv(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Hsv
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : Hsv, t : Float)
    return new Hsv([
      t.interpolateAngle(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value)
    ]);

  public function interpolateWidest(other : Hsv, t : Float)
    return new Hsv([
      t.interpolateAngleWidest(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value)
    ]);

  public function min(other : Hsv)
    return create(hue.min(other.hue), saturation.min(other.saturation), value.min(other.value));

  public function max(other : Hsv)
    return create(hue.max(other.hue), saturation.max(other.saturation), value.max(other.value));

  public function normalize()
    return create(hue.wrapCircular(360), saturation.normalize(), value.normalize());

  public function rotate(angle : Float)
    return withHue(hue + angle).normalize();

  public function roundTo(decimals : Int)
    return create(hue.roundTo(decimals), saturation.roundTo(decimals), value.roundTo(decimals));

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
    return new Hsva(this.concat([alpha]));

  public function withHue(newhue : Float)
    return new Hsv([newhue, saturation, value]);

  public function withValue(newvalue : Float)
    return new Hsv([hue, saturation, newvalue]);

  public function withSaturation(newsaturation : Float)
    return new Hsv([hue, newsaturation, value]);

  @:to public function toString() : String
    return 'hsv(${hue},${(saturation*100)}%,${(value*100)}%)';

  @:op(A==B) public function equals(other : Hsv) : Bool
    return nearEquals(other);

  public function nearEquals(other : Hsv, ?tolerance = Floats.EPSILON) : Bool
    return hue.nearEqualAngles(other.hue, null, tolerance) && saturation.nearEquals(other.saturation, tolerance) && value.nearEquals(other.value, tolerance);

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

  @:to public function toHsl()
    return toRgbx().toHsl();

  @:to public function toHsva()
    return withAlpha(1.0);

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx() {
    if(saturation == 0)
      return new Rgbx([value, value, value]);

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

    return new Rgbx([r, g, b]);
  }

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

  inline function get_hue() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_value() : Float
    return this[2];
}
