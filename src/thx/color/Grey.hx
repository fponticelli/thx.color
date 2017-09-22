package thx.color;

using thx.Floats;
import thx.color.parse.ColorParser;

/**
A gray scale color space that ranges from white to black.
**/
@:access(thx.color.Rgbx)
abstract Grey(Float) from Float to Float {
  public static var black(default, null): Grey = new Grey(0);
  public static var white(default, null): Grey = new Grey(1);

  @:from inline public static function create(v: Float)
    return new Grey(v);

  @:from public static function fromString(color: String): Null<Grey> {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'grey', 'gray':
        new thx.color.Grey(ColorParser.getFloatChannels(info.channels, 1, [NaturalMode])[0]);
      case _:
        null;
    } catch(e: Dynamic) null;
  }

  public var grey(get, never): Float;
  inline public function new(grey: Float): Grey
    this = grey;

  public function contrast()
    return this > 0.5 ? black: white;

  public function darker(t: Float)
    return new Grey(t.interpolate(grey, 0));

  public function lighter(t: Float)
    return new Grey(t.interpolate(grey, 1));

  public function interpolate(other: Grey, t: Float)
    return new Grey(t.interpolate(grey, other.grey));

  public function min(other: Grey)
    return create(grey.min(other.grey));

  public function max(other: Grey)
    return create(grey.max(other.grey));

  public function normalize()
    return create(this.normalize());

  public function roundTo(decimals: Int)
    return create(grey.roundTo(decimals));

  @:to public function toString(): String
    return 'grey(${(grey*100)}%)';

  @:op(A==B) public function equals(other: Grey): Bool
    return nearEquals(other);

  public function nearEquals(other: Grey, ?tolerance = Floats.EPSILON): Bool
    return this.nearEquals(other.grey, tolerance);

  inline function get_grey(): Float
    return this;

  @:to public function toLab(): Lab
    return toXyz().toLab();

  @:to public function toLCh(): LCh
    return toLab().toLCh();

  @:to public function toLuv(): Luv
    return toRgbx().toLuv();

  @:to public function toCmy(): Cmy
    return toRgbx().toCmy();

  @:to public function toCmyk(): Cmyk
    return toRgbx().toCmyk();

  @:to public function toCubeHelix(): CubeHelix
    return toRgbx().toCubeHelix();

  @:to public function toHsl(): Hsl
    return toRgbx().toHsl();

  @:to public function toHsv(): Hsv
    return toRgbx().toHsv();

  @:to public function toHunterLab(): HunterLab
    return toXyz().toHunterLab();

  @:to public function toRgb(): Rgb
    return toRgbx().toRgb();

  @:to public function toRgba(): Rgba
    return toRgbxa().toRgba();

  @:to public function toArgb(): Argb
    return toRgbxa().toArgb();

  @:to public function toRgbx(): Rgbx
    return new Rgbx([grey, grey, grey]);

  @:to public function toRgbxa(): Rgbxa
    return toRgbx().toRgbxa();

  @:to public function toTemperature(): Temperature
    return toRgbx().toTemperature();

  @:to public function toYuv(): Yuv
    return toRgbx().toYuv();

  @:to public function toXyz(): Xyz
    return toRgbx().toXyz();

  @:to public function toYxy(): Yxy
    return toRgbx().toYxy();
}
