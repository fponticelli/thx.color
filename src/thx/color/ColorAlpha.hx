package thx.color;
class ColorAlpha extends Color{
	public function toRgba64() : Rgba64{
		return null;
	}
	override public function toString(){
		var rgba = this.toRgba64();
		return 'rgba($(rgba.redf*100)%,$(rgba.greenf*100)%,$(rgba.bluef*100)%)';
	}
}
