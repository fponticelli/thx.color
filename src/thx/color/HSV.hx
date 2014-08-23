package thx.color;
using thx.core.Floats;

@:access(thx.color.RGBX)
@:access(thx.color.HSVA)
abstract HSV(Array<Float>) {
	public var hue(get, never) : Angle;
    public var huef(get, never) : Float;
	public var saturation(get, never) : Float;
	public var value(get, never) : Float;

	inline public static function fromFloats(hue: Float, saturation: Float, value: Float)
		return new HSV([
			hue,
			saturation,
			value
		]);

	inline function new(channels : Array<Float>)
		this = channels;

	@:to inline public function toCMYK()
		return toRGBX().toCMYK();

	@:to inline public function toGrey()
		return toRGBX().toGrey();

	@:to inline public function toHSL()
		return toRGBX().toHSL();

	@:to inline public function toRGBX() {
		if(saturation == 0)
			return new RGBX([value, value, value]);

		var r : Float, g : Float, b : Float, i : Int, f : Float, p : Float, q : Float, t : Float;
		var h = hue / 60;

		i = Math.floor(h);
		f = h - i;
		p = value * (1 - saturation);
		q = value * (1 - f * saturation);
		t = value * (1 - (1 - f) * saturation);

		switch(i){
			case 0: r = value; g = t; b = p;
			case 1: r = q; g = value; b = p;
			case 2: r = p; g = value; b = t;
			case 3: r = p; g = q; b = value;
			case 4: r = t; g = p; b = value;
			default: r = value; g = p; b = q; // case 5
		}

		return new RGBX([r, g, b]);
	}

	@:to inline public function toRGBXA()
		return toRGBX().toRGBXA();

	@:to inline public function toHSVA()
		return withAlpha(1.0);

	inline public function withAlpha(alpha : Float)
		return new HSVA(this.concat([alpha]));

	inline public function toString()
		return 'hsv($huef,${saturation*100}%,${value*100}%)';

	@:op(A==B) public function equals(other : HSV)
		return hue == other.hue && saturation == other.saturation && value == other.value;

	public function darker(t : Float)
		return new HSV([
			hue,
			saturation,
			t.interpolateBetween(value, 0)
		]);

	public function lighter(t : Float)
		return new HSV([
			hue,
			saturation,
			t.interpolateBetween(value, 1)
		]);

	public function interpolate(other : HSV, t : Float)
		return new HSV([
			t.interpolateBetween(hue, other.hue),
			t.interpolateBetween(saturation, other.saturation),
			t.interpolateBetween(value, other.value)
		]);

	inline function get_hue() : Angle
		return this[0];
	inline function get_huef() : Float
		return this[0];
	inline function get_saturation()
		return this[1];
	inline function get_value()
		return this[2];
}