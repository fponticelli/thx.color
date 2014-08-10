
package thx.color;

import utest.Assert;
using thx.color.Convert;

class TestHSV {
	public function new() { }

	public function testBasics() {
		var hsv = new HSV(1, 0, 0);
		Assert.equals(1, hsv.hue);
		Assert.equals(0, hsv.saturation);
		Assert.equals(0, hsv.value);
	}

	public function testParse() {
		var hsv = HSV.parseHSV("hsv(0,0%,100%)");
		Assert.equals("hsv(0,0%,100%)", hsv.toString());
	}

	public function testStrings() {
		var hsv = new HSV(0, 0, 1);
		Assert.equals("hsv(0,0%,100%)", hsv.toString());
		Assert.equals("hsva(0,0%,100%,0.25)", hsv.toStringAlpha(0.25));
		Assert.equals("#FFFFFF", hsv.toHex());
		Assert.equals("rgb(100%,100%,100%)", hsv.toCSS3());
		Assert.equals("rgba(100%,100%,100%,0.5)", hsv.toCSS3Alpha(0.5));
	}

	public function testConvert() {
		var tests = [
			{ rgb : new RGBX(1.00,1.00,1.00),    hsv : new HSV(0,0,1) },
			{ rgb : new RGBX(0.75,0.75,0.00),    hsv : new HSV(60,1,0.75) },
			{ rgb : new RGBX(0.931,0.463,0.315), hsv : new HSV(14.3,0.661,0.931) }
		];
		for (test in tests)
		{
			Assert.isTrue(test.rgb.equalRGB(test.hsv), "expected " + test.rgb.toHex() + " but was " + test.hsv.toHex() + " for " + test.hsv);
			var c = test.rgb.toHSV();
			Assert.isTrue(c.equalRGB(test.hsv), "expected " + c.toHex() + " but was " + test.hsv.toHex() + " for " + test.hsv);
		}
	}
}
