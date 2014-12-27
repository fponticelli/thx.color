package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.CIELab)
@:access(thx.color.Yxy)
abstract XYZ(Array<Float>) {
  public var x(get, never) : Float;
  public var y(get, never) : Float;
  public var z(get, never) : Float;

  public static function create(x : Float, y : Float, z : Float)
    return new XYZ([x, y, z]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return XYZ.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'ciexyz', 'xyz':
        new thx.color.XYZ(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }


  inline function new(channels : Array<Float>) : XYZ
    this = channels;

  public function interpolate(other : XYZ, t : Float)
    return new XYZ([
      t.interpolate(x, other.x),
      t.interpolate(y, other.y),
      t.interpolate(z, other.z),
    ]);

  public function withX(newx : Float)
    return new XYZ([newx, y, z]);

  public function withY(newy : Float)
    return new XYZ([x, newy, z]);

  public function withZ(newz : Float)
    return new XYZ([x, y, newz]);

  inline public function toString() : String
    return 'XYZ($x,$y,$z)';

  @:op(A==B) public function equals(other : XYZ) : Bool
    return x == other.x && y == other.y && z == other.z;

  @:to public function toCIELab() : CIELab {
    var x = x * 0.0105211106,
        y = y * 0.01,
        z = z * 0.00918417016,
        p;

    x = x > 0.008856 ? Math.pow(x, 1/3) : (7.787 * x) + 16/116;
    y = y > 0.008856 ? Math.pow(y, 1/3) : (7.787 * y) + 16/116;
    z = z > 0.008856 ? Math.pow(z, 1/3) : (7.787 * z) + 16/116;

    return new CIELab(
      y > 0.008856 ?
      [(116 * y) - 16, 500 * (x - y), 200 * (y - z)] :
      [903.3 * y, 500 * (x - y), 200 * (y - z)]
    );
  }

  @:to inline public function toCIELCh()
    return toCIELab().toCIELCh();

  @:to inline public function toCMY()
    return toRGBX().toCMY();

  @:to inline public function toCMYK()
    return toRGBX().toCMYK();

  @:to inline public function toGrey()
    return toRGBX().toGrey();

  @:to inline public function toHSL()
    return toRGBX().toHSL();

  @:to inline public function toHSV()
    return toRGBX().toHSV();

  @:to inline public function toRGB()
    return toRGBX().toRGB();

  @:to public function toRGBX() {
    var x = x / 100,
        y = y / 100,
        z = z / 100,
        r = x *  3.2406 + y * -1.5372 + z * -0.4986,
        g = x * -0.9689 + y *  1.8758 + z *  0.0415,
        b = x *  0.0557 + y * -0.2040 + z *  1.0570;

    r = r > 0.0031308 ? 1.055 * Math.pow(r,(1/2.4)) - 0.055 : 12.92 * r;
    g = g > 0.0031308 ? 1.055 * Math.pow(g,(1/2.4)) - 0.055 : 12.92 * g;
    b = b > 0.0031308 ? 1.055 * Math.pow(b,(1/2.4)) - 0.055 : 12.92 * b;

    return new RGBX([r,g,b]);
  }

  @:to inline public function toRGBXA()
    return toRGBX().toRGBXA();

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