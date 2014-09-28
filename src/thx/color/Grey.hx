package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract Grey(Float) {
	public static var black(default, null) : Grey = new Grey(0);
	public static var white(default, null) : Grey = new Grey(1);

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
		this = grey.normalize();

	@:to inline public function toCMYK() : CMYK
		return toRGBX().toCMYK();

	@:to inline public function toHSL() : HSL
		return toRGBX().toHSL();

	@:to inline public function toHSV() : HSV
		return toRGBX().toHSV();

	@:to inline public function toRGB() : RGB
		return toRGBX().toRGB();

	@:to inline public function toRGBX() : RGBX
		return new RGBX([grey, grey, grey]);

	@:to inline public function toRGBXA() : RGBXA
		return toRGBX().toRGBXA();

	@:op(A==B) public function equals(other : Grey) : Bool
		return this == other.grey;

	public function contrast()
		return this > 0.5 ? black : white;

	public static function darker(color : Grey, t : Float) : Grey
		return new Grey(t.interpolate(color.grey, 0));

	public static function lighter(color : Grey, t : Float) : Grey
		return new Grey(t.interpolate(color.grey, 1));

	public static function interpolate(a : Grey, b : Grey, t : Float) : Grey
		return new Grey(t.interpolate(a.grey, b.grey));

	inline function get_grey() : Float
		return this;

	inline public function toString() : String
		return 'grey(${grey*100}%)';
}