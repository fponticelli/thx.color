/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import thx.color.ColorParser;
using StringTools;
using thx.core.Floats;
using thx.core.Ints;
using Math;

class RGBX extends Color
{
	public static function parseRGBX(s : String) : Null<RGBX>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : RGBXAssembler.instance.toSolid(info);
	}
	
	public static function parse(s : String) : Null<Color>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : RGBXAssembler.instance.toColor(info);
	}
	
	inline public static function fromInts(red : Int, green : Int, blue : Int)
		return new RGBX(red / 255, green / 255, blue / 255);
	public var red(get, set) : Int;
	public var green(get, set) : Int;
	public var blue(get, set) : Int;
	@:isVar public var redf(get, set) : Float;
	@:isVar public var greenf(get, set) : Float;
	@:isVar public var bluef(get, set) : Float;
	
	public function new(red : Float, green : Float, blue : Float)
	{
		this.redf   = red.normalize();
		this.greenf = green.normalize();
		this.bluef  = blue.normalize();
	}
	
	override public function toRGBX()
		return clone();
	
	override public function clone() : RGBX
		return new RGBX(redf, greenf, bluef);
	
	override public function toCSS3()
		return toString();
	override public function toCSS3Alpha(alpha : Float)
		return toStringAlpha(alpha);
	override public function toString()
		return 'rgb(${redf*100}%,${greenf*100}%,${bluef*100}%)';
	override public function toStringAlpha(alpha : Float)
		return 'rgba(${redf*100}%,${greenf*100}%,${bluef*100}%,${alpha.normalize()})';
	override public function toHex(prefix = "#")
		return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}';
	
	function get_red()
		return (redf   * 255).round();
	function get_green()
		return (greenf * 255).round();
	function get_blue()
		return (bluef  * 255).round();
	
	function set_red(value : Int)
	{
		redf = value.clamp(0, 255) / 255;
		return value;
	}
	function set_green(value : Int)
	{
		greenf = value.clamp(0, 255) / 255;
		return value;
	}
	function set_blue(value : Int)
	{
		bluef = value.clamp(0, 255) / 255;
		return value;
	}
	
	function get_redf()
		return redf;
	function get_greenf()
		return greenf;
	function get_bluef()
		return bluef;
	
	function set_redf(value : Float)
		return redf   = value.normalize();
	function set_greenf(value : Float)
		return greenf = value.normalize();
	function set_bluef(value : Float)
		return bluef  = value.normalize();
}

class RGBXAssembler extends ColorAssembler<RGBX>
{
	public static var instance(default, null) : RGBXAssembler = new RGBXAssembler();
	function new() { }
	override public function toSolid(info : ColorInfo) : Null<RGBX>
	{
		if (info.name != "rgb" || info.channels.length < 3) return null;
		var red   = ColorParser.getFloatChannel(info.channels[0]),
			green = ColorParser.getFloatChannel(info.channels[1]),
			blue  = ColorParser.getFloatChannel(info.channels[2]);
		if (null == red || null == green || null == blue)
			return null;
		return new RGBX(red, green, blue);
	}
}
