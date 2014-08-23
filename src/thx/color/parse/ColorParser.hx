/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color.parse;

import thx.core.Floats;
import thx.core.Ints;

class ColorParser {
	static var parser(default, null) = new ColorParser();
	public static function parseColor(s : String) : ColorInfo
		return parser.processColor(s);

	public static function parseChannel(s : String) : ChannelInfo
		return parser.processChannel(s);

	var pattern_color : EReg;
	var pattern_channel : EReg;
	public function new() {
		pattern_color   = ~/^\s*([^(]+)\s*\(([^)]*)\)\s*$/i;
		pattern_channel = ~/^\s*(\d*.\d+|\d+)([%º]|deg)?\s*$/i;
	}

	static var isPureHex = ~/^([0-9a-f]{2}){3,4}$/i;
	public function processHex(s : String) : ColorInfo {
		if(isPureHex.match(s))
			s = "0x" + s;
		else if (s.substr(0, 1) == "#") {
			if(s.length == 4) // needs dup
				s = "0x" + s.charAt(1) + s.charAt(1) + s.charAt(2) + s.charAt(2) + s.charAt(3) + s.charAt(3);
			else if(s.length == 5) // needs dup
				s = "0x" + s.charAt(1) + s.charAt(1) + s.charAt(2) + s.charAt(2) + s.charAt(3) + s.charAt(3) + s.charAt(4) + s.charAt(4);
			else
				s = "0x" + s.substr(1);
		} else if (s.substr(0,2) != "0x")
			return null;

		if(s.length == 10) {
			// has alpha
			var alpha = Ints.parse('0x' + s.substr(2, 2));
			s = '0x' + s.substr(4);
			var i = Ints.parse(s);
			return new ColorInfo("rgba", [CIInt8((i >> 16) & 0xFF), CIInt8((i >> 8) & 0xFF), CIInt8(i & 0xFF), CIInt8(alpha)]);
		} else {
			var i = Ints.parse(s);
			return new ColorInfo("rgb",  [CIInt8((i >> 16) & 0xFF), CIInt8((i >> 8) & 0xFF), CIInt8(i & 0xFF)]);
		}
	}

	public function processColor(s : String) : ColorInfo {
		var hex = processHex(s);
		if (null != hex)
			return hex;
		if (!pattern_color.match(s))
			return null;

		var name = pattern_color.matched(1);
		if (null == name) return null;

		name = name.toLowerCase();

		var m2 = pattern_color.matched(2),
			s_channels = null == m2 ? [] : m2.split(","),
			channels = [],
			channel;
		for (s_channel in s_channels) {
			channel = processChannel(s_channel);
			if (null == channel) return null;
			channels.push(channel);
		}
		return new ColorInfo(name, channels);
	}

	public function processChannel(s : String) : ChannelInfo {
		if (!pattern_channel.match(s)) return null;
		var value = pattern_channel.matched(1),
			unit  = pattern_channel.matched(2);
		if (unit == null) unit = "";
		return try switch unit {
			case "%" if (Floats.canParse(value)) :
				CIPercent(Floats.parse(value));
			case ("deg" | "DEG" | "º") if (Floats.canParse(value)) :
				CIDegree(Floats.parse(value));
			case "" if (Ints.canParse(value)) :
				var i = Ints.parse(value);
				if (i == 0)
					CIBool(false)
				else if (i == 1)
					CIBool(true)
				else if (i < 256)
					CIInt8(i)
				else CIInt(i);
			case "" if (Floats.canParse(value)) :
				CIFloat(Floats.parse(value));
			default: null;
		} catch(e : Dynamic) return null;
	}

	public static function getFloatChannels(channels : Array<ChannelInfo>, length : Int) {
		if(length != channels.length)
			throw 'invalid number of channels, expected $length but it is ${channels.length}';
		return channels.map(getFloatChannel);
	}

	public static function getFloatChannel(channel : ChannelInfo)
		return switch(channel) {
			case CIBool(v): v ? 1 : 0;
			case CIFloat(v): v;
			case CIInt(v): v;
			case CIDegree(v): v;
			case CIInt8(v): v / 255;
			case CIPercent(v): v / 100;
			default: throw 'can\'t get a float value from $channel';
		};
}

class ColorInfo {
	public var name(default, null) : String;
	public var channels(default, null) : Array<ChannelInfo>;

	public function new(name : String, channels : Array<ChannelInfo>) {
		this.name = name;
		this.channels = channels;
	}

	public function toString()
		return '$name, channels: $channels';
}

enum ChannelInfo {
	CIPercent(value : Float);
	CIFloat(value : Float);
	CIDegree(value : Float);
	CIInt8(value : Int);
	CIInt(value : Int);
	CIBool(value : Bool);
}