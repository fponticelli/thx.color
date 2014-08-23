package thx.color;

using StringTools;
using thx.core.Floats;
using Math;

@:access(thx.color.RGBX)
abstract RGB(Int) {
	public static function fromFloats(red : Float, green : Float, blue : Float)
		return fromInts((red.normalize() * 255).round(), (green.normalize() * 255).round(), (blue.normalize() * 255).round());
	inline public static function fromInts(red : Int, green : Int, blue : Int)
		return new RGB(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));
	inline public static function fromInt(rgb : Int)
		return new RGB(rgb);

	inline public function new(rgb : Int)
		this = rgb;

	public var red(get, never)   : Int;
	public var green(get, never) : Int;
	public var blue(get, never)  : Int;

	@:to inline public function toInt() : Int
		return this;

	@:to public function toCMYK()
		return toRGBX().toCMYK();

	@:to inline public function toGrey()
		return toRGBX().toGrey();

	@:to inline public function toHSL()
		return toRGBX().toHSL();

	@:to inline public function toHSV()
		return toRGBX().toHSV();

	@:to public function toRGBX()
		return RGBX.fromInts(red, green, blue);

	@:to inline public function toRGBA()
		return withAlpha(255);

	@:to inline public function toRGBXA()
		return toRGBA().toRGBXA();

	inline public function withAlpha(alpha : Int)
		return RGBA.fromInts(red, green, blue, alpha);

	inline public function toCSS3()
		return toString();
	@:to inline  public function toString()
		return 'rgb($red,$green,$blue)';
	inline  public function toHex(prefix = "#")
		return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	@:op(A==B) public function equals(other : RGB)
		return red == other.red && green == other.green && blue == other.blue;

	public function darker(t : Float)
		return toRGBX().darker(t).toRGB();
	public function lighter(t : Float)
		return toRGBX().lighter(t).toRGB();
	public function interpolate(other : RGB, t : Float)
		return toRGBX().interpolate(other.toRGBX(), t);

	inline function get_red()
		return (this >> 16) & 0xFF;
	inline function get_green()
		return (this >> 8) & 0xFF;
	inline function get_blue()
		return this & 0xFF;
}