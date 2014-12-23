package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.CIELAB)
abstract XYZ(Array<Float>) {
  public var x(get, never) : Float;
  public var y(get, never) : Float;
  public var z(get, never) : Float;

  @:from public static function fromString(color : String) : XYZ {
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

  inline public static function fromFloats(x : Float, y : Float, z : Float) : XYZ
    return new XYZ([x, y, z]);

  inline function new(channels : Array<Float>) : XYZ
    this = channels;

  @:to public function toCIELAB() : CIELAB {
    var x = x * 0.0105211106,
        y = y * 0.01,
        z = z * 0.00918417016,
        p;

    x = x > 0.008856 ? Math.pow(x, 1/3) : (7.787 * x) + 16/116;
    y = y > 0.008856 ? Math.pow(y, 1/3) : (7.787 * y) + 16/116;
    z = z > 0.008856 ? Math.pow(z, 1/3) : (7.787 * z) + 16/116;

    return new CIELAB(
      y > 0.008856 ?
      [(116 * y) - 16, 500 * (x - y), 200 * (y - z)] :
      [903.3 * y, 500 * (x - y), 200 * (y - z)]
    );
  }

  @:to inline public function toCIELCH() : CIELCH
    return toCIELAB().toCIELCH();

  @:to inline public function toCMYK() : CMYK
    return toRGBX().toCMYK();

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX {
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

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  inline public function toString() : String
    return 'XYZ($x,$y,$z)';

  @:op(A==B) public function equals(other : XYZ) : Bool
    return x == other.x && y == other.y && z == other.z;

  inline function get_x() : Float
    return this[0];
  inline function get_y() : Float
    return this[1];
  inline function get_z() : Float
    return this[2];
}