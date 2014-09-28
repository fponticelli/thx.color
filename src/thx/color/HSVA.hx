package thx.color;

using thx.core.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBXA)
@:access(thx.color.HSV)
abstract HSVA(Array<Float>) {
	public var hue(get, never) : Float;
    public var huef(get, never) : Float;
	public var saturation(get, never) : Float;
	public var value(get, never) : Float;
	public var alpha(get, never) : Float;

	@:from public static function fromString(color : String) : HSVA {
		var info = ColorParser.parseColor(color);
		if(null == info)
			return null;

		return try switch info.name {
			case 'hsv':
				new thx.color.HSV(ColorParser.getFloatChannels(info.channels, 3)).toHSVA();
			case 'hsva':
				new thx.color.HSVA(ColorParser.getFloatChannels(info.channels, 4));
			case _:
				null;
		} catch(e : Dynamic) null;
	}

	inline public static function fromFloats(hue: Float, saturation: Float, value: Float, alpha: Float) : HSVA
		return new HSVA([
			hue,
			saturation,
			value,
			alpha
		]);

	inline function new(channels : Array<Float>) : HSVA
		this = channels;

	@:to inline public function toHSV() : HSV
		return new HSV(this.slice(0, 3));

	@:to inline public function toHSLA() : HSLA
		return toRGBXA().toHSLA();

	@:to inline public function toRGB() : RGB
		return toRGBXA().toRGB();

	@:to inline public function toRGBXA() : RGBXA {
		if(saturation == 0)
			return new RGBXA([value, value, value, alpha]);

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

		return new RGBXA([r, g, b, alpha]);
	}

	inline public function toString() : String
		return 'hsva($huef,${saturation*100}%,${value*100}%,$alpha)';

	@:op(A==B) public function equals(other : HSVA) : Bool
		return hue == other.hue && saturation == other.saturation && value == other.value && alpha == other.alpha;

	public function darker(t : Float) : HSVA
		return new HSVA([
			hue,
			saturation,
			t.interpolate(value, 0),
			alpha
		]);

	public function lighter(t : Float) : HSVA
		return new HSVA([
			hue,
			saturation,
			t.interpolate(value, 1),
			alpha
		]);

	public function transparent(t : Float) : HSVA
		return new HSVA([
			hue,
			saturation,
			value,
			t.interpolate(alpha, 0)
		]);

	public function opaque(t : Float) : HSVA
		return new HSVA([
			hue,
			saturation,
			value,
			t.interpolate(alpha, 1)
		]);

	public function interpolate(other : HSVA, t : Float) : HSVA
		return new HSVA([
			t.interpolate(hue, other.hue),
			t.interpolate(saturation, other.saturation),
			t.interpolate(value, other.value),
			t.interpolate(alpha, other.alpha)
		]);

	inline function get_hue() : Float
		return this[0];
	inline function get_huef() : Float
		return this[0];
	inline function get_saturation() : Float
		return this[1];
	inline function get_value() : Float
		return this[2];
	inline function get_alpha() : Float
		return this[3];
}