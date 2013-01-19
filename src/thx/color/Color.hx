package thx.color;

using StringTools;

class Color {
	public function toRGBHR() : RGBHR {
		return throw "abstract method, must override";
	}
	public function clone() : Color {
		return throw "abstract method, must override";
	}
	public function toHex(prefix = "#") {
		return toRGBHR().toHex(prefix);
	}
	public function toCSS3() {
		return toRGBHR().toCSS3();
	}
	public function toString() {
		return toRGBHR().toString();
	}
	public function toCSS3Alpha(alpha : Float) {
		return toRGBHR().toCSS3Alpha(alpha);
	}
	public function toStringAlpha(alpha : Float) {
		return toRGBHR().toStringAlpha(alpha);
	}
	
	@:access(thx.color.ColorAlpha)
	public function withAlpha(alpha : Float) return new ColorAlpha(this.clone(), alpha)
}

