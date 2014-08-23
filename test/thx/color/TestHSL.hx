
package thx.color;

import utest.Assert;

class TestHSL {
	public function new() { }

	public function testBasics() {
		var hsl = HSL.fromFloats(1, 0, 0);
		Assert.equals(1, hsl.hue);
		Assert.equals(0, hsl.saturation);
		Assert.equals(0, hsl.lightness);
	}

	public function testStrings() {
		var hsl = HSL.fromFloats(0, 0, 1);
		Assert.equals("hsl(0,0%,100%)", hsl.toString());
		Assert.equals("hsl(0,0%,100%)", hsl.toCSS3());
	}
}
