package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbxa)
@:access(thx.color.Hsl)
abstract Hsla(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;
  public var alpha(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float, alpha : Float)
    return new Hsla([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1),
      alpha.clamp(0, 1)
    ]);

  @:from  public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return Hsla.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsl':
        new thx.color.Hsl(ColorParser.getFloatChannels(info.channels, 3)).toHsla();
      case 'hsla':
        new thx.color.Hsla(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Hsla
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function darker(t : Float)
    return new Hsla([
      hue,
      saturation,
      t.interpolate(lightness, 0),
      alpha
    ]);

  public function lighter(t : Float)
    return new Hsla([
      hue,
      saturation,
      t.interpolate(lightness, 1),
      alpha
    ]);

  public function transparent(t : Float)
    return new Hsla([
      hue,
      saturation,
      lightness,
      t.interpolate(alpha, 0)
    ]);

  public function opaque(t : Float)
    return new Hsla([
      hue,
      saturation,
      lightness,
      t.interpolate(alpha, 1)
    ]);

  public function interpolate(other : Hsla, t : Float)
    return new Hsla([
      t.interpolateAngle(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness),
      t.interpolate(alpha, other.alpha)
    ]);

  public function rotate(angle : Float)
    return Hsla.create(hue + angle, saturation, lightness, alpha);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function withAlpha(newalpha : Float)
    return new Hsla([hue, saturation, lightness, newalpha.normalize()]);

  public function withHue(newhue : Float)
    return new Hsla([newhue.wrapCircular(360), saturation, lightness, alpha]);

  public function withLightness(newlightness : Float)
    return new Hsla([hue, saturation, newlightness.normalize(), alpha]);

  public function withSaturation(newsaturation : Float)
    return new Hsla([hue, newsaturation.normalize(), lightness, alpha]);

  public function toCss3() : String
    return toString();

  public function toString() : String
    return 'hsla(${hue.roundTo(6)},${(saturation*100).roundTo(6)}%,${(lightness*100).roundTo(6)}%,${alpha.roundTo(6)})';

  @:op(A==B) public function equals(other : Hsla) : Bool
    return hue.nearEquals(other.hue) && saturation.nearEquals(other.saturation) && lightness.nearEquals(other.lightness) && alpha.nearEquals(other.alpha);

  @:to public function toHsl()
    return new Hsl(this.slice(0, 3));

  @:to public function toHsva()
    return toRgbxa().toHsva();

  @:to public function toRgb()
    return toRgbxa().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbxa()
    return new Rgbxa([
      _c(hue + 120, saturation, lightness),
      _c(hue, saturation, lightness),
      _c(hue - 120, saturation, lightness),
      alpha
    ]);

  inline function get_hue() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_lightness() : Float
    return this[2];
  inline function get_alpha() : Float
    return this[3];

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
