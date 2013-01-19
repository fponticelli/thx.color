/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;
import thx.core.Floats;
using Math;
/*
class ConvertRgba64
{
	inline public static function toRgba8(src : Rgba64)
		return Rgba8.fromInts(src.red, src.green, src.blue, src.alpha)
	inline public static function toHsla(src : Rgba64)
		return ConvertRgbChannels.toHsla(src.redf, src.greenf, src.bluef, src.alpha)
}

class ConvertRgb64
{
	inline public static function toRGBHR(src : RGBHR)
		return src.clone()
	inline public static function toRgba64(src : RGBHR, alpha = 0.0)
		return new Rgba64(src.red, src.green, src.blue, alpha)
	inline public static function toHsl(src : RGBHR)
		return ConvertRgbChannels.toHsl(src.redf, src.bluef, src.greenf)
	inline public static function toHsla(src : RGBHR, alpha = 0.0)
		return ConvertRgbChannels.toHsla(src.redf, src.greenf, src.bluef, alpha)
	inline public static function toCmyk(src : RGBHR)
		return ConvertRgbChannels.toCmyk(src.redf, src.greenf, src.bluef)
}

class ConvertIRgba
{
	inline public static function toRgba8(src : IRgba)
		return Rgba8.fromInts(src.red, src.green, src.blue, src.alpha)
	inline public static function toRgba64(src : IRgba)
		return Rgba64.fromInts(src.red, src.green, src.blue, src.alpha)
	inline public static function toHsla(src : IRgba)
		return ConvertRgbChannels.toHsla(src.red / 255, src.green / 255, src.blue / 255, src.alpha)
}
*/
class ConvertIRgb
{
	inline public static function toRgb8(src : IRgb)
		return RGB.fromInts(src.red, src.green, src.blue)
//	inline public static function toRgba8(src : IRgb, alpha = 0.0)
//		return Rgba8.fromInts(src.red, src.green, src.blue, alpha)
//	inline public static function toRGBHR(src : IRgb)
//		return RGBHR.fromInts(src.red, src.green, src.blue)
//	inline public static function toRgba64(src : IRgb, alpha = 0.0)
//		return Rgba64.fromInts(src.red, src.green, src.blue, alpha)
	inline public static function toHsl(src : IRgb)
		return ConvertRgbChannels.toHsl(src.red / 255, src.blue / 255, src.green / 255)
//	inline public static function toHsla(src : IRgb, alpha = 0.0)
//		return ConvertRgbChannels.toHsla(src.red / 255, src.blue / 255, src.green / 255, alpha)
	inline public static function toCmyk(src : IRgb)
		return ConvertRgbChannels.toCmyk(src.red / 255, src.green / 255, src.blue / 255)
}

class ConvertRgbChannels
{
	static function toHslArray(r : Float, g : Float, b : Float)
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
	
	public static function toHsl(r : Float, g : Float, b : Float)
	{
		var arr = toHslArray(r, g, b);
		return new HSL(arr[0], arr[1], arr[2]);
	}
	/*
	public static function toHsla(r : Float, g : Float, b : Float, a : Float)
	{
		var arr = toHslArray(r, g, b);
		return new Hsla(arr[0], arr[1], arr[2], a);
	}
	*/
	public static function toCmyk(r : Float, g : Float, b : Float)
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