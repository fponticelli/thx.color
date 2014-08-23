/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using StringTools;
using thx.core.Floats;
using thx.core.Ints;
using Math;

@:access(thx.color.HSL)
@:access(thx.color.HSV)
@:access(thx.color.CMYK)
@:access(thx.color.RGB)
@:access(thx.color.Grey)
@:access(thx.color.RGBXA)
abstract RGBX(Array<Float>) {
	inline public static function fromInts(red : Int, green : Int, blue : Int)
		return new RGBX([red / 255, green / 255, blue / 255]);

	inline public static function fromFloats(red : Float, green : Float, blue : Float)
		return new RGBX([red,green,blue]);

	public var red(get, never) : Int;
	public var green(get, never) : Int;
	public var blue(get, never) : Int;
	public var redf(get, never) : Float;
	public var greenf(get, never) : Float;
	public var bluef(get, never) : Float;

	inline function new(channels : Array<Float>)
		this = channels;

	inline public function toCSS3()
		return toString();
	@:to inline public function toString()
		return 'rgb(${redf*100}%,${greenf*100}%,${bluef*100}%)';
	inline public function toHex(prefix = "#")
		return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	@:to public function toCMYK() : CMYK {
		var c = 0.0, y = 0.0, m = 0.0, k;
		if (redf + greenf + bluef == 0) {
			k = 1.0;
		} else {
			c = 1 - redf;
			m = 1 - greenf;
			y = 1 - bluef;
			k = c.min(m).min(y);
			c = (c - k) / (1 - k);
			m = (m - k) / (1 - k);
			y = (y - k) / (1 - k);
		}
		return new CMYK([c, m, y, k]);
	}

	@:to public inline function toGrey()
		return new Grey(redf * .2126 + greenf * .7152 + bluef * .0722);

	public inline function toPerceivedGrey()
		return new Grey(redf * .299 + greenf * .587 + bluef * .114);

	public inline function toPerceivedAccurateGrey()
		return new Grey(Math.pow(redf, 2) * .241 + Math.pow(greenf, 2) * .691 + Math.pow(bluef, 2) * .068);

	@:to public function toHSL() {
		var	min = redf.min(greenf).min(bluef),
			max = redf.max(greenf).max(bluef),
			delta = max - min,
			h,
			s,
			l = (max + min) / 2;
		if (delta == 0.0)
			s = h = 0.0;
		else {
			s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
			if (redf == max)
				h = (greenf - bluef) / delta + (greenf < blue ? 6 : 0);
			else if (greenf == max)
				h = (bluef - redf) / delta + 2;
			else
				h = (redf - greenf) / delta + 4;
			h *= 60;
		}
		return new HSL([h, s, l]);
	}

	@:to public function toHSV() : HSV {
		var	min = redf.min(greenf).min(bluef),
			max = redf.max(greenf).max(bluef),
			delta = max - min,
			h : Float,
			s : Float,
			v : Float = max;
		if (delta != 0)
			s = delta / max;
		else {
			s = 0;
			h = -1;
			return new HSV([h, s, v]);
		}

		if (redf == max)
			h = (greenf - bluef) / delta;
		else if (greenf == max)
			h = 2 + (bluef - redf) / delta;
		else
			h = 4 + (redf - greenf) / delta;

		h *= 60;
		if (h < 0)
			h += 360;
		return new HSV([h, s, v]);
	}

	@:to inline public function toRGBXA()
		return withAlpha(1.0);

	inline public function withAlpha(alpha : Float)
		return new RGBXA(this.concat([alpha]));

	@:to inline public function toRGB()
		return RGB.fromFloats(redf, greenf, bluef);

	@:op(A==B) public function equals(other : RGBX)
		return redf == other.redf && greenf == other.greenf && bluef == other.bluef;

	public function darker(t : Float)
		return new RGBX([
			t.interpolateBetween(redf, 0),
			t.interpolateBetween(greenf, 0),
			t.interpolateBetween(bluef, 0),
		]);

	public function lighter(t : Float)
		return new RGBX([
			t.interpolateBetween(redf, 1),
			t.interpolateBetween(greenf, 1),
			t.interpolateBetween(bluef, 1),
		]);

	public function interpolate(other : RGBX, t : Float)
		return new RGBX([
			t.interpolateBetween(redf, other.redf),
			t.interpolateBetween(greenf, other.greenf),
			t.interpolateBetween(bluef, other.bluef)
		]);

	inline function get_red()
		return (redf   * 255).round();
	inline function get_green()
		return (greenf * 255).round();
	inline function get_blue()
		return (bluef  * 255).round();

	inline function get_redf()
		return this[0];
	inline function get_greenf()
		return this[1];
	inline function get_bluef()
		return this[2];
}