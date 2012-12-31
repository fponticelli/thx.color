package thx.color;
using thx.core.Floats;
class Hsv extends Color
{
	@:isVar public var hue(get, set) : Float;
	@:isVar public var saturation(get, set) : Float;
	@:isVar public var value(get, set) : Float;

	public function new(hue : Float, saturation : Float, value : Float)
	{
		this.hue = hue;
		this.saturation = saturation;
		this.value = value;
	}
	override public function toRgb64()
	{
		var r = 0.0, g = 0.0, b = 0.0;

		var i = Math.floor(hue * 6);
		var f = hue * 6 - i;
		var p = value * (1 - saturation);
		var q = value * (1 - f * saturation);
		var t = value * (1 - (1 - f) * saturation);

		switch(i % 6){
			case 0: r = value; g = t; b = p;
			case 1: r = q; g = value; b = p;
			case 2: r = p; g = value; b = t;
			case 3: r = p; g = q; b = value;
			case 4: r = t; g = p; b = value;
			case 5: r = value; g = p; b = q;
		}

		return new Rgb64(r,g,b);
	}

	public function clone() return new Hsv(hue, saturation, value)

	function get_hue() return hue
	function set_hue(value : Float) return hue = value.wrapCircular(360)
	function get_saturation() return saturation
	function set_saturation(value : Float) return saturation = value.normalize()
	function get_value() return value
	function set_value(value : Float) return this.value = value.normalize()
}
