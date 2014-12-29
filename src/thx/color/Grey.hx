package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract Grey(Float) from Float to Float {
  public static var black(default, null) : Grey = new Grey(0);
  public static var white(default, null) : Grey = new Grey(1);

  @:from public static function create(v : Float)
    return new Grey(v.normalize());

  @:from public static function fromString(color : String) : Null<Grey> {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'grey', 'gray':
        new thx.color.Grey(ColorParser.getFloatChannels(info.channels, 1)[0]);
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  public var grey(get, never) : Float;
  inline public function new(grey : Float) : Grey
    this = grey;

  public function contrast()
    return this > 0.5 ? black : white;

  public function darker(t : Float)
    return new Grey(t.interpolate(grey, 0));

  public function lighter(t : Float)
    return new Grey(t.interpolate(grey, 1));

  public function interpolate(other : Grey, t : Float)
    return new Grey(t.interpolate(grey, other.grey));

  inline public function toString() : String
    return 'grey(${grey*100}%)';

  @:op(A==B) public function equals(other : Grey) : Bool
    return this.nearEquals(other.grey);

  inline function get_grey() : Float
    return this;

  @:to inline public function toCIELab()
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to inline public function toCMY()
    return toRGBX().toCMY();

  @:to inline public function toCMYK()
    return toRGBX().toCMYK();

  @:to inline public function toHSL()
    return toRGBX().toHSL();

  @:to inline public function toHSV()
    return toRGBX().toHSV();

  @:to inline public function toRGB()
    return toRGBX().toRGB();

  @:to inline public function toRGBA()
    return toRGBXA().toRGBA();

  @:to inline public function toRGBX()
    return new RGBX([grey, grey, grey]);

  @:to inline public function toRGBXA()
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ()
    return toRGBX().toXYZ();

  @:to inline public function toYxy()
    return toRGBX().toYxy();
}