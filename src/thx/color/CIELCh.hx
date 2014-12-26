package thx.color;

using thx.core.Floats;
using thx.core.Nulls;
import thx.color.parse.ColorParser;

@:access(thx.color.CIELab)
@:access(thx.color.CIELCh)
@:access(thx.color.XYZ)
@:access(thx.color.RGBX)
abstract CIELCh(Array<Float>) {
  public var l(get, never) : Float;
  public var c(get, never) : Float;
  public var h(get, never) : Float;

  public static function create(l : Float, a : Float, b : Float)
    return new CIELCh([
      l.clamp(0, 100),
      a,
      b.wrapCircular(360)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) : CIELCh
    return CIELCh.create(arr[0].or(0), arr[1].or(0), arr[2].or(0));

  @:from public static function fromString(color : String) : CIELCh {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'cielch':
        CIELCh.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : CIELCh
    this = channels;

  public function interpolate(other : CIELCh, t : Float) : CIELCh
    return new CIELCh([
      t.interpolate(l, other.l),
      t.interpolate(c, other.c),
      t.interpolate(h, other.h)
    ]);

  inline public function toString() : String
    return 'CIELCh($l,$c,$h)';

  @:op(A==B) public function equals(other : CIELCh) : Bool
    return l == other.l && c == other.c && h == other.h;

  @:to public function toCIELab() : CIELab {
    var hradi = h * (Math.PI / 180),
        a = Math.cos(hradi) * c,
        b = Math.sin(hradi) * c;
    return new CIELab([l, a, b]);
  }

  @:to inline public function toCMY() : CMY
    return toRGBX().toCMY();

  @:to inline public function toCMYK() : CMYK
    return toRGBX().toCMYK();

  @:to inline public function toGrey() : Grey
    return toRGBX().toGrey();

  @:to inline public function toHSL() : HSL
    return toRGBX().toHSL();

  @:to inline public function toHSV() : HSV
    return toRGBX().toHSV();

  @:to inline public function toRGB() : RGB
    return toRGBX().toRGB();

  @:to inline public function toRGBX() : RGBX
    return toCIELab().toRGBX();

  @:to inline public function toRGBXA() : RGBXA
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ() : XYZ
    return toCIELab().toXYZ();

  @:to inline public function toYxy() : Yxy
    return toCIELab().toYxy();

  inline function get_l() : Float
    return this[0];
  inline function get_c() : Float
    return this[1];
  inline function get_h() : Float
    return this[2];
}