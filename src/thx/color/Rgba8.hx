/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

class Rgba8 extends Rgb8, implements IRgba
{
	inline public static function fromInts(red : Int, green : Int, blue : Int, alpha : Float) return new Rgba8(((red & 0xFF) << 16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0), alpha)
	@:isVar public var alpha(get, set) : Float;
	public function new(rgb : Int, alpha : Float)
	{
		super(rgb);
		this.alpha = alpha;
	}
	
	override public function clone() return new Rgba8(rgb, alpha)	
	public function toRgba64() return new Rgba64(red / 255, green / 255, blue / 255, alpha)
	
	function get_alpha() return alpha
	function set_alpha(value : Float) return alpha = value.normalize()
	
	override public function toString() return 'rgba($red,$green,$blue,$alpha)'
}