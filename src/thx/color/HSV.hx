package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.HSVA)
abstract HSV(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var value(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float)
    return new HSV([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return HSV.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsv':
        new thx.color.HSV(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : HSV
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : HSV, t : Float)
    return new HSV([
      t.interpolateAngle(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value)
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
    return new HSVA(this.concat([alpha.normalize()]));

  public function withHue(newhue : Float)
    return new HSV([newhue.wrapCircular(360), saturation, value]);

  public function withValue(newvalue : Float)
    return new HSV([hue, saturation, newvalue.normalize()]);

  public function withSaturation(newsaturation : Float)
    return new HSV([hue, newsaturation.normalize(), value]);

  public function toString() : String
    return 'hsv(${hue.roundTo(6)},${(saturation*100).roundTo(6)}%,${(value*100).roundTo(6)}%)';

  @:op(A==B) public function equals(other : HSV) : Bool
    return hue.nearEquals(other.hue) && saturation.nearEquals(other.saturation) && value.nearEquals(other.value);

  @:to public function toCIELab()
    return toRGBX().toCIELab();

  @:to public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to public function toCMY()
    return toRGBX().toCMY();

  @:to public function toCMYK()
    return toRGBX().toCMYK();

  @:to public function toGrey()
    return toRGBX().toGrey();

  @:to public function toHSL()
    return toRGBX().toHSL();

  @:to public function toHSVA()
    return withAlpha(1.0);

  @:to public function toRGB()
    return toRGBX().toRGB();

  @:to public function toRGBA()
    return toRGBXA().toRGBA();

  @:to public function toRGBX() {
    if(saturation == 0)
      return new RGBX([value, value, value]);

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

    return new RGBX([r, g, b]);
  }

  @:to public function toRGBXA()
    return toRGBX().toRGBXA();

  @:to public function toXYZ()
    return toRGBX().toXYZ();

  @:to public function toYxy()
    return toRGBX().toYxy();

  inline function get_hue() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_value() : Float
    return this[2];
}