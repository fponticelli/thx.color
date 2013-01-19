package thx.color;
import thx.core.Floats;
class ColorAlpha extends Color {
	@:isVar public var alpha(get, set) : Int;
	public var alpha : Color;
	public function new(color : Color, alpha : Floats)
	{
		if (null == color) throw "null argument color";
		this.color = color;
		this.alpha = alpha;
	}
	
	override public function toString() return color.toAlphaString(alpha)
	override public function toCss3() return color.toCss3String(alpha)
	
	function get_alpha() return alpha
	function set_alpha(value : Float) return alpha = value.normalize()
}
