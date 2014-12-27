package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
using thx.core.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.CIELab)
@:access(thx.color.CIELCh)
@:access(thx.color.XYZ)
@:access(thx.color.RGBX)
abstract CIELCh(Array<Float>) {
  public var l(get, never) : Float;
  public var c(get, never) : Float;
  public var h(get, never) : Float;

  public static function create(l : Float, c : Float, h : Float)
    return new CIELCh([
      l,
      c,
      h.wrapCircular(360)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return CIELCh.create(arr[0], arr[1], arr[2]);
  }


  @:from public static function fromString(color : String) {
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

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : CIELCh, t : Float)
    return new CIELCh([
      t.interpolate(l, other.l),
      t.interpolate(c, other.c),
      t.interpolateAngle(h, other.h, 360)
    ]);

  public function rotate(angle : Float)
    return withHue(h + angle);

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

  public function withLightness(lightness : Float)
    return new CIELCh([lightness, c, h]);

  public function withChroma(newchroma : Float)
    return new CIELCh([l, newchroma, h]);

  public function withHue(newhue : Float)
    return new CIELCh([l, c, newhue.wrapCircular(360)]);

  @:op(A==B) public function equals(other : CIELCh) : Bool
    return l == other.l && c == other.c && h == other.h;

  @:to inline public function toString() : String
    return 'CIELCh($l,$c,$h)';

  @:to public function toCIELab() {
    var hradi = h * (Math.PI / 180),
        a = Math.cos(hradi) * c,
        b = Math.sin(hradi) * c;
    return new CIELab([l, a, b]);
  }

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

  @:to inline public function toRGBX()
    return toCIELab().toRGBX();

  @:to inline public function toRGBXA()
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ()
    return toCIELab().toXYZ();

  @:to inline public function toYxy()
    return toCIELab().toYxy();

  inline function get_l() : Float
    return this[0];
  inline function get_c() : Float
    return this[1];
  inline function get_h() : Float
    return this[2];
}