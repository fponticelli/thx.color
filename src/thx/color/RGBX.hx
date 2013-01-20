/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using StringTools;
using thx.core.Floats;
using thx.core.Ints;
using Math;

class RGBX extends Color, implements IRgb
{
	inline public static function fromInts(red : Int, green : Int, blue : Int) return new RGBX(red / 255, green / 255, blue / 255)
	public var red(get, set) : Int;
	public var green(get, set) : Int;
	public var blue(get, set) : Int;
	@:isVar public var redf(get, set) : Float;
	@:isVar public var greenf(get, set) : Float;
	@:isVar public var bluef(get, set) : Float;
	
	public function new(red : Float, green : Float, blue : Float)
	{
		this.redf   = red.normalize();
		this.greenf = green.normalize();
		this.bluef  = blue.normalize();
	}
	
	override public function toRGBX() return clone()
	
	override public function clone() : RGBX return new RGBX(redf, greenf, bluef)
	
	override public function toCSS3() return toString()
	override public function toCSS3Alpha(alpha : Float) return toStringAlpha(alpha)
	override public function toString() return 'rgb(${redf*100}%,${greenf*100}%,${bluef*100}%)'
	override public function toStringAlpha(alpha : Float) return 'rgba{$(redf*100})%,${greenf*100}%,${bluef*100}%,${alpha.normalize()*100}%)'
	override public function toHex(prefix = "#") return '$prefix${red.hex(2)}${green.hex(2)}${blue.hex(2)}'
	
	function get_red()   return (redf   * 255).round()
	function get_green() return (greenf * 255).round()
	function get_blue()  return (bluef  * 255).round()
	
	function set_red(value : Int)
	{
		redf = value.clamp(0, 255) / 255;
		return value;
	}
	function set_green(value : Int)
	{
		greenf = value.clamp(0, 255) / 255;
		return value;
	}
	function set_blue(value : Int)
	{
		bluef = value.clamp(0, 255) / 255;
		return value;
	}
	
	function get_redf()   return redf
	function get_greenf() return greenf
	function get_bluef()  return bluef
	
	function set_redf(value : Float)   return redf   = value.normalize()
	function set_greenf(value : Float) return greenf = value.normalize()
	function set_bluef(value : Float)  return bluef  = value.normalize()
}
