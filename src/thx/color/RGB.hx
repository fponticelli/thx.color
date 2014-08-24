package thx.color;

using StringTools;
using thx.core.Floats;
using Math;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract RGB(Int) {
	@:from public static function fromString(color : String) : Null<RGB> {
		var info = ColorParser.parseHex(color);
		if(null == info)
			info = ColorParser.parseColor(color);
		if(null == info)
			return null;

		return try switch info.name {
			case 'rgb':
				thx.color.RGB.fromArray(ColorParser.getInt8Channels(info.channels, 3));
			case _:
				null;
		} catch(e : Dynamic) null;
	}
	public static function fromFloats(red : Float, green : Float, blue : Float) : RGB
		return fromInts((red.normalize() * 255).round(), (green.normalize() * 255).round(), (blue.normalize() * 255).round());
	inline public static function fromArray(arr : Array<Int>) : RGB
		return fromInts(arr[0], arr[1], arr[2]);
	inline public static function fromInts(red : Int, green : Int, blue : Int) : RGB
		return new RGB(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));
	inline public static function fromInt(rgb : Int) : RGB
		return new RGB(rgb);

	inline public function new(rgb : Int) : RGB
		this = rgb;

	public var red(get, never)   : Int;
	public var green(get, never) : Int;
	public var blue(get, never)  : Int;

	@:to inline public function toInt() : Int
		return this;

	@:to public function toCMYK() : CMYK
		return toRGBX().toCMYK();

	@:to inline public function toGrey() : Grey
		return toRGBX().toGrey();

	@:to inline public function toHSL() : HSL
		return toRGBX().toHSL();

	@:to inline public function toHSV() : HSV
		return toRGBX().toHSV();

	@:to public function toRGBX() : RGBX
		return RGBX.fromInts(red, green, blue);

	@:to inline public function toRGBA() : RGBA
		return withAlpha(255);

	@:to inline public function toRGBXA() : RGBXA
		return toRGBA().toRGBXA();

	inline public function withAlpha(alpha : Int) : RGBXA
		return RGBA.fromInts(red, green, blue, alpha);

	inline public function toCSS3() : String
		return toString();
	@:to inline  public function toString() : String
		return 'rgb($red,$green,$blue)';
	inline  public function toHex(prefix = "#")
		return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	@:op(A==B) public function equals(other : RGB) : Bool
		return red == other.red && green == other.green && blue == other.blue;

	public function darker(t : Float) : RGB
		return toRGBX().darker(t).toRGB();
	public function lighter(t : Float) : RGB
		return toRGBX().lighter(t).toRGB();
	public function interpolate(other : RGB, t : Float) : RGB
		return toRGBX().interpolate(other.toRGBX(), t);

	inline function get_red() : Int
		return (this >> 16) & 0xFF;
	inline function get_green() : Int
		return (this >> 8) & 0xFF;
	inline function get_blue() : Int
		return this & 0xFF;
}