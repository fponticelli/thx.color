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
abstract RGBX(Array<Float>) {
	inline public static function fromInts(red : Int, green : Int, blue : Int)
		return new RGBX([red / 255, green / 255, blue / 255]);

	public var red(get, never) : Int;
	public var green(get, never) : Int;
	public var blue(get, never) : Int;
	public var redf(get, never) : Float;
	public var greenf(get, never) : Float;
	public var bluef(get, never) : Float;

	inline public static function fromFloats(red : Float, green : Float, blue : Float)
		return new RGBX([red,green,blue]);

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
		if (red + green + blue == 0) {
			k = 1.0;
		} else {
			c = 1 - red;
			m = 1 - green;
			y = 1 - blue;
			k = c.min(m).min(y);
			c = (c - k) / (1 - k);
			m = (m - k) / (1 - k);
			y = (y - k) / (1 - k);
		}
		return new CMYK([c, m, y, k]);
	}

	@:to public inline function toGrey()
		return new Grey(red * .2126 + green * .7152 + blue * .0722);

	public inline function toPerceivedGrey()
		return new Grey(red * .299 + green * .587 + blue * .114);

	public inline function toPerceivedAccurateGrey()
		return new Grey(Math.pow(red, 2) * .241 + Math.pow(green, 2) * .691 + Math.pow(blue, 2) * .068);

	@:to public function toHSL() {
		var	min = red.min(green).min(blue),
			max = red.max(green).max(blue),
			delta = max - min,
			h,
			s,
			l = (max + min) / 2;
		if (delta == 0.0)
			s = h = 0.0;
		else {
			s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
			if (red == max)
				h = (green - blue) / delta + (green < blue ? 6 : 0);
			else if (green == max)
				h = (blue - red) / delta + 2;
			else
				h = (red - green) / delta + 4;
			h *= 60;
		}
		return new HSL([h, s, l]);
	}

	@:to public function toHSV() {
		var	min = red.min(green).min(blue),
			max = red.max(green).max(blue),
			delta = max - min,
			h : Float,
			s : Float,
			v : Float = max;
		if (delta != 0)
			s = delta / max;
		else {
			s = 0;
			h = -1;
			return [h, s, v];
		}

		if (red == max)
			h = (green - blue) / delta;
		else if (green == max)
			h = 2 + (blue - red) / delta;
		else
			h = 4 + (red - green) / delta;

		h *= 60;
		if (h < 0)
			h += 360;
		return new HSV([h, s, v]);
	}

	@:to inline public function toRGB()
		return RGB.fromFloats(redf, greenf, bluef);

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