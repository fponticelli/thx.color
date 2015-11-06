package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

/**
YUV is a color space typically used as part of a color image pipeline. It
encodes a color image or video taking human perception into account, allowing
reduced bandwidth for chrominance components, thereby typically enabling
transmission errors or compression artifacts to be more efficiently masked by
the human perception than using a "direct" RGB-representation. Other color
spaces have similar properties, and the main reason to implement or investigate
properties of Y'UV would be for interfacing with analog or digital television or
photographic equipment that conforms to certain Y'UV standards.
**/
@:access(thx.color.Rgbx)
@:access(thx.color.Lab)
@:access(thx.color.Xyz)
abstract Yuv(Array<Float>) {
  public var y(get, never) : Float;
  public var u(get, never) : Float;
  public var v(get, never) : Float;

  inline public static function create(y : Float, u : Float, v : Float)
    return new Yuv([y, u, v]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Yuv.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
    case 'yuv':
        new thx.color.Yuv(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Yuv
    this = channels;

  public function interpolate(other : Yuv, t : Float)
    return new Yuv([
      t.interpolate(y, other.y),
      t.interpolate(u,  other.u),
      t.interpolate(v, other.v)
    ]);

  public function min(other : Yuv)
    return create(y.min(other.y), u.min(other.u), v.min(other.v));

  public function max(other : Yuv)
    return create(y.max(other.y), u.max(other.u), v.max(other.v));

  public function normalize()
    return create(y.normalize(), u.clampSym(0.436), v.clampSym(0.615));

  public function roundTo(decimals : Int)
    return create(y.roundTo(decimals), u.roundTo(decimals), v.roundTo(decimals));

  public function withY(newy : Float)
    return new Yuv([newy, u, v]);

  public function withU(newu : Float)
    return new Yuv([y, newu, v]);

  public function withV(newv : Float)
    return new Yuv([y, u, newv]);

  @:to public function toString() : String
    return 'yuv(${y},${u},${v})';

  @:op(A==B) public function equals(other : Yuv) : Bool
    return nearEquals(other);

  public function nearEquals(other : Yuv, ?tolerance = Floats.EPSILON) : Bool
    return y.nearEquals(other.y, tolerance) && u.nearEquals(other.u, tolerance) && v.nearEquals(other.v, tolerance);

  @:to public function toLab()
    return toXyz().toLab();

  @:to public function toLCh()
    return toLab().toLCh();

  @:to public function toLuv()
    return toRgbx().toLuv();

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

  @:to public function toRgbx() {
    var r = y + 1.139837398373983740  * v,
        g = y - 0.3946517043589703515 * u - 0.5805986066674976801 * v,
        b = y + 2.032110091743119266  * u;

    return new Rgbx([r, g, b]);
  }

  @:to public function toRgbxa()
    return toRgbx().toRgbxa();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toYxy()
    return toRgbx().toYxy();

  @:to public function toXyz()
    return toRgbx().toXyz();

  inline function get_y() : Float
    return this[0];
  inline function get_u() : Float
    return this[1];
  inline function get_v() : Float
    return this[2];
}
