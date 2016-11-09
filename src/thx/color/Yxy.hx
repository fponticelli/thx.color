package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.Xyz)
abstract Yxy(Array<Float>) {
  public var y1(get, never): Float;
  public var x(get, never): Float;
  public var y2(get, never): Float;

  inline public static function create(y1: Float, x: Float, y2: Float)
    return new Yxy([y1, x, y2]);

  @:from public static function fromFloats(arr: Array<Float>) {
    arr = arr.resized(3);
    return Yxy.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color: String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'yxy':
        new thx.color.Yxy(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e: Dynamic) null;
  }

  inline function new(channels: Array<Float>): Yxy
    this = channels;

  public function interpolate(other: Yxy, t: Float)
    return new Yxy([
      t.interpolate(y1, other.y1),
      t.interpolate(x,  other.x),
      t.interpolate(y2, other.y2)
    ]);

  public function min(other: Yxy)
    return create(y1.min(other.y1), x.min(other.x), y2.min(other.y2));

  public function max(other: Yxy)
    return create(y1.max(other.y1), x.max(other.x), y2.max(other.y2));

  public function roundTo(decimals: Int)
    return create(y1.roundTo(decimals), x.roundTo(decimals), y2.roundTo(decimals));

  public function withY1(newy1: Float)
    return new Yxy([newy1, x, y2]);

  public function withY(newx: Float)
    return new Yxy([y1, newx, y2]);

  public function withZ(newy2: Float)
    return new Yxy([y1, x, newy2]);

  @:to public function toString(): String
    return 'yxy(${y1},${x},${y2})';

  @:op(A==B) public function equals(other: Yxy): Bool
    return nearEquals(other);

  public function nearEquals(other: Yxy, ?tolerance = Floats.EPSILON): Bool
    return y1.nearEquals(other.y1, tolerance) && x.nearEquals(other.x, tolerance) && y2.nearEquals(other.y2, tolerance);

  @:to public function toLab(): Lab
    return toXyz().toLab();

  @:to public function toLCh(): LCh
    return toLab().toLCh();

  @:to public function toLuv(): Luv
    return toRgbx().toLuv();

  @:to public function toCmy(): Cmy
    return toXyz().toCmy();

  @:to public function toCmyk(): Cmyk
    return toXyz().toCmyk();

  @:to public function toCubeHelix(): CubeHelix
    return toXyz().toCubeHelix();

  @:to public function toGrey(): Grey
    return toXyz().toGrey();

  @:to public function toHsl(): Hsl
    return toRgbx().toHsl();

  @:to public function toHsv(): Hsv
    return toXyz().toHsv();

  @:to public function toHunterLab(): HunterLab
    return toXyz().toHunterLab();

  @:to public function toRgb(): Rgb
    return toXyz().toRgb();

  @:to public function toRgba(): Rgba
    return toRgbxa().toRgba();

  @:to public function toArgb(): Argb
    return toRgbxa().toArgb();

  @:to public function toRgbx(): Rgbx
    return toXyz().toRgbx();

  @:to public function toRgbxa(): Rgbxa
    return toXyz().toRgbxa();

  @:to public function toTemperature(): Temperature
    return toRgbx().toTemperature();

  @:to public function toYuv(): Yuv
    return toRgbx().toYuv();
  @:to public function toXyz(): Xyz
    return new Xyz([
      x * (y1 / y2),
      y1,
      (1 - x - y2) * (y1 / y2)
    ]);

  inline function get_y1(): Float
    return this[0];
  inline function get_x(): Float
    return this[1];
  inline function get_y2(): Float
    return this[2];
}
