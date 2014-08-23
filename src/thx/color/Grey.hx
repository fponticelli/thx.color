package thx.color;

using thx.core.Floats;

@:access(thx.color.RGBX)
abstract Grey(Float) {
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

	inline function get_grey()
		return this;

	inline public function toString()
		return 'grey(${grey*100}%)';
}