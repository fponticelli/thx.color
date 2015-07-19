package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

/**
The CIE XYZ color space encompasses all color sensations that an average person
can experience. It serves as a standard reference against which many other color
spaces are defined. A set of color-matching functions, like the spectral
sensitivity curves of the LMS space but not restricted to be nonnegative
sensitivities, associates physically produced light spectra with specific
tristimulus values.

When judging the relative luminance (brightness) of different colors in well-lit
situations, humans tend to perceive light within the green parts of the spectrum
as brighter than red or blue light of equal power. The luminosity function that
describes the perceived brightnesses of different wavelengths is thus roughly
analogous to the spectral sensitivity of M cones.

The CIE model capitalises on this fact by defining Y as luminance. Z is
quasi-equal to blue stimulation, or the S cone response, and X is a mix (a
linear combination) of cone response curves chosen to be nonnegative. The XYZ
tristimulus values are thus analogous to, but different to, the LMS cone
responses of the human eye. Defining Y as luminance has the useful result that
for any given Y value, the XZ plane will contain all possible chromaticities at
that luminance.
**/
@:access(thx.color.Rgbx)
@:access(thx.color.Lab)
@:access(thx.color.Luv)
@:access(thx.color.HunterLab)
@:access(thx.color.Yxy)
abstract Xyz(Array<Float>) {
  public static var whiteReference(default, null) = new Xyz([0.95047, 1, 1.08883]);
  public static var epsilon(default, null) = 216.0/24389.0; // 0.008856
  public static var kappa(default, null) = 24389.0/27.0; // 903.3

  public var x(get, never) : Float;
  public var y(get, never) : Float;
  public var z(get, never) : Float;

  public var u(get, never) : Float;
  public var v(get, never) : Float;

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

  @:to public function toLab() : Lab {
    function f(t : Float) {
      if(t > (6 / 29) * (6 / 29) * (6 / 29)) {
        return Math.pow(t, 1 / 3);
      } else {
        return 1 / 3 * (29 / 6) * (29 / 6) * t + 4 / 29;
      }
    }
    var x1 = x / Xyz.whiteReference.x,
        y1 = y / Xyz.whiteReference.y,
        z1 = z / Xyz.whiteReference.z,
        fy1 = f(y1),
        l = 116 * fy1 - 16,
        a = 500 * (f(x1) - fy1),
        b = 200 * (fy1 - f(z1));
    return new Lab([l, a, b]);
  }

  @:to public function toLCh()
    return toLab().toLCh();

  @:to public function toLuv() {
    var x = x * 100,
        y = y * 100,
        z = z * 100,
        f = y / (whiteReference.y * 100),
        r = Math.pow(6/29, 3),
        l = f > r ?
              116 * Math.pow(f, 1.0 / 3.0) - 16 :
              Math.pow(29 / 3, 3) * f,
        u = 13 * l * (u - whiteReference.u * 100),
        v = 13 * l * (v - whiteReference.v * 100);
    return new Luv([l / 100, u / 100, v / 100]);
  }

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

  @:to public function toHunterLab() {
    var l = 10.0 * Math.sqrt(y),
        a = y != 0 ? 17.5 * (((1.02 * x) - y) / Math.sqrt(y)) : 0,
        b = y != 0 ? 7.0 * ((y - (.847 * z)) / Math.sqrt(y)) : 0;
    return new HunterLab([l, a, b]);
  }

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

  @:to public function toTemperature()
    return toRgbx().toTemperature();

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
  function get_u() : Float
    return try (4 * x) / (x + 15 * y + 3 * z) catch(e : Dynamic) 0;
  function get_v() : Float
    return try (9 * y) / (x + 15 * y + 3 * z) catch(e : Dynamic) 0;
}
