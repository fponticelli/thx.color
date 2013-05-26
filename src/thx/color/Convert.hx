/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;
import thx.core.Floats;
using Math;

class ConvertRGB
{
	inline public static function toCMYK(rgb : RGB)
		return ConvertRGBChannels.toCMYK(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
	inline public static function toHSL(rgb : RGB)
		return ConvertRGBChannels.toHSL(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
	inline public static function toHSV(rgb : RGB)
		return ConvertRGBChannels.toHSV(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
	inline public static function toGrey(rgb : RGB)
		return ConvertRGBChannels.toGrey(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
	inline public static function toPerceivedGrey(rgb : RGB)
		return ConvertRGBChannels.toPerceivedGrey(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
	inline public static function toPerceivedAccurateGrey(rgb : RGB)
		return ConvertRGBChannels.toPerceivedAccurateGrey(rgb.red / 255, rgb.green / 255, rgb.blue / 255);
}

class ConvertRGBX
{
	inline public static function toCMYK(rgb : RGBX)
		return ConvertRGBChannels.toCMYK(rgb.redf, rgb.greenf, rgb.bluef);
	inline public static function toHSL(rgb : RGBX)
		return ConvertRGBChannels.toHSL(rgb.redf, rgb.greenf, rgb.bluef);
	inline public static function toHSV(rgb : RGBX)
		return ConvertRGBChannels.toHSV(rgb.redf, rgb.greenf, rgb.bluef);
	inline public static function toRGB(rgb : RGBX)
		return RGB.fromFloats(rgb.redf, rgb.greenf, rgb.bluef);
	inline public static function toGrey(rgb : RGBX)
		return ConvertRGBChannels.toGrey(rgb.redf, rgb.greenf, rgb.bluef);
	inline public static function toPerceivedGrey(rgb : RGBX)
		return ConvertRGBChannels.toPerceivedGrey(rgb.redf, rgb.greenf, rgb.bluef);
	inline public static function toPerceivedAccurateGrey(rgb : RGBX)
		return ConvertRGBChannels.toPerceivedAccurateGrey(rgb.redf, rgb.greenf, rgb.bluef);
}

class ConvertColor
{
	inline public static function toCMYK(color : Color)
		return ConvertRGBX.toCMYK(color.toRGBX());
	inline public static function toHSL(color : Color)
		return ConvertRGBX.toHSL(color.toRGBX());
	inline public static function toHSV(color : Color)
		return ConvertRGBX.toHSV(color.toRGBX());
	inline public static function toRGB(color : Color)
		return ConvertRGBX.toRGB(color.toRGBX());
	inline public static function toGrey(color : Color)
		return ConvertRGBX.toGrey(color.toRGBX());
	inline public static function toPerceivedGrey(color : Color)
		return ConvertRGBX.toPerceivedGrey(color.toRGBX());
	inline public static function toPerceivedAccurateGrey(color : Color)
		return ConvertRGBX.toPerceivedAccurateGrey(color.toRGBX());
}

class ConvertRGBChannels
{
	public inline static function toGrey(r : Float, g : Float, b : Float)
		return new Grey(r * .2126 + g * .7152 + b * .0722);
	
	public inline static function toPerceivedGrey(r : Float, g : Float, b : Float)
		return new Grey(r * .299 + g * .587 + b * .114);
	
	public inline static function toPerceivedAccurateGrey(r : Float, g : Float, b : Float)
		return new Grey(Math.pow(r, 2) * .241 + Math.pow(g, 2) * .691 + Math.pow(b, 2) * .068);
	
	static function toHSLArray(r : Float, g : Float, b : Float)
	{
		var	min = r.min(g).min(b),
			max = r.max(g).max(b),
			delta = max - min,
			h,
			s,
			l = (max + min) / 2;
		if (delta == 0.0)
			s = h = 0.0;
		else {
			s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
			if (r == max)
				h = (g - b) / delta + (g < b ? 6 : 0);
			else if (g == max)
				h = (b - r) / delta + 2;
			else
				h = (r - g) / delta + 4;
			h *= 60;
		}
		return [h, s, l];
	}
	
	static function toHSVArray(r : Float, g : Float, b : Float)
	{
		var	min = r.min(g).min(b),
			max = r.max(g).max(b),
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
		
		if (r == max)
			h = (g - b) / delta;
		else if (g == max)
			h = 2 + (b - r) / delta;
		else
			h = 4 + (r - g) / delta;
			
		h *= 60;
		if (h < 0)
			h += 360;
		return [h, s, v];
	}
	
	public static function toHSL(r : Float, g : Float, b : Float) : HSL
	{
		var arr = toHSLArray(r, g, b);
		return new HSL(arr[0], arr[1], arr[2]);
	}
	
	public static function toHSV(r : Float, g : Float, b : Float) : HSV
	{
		var arr = toHSVArray(r, g, b);
		return new HSV(arr[0], arr[1], arr[2]);
	}
	
	public static function toCMYK(r : Float, g : Float, b : Float) : CMYK
	{
		var c = 0.0, y = 0.0, m = 0.0, k;
		if (r + g + b == 0)
		{
			k = 1.0;
		} else {
			c = 1 - r;
			m = 1 - g;
			y = 1 - b;
			k = c.min(m).min(y);
			c = (c - k) / (1 - k);
			m = (m - k) / (1 - k);
			y = (y - k) / (1 - k);
		}
		return new CMYK(c, m, y, k);
	}
}