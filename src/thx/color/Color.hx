package thx.color;

using StringTools;

class Color {
	public function toRGBX() : RGBX
	{
		return throw "abstract method, must override";
	}
	public function clone() : Color
	{
		return throw "abstract method, must override";
	}
	public function toHex(prefix = "#")
	{
		return toRGBX().toHex(prefix);
	}
	public function toCSS3() {
		return toRGBX().toCSS3();
	}
	public function toString()
	{
		return toRGBX().toString();
	}
	public function toCSS3Alpha(alpha : Float)
	{
		return toRGBX().toCSS3Alpha(alpha);
	}
	public function toStringAlpha(alpha : Float)
	{
		return toRGBX().toStringAlpha(alpha);
	}
	public function equalRGB(other : Color)
	{
		var a = toRGBX(),
			b = other.toRGBX();
		return a.red == b.red && a.green == b.green && a.blue == b.blue;
	}
	
	@:access(thx.color.ColorAlpha)
	public function withAlpha(alpha : Float) return new ColorAlpha(this.clone(), alpha)
}

