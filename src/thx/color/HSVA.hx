package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
using thx.core.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBXA)
@:access(thx.color.HSV)
abstract HSVA(Array<Float>) {
  public var hue(get, never) : Float;
  public var huef(get, never) : Float;
  public var saturation(get, never) : Float;
  public var value(get, never) : Float;
  public var alpha(get, never) : Float;

  public static function create(hue : Float, saturation : Float, value : Float, alpha : Float)
    return new HSVA([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      value.clamp(0, 1),
      alpha.clamp(0, 1)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return HSVA.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsv':
        new thx.color.HSV(ColorParser.getFloatChannels(info.channels, 3)).toHSVA();
      case 'hsva':
        new thx.color.HSVA(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : HSVA
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function transparent(t : Float)
    return new HSVA([
      hue,
      saturation,
      value,
      t.interpolate(alpha, 0)
    ]);

  public function opaque(t : Float)
    return new HSVA([
      hue,
      saturation,
      value,
      t.interpolate(alpha, 1)
    ]);

  public function interpolate(other : HSVA, t : Float)
    return new HSVA([
      t.interpolateAngle(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value),
      t.interpolate(alpha, other.alpha)
    ]);

  public function rotate(angle : Float)
    return HSVA.create(hue + angle, saturation, value, alpha);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  inline public function withAlpha(newalpha : Float)
    return new HSVA([hue, saturation, value, newalpha.normalize()]);

  inline public function withHue(newhue : Float)
    return new HSVA([newhue.normalize(), saturation, value, alpha]);

  inline public function withLightness(newvalue : Float)
    return new HSVA([hue, saturation, newvalue.normalize(), alpha]);

  inline public function withSaturation(newsaturation : Float)
    return new HSVA([hue, newsaturation.normalize(), value, alpha]);

  inline public function toString() : String
    return 'hsva($huef,${saturation*100}%,${value*100}%,$alpha)';

  @:op(A==B) public function equals(other : HSVA) : Bool
    return hue.nearEquals(other.hue) && saturation.nearEquals(other.saturation) && value.nearEquals(other.value) && alpha.nearEquals(other.alpha);

  @:to inline public function toHSV()
    return new HSV(this.slice(0, 3));

  @:to inline public function toHSLA()
    return toRGBXA().toHSLA();

  @:to inline public function toRGB()
    return toRGBXA().toRGB();

  @:to inline public function toRGBA()
    return toRGBXA().toRGBA();

  @:to inline public function toRGBXA() {
    if(saturation == 0)
      return new RGBXA([value, value, value, alpha]);

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

    return new RGBXA([r, g, b, alpha]);
  }

  inline function get_hue() : Float
    return this[0];
  inline function get_huef() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_value() : Float
    return this[2];
  inline function get_alpha() : Float
    return this[3];
}