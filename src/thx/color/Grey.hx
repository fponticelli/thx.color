package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
abstract Grey(Float) {
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
	inline public function new(grey : Float)
		this = grey.normalize();

	@:to inline public function toCMYK()
		return toRGBX().toCMYK();

	@:to inline public function toHSL()
		return toRGBX().toHSL();

	@:to inline public function toHSV()
		return toRGBX().toHSV();

	@:to inline public function toRGBX()
		return new RGBX([grey, grey, grey]);

	@:to inline public function toRGBXA()
		return toRGBX().toRGBXA();

	@:op(A==B) public function equals(other : Grey)
		return this == other.grey;

	public static function darker(color : Grey, t : Float) : Grey
		return new Grey(t.interpolateBetween(color.grey, 0));

	public static function lighter(color : Grey, t : Float) : Grey
		return new Grey(t.interpolateBetween(color.grey, 1));

	public static function interpolate(a : Grey, b : Grey, t : Float)
		return new Grey(t.interpolateBetween(a.grey, b.grey));

	inline function get_grey()
		return this;

	inline public function toString()
		return 'grey(${grey*100}%)';
}