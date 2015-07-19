package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

/**
A colour scheme which is intended to be perceived as increasing in intensity.
Developed by D. A. Green (http://astron-soc.in/bulletin/11June/289392011.pdf).
**/
@:access(thx.color.Rgbx)
abstract CubeHelix(Array<Float>) {
  inline public static var A  = -0.14861;
  inline public static var B  =  1.78277;
  inline public static var C  = -0.29227;
  inline public static var D  = -0.90649;
  inline public static var E  =  1.97294;
  inline public static var ED = E * D;
  inline public static var EB = E * B;
  inline public static var BC_DA = B * C - D * A;

  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;
  public var gamma(get, never) : Float;

  inline public static function create(hue : Float, saturation : Float, lightness : Float, ?gamma : Float)
    return new CubeHelix([hue, saturation, lightness, null == gamma ? 1.0 : gamma]);

  @:from public static function fromFloats(arr : Array<Float>) {
    if(arr.length < 4) {
      arr.resize(3);
      arr.push(1);
    }
    return CubeHelix.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
    case 'cubehelix' if(info.channels.length >= 4):
        new thx.color.CubeHelix(ColorParser.getFloatChannels(info.channels, 4, false));
    case 'cubehelix':
        new thx.color.CubeHelix(ColorParser.getFloatChannels(info.channels, 3, false).concat([1.0]));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CubeHelix
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function darker(t : Float)
    return new CubeHelix([
      hue,
      saturation,
      t.interpolate(lightness, 0),
      gamma
    ]);

  public function lighter(t : Float)
    return new CubeHelix([
      hue,
      saturation,
      t.interpolate(lightness, 1),
      gamma
    ]);

  public function interpolate(other : CubeHelix, t : Float)
    return new CubeHelix([
      t.interpolateAngle(hue, other.hue, 360),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness),
      t.interpolate(gamma, other.gamma)
    ]);

  public function interpolateWidest(other : CubeHelix, t : Float)
    return new CubeHelix([
      t.interpolateAngleWidest(hue, other.hue, 360),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness),
      t.interpolate(gamma, other.gamma)
    ]);

  public function min(other : CubeHelix)
    return create(hue.min(other.hue), saturation.min(other.saturation), lightness.min(other.lightness), gamma.min(other.gamma));

  public function max(other : CubeHelix)
    return create(hue.max(other.hue), saturation.max(other.saturation), lightness.max(other.lightness), gamma.max(other.gamma));

  public function normalize()
    return create(hue.wrapCircular(360), saturation.normalize(), lightness.normalize(), gamma.normalize());

  public function rotate(angle : Float)
    return withHue(hue + angle);

  public function roundTo(decimals : Int)
    return create(hue.roundTo(decimals), saturation.roundTo(decimals), lightness.roundTo(decimals), gamma.roundTo(decimals));

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

  public function withGamma(newgamma : Float)
    return new CubeHelix([hue, saturation, lightness, newgamma]);

  public function withHue(newhue : Float)
    return new CubeHelix([newhue, saturation, lightness, gamma]);

  public function withLightness(newlightness : Float)
    return new CubeHelix([hue, saturation, newlightness, gamma]);

  public function withSaturation(newsaturation : Float)
    return new CubeHelix([hue, newsaturation, lightness, gamma]);

  public function toCss3() : String
    return toString();
  @:to public function toString() : String {
    if(gamma != 1)
      return 'cubehelix(${hue},${saturation},${lightness}, ${gamma})';
    else
      return 'cubehelix(${hue},${saturation},${lightness})';
  }

  @:op(A==B) public function equals(other : CubeHelix) : Bool
    return nearEquals(other);

  public function nearEquals(other : CubeHelix, ?tolerance = Floats.EPSILON) : Bool {
    return hue.nearEqualAngles(other.hue, null, tolerance) && saturation.nearEquals(other.saturation, tolerance) && lightness.nearEquals(other.lightness, tolerance) && gamma.nearEquals(other.gamma, tolerance);
  }

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

  @:to public function toRgbx() {
    var h = Math.isNaN(hue) ? 0 : (hue + 120) / 180 * Math.PI,
        l = Math.pow(lightness, gamma),
        a = Math.isNaN(saturation) ? 0 : saturation * l * (1 - l),
        cosh = Math.cos(h),
        sinh = Math.sin(h);
    return new Rgbx([
      l + a * (A * cosh + B * sinh),
      l + a * (C * cosh + D * sinh),
      l + a * (E * cosh)
    ]);
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
  inline function get_lightness() : Float
    return this[2];
  inline function get_gamma() : Float
    return this[3];
}
