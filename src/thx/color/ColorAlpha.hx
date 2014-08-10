package thx.color;

using thx.core.Floats;

class ColorAlpha extends Color {
	public var color : Color;
	@:isVar public var alpha(get, set) : Float;
	function new(color : Color, alpha : Float) {
		this.color = color;
		this.alpha = alpha;
	}

	override public function clone() : ColorAlpha
		return new ColorAlpha(color.clone(), alpha);
	override public function toString()
		return color.toStringAlpha(alpha);
	override public function toCSS3()
		return color.toCSS3Alpha(alpha);

	function get_alpha()
		return alpha;
	function set_alpha(value : Float)
		return alpha = value.normalize();
}
