package thx.color.parse;

import thx.Floats;
import thx.Ints;

class ColorParser {
  static var parser(default, null) = new ColorParser();
  public static function parseColor(s : String) : ColorInfo
    return parser.processColor(s);

  public static function parseHex(s : String) : ColorInfo
    return parser.processHex(s);

  public static function parseChannel(s : String) : ChannelInfo
    return parser.processChannel(s);

  var pattern_color : EReg;
  var pattern_channel : EReg;
  public function new() {
    pattern_color   = ~/^\s*([^(]+)\s*\(([^)]*)\)\s*$/i;
    pattern_channel = ~/^\s*(-?\d*.\d+|-?\d+)(%|deg|rad)?\s*$/i;
  }

  static var isPureHex = ~/^([0-9a-f]{2}){3,4}$/i;
  public function processHex(s : String) : ColorInfo {
    if(!isPureHex.match(s)) {
      if(s.substr(0, 1) == "#") {
        if(s.length == 4) // needs dup
          s = s.charAt(1) + s.charAt(1) + s.charAt(2) + s.charAt(2) + s.charAt(3) + s.charAt(3);
        else if(s.length == 5)// needs dup
          s = s.charAt(1) + s.charAt(1) + s.charAt(2) + s.charAt(2) + s.charAt(3) + s.charAt(3) + s.charAt(4) + s.charAt(4);
        else
          s = s.substr(1);
      } else if(s.substr(0,2) == "0x")
        s = s.substr(2);
      else
        return null;
    }

    var channels = [];
    while(s.length > 0) {
      channels.push(CIInt8(Std.parseInt('0x${s.substr(0,2)}')));
      s = s.substr(2);
    }
    if(channels.length == 4)
      return new ColorInfo("rgba", channels.slice(1).concat([channels[0]]));
    else
      return new ColorInfo("rgb", channels);
  }

  public function processColor(s : String) : ColorInfo {
    if(!pattern_color.match(s))
      return null;

    var name = pattern_color.matched(1);
    if(null == name) return null;

    name = name.toLowerCase();

    var m2 = pattern_color.matched(2),
      s_channels = null == m2 ? [] : m2.split(","),
      channels = [],
      channel;
    for(s_channel in s_channels) {
      channel = processChannel(s_channel);
      if(null == channel) return null;
      channels.push(channel);
    }
    return new ColorInfo(name, channels);
  }

  public function processChannel(s : String) : ChannelInfo {
    if(!pattern_channel.match(s)) return null;
    var value = pattern_channel.matched(1),
        unit  = pattern_channel.matched(2);
    if(unit == null) unit = "";
    return try switch unit {
      case "%" if(Floats.canParse(value)) :
        CIPercent(Floats.parse(value));
      case("deg" | "DEG") if(Floats.canParse(value)) :
        CIDegree(Floats.parse(value));
      case("rad" | "RAD") if(Floats.canParse(value)) :
        CIDegree(Floats.parse(value) * 180 / Math.PI);
      case "" if(value == '${Ints.parse(value)}') :
        var i = Ints.parse(value);
        if(i == 0)
          CIBool(false)
        else if(i == 1)
          CIBool(true)
        else if(i < 256)
          CIInt8(i)
        else CIInt(i);
      case "" if(Floats.canParse(value)) :
        CIFloat(Floats.parse(value));
      default: null;
    } catch(e : Dynamic) return null;
  }

  public static function getFloatChannels(channels : Array<ChannelInfo>, length : Int, useInt8 : Bool) {
    if(length != channels.length)
      throw 'invalid number of channels, expected $length but it is ${channels.length}';
    return channels.map(getFloatChannel.bind(_, useInt8));
  }

  public static function getInt8Channels(channels : Array<ChannelInfo>, length : Int) {
    if(length != channels.length)
      throw 'invalid number of channels, expected $length but it is ${channels.length}';
    return channels.map(getInt8Channel);
  }

  public static function getFloatChannel(channel : ChannelInfo, useInt8 = true)
    return switch(channel) {
      case CIBool(v): v ? 1 : 0;
      case CIFloat(v): v;
      case CIInt(v): v;
      case CIDegree(v): v;
      case CIInt8(v) if(useInt8): v / 255;
      case CIInt8(v): v;
      case CIPercent(v): v / 100;
      default: throw 'can\'t get a float value from $channel';
    };

  public static function getInt8Channel(channel : ChannelInfo)
    return switch(channel) {
      case CIBool(v) : v ? 1 : 0;
      case CIInt8(v) : v;
      case CIPercent(v): Math.round(255 * v / 100);
      default : throw "unable to extract a valid int8 value";
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
