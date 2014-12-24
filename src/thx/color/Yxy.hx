package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.CIELab)
@:access(thx.color.XYZ)
abstract Yxy(Array<Float>) {
  public var y1(get, never) : Float;
  public var x(get, never) : Float;
  public var y2(get, never) : Float;

  @:from public static function fromString(color : String) : Yxy {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'yxy':
        new thx.color.Yxy(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline public static function fromFloats(y1 : Float, x : Float, y2 : Float) : Yxy
    return new Yxy([y1, x, y2]);

  inline function new(channels : Array<Float>) : Yxy
    this = channels;

  @:to inline public function toCIELab() : CIELab
    return toXYZ().toCIELab();

  @:to inline public function toCIELCh() : CIELCh
    return toCIELab().toCIELCh();

  @:to inline public function toCMYK() : CMYK
    return toRGBX().toCMYK();

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX
    return toXYZ().toRGBX();

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to public function toXYZ() : XYZ
    return new XYZ([
      x * (y1 / y2),
      y1,
      (1 - x - y2) * (y1 / y2)
    ]);

  inline public function toString() : String
    return 'Yxy($y1,$x,$y2)';

  @:op(A==B) public function equals(other : Yxy) : Bool
    return y1 == other.y1 && x == other.x && y2 == other.y2;

  inline function get_y1() : Float
    return this[0];
  inline function get_x() : Float
    return this[1];
  inline function get_y2() : Float
    return this[2];
}