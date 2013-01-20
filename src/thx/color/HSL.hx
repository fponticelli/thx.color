/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;
import thx.color.ColorParser;

class HSL extends Color
{
	public static function parseHSL(s : String) : Null<HSL>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : HSLAssembler.instance.toSolid(info);
	}
	
	public static function parse(s : String) : Null<Color>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : HSLAssembler.instance.toColor(info);
	}
	
	@:isVar public var hue(get, set) : Float;
	@:isVar public var saturation(get, set) : Float;
	@:isVar public var lightness(get, set) : Float;
	
	public function new(hue : Float, saturation : Float, lightness : Float)
	{
		this.hue = hue;
		this.saturation = saturation;
		this.lightness = lightness;
	}
	
	override public function toRGBX()
	{
		return new RGBX(
			_c(hue + 120, saturation, lightness),
			_c(hue, saturation, lightness),
			_c(hue - 120, saturation, lightness)
		);
	}
	
	override public function clone() : HSL return new HSL(hue, saturation, lightness)
	override public function toCSS3() return toString()
	override public function toCSS3Alpha(alpha : Float) return toStringAlpha(alpha)
	override public function toString() return 'hsl($hue,${saturation*100}%,${lightness*100}%)'
	override public function toStringAlpha(alpha : Float) return 'hsla($hue,${saturation*100}%,${lightness*100}%,${alpha.normalize()})'
	
	function get_hue() return hue
	function set_hue(value : Float) return hue = value.wrapCircular(360)
	function get_saturation() return saturation
	function set_saturation(value : Float) return saturation = value.normalize()
	function get_lightness() return lightness
	function set_lightness(value : Float) return lightness = value.normalize()
	
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

class HSLAssembler extends ColorAssembler<HSL>
{
	public static var instance(default, null) : HSLAssembler = new HSLAssembler();
	function new() { }
	override public function toSolid(info : ColorInfo) : Null<HSL>
	{
		if (info.name != "hsl" || info.channels.length < 3) return null;
		var hue        = ColorParser.getFloatChannel(info.channels[0]),
			saturation = ColorParser.getFloatChannel(info.channels[1]),
			lightness  = ColorParser.getFloatChannel(info.channels[2]);
		if (null == hue || null == saturation || null == lightness)
			return null;
		return new HSL(hue, saturation, lightness);
	}
}
