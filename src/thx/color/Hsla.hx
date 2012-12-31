/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

class Hsla extends Hsl, implements IColorAlpha
{
	@:isVar public var alpha(get, set) : Float;
	public function new(hue : Float, saturation : Float, lightness : Float, alpha : Float)
	{
		super(hue, saturation, lightness);
		this.alpha = alpha;
	}
	
	public function toRgba64()
	{
		return new Rgba64(
			Hsl._c(hue + 120, saturation, lightness),
			Hsl._c(hue, saturation, lightness),
			Hsl._c(hue - 120, saturation, lightness),
			alpha
		);
	}
	override public function clone() return new Hsla(hue, saturation, lightness, alpha)
	
	function get_alpha() return alpha
	function set_alpha(value : Float) return alpha = value.normalize()
	
	override public function toString() return 'hsla($hue,$(saturation*100)%,$(lightness*100)%,$alpha)'
}