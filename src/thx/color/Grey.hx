package thx.color;

using thx.core.Floats;
import thx.color.ColorParser;

class Grey extends Color
{
	public static function parseGrey(s : String) : Null<Grey>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : GreyAssembler.instance.toSolid(info);
	}
	
	public static function parse(s : String) : Null<Color>
	{
		var info = ColorParser.parseColor(s);
		return null == info ? null : GreyAssembler.instance.toColor(info);
	}
	
	@:isVar public var grey(get, set) : Float;
	public function new(grey : Float)
	{
		this.grey = grey.normalize();
	}
	
	override public function clone() : Grey
		return new Grey(grey);
	
	override public function toRGBX()
		return new RGBX(grey, grey, grey);
	
	override public function toString()
		return 'grey(${grey*100}%)';
	override public function toStringAlpha(alpha : Float)
		return 'greya(${grey*100}%,${alpha.normalize()})';
	
	function get_grey()
		return grey;
	function set_grey(value : Float)
		return grey = value;
}

class GreyAssembler extends ColorAssembler<Grey>
{
	public static var instance(default, null) : GreyAssembler = new GreyAssembler();
	function new() { }
	override public function toSolid(info : ColorInfo) : Null<Grey>
	{
		if (info.name != "grey" && info.name != "gray" || info.channels.length < 1) return null;
		var grey = ColorParser.getFloatChannel(info.channels[0]);
		if (null == grey)
			return null;
		return new Grey(grey);
	}
}