/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

@:access(thx.color.RGBXA)
@:access(thx.color.HSL)
abstract HSLA(Array<Float>) {
	public var hue(get, never) : Angle;
    public var huef(get, never) : Float;
	public var saturation(get, never) : Float;
	public var lightness(get, never) : Float;
	public var alpha(get, never) : Float;

	inline public static function fromFloats(hue: Float, saturation: Float, lightness: Float, alpha : Float)
		return new HSLA([
			hue,
			saturation,
			lightness,
			alpha
		]);

	inline function new(channels : Array<Float>)
		this = channels;

	@:to inline public function toHSL()
		return new HSL(this.slice(0, 3));

	@:to inline public function toHSVA()
		return toRGBXA().toHSVA();

	@:to inline public function toRGBXA()
		return new RGBXA([
			_c(hue + 120, saturation, lightness),
			_c(hue, saturation, lightness),
			_c(hue - 120, saturation, lightness),
			alpha
		]);

	inline public function toCSS3()
		return toString();
	inline public function toString()
		return 'hsla(${huef},${saturation*100}%,${lightness*100}%,$alpha)';

	@:op(A==B) public function equals(other : HSLA)
		return hue == other.hue && saturation == other.saturation && lightness == other.lightness && alpha == other.alpha;

	public function darker(t : Float)
		return new HSLA([
			hue,
			saturation,
			t.interpolateBetween(lightness, 0),
			alpha
		]);

	public function lighter(t : Float)
		return new HSLA([
			hue,
			saturation,
			t.interpolateBetween(lightness, 1),
			alpha
		]);

	public function transparent(t : Float)
		return new HSLA([
			hue,
			saturation,
			lightness,
			t.interpolateBetween(alpha, 0)
		]);

	public function opaque(t : Float)
		return new HSLA([
			hue,
			saturation,
			lightness,
			t.interpolateBetween(alpha, 1)
		]);

	public function interpolate(other : HSLA, t : Float)
		return new HSLA([
			t.interpolateBetween(hue, other.hue),
			t.interpolateBetween(saturation, other.saturation),
			t.interpolateBetween(lightness, other.lightness),
			t.interpolateBetween(alpha, other.alpha)
		]);

	inline function get_hue() : Angle
		return this[0];
    inline function get_huef() : Float
		return this[0];
	inline function get_saturation()
		return this[1];
	inline function get_lightness()
		return this[2];
	inline function get_alpha() : Float
		return this[3];

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