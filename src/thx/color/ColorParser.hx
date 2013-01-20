/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import thx.core.Floats;
import thx.core.Ints;

class ColorParser
{
	static var parser(default, null) = new ColorParser();
	public static function parseColor(s : String) : ColorInfo
	{
		return parser.processColor(s);
	}
	
	public static function parseChannel(s : String) : ChannelInfo
	{
		return parser.processChannel(s);
	}
	
	var pattern_color : EReg;
	var pattern_channel : EReg;
	public function new()
	{
		pattern_color   = ~/^\s*([^(]+)\s*\(([^)]*)\)\s*$/i;
		pattern_channel = ~/^\s*(\d*.\d+|\d+)(%|deg|º)?\s*$/i;
	}
	
	public function processColor(s : String) : ColorInfo
	{
		if (!pattern_color.match(s)) return null;
		
		var name = pattern_color.matched(1);

		if (null == name) return null;
		
		name = name.toLowerCase();
		var has_alpha = name.length > 1 && name.substr(-1) == "a";
		if (has_alpha) name = name.substr(0, name.length - 1);
		
		var m2 = pattern_color.matched(2),
			s_channels = null == m2 ? [] : m2.split(","),
			channels = [],
			channel;
		for (s_channel in s_channels)
		{
			channel = processChannel(s_channel);
			if (null == channel) return null;
			channels.push(channel);
		}
		return new ColorInfo(name, has_alpha, channels);
	}
	
	public function processChannel(s : String) : ChannelInfo
	{
		if (!pattern_channel.match(s)) return null;
		var value = pattern_channel.matched(1),
			unit  = pattern_channel.matched(2);
		if (unit == null) unit = "";
		return switch(unit)
		{
			case "%" if (Floats.canParse(value)) :
				CIPercent(Floats.parse(value));
			case ("deg" | "DEG" | "º") if (Floats.canParse(value)) :
				CIDegree(Floats.parse(value));
			case "" if (Ints.canParse(value)) :
				var i = Ints.parse(value);
				if (i == 0 || i == 1) CI0or1(i) else if (i < 256) CIInt8(i) else CIInt(i);
			case "" if (Floats.canParse(value)) :
				CIFloat(Floats.parse(value));
			default: null;
		}
	}

	public static function getFloatChannel(channel : ChannelInfo)
	{
		return switch(channel) {
			case CI0or1(v) :
				v;
			case CIFloat(v) :
				v;
			case CIPercent(v) :
				v / 100;
			default :
				null;
		};
	}
}

class ColorInfo
{
	public var name(default, null) : String;
	public var hasAlpha(default, null) : Bool;
	public var channels(default, null) : Array<ChannelInfo>;
	
	public function new(name : String, has_alpha : Bool, channels : Array<ChannelInfo>)
	{
		this.name = name;
		this.hasAlpha = has_alpha;
		this.channels = channels;
	}
	
	public function toString() return '$name, has alpha: $hasAlpha, channels: $channels'
}

enum ChannelInfo
{
	CIPercent(value : Float);
	CIFloat(value : Float);
	CIDegree(value : Float);
	CIInt8(value : Int);
	CIInt(value : Int);
	CI0or1(value : Int);
}

class ColorAssembler<T : Color>
{
	public function toSolid(info : ColorInfo) : Null<T>
	{
		return throw "abstract method";
	}
	
	@:access(thx.color.ColorAlpha)
	public function toColor(info : ColorInfo) : Null<Color>
	{
		var color = toSolid(info);
		if (null == color)
			return null;
		if (!info.hasAlpha)
			return color;
		if (null == info.channels[info.channels.length-1])
			return null;
		var alpha = ColorParser.getFloatChannel(info.channels[info.channels.length-1]);
		if (null == alpha)
			return null;
		return new ColorAlpha(color, alpha);
	}
}