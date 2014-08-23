/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

@:access(thx.color.RGBX)
abstract HSL(Array<Float>) {
	public var hue(get, never) : Angle;
    public var huef(get, never) : Float;
	public var saturation(get, never) : Float;
	public var lightness(get, never) : Float;

	inline public static function fromFloats(hue: Float, saturation: Float, lightness: Float)
		return new HSL([
			hue,
			saturation,
			lightness
		]);

	inline function new(channels : Array<Float>)
		this = channels;

	@:to inline public function toCMYK()
		return toRGBX().toCMYK();

	@:to inline public function toGrey()
		return toRGBX().toGrey();

	@:to inline public function toHSV()
		return toRGBX().toHSV();

	@:to inline public function toRGBX()
		return new RGBX([
			_c(hue + 120, saturation, lightness),
			_c(hue, saturation, lightness),
			_c(hue - 120, saturation, lightness)
		]);

	inline public function toCSS3()
		return toString();
	inline public function toString()
		return 'hsl(${huef},${saturation*100}%,${lightness*100}%)';

	@:op(A==B) public function equals(other : HSL)
		return hue == other.hue && saturation == other.saturation && lightness == other.lightness;

	public function darker(t : Float)
		return new HSL([
			hue,
			saturation,
			t.interpolateBetween(lightness, 0)
		]);

	public function lighter(t : Float)
		return new HSL([
			hue,
			saturation,
			t.interpolateBetween(lightness, 1)
		]);

	public function interpolate(other : HSL, t : Float)
		return new HSL([
			t.interpolateBetween(hue, other.hue),
			t.interpolateBetween(saturation, other.saturation),
			t.interpolateBetween(lightness, other.lightness)
		]);

	inline function get_hue() : Angle
		return this[0];
    inline function get_huef() : Float
		return this[0];
	inline function get_saturation()
		return this[1];
	inline function get_lightness()
		return this[2];

	// Based on D3.js by Michael Bostock
	static function _c(d : Float, s : Float, l : Float) {
		var m2 = l <= 0.5 ? l * (1 + s) : l + s - l * s,
			m1 = 2 * l - m2;

		d = d.wrapCircular(360);
		if (d < 60)
			return m1 + (m2 - m1) * d / 60;
		else if (d < 180)
			return m2;
		else if (d < 240)
			return m1 + (m2 - m1) * (240 - d) / 60;
		else
			return m1;
	}
}