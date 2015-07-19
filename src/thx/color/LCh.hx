package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

/**
The CIELCh color space is a CIELab cube color space, whereby instead of
Cartesian coordinates a*, b*, the cylindrical coordinates C* (chroma,
relative saturation) and h° (hue angle, angle of the hue in the CIELab color
wheel) are specified. The CIELab - brightness L* remains unchanged.

The CIELCh color space is not the same as the HSV, HSL or HSB color spaces.
Although their values can also be interpreted as a base color, brightness and
saturation of a color tone, and are polar coordinate transformation of what is
technically defined RGB cube color space, CIELCh is still perceptually uniform.

For example, H and h are not identical, because HSL space use as primary colors,
the three additive primary colors red, green, blue (H = 0, 120, 240°), instead
the CIELCh system use four physiological elementary colors yellow, green, blue
and red (h = 90, 180, 270, 360°). h = 0 mean the achromatic colors to the gray
axis.

There are simplified spellings LCh, LCH and HLC common.
**/
@:access(thx.color.Lab)
abstract LCh(Array<Float>) {
  public var lightness(get, never) : Float;
  public var chroma(get, never) : Float;
  public var hue(get, never) : Float;

  inline public static function create(lightness : Float, chroma : Float, hue : Float)
    return new LCh([
      lightness,
      chroma,
      hue
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return LCh.create(arr[0], arr[1], arr[2]);
  }


  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielch', 'lch':
        new LCh(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'hcl':
        var c = ColorParser.getFloatChannels(info.channels, 3, false);
        LCh.create(c[2], c[1], c[0]);
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : LCh
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : LCh, t : Float)
    return new LCh([
      t.interpolate(lightness, other.lightness),
      t.interpolate(chroma, other.chroma),
      t.interpolateAngle(hue, other.hue, 360)
    ]);

  public function interpolateWidest(other : LCh, t : Float)
    return new LCh([
      t.interpolate(lightness, other.lightness),
      t.interpolate(chroma, other.chroma),
      t.interpolateAngleWidest(hue, other.hue, 360)
    ]);

  public function min(other : LCh)
    return create(lightness.min(other.lightness), chroma.min(other.chroma), hue.min(other.hue));

  public function max(other : LCh)
    return create(lightness.max(other.lightness), chroma.max(other.chroma), hue.max(other.hue));

  public function normalize()
    return create(lightness.clamp(0, 1), chroma.clamp(0, 1), hue.wrapCircular(360));

  public function rotate(angle : Float)
    return withHue(hue + angle).normalize();

  public function roundTo(decimals : Int)
    return create(lightness.roundTo(decimals), chroma.roundTo(decimals), hue.roundTo(decimals));

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

  public function withLightness(newlightness : Float)
    return new LCh([newlightness, chroma, hue]);

  public function withChroma(newchroma : Float)
    return new LCh([lightness, newchroma, hue]);

  public function withHue(newhue : Float)
    return new LCh([lightness, chroma, newhue]);

  @:op(A==B) public function equals(other : LCh) : Bool
    return nearEquals(other);

  public function nearEquals(other : LCh, ?tolerance = Floats.EPSILON) : Bool
    return lightness.nearEqualAngles(other.lightness, null, tolerance) && chroma.nearEquals(other.chroma, tolerance) && hue.nearEquals(other.hue, tolerance);

  @:to public function toString() : String
    return 'lch(${lightness},${chroma},${hue})';

  public function toHclString() : String
    return 'hcl(${hue},${chroma},${lightness})';

  @:to public function toLab() {
    var hradi = hue * (Math.PI / 180),
        a = Math.cos(hradi) * chroma,
        b = Math.sin(hradi) * chroma;
    return new Lab([lightness, a, b]);
  }

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

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx()
    return toLab().toRgbx();

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz()
    return toLab().toXyz();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toLab().toYxy();

  inline function get_lightness() : Float
    return this[0];
  inline function get_chroma() : Float
    return this[1];
  inline function get_hue() : Float
    return this[2];
}
