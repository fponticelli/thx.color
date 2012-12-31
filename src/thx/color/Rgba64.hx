/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

class Rgba64 extends Rgb64, implements IRgba
{
	inline public static function fromInts(red : Int, green : Int, blue : Int, alpha : Float) return new Rgba64(red / 255, green / 255, blue / 255, alpha)
	
	@:isVar public var alpha(get, set) : Float;
	public function new(red : Float, green : Float, blue : Float, alpha : Float)
	{
		super(red, green, blue);
		this.alpha = alpha;
	}
	
	public function toRgba64() return clone()
	override public function clone() return new Rgba64(redf, greenf, bluef, alpha)
	
	function get_alpha() return alpha
	function set_alpha(value : Float) return alpha = value.normalize()
	
	override public function toString() return 'rgb($(redf*100)%,$(greenf*100)%,$(bluef*100)%,$alpha)'
}