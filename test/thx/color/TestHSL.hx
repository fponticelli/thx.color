
package thx.color;

import utest.Assert;
using thx.color.Convert;

class TestHSL {
	public function new() { }

	public function testBasics() {
		var hsl = new HSL(1, 0, 0);
		Assert.equals(1, hsl.hue);
		Assert.equals(0, hsl.saturation);
		Assert.equals(0, hsl.lightness);
	}

	public function testParse() {
		var hsl = HSL.parseHSL("hsl(0,0%,100%)");
		Assert.equals("hsl(0,0%,100%)", hsl.toString());
	}

	public function testStrings() {
		var hsl = new HSL(0, 0, 1);
		Assert.equals("hsl(0,0%,100%)", hsl.toString());
		Assert.equals("hsla(0,0%,100%,0.25)", hsl.toStringAlpha(0.25));
		Assert.equals("#FFFFFF", hsl.toHex());
		Assert.equals("hsl(0,0%,100%)", hsl.toCSS3());
		Assert.equals("hsla(0,0%,100%,0.5)", hsl.toCSS3Alpha(0.5));
	}

	public function testConvert() {
		var tests = [
			{ rgb : RGB.fromFloats(1.00,1.00,1.00), hsl : new HSL(0,0,1) },
			{ rgb : RGB.fromFloats(0.50,0.50,0.50), hsl : new HSL(0,0,0.5) },
			{ rgb : RGB.fromFloats(0.00,0.00,0.00), hsl : new HSL(0,0,0) },
			{ rgb : RGB.fromFloats(1.00,0.00,0.00), hsl : new HSL(0,1,0.5) },
			{ rgb : RGB.fromFloats(0.75,0.75,0.00), hsl : new HSL(60,1,0.375) },
			{ rgb : RGB.fromFloats(0.00,0.50,0.00), hsl : new HSL(120,1,0.25) },
			{ rgb : RGB.fromFloats(0.50,1.00,1.00), hsl : new HSL(180,1,0.75) },
			{ rgb : RGB.fromFloats(0.50,0.50,1.00), hsl : new HSL(240,1,0.75) },
			{ rgb : RGB.fromFloats(0.75,0.25,0.75), hsl : new HSL(300,0.5,0.5) }
		];
		for (test in tests)
		{
			Assert.isTrue(test.rgb.equalRGB(test.hsl), "expected " + test.rgb.toHex() + " but was " + test.hsl.toHex() + " for " + test.hsl);
			var c = test.rgb.toHSL();
			Assert.isTrue(c.equalRGB(test.hsl), "expected " + c.toHex() + " but was " + test.hsl.toHex() + " for " + test.hsl);
		}
	}
}
