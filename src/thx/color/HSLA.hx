package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
using thx.core.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBXA)
@:access(thx.color.HSL)
abstract HSLA(Array<Float>) {
  public var hue(get, never) : Float;
  public var huef(get, never) : Float;
  public var saturation(get, never) : Float;
  public var lightness(get, never) : Float;
  public var alpha(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float, alpha : Float)
    return new HSLA([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1),
      alpha.clamp(0, 1)
    ]);

  @:from  public static function fromFloats(arr : Array<Float>) : HSLA {
    arr.resize(4);
    return HSLA.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) : HSLA {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsl':
        new thx.color.HSL(ColorParser.getFloatChannels(info.channels, 3)).toHSLA();
      case 'hsla':
        new thx.color.HSLA(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : HSLA
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function darker(t : Float) : HSLA
    return new HSLA([
      hue,
      saturation,
      t.interpolate(lightness, 0),
      alpha
    ]);

  public function lighter(t : Float) : HSLA
    return new HSLA([
      hue,
      saturation,
      t.interpolate(lightness, 1),
      alpha
    ]);

  public function transparent(t : Float) : HSLA
    return new HSLA([
      hue,
      saturation,
      lightness,
      t.interpolate(alpha, 0)
    ]);

  public function opaque(t : Float) : HSLA
    return new HSLA([
      hue,
      saturation,
      lightness,
      t.interpolate(alpha, 1)
    ]);

  public function interpolate(other : HSLA, t : Float) : HSLA
    return new HSLA([
      // TODO circular interpolation
      t.interpolate(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(lightness, other.lightness),
      t.interpolate(alpha, other.alpha)
    ]);

  public function rotate(angle : Float)
    return HSLA.create(hue + angle, saturation, lightness, alpha);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  inline public function toCSS3() : String
    return toString();

  inline public function toString() : String
    return 'hsla(${huef},${saturation*100}%,${lightness*100}%,$alpha)';

  @:op(A==B) public function equals(other : HSLA) : Bool
    return hue == other.hue && saturation == other.saturation && lightness == other.lightness && alpha == other.alpha;

  @:to inline public function toHSL() : HSL
    return new HSL(this.slice(0, 3));

  @:to inline public function toHSVA() : HSVA
    return toRGBXA().toHSVA();

  @:to inline public function toRGB() : RGB
    return toRGBXA().toRGB();

  @:to inline public function toRGBXA() : RGBXA
    return new RGBXA([
      _c(hue + 120, saturation, lightness),
      _c(hue, saturation, lightness),
      _c(hue - 120, saturation, lightness),
      alpha
    ]);

  inline function get_hue() : Float
    return this[0];
  inline function get_huef() : Float
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