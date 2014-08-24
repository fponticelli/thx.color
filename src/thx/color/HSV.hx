package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.HSVA)
abstract HSV(Array<Float>) {
	public var hue(get, never) : Angle;
    public var huef(get, never) : Float;
	public var saturation(get, never) : Float;
	public var value(get, never) : Float;

	@:from public static function fromString(color : String) : HSV {
		var info = ColorParser.parseColor(color);
		if(null == info)
			return null;

		return try switch info.name {
			case 'hsv':
				new thx.color.HSV(ColorParser.getFloatChannels(info.channels, 3));
			case _:
				null;
		} catch(e : Dynamic) null;
	}

	inline public static function fromFloats(hue: Float, saturation: Float, value: Float) : HSV
		return new HSV([
			hue,
			saturation,
			value
		]);

	inline function new(channels : Array<Float>) : HSV
		this = channels;

	@:to inline public function toCMYK() : CMYK
		return toRGBX().toCMYK();

	@:to inline public function toGrey() : Grey
		return toRGBX().toGrey();

	@:to inline public function toHSL() : HSL
		return toRGBX().toHSL();

	@:to inline public function toRGB() : RGB
		return toRGBX().toRGB();

	@:to inline public function toRGBX() : RGBX {
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

	@:to inline public function toRGBXA() : RGBXA
		return toRGBX().toRGBXA();

	@:to inline public function toHSVA() : HSVA
		return withAlpha(1.0);

	inline public function withAlpha(alpha : Float) : HSVA
		return new HSVA(this.concat([alpha]));

	inline public function toString() : String
		return 'hsv($huef,${saturation*100}%,${value*100}%)';

	@:op(A==B) public function equals(other : HSV) : Bool
		return hue == other.hue && saturation == other.saturation && value == other.value;

	public function darker(t : Float) : HSV
		return new HSV([
			hue,
			saturation,
			t.interpolateBetween(value, 0)
		]);

	public function lighter(t : Float) : HSV
		return new HSV([
			hue,
			saturation,
			t.interpolateBetween(value, 1)
		]);

	public function interpolate(other : HSV, t : Float) : HSV
		return new HSV([
			t.interpolateBetween(hue, other.hue),
			t.interpolateBetween(saturation, other.saturation),
			t.interpolateBetween(value, other.value)
		]);

	inline function get_hue() : Angle
		return this[0];
	inline function get_huef() : Float
		return this[0];
	inline function get_saturation() : Float
		return this[1];
	inline function get_value() : Float
		return this[2];
}