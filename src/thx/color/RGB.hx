/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;
using thx.core.Ints;
import thx.color.ColorParser;
using StringTools;
using Math;

class RGB extends Color {
	public static function parseRGB(s : String) : Null<RGB> {
		var info = ColorParser.parseColor(s);
		return null == info ? null : RGBAssembler.instance.toSolid(info);
	}

	public static function parse(s : String) : Null<Color> {
		var info = ColorParser.parseColor(s);
		return null == info ? null : RGBAssembler.instance.toColor(info);
	}

	inline public static function fromFloats(red : Float, green : Float, blue : Float)
		return fromInts((red.normalize() * 255).round(), (green.normalize() * 255).round(), (blue.normalize() * 255).round());
	inline public static function fromInts(red : Int, green : Int, blue : Int)
		return new RGB(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));

	@:isVar public var rgb(get, set) : Int;
	public function new(rgb : Int)
		this.rgb = rgb.clamp(0, 0xFFFFFF);

	override public function clone() : RGB
		return new RGB(rgb);

	public var red(get, set)   : Int;
	public var green(get, set) : Int;
	public var blue(get, set)  : Int;

	override public function toRGBX()
		return new RGBX(red / 255, green / 255, blue / 255);

	override public function toCSS3()
		return toString();
	override public function toCSS3Alpha(alpha : Float)
		return toStringAlpha(alpha);
	override public function toString()
		return 'rgb($red,$green,$blue)';
	override public function toStringAlpha(alpha : Float)
		return 'rgba($red,$green,$blue,${alpha.normalize()})';
	override public function toHex(prefix = "#")
		return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	function get_rgb()
		return rgb;
	function set_rgb(value : Int)
		return rgb = value;

	function get_red()
		return (rgb >> 16) & 0xFF;
	function get_green()
		return (rgb >> 8) & 0xFF;
	function get_blue()
		return rgb & 0xFF;

	function set_red(value : Int) {
		rgb = ((value & 0xFF) << 16)|((green & 0xFF) << 8)|((blue & 0xFF) << 0);
		return value;
	}
	function set_green(value : Int) {
		rgb = ((red & 0xFF) << 16)|((value & 0xFF) << 8)|((blue & 0xFF) << 0);
		return value;
	}
	function set_blue(value : Int) {
		rgb = ((red & 0xFF) << 16)|((green & 0xFF) << 8)|((value & 0xFF) << 0);
		return value;
	}
}

class RGBAssembler extends ColorAssembler<RGB> {
	public static var instance(default, null) : RGBAssembler = new RGBAssembler();
	function new() { }
	override public function toSolid(info : ColorInfo) : Null<RGB> {
		if (info.name != "rgb" || info.channels.length < 3) return null;
		var red   = ColorParser.getInt8Channel(info.channels[0]),
			green = ColorParser.getInt8Channel(info.channels[1]),
			blue  = ColorParser.getInt8Channel(info.channels[2]);
		if (null == red || null == green || null == blue)
			return null;
		return RGB.fromInts(red, green, blue);
	}
}