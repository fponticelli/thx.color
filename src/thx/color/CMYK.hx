/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract CMYK(Array<Float>) {
	public var black(get, never): Float;
	public var cyan(get, never): Float;
	public var magenta(get, never): Float;
	public var yellow(get, never): Float;

	@:from public static function fromString(color : String) : CMYK {
		var info = ColorParser.parseColor(color);
		if(null == info)
			return null;
		return try switch info.name {
			case 'cmyk':
				new thx.color.CMYK(ColorParser.getFloatChannels(info.channels, 4));
			case _:
				null;
		} catch(e : Dynamic) null;
	}

	inline public static function fromFloats(cyan: Float, magenta: Float, yellow: Float, black: Float) : CMYK
		return new CMYK([
			cyan.normalize(),
			magenta.normalize(),
			yellow.normalize(),
			black.normalize()
		]);

	inline function new(channels : Array<Float>) : CMYK
		this = channels;

	@:to inline public function toGrey() : Grey
		return toRGBX().toGrey();

	@:to inline public function toHSL() : HSL
		return toRGBX().toHSL();

	@:to inline public function toHSV() : HSV
		return toRGBX().toHSV();

	@:to inline public function toRGB() : RGB
		return toRGBX().toRGB();

	@:to inline public function toRGBX() : RGBX
		return new RGBX([
			(1 - cyan    - black).normalize(),
			(1 - magenta - black).normalize(),
			(1 - yellow  - black).normalize()
		]);

	@:to inline public function toRGBXA() : RGBXA
		return toRGBX().toRGBXA();

	@:to inline public function toString() : String
		return 'cmyk($cyan,$magenta,$yellow,$black)';

	@:op(A==B) public function equals(other : CMYK) : Bool
		return cyan == other.cyan && magenta == other.magenta && yellow == other.yellow && black == other.black;

	inline public function darker(t : Float) : CMYK
		return new CMYK([cyan, magenta, yellow, t.interpolateBetween(black, 1)]);

	inline public function lighter(t : Float) : CMYK
		return new CMYK([cyan, magenta, yellow, t.interpolateBetween(black, 0)]);

	public function interpolate(other : CMYK, t : Float) : CMYK
		return new CMYK([
			t.interpolateBetween(cyan,    other.cyan),
			t.interpolateBetween(magenta, other.magenta),
			t.interpolateBetween(yellow,  other.yellow),
			t.interpolateBetween(black,   other.black)
		]);

	inline function get_black() : Float
		return this[3];
	inline function get_cyan() : Float
		return this[0];
	inline function get_magenta() : Float
		return this[1];
	inline function get_yellow() : Float
		return this[2];
}