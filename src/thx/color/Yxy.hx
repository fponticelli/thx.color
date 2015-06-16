package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbx)
@:access(thx.color.CieLab)
@:access(thx.color.Xyz)
abstract Yxy(Array<Float>) {
  public var y1(get, never) : Float;
  public var x(get, never) : Float;
  public var y2(get, never) : Float;

  inline public static function create(y1 : Float, x : Float, y2 : Float)
    return new Yxy([y1, x, y2]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Yxy.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
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

  inline function new(channels : Array<Float>) : Yxy
    this = channels;

  public function interpolate(other : Yxy, t : Float)
    return new Yxy([
      t.interpolate(y1, other.y1),
      t.interpolate(x,  other.x),
      t.interpolate(y2, other.y2)
    ]);

  public function withY1(newy1 : Float)
    return new Yxy([newy1, x, y2]);

  public function withY(newx : Float)
    return new Yxy([y1, x, y2]);

  public function withZ(newy2 : Float)
    return new Yxy([y1, x, y2]);

  @:to public function toString() : String
    return 'Yxy(${y1.roundTo(6)},${x.roundTo(6)},${y2.roundTo(6)})';

  @:op(A==B) public function equals(other : Yxy) : Bool
    return y1.nearEquals(other.y1) && x.nearEquals(other.x) && y2.nearEquals(other.y2);

  @:to public function toCieLab()
    return toXyz().toCieLab();

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

  @:to public function toRgbx()
    return toXyz().toRgbx();

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toXyz()
    return new Xyz([
      x * (y1 / y2),
      y1,
      (1 - x - y2) * (y1 / y2)
    ]);

  inline function get_y1() : Float
    return this[0];
  inline function get_x() : Float
    return this[1];
  inline function get_y2() : Float
    return this[2];
}
