package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.CieLab)
abstract CieLCh(Array<Float>) {
  public var lightness(get, never) : Float;
  public var chroma(get, never) : Float;
  public var hue(get, never) : Float;

  inline public static function create(lightness : Float, chroma : Float, hue : Float)
    return new CieLCh([
      lightness,
      chroma,
      hue
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return CieLCh.create(arr[0], arr[1], arr[2]);
  }


  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielch', 'lch':
        CieLCh.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CieLCh
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : CieLCh, t : Float)
    return new CieLCh([
      t.interpolate(lightness, other.lightness),
      t.interpolate(chroma, other.chroma),
      t.interpolateAngle(hue, other.hue, 360)
    ]);

  public function min(other : CieLCh)
    return create(lightness.min(other.lightness), chroma.min(other.chroma), hue.min(other.hue));

  public function max(other : CieLCh)
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
    return new CieLCh([newlightness, chroma, hue]);

  public function withChroma(newchroma : Float)
    return new CieLCh([lightness, newchroma, hue]);

  public function withHue(newhue : Float)
    return new CieLCh([lightness, chroma, newhue]);

  @:op(A==B) public function equals(other : CieLCh) : Bool
    return nearEquals(other);

  public function nearEquals(other : CieLCh, ?tolerance = Floats.EPSILON) : Bool
    return lightness.nearEqualAngles(other.lightness, null, tolerance) && chroma.nearEquals(other.chroma, tolerance) && hue.nearEquals(other.hue, tolerance);

  @:to public function toString() : String
    return 'cielch(${lightness},${chroma},${hue})';

  @:to public function toCieLab() {
    var hradi = hue * (Math.PI / 180),
        a = Math.cos(hradi) * chroma,
        b = Math.sin(hradi) * chroma;
    return new CieLab([lightness, a, b]);
  }

  @:to public function toCieLuv()
    return toRgbx().toCieLuv();

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
    return toCieLab().toRgbx();

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz()
    return toCieLab().toXyz();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toCieLab().toYxy();

  inline function get_lightness() : Float
    return this[0];
  inline function get_chroma() : Float
    return this[1];
  inline function get_hue() : Float
    return this[2];
}
