package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbx)
@:access(thx.color.CieLab)
@:access(thx.color.Yxy)
abstract Xyz(Array<Float>) {
  public var x(get, never) : Float;
  public var y(get, never) : Float;
  public var z(get, never) : Float;

  inline public static function create(x : Float, y : Float, z : Float)
    return new Xyz([x, y, z]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'ciexyz', 'xyz':
        new thx.color.Xyz(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Xyz
    this = channels;

  public function interpolate(other : Xyz, t : Float)
    return new Xyz([
      t.interpolate(x, other.x),
      t.interpolate(y, other.y),
      t.interpolate(z, other.z),
    ]);

  public function min(other : Xyz)
    return create(x.min(other.x), y.min(other.y), z.min(other.z));

  public function max(other : Xyz)
    return create(x.max(other.x), y.max(other.y), z.max(other.z));

  public function roundTo(decimals : Int)
    return create(x.roundTo(decimals), y.roundTo(decimals), z.roundTo(decimals));

  public function withX(newx : Float)
    return new Xyz([newx, y, z]);

  public function withY(newy : Float)
    return new Xyz([x, newy, z]);

  public function withZ(newz : Float)
    return new Xyz([x, y, newz]);

  @:to public function toString() : String
    return 'xyz(${x},${y},${z})';

  @:op(A==B) public function equals(other : Xyz) : Bool
    return nearEquals(other);

  public function nearEquals(other : Xyz, ?tolerance = Floats.EPSILON) : Bool
    return x.nearEquals(other.x, tolerance) && y.nearEquals(other.y, tolerance) && z.nearEquals(other.z, tolerance);

  @:to public function toCieLab() : CieLab {
    var x = x * 0.0105211106,
        y = y * 0.01,
        z = z * 0.00918417016,
        p;

    x = x > 0.008856 ? Math.pow(x, 1/3) : (7.787 * x) + 16/116;
    y = y > 0.008856 ? Math.pow(y, 1/3) : (7.787 * y) + 16/116;
    z = z > 0.008856 ? Math.pow(z, 1/3) : (7.787 * z) + 16/116;

    return new CieLab(
      y > 0.008856 ?
      [(116 * y) - 16, 500 * (x - y), 200 * (y - z)] :
      [903.3 * y, 500 * (x - y), 200 * (y - z)]
    );
  }

  @:to public function toCieLCh()
    return toCieLab().toCieLCh();

  @:to public function toCmy()
    return toRgbx().toCmy();

  @:to public function toCmyk()
    return toRgbx().toCmyk();

  @:to public function toCubeHelix()
    return toRgbx().toCubeHelix();

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHcl()
    return toCieLab().toHcl();

  @:to public function toHsl()
    return toRgbx().toHsl();

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx() {
    var x = x,
        y = y,
        z = z,
        r = x *  3.2406 + y * -1.5372 + z * -0.4986,
        g = x * -0.9689 + y *  1.8758 + z *  0.0415,
        b = x *  0.0557 + y * -0.2040 + z *  1.0570;

    r = r > 0.0031308 ? 1.055 * Math.pow(r, 1.0 / 2.4) - 0.055 : 12.92 * r;
    g = g > 0.0031308 ? 1.055 * Math.pow(g, 1.0 / 2.4) - 0.055 : 12.92 * g;
    b = b > 0.0031308 ? 1.055 * Math.pow(b, 1.0 / 2.4) - 0.055 : 12.92 * b;

    return new Rgbx([r,g,b]);
  }

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy() {
    var sum = x + y + z;
    return new Yxy([
      y,
      sum == 0 ? 1 : x / sum,
      sum == 0 ? 1 : y / sum
    ]);
  }

  inline function get_x() : Float
    return this[0];
  inline function get_y() : Float
    return this[1];
  inline function get_z() : Float
    return this[2];
}
