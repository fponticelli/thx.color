package thx.color;

using thx.Floats;
import thx.color.parse.ColorParser;

/**
The color temperature of a light source is the temperature of an ideal
black-body radiator that radiates light of comparable hue to that of the light
source. Color temperature is a characteristic of visible light that has
important applications in lighting, photography, videography, publishing,
manufacturing, astrophysics, horticulture, and other fields. In practice, color
temperature is only meaningful for light sources that do in fact correspond
somewhat closely to the radiation of some black body, i.e., those on a line from
reddish/orange via yellow and more or less white to blueish white; it does not
make sense to speak of the color temperature of, e.g., a green or a purple
light. Color temperature is conventionally stated in the unit of absolute
temperature, the Kelvin, having the unit symbol K.

Color temperatures over 5,000K are called cool colors (bluish white), while
lower color temperatures (2,700–3,000 K) are called warm colors (yellowish white
through red). This relation, however, is a psychological one in contrast to the
physical relation implied by Wien's displacement law, according to which the
spectral peak is shifted towards shorter wavelengths (resulting in a more
blueish white) for higher temperatures.
**/
@:access(thx.color.Rgbx)
abstract Temperature(Float) from Float to Float {
  public static function temperatureToRgbx(kelvin : Float) {
    var t = kelvin / 100.0;
    var r : Float, g : Float, b : Float;

    // red
    if(t < 66.0) {
      r = 1;
    } else {
      r = t - 55.0;
      r = (351.97690566805693+ 0.114206453784165 * r - 40.25366309332127 * Math.log(r)) / 255;
      if(r < 0) r = 0;
      if(r > 1) r = 1;
    }

    // green
    if(t < 66.0) {
      g = t - 2;
      g = (-155.25485562709179 - 0.44596950469579133 * g + 104.49216199393888 * Math.log(g)) / 255;
      if(g < 0) g = 0;
      if(g > 1) g = 1;
    } else {
      g = t - 50;
      g = (325.4494125711974 + 0.07943456536662342 * g - 28.0852963507957 * Math.log(g)) / 255;
      if(g < 0) g = 0;
      if(g > 1) g = 1;
    }

    // blue
    if(t >= 66.0) {
      b = 1;
    } else  if(t <= 20.0) {
      b = 0;
    } else {
      b = t - 10;
      b = (-254.76935184120902 + 0.8274096064007395 * b + 115.67994401066147 * Math.log(b)) / 255;
      if(b < 0) b = 0;
      if(b > 1) b = 1;
    }

    return new Rgbx([r, g, b]);
  }

  @:from inline public static function create(v : Float)
    return new Temperature(v);

  @:from public static function fromString(color : String) : Null<Temperature> {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
    case 'temperature':
        new thx.color.Temperature(ColorParser.getFloatChannels(info.channels, 1, false)[0]);
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  public var kelvin(get, never) : Float;
  inline public function new(kelvin : Float) : Temperature
    this = kelvin;

  public function interpolate(other : Temperature, t : Float)
    return new Temperature(t.interpolate(kelvin, other.kelvin));

  public function min(other : Temperature)
    return create(kelvin.min(other.kelvin));

  public function max(other : Temperature)
    return create(kelvin.max(other.kelvin));

  public function roundTo(decimals : Int)
    return create(kelvin.roundTo(decimals));

  @:to public function toString() : String
    return 'temperature(${kelvin})';

  @:op(A==B) public function equals(other : Temperature) : Bool
    return nearEquals(other);

  public function nearEquals(other : Temperature, ?tolerance = Floats.EPSILON) : Bool
    return this.nearEquals(other.kelvin, tolerance);

  inline function get_kelvin() : Float
    return this;

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

  public function toRgbxTannerHelland() {
    var t = kelvin / 100,
        r : Float, g : Float, b : Float;

    // red
    if(t <= 66) {
      r = 1;
    } else {
      r = t - 60;
      r = 329.698727446 * Math.pow(r, -0.1332047592) / 1;
      if(r < 0) r = 0;
      if(r > 1) r = 1;
    }

    // green
    if(t <= 66.0) {
      g = t;
      g = (99.4708025861 * Math.log(g) - 161.1195681661) / 1;
      if(g < 0) g = 0;
      if(g > 1) g = 1;
    } else {
      g = t - 60.0;
      g = 288.1221695283 * Math.pow(g, -0.0755148492) / 1;
      if(g < 0) g = 0;
      if(g > 1) g = 1;
    }

    // blue
    if(t >= 66.0) {
      b = 1;
    } else if(t <= 19.0) {
      b = 0;
    } else {
      b = t - 10;
      b = (138.5177312231 * Math.log(b) - 305.0447927307) / 1;
      if(b < 0) b = 0;
      if(b > 1) b = 1;
    }
    return new Rgbx([r, g, b]);
  }

  @:to public function toRgbx()
    return Temperature.temperatureToRgbx(this);

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toXyz()
    return toRgbx().toXyz();

  @:to public function toYxy()
    return toRgbx().toYxy();
}
