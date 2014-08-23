/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

@:access(thx.color.RGBX)
abstract CMYK(Array<Float>) {
	public var black(get, never): Float;
	public var cyan(get, never): Float;
	public var magenta(get, never): Float;
	public var yellow(get, never): Float;

	inline public static function fromFloats(cyan: Float, magenta: Float, yellow: Float, black: Float)
		return new CMYK([
			cyan.normalize(),
			magenta.normalize(),
			yellow.normalize(),
			black.normalize()
		]);

	inline function new(channels : Array<Float>)
		this = channels;

	@:to inline public function toGrey()
		return toRGBX().toGrey();

	@:to inline public function toHSL()
		return toRGBX().toHSL();

	@:to inline public function toHSV()
		return toRGBX().toHSV();

	@:to inline public function toRGBX()
		return new RGBX([
			(1 - cyan    - black).normalize(),
			(1 - magenta - black).normalize(),
			(1 - yellow  - black).normalize()
		]);

	@:to inline public function toString()
		return 'cmyk($cyan,$magenta,$yellow,$black)';

	inline function get_black()
		return this[3];
	inline function get_cyan()
		return this[0];
	inline function get_magenta()
		return this[1];
	inline function get_yellow()
		return this[2];
}