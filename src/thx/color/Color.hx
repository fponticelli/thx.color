package thx.color;
using thx.core.Ints;
using StringTools;

class Color {
	public function toRgb64() : Rgb64{
		return null;
	}
	public function toHex(prefix = "#"){
		return toRgb64().toHex(prefix);
	}
	public function toString() {
		return toRgb64().toString();
	}
	public function toStringAlpha(alpha : Float) {
		return toRgb64().toStringAlpha(alpha);
	}
}

