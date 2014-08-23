
package thx.color;

import utest.Assert;

class TestHSV {
	public function new() { }

	public function testBasics() {
		var hsv = HSV.fromFloats(1, 0, 0);
		Assert.equals(1, hsv.hue);
		Assert.equals(0, hsv.saturation);
		Assert.equals(0, hsv.value);
	}

	public function testStrings() {
		var hsv = HSV.fromFloats(0, 0, 1);
		Assert.equals("hsv(0,0%,100%)", hsv.toString());
	}
}
