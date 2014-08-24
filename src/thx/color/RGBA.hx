package thx.color;

using Math;
using StringTools;
using thx.core.Floats;
import thx.color.parse.ColorParser;

abstract RGBA(Int) {
	@:from public static function fromString(color : String) : RGBA {
		var info = ColorParser.parseHex(color);
		if(null == info)
			info = ColorParser.parseColor(color);
		if(null == info)
			return null;

		return try switch info.name {
			case 'rgba':
				thx.color.RGBA.fromArray([
					ColorParser.getInt8Channel(info.channels[0]),
					ColorParser.getInt8Channel(info.channels[1]),
					ColorParser.getInt8Channel(info.channels[2]),
					Math.round(ColorParser.getFloatChannel(info.channels[3]) * 255)
				]);
			case _:
				null;
		} catch(e : Dynamic) null;
	}
	inline public static function fromArray(arr : Array<Int>)
		return fromInts(arr[0], arr[1], arr[2], arr[3]);
	public static function fromFloats(red : Float, green : Float, blue : Float, alpha : Float)
		return fromInts((red.normalize() * 255).round(), (green.normalize() * 255).round(), (blue.normalize() * 255).round(), (alpha.normalize() * 255).round());
	inline public static function fromInts(red : Int, green : Int, blue : Int, alpha : Int)
		return new RGBA(((alpha & 0xFF) << 24) | ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));
	inline public static function fromInt(rgba : Int)
		return new RGBA(rgba);

	inline public function new(rgba : Int)
		this = rgba;

	public var red(get, never)   : Int;
	public var green(get, never) : Int;
	public var blue(get, never)  : Int;
	public var alpha(get, never)  : Int;

	@:to inline public function toInt() : Int
		return this;

	@:to inline public function toHSLA()
		return toRGBXA().toHSLA();

	@:to inline public function toHSVA()
		return toRGBXA().toHSVA();

	@:to public function toRGB()
		return RGB.fromInts(red, green, blue);

	@:to public function toRGBX()
		return RGBX.fromInts(red, green, blue);

	@:to public function toRGBXA()
		return RGBXA.fromInts(red, green, blue, alpha);

	inline public function toCSS3()
		return toString();
	@:to inline  public function toString()
		return 'rgba($red,$green,$blue,${alpha/255})';
	inline  public function toHex(prefix = "#")
		return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	@:op(A==B) public function equals(other : RGBA)
		return red == other.red && alpha == other.alpha && green == other.green && blue == other.blue;

	public function darker(t : Float)
		return toRGBXA().darker(t).toRGBA();
	public function lighter(t : Float)
		return toRGBXA().lighter(t).toRGBA();
	public function transparent(t : Float)
		return toRGBXA().transparent(t).toRGBA();
	public function opaque(t : Float)
		return toRGBXA().opaque(t).toRGBA();
	public function interpolate(other : RGBA, t : Float)
		return toRGBXA().interpolate(other.toRGBXA(), t);

	inline function get_alpha()
		return (this >> 24) & 0xFF;
	inline function get_red()
		return (this >> 16) & 0xFF;
	inline function get_green()
		return (this >> 8) & 0xFF;
	inline function get_blue()
		return this & 0xFF;
}