package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

/**
A version of `Hsl` with support for an additional `alpha` channel.
**/
@:access(thx.color.Rgbxa)
@:access(thx.color.Hsl)
abstract Hsla(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;
  public var alpha(get, never) : Float;

  inline public static function create(hue : Float, saturation : Float, lightness : Float, alpha : Float)
    return new Hsla([hue, saturation, lightness, alpha]);

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
        new thx.color.Hsl(ColorParser.getFloatChannels(info.channels, 3, false)).toHsla();
      case 'hsla':
        new thx.color.Hsla(ColorParser.getFloatChannels(info.channels, 4, false));
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

  public function normalize()
    return create(hue.wrapCircular(360), saturation.normalize(), lightness.normalize(), alpha.normalize());

  public function roundTo(decimals : Int)
    return create(hue.roundTo(decimals), saturation.roundTo(decimals), lightness.roundTo(decimals), alpha.roundTo(decimals));

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
    return new Hsla([hue + angle, saturation, lightness, alpha]);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function withAlpha(newalpha : Float)
    return new Hsla([hue, saturation, lightness, newalpha]);

  public function withHue(newhue : Float)
    return new Hsla([newhue, saturation, lightness, alpha]);

  public function withLightness(newlightness : Float)
    return new Hsla([hue, saturation, newlightness, alpha]);

  public function withSaturation(newsaturation : Float)
    return new Hsla([hue, newsaturation, lightness, alpha]);

  public function toCss3() : String
    return toString();

  public function toString() : String
    return 'hsla(${hue},${(saturation*100)}%,${(lightness*100)}%,${alpha})';

  @:op(A==B) public function equals(other : Hsla) : Bool
    return nearEquals(other);

  public function nearEquals(other : Hsla, ?tolerance = Floats.EPSILON) : Bool
    return hue.nearEqualAngles(other.hue, null, tolerance) && saturation.nearEquals(other.saturation, tolerance) && lightness.nearEquals(other.lightness, tolerance) && alpha.nearEquals(other.alpha, tolerance);

  @:to public function toHsl()
    return new Hsl(this.slice(0, 3));

  @:to public function toHsva()
    return toRgbxa().toHsva();

  @:to public function toRgb()
    return toRgbxa().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:access(thx.color.Hsl._c)
  @:to public function toRgbxa()
    return new Rgbxa([
      Hsl._c(hue + 120, saturation, lightness),
      Hsl._c(hue, saturation, lightness),
      Hsl._c(hue - 120, saturation, lightness),
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
}
