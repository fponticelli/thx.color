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

	inline public function new(rgb : Int)
		this = rgb;

	public var red(get, never)   : Int;
	public var green(get, never) : Int;
	public var blue(get, never)  : Int;

	@:to inline public function toInt() : Int
		return this;

	@:to inline public function toCMYK()
		return toRGBX().toCMYK();

	@:to inline public function toGrey()
		return toRGBX().toGrey();

	@:to inline public function toHSL()
		return toRGBX().toHSL();

	@:to inline public function toHSV()
		return toRGBX().toHSV();

	@:to inline public function toRGBX()
		return new RGBX([red / 255, green / 255, blue / 255]);

	inline public function toCSS3()
		return toString();
	inline  public function toCSS3Alpha(alpha : Float)
		return toStringAlpha(alpha);
	inline  public function toString()
		return 'rgb($red,$green,$blue)';
	inline  public function toStringAlpha(alpha : Float)
		return 'rgba($red,$green,$blue,${alpha.normalize()})';
	inline  public function toHex(prefix = "#")
		return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	function get_red()
		return (this >> 16) & 0xFF;
	function get_green()
		return (this >> 8) & 0xFF;
	function get_blue()
		return this & 0xFF;
}