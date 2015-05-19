package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbx)
@:access(thx.color.Hsla)
abstract Hsl(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float)
    return new Hsl([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1)
    ]);

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
        new thx.color.Hsl(ColorParser.getFloatChannels(info.channels, 3));
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

  public function withAlpha(alpha : Float)
    return new Hsla(this.concat([alpha.normalize()]));

  public function withHue(newhue : Float)
    return new Hsl([newhue.wrapCircular(360), saturation, lightness]);

  public function withLightness(newlightness : Float)
    return new Hsl([hue, saturation, newlightness.normalize()]);

  public function withSaturation(newsaturation : Float)
    return new Hsl([hue, newsaturation.normalize(), lightness]);

  public function toCss3() : String
    return toString();
  public function toString() : String
    return 'hsl(${hue.roundTo(6)},${(saturation*100).roundTo(6)}%,${(lightness*100).roundTo(6)}%)';

  @:op(A==B) public function equals(other : Hsl) : Bool
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