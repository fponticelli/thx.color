/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;
using StringTools;
using Math;

class Rgb8 implements IRgb
{
	inline public static function fromFloats(red : Float, green : Float, blue : Float)
	{
		return fromInts((red.normalize() * 255).round(), (green.normalize() * 255).round(), (blue.normalize() * 255).round());
	}
	inline public static function fromInts(red : Int, green : Int, blue : Int)
	{
		return new Rgb8(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0));
	}
	
	@:isVar public var rgb(get, set) : Int;
	public function new(rgb : Int) 
	{
		this.rgb = rgb;
	}
	
	public function clone() return new Rgb8(rgb)
	
	public var red(get, set)   : Int;
	public var green(get, set) : Int;
	public var blue(get, set)  : Int;
	
	public function toRgb64() return new Rgb64(red / 255, green / 255, blue / 255)
	
	public function toString() return 'rgb($red,$green,$blue)'
	public function toHex(prefix = "#") return '$prefix$(red.hex(2))$(green.hex(2))$(blue.hex(2))'
	
	function get_rgb() return rgb
	function set_rgb(value : Int) return rgb = value
	
	function get_red()   return (rgb >> 16) & 0xFF
	function get_green() return (rgb >> 8) & 0xFF
	function get_blue()  return rgb & 0xFF
	
	function set_red(value : Int)
	{
		rgb = ((value & 0xFF) << 16)|((green & 0xFF) << 8)|((blue & 0xFF) << 0);
		return value;
	}
	function set_green(value : Int)
	{
		rgb = ((red & 0xFF) << 16)|((value & 0xFF) << 8)|((blue & 0xFF) << 0);
		return value;
	}
	function set_blue(value : Int)
	{
		rgb = ((red & 0xFF) << 16)|((green & 0xFF) << 8)|((value & 0xFF) << 0);
		return value;
	}
}