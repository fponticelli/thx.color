/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;
import thx.color.ColorParser;

class CMYK extends Color
{
	public static function parse(s : String) : Null<CMYK>
	{
		var info = ColorParser.parseColor(s);
		if (null == info)
			return null;
		else
			return CMYKParser.solidCMYKfromInfo(info);
	}
	
	public static function parseColor(s : String) : Null<Color>
	{
		var info = ColorParser.parseColor(s);
		if (null == info)
			return null;
		else
			return CMYKParser.fromInfo(info);
	}
	
	@:isVar public var black(get, set): Float;
	@:isVar public var cyan(get, set): Float;
	@:isVar public var magenta(get, set): Float;
	@:isVar public var yellow(get, set): Float;
	
	public function new(cyan: Float, magenta: Float, yellow: Float, black: Float)
	{
		this.cyan    = cyan.normalize();
		this.magenta = magenta.normalize();
		this.yellow  = yellow.normalize();
		this.black   = black.normalize();
	}
	
	override public function clone() : CMYK {
		return new CMYK(cyan, magenta, yellow, black);
	}
	override public function toRGBHR()
	{
		return new RGBHR(
			(1 - cyan    - black).normalize(),
			(1 - magenta - black).normalize(),
			(1 - yellow  - black).normalize()
		);
	}

	override public function toString() return 'cmyk($cyan,$magenta,$yellow,$black)'
	override public function toStringAlpha(alpha : Float) return 'cmyka($cyan,$magenta,$yellow,$black,$(alpha.normalize()))'
	
	function get_black() return black
	function set_black(value : Float) return black = value.normalize()
	function get_cyan() return cyan
	function set_cyan(value : Float) return cyan = value.normalize()
	function get_magenta() return magenta
	function set_magenta(value : Float) return magenta = value.normalize()
	function get_yellow() return yellow
	function set_yellow(value : Float) return yellow = value.normalize()
}

private class CMYKParser
{
	public static function solidCMYKfromInfo(info : ColorInfo) : Null<CMYK>
	{
		if (info.name != "cmyk" || info.channels.length < 4) return null;
		var cyan    = ColorParser.getFloatChannel(info.channels[0]),
			magenta = ColorParser.getFloatChannel(info.channels[1]),
			yellow  = ColorParser.getFloatChannel(info.channels[2]),
			black   = ColorParser.getFloatChannel(info.channels[3]);
		if (null == cyan || null == magenta || null == yellow || null == black)
			return null;
		return new CMYK(cyan, magenta, yellow, black);
	}
	
	@:access(thx.color.ColorAlpha)
	public static function fromInfo(info : ColorInfo) : Null<Color>
	{
		var color = solidCMYKfromInfo(info);
		if (null == color)
			return null;
		if (!info.hasAlpha)
			return color;
		if (null == info.channels[4])
			return null;
		var alpha = ColorParser.getFloatChannel(info.channels[4]);
		if (null == alpha)
			return null;
		return new ColorAlpha(color, alpha);
	}
}