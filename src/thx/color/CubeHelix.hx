package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbx)
abstract CubeHelix(Array<Float>) {
  public static var gamma : Float = 1;

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

  inline public static function create(hue : Float, saturation : Float, lightness : Float)
    return new CubeHelix([hue, saturation, lightness]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return CubeHelix.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cubehelix':
        new thx.color.CubeHelix(ColorParser.getFloatChannels(info.channels, 3));
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
      t.interpolate(lightness, 0)
    ]);

  public function lighter(t : Float)
    return new CubeHelix([
      hue,
      saturation,
      t.interpolate(lightness, 1)
    ]);

  public function interpolate(other : CubeHelix, t : Float)
    return new CubeHelix([
      t.interpolateAngle(hue, other.hue, 360),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness)
    ]);

  public function normalize()
    return create(
      hue.wrapCircular(360),
      saturation.normalize(),
      lightness.normalize()
    );

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

  public function withHue(newhue : Float)
    return new CubeHelix([newhue.wrapCircular(360), saturation, lightness]);

  public function withLightness(newlightness : Float)
    return new CubeHelix([hue, saturation, newlightness.normalize()]);

  public function withSaturation(newsaturation : Float)
    return new CubeHelix([hue, newsaturation.normalize(), lightness]);

  public function toCss3() : String
    return toString();
  public function toString() : String
    return 'cubehelix(${hue.roundTo(6)},${(saturation*100).roundTo(6)}%,${(lightness*100).roundTo(6)}%)';

  @:op(A==B) public function equals(other : CubeHelix) : Bool
    return hue.nearEquals(other.hue) && saturation.nearEquals(other.saturation) && lightness.nearEquals(other.lightness);

  @:to public function toCieLab()
    return toRgbx().toCieLab();

  @:to public function toCieLCh()
    return toRgbx().toCieLCh();

  @:to public function toCmy()
    return toRgbx().toCmy();

  @:to public function toCmyk()
    return toRgbx().toCmyk();

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHcl()
    return toCieLab().toHcl();

  @:to public function toHsv()
    return toRgbx().toHsv();

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
    return Rgbx.create(
      l + a * (A * cosh + B * sinh),
      l + a * (C * cosh + D * sinh),
      l + a * (E * cosh)
    );
  }

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toXyz()
    return toRgbx().toXyz();

  @:to public function toYxy()
    return toRgbx().toYxy();

  inline function get_hue() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_lightness() : Float
    return this[2];
}
