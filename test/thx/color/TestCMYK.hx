
package thx.color;

import utest.Assert;

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
		var cmyk = CMYK.parse("CMYK(10%, 0.2, 0.3, 0.4)");
		Assert.notNull(cmyk);
		Assert.equals(0.1, cmyk.cyan);
		Assert.equals(0.2, cmyk.magenta);
		Assert.equals(0.3, cmyk.yellow);
		Assert.equals(0.4, cmyk.black);
		
		Assert.equals("cmyk(0.1,0.2,0.3,0.4)", CMYK.parse("cmyka(0.1,0.2,0.3,0.4,0.5)").toString());
		Assert.equals("cmyka(0.1,0.2,0.3,0.4,0.5)", CMYK.parseColor("cmyka(0.1,0.2,0.3,0.4,0.5)").toString());
	}
	
	public function testStrings()
	{
		var cmyk = CMYK.parse("CMYK(0.1, 0.2, 0.3, 0.4)");
		Assert.equals("cmyk(0.1,0.2,0.3,0.4)", cmyk.toString());
		Assert.equals("cmyka(0.1,0.2,0.3,0.4,0.5)", cmyk.toStringAlpha(0.5));
	}

	public function testToRGBX()
	{
		var cmyk = CMYK.parse("CMYK(0.76, 0.30, 0.77, 0.11)");
		Assert.equals("#ABD7AA", cmyk.toRGBX().toHex()); //171, 215 170
		trace(cmyk.toCSS3());
	}
}
