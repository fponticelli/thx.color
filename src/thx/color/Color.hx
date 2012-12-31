package thx.color;
using thx.core.Ints;
using StringTools;

class Color {
	public function toRgb64() : Rgb64{
		return null;
	}
	public function toString(){
		var rgb = this.toRgb64();
		return 'rgb($(rgb.redf*100)%,$(rgb.greenf*100)%,$(rgb.bluef*100)%)';
	}
	public function toHex(prefix = "#"){
		var rgb = this.toRgb64();
		return '$prefix$(rgb.red.hex(2))$(rgb.green.hex(2))$(rgb.blue.hex(2))';
	}

}

