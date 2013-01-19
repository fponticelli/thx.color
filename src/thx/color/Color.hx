package thx.color;

using StringTools;

class Color {
	public function toRgb64() : Rgb64 {
		return throw "abstract method, must override";
	}
	public function clone() : Color {
		return throw "abstract method, must override";
	}
	public function toHex(prefix = "#") {
		return toRgb64().toHex(prefix);
	}
	public function toCss3() {
		return toRgb64().toCss3();
	}
	public function toString() {
		return toRgb64().toString();
	}
	public function toCss3Alpha(alpha : Float) {
		return toRgb64().toCss3Alpha(alpha);
	}
	public function toStringAlpha(alpha : Float) {
		return toRgb64().toStringAlpha(alpha);
	}
	
	@:access(thx.color.ColorAlpha)
	public function withAlpha(alpha : Float) return new ColorAlpha(this.clone(), alpha)
}

