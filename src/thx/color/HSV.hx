package thx.color;
using thx.core.Floats;
import thx.color.ColorParser;

class HSV extends Color
{
	public static function parseHSV(s : String) : Null<HSV>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : HSVAssembler.instance.toSolid(info);
	}
	
	public static function parse(s : String) : Null<Color>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : HSVAssembler.instance.toColor(info);
	}
	
	@:isVar public var hue(get, set) : Float;
	@:isVar public var saturation(get, set) : Float;
	@:isVar public var value(get, set) : Float;

	public function new(hue : Float, saturation : Float, value : Float)
	{
		this.hue = hue;
		this.saturation = saturation;
		this.value = value;
	}
	override public function toRGBX()
	{
		if (saturation == 0)
			return new RGBX(value, value, value);
		
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

		return new RGBX(r, g, b);
	}

	override public function clone() : HSV
		return new HSV(hue, saturation, value);

	override public function toString()
		return 'hsv($hue,${saturation*100}%,${value*100}%)';
	override public function toStringAlpha(alpha : Float)
		return 'hsva($hue,${saturation*100}%,${value*100}%,${alpha.normalize()})';
	
	function get_hue()
		return hue;
	function set_hue(value : Float)
		return hue = value.wrapCircular(360);
	function get_saturation()
		return saturation;
	function set_saturation(value : Float)
		return saturation = value.normalize();
	function get_value()
		return value;
	function set_value(value : Float)
		return this.value = value.normalize();
}

class HSVAssembler extends ColorAssembler<HSV>
{
	public static var instance(default, null) : HSVAssembler = new HSVAssembler();
	function new() { }
	override public function toSolid(info : ColorInfo) : Null<HSV>
	{
		if (info.name != "hsv" || info.channels.length < 3) return null;
		var hue        = ColorParser.getFloatChannel(info.channels[0]),
			saturation = ColorParser.getFloatChannel(info.channels[1]),
			value      = ColorParser.getFloatChannel(info.channels[2]);
		if (null == hue || null == saturation || null == value)
			return null;
		return new HSV(hue, saturation, value);
	}
}
