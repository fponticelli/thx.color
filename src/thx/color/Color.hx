package thx.color;

import thx.color.parse.ColorParser;

/**
Utility class to parse any supported color space to `Rgbxa`.
**/
class Color {
  static var namedColors : Map<String, Rgbx> = new Map();
/**
Parse a string and returns an `Rgba` instance. If the string cannot be parsed
it returns `null`.
**/
  public static function parse(color : String) : Rgbxa {
    var info = ColorParser.parseHex(color);
    if(null == info)
      info = ColorParser.parseColor(color);
    if(null == info)
      return namedColors.get(color);

    return try switch info.name {
      case 'cielab', 'lab':
        CieLab.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'cielch', 'lch':
        CieLCh.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'cieluv', 'luv':
        CieLuv.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'cmy':
        Cmy.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'cmyk':
        Cmyk.fromFloats(ColorParser.getFloatChannels(info.channels, 4, false));
      case 'cubehelix':
        CubeHelix.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'grey', 'gray':
        Grey.create(ColorParser.getFloatChannels(info.channels, 1, false)[0]);
      case 'hcl':
        var c = ColorParser.getFloatChannels(info.channels, 3, false);
        CieLCh.create(c[2], c[1], c[0]);
      case 'hsl':
        Hsl.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'hsla':
        Hsla.fromFloats(ColorParser.getFloatChannels(info.channels, 4, false));
      case 'hsv', 'hsb':
        Hsv.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'hsva':
        Hsva.fromFloats(ColorParser.getFloatChannels(info.channels, 4, false));
      case 'hunterlab':
        HunterLab.fromFloats(ColorParser.getFloatChannels(info.channels, 4, false));
      case 'rgb':
        Rgbx.fromFloats(ColorParser.getFloatChannels(info.channels, 3, true));
      case 'rgba':
        Rgbxa.fromFloats(ColorParser.getFloatChannels(info.channels, 4, true));
      case 'ciexyz', 'xyz':
        Xyz.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'yuv':
        Yuv.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case 'yxy':
        Yxy.fromFloats(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }
}
