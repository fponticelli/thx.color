/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

class HSL extends Color
{
	@:isVar public var hue(get, set) : Float;
	@:isVar public var saturation(get, set) : Float;
	@:isVar public var lightness(get, set) : Float;
	
	public function new(hue : Float, saturation : Float, lightness : Float) 
	{
		this.hue = hue;
		this.saturation = saturation;
		this.lightness = lightness;
	}
	
	override public function toRGBHR()
	{
		return new RGBHR(
			_c(hue + 120, saturation, lightness),
			_c(hue, saturation, lightness),
			_c(hue - 120, saturation, lightness)
		);
	}
	
	override public function clone() : HSL return new HSL(hue, saturation, lightness)
	override public function toCSS3() return toString()
	override public function toCSS3Alpha(alpha : Float) return toStringAlpha(alpha)
	override public function toString() return 'hsl($hue,$(saturation*100)%,$(lightness*100)%)'
	override public function toStringAlpha(alpha : Float) return 'hsla($hue,$(saturation*100)%,$(lightness*100)%,$(alpha.normalize()*100)%)'
	
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
