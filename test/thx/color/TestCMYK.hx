
package thx.color;

import utest.Assert;
using thx.color.Convert;

class TestCMYK
{
	public function new() { }
	
	public function testBasics()
	{
		var cmyk = new CMYK(0.1, 0.2, 0.3, 0.4);
		Assert.equals(0.1, cmyk.cyan);
		Assert.equals(0.2, cmyk.magenta);
		Assert.equals(0.3, cmyk.yellow);
		Assert.equals(0.4, cmyk.black);
	}
	
	public function testParse()
	{
		var cmyk = CMYK.parseCMYK("CMYK(10%, 0.2, 0.3, 0.4)");
		Assert.notNull(cmyk);
		Assert.equals(0.1, cmyk.cyan);
		Assert.equals(0.2, cmyk.magenta);
		Assert.equals(0.3, cmyk.yellow);
		Assert.equals(0.4, cmyk.black);
		
		Assert.equals("cmyk(0.1,0.2,0.3,0.4)", CMYK.parseCMYK("cmyka(0.1,0.2,0.3,0.4,0.5)").toString());
		Assert.equals("cmyka(0.1,0.2,0.3,0.4,0.5)", CMYK.parse("cmyka(0.1,0.2,0.3,0.4,0.5)").toString());
	}
	
	public function testStrings()
	{
		var cmyk = CMYK.parse("CMYK(0,1,1,0)");
		Assert.equals("cmyk(0,1,1,0)", cmyk.toString());
		Assert.equals("cmyka(0,1,1,0,0.5)", cmyk.toStringAlpha(0.5));
		
		Assert.equals("#FF0000", cmyk.toHex());
		Assert.equals("rgb(100%,0%,0%)", cmyk.toCSS3());
		Assert.equals("rgba(100%,0%,0%,0.5)", cmyk.toCSS3Alpha(0.5));
	}

	public function testConversion()
	{
		var tests = [
			{ rgb : RGB.fromInts(255,0,0),     cmyk : new CMYK(0,1,1,0) },
			{ rgb : RGB.fromInts(255,102,0),   cmyk : new CMYK(0,0.6,1,0) },
			{ rgb : RGB.fromInts(0,255,0),     cmyk : new CMYK(1,0,1,0) },
			{ rgb : RGB.fromInts(102,255,102), cmyk : new CMYK(0.6,0,0.6,0) },
			{ rgb : RGB.fromInts(0,102,255),   cmyk : new CMYK(1,0.6,0,0) },
		];
		for (test in tests)
		{
			Assert.isTrue(test.rgb.equalRGB(test.cmyk), "expected " + test.rgb.toHex() + " but was " + test.cmyk.toHex() + " for " + test.cmyk);
			var c = test.rgb.toCMYK();
			Assert.isTrue(c.equalRGB(test.cmyk), "expected " + c.toHex() + " but was " + test.cmyk.toHex() + " for " + test.cmyk);
		}
	}
}
