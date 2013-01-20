
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
		var cmyk = CMYK.parse("CMYK(0.1, 0.2, 0.3, 0.4)");
		Assert.notNull(cmyk);
		Assert.equals(0.1, cmyk.cyan);
		Assert.equals(0.2, cmyk.magenta);
		Assert.equals(0.3, cmyk.yellow);
		Assert.equals(0.4, cmyk.black);
	}
	
	public function testStrings()
	{
		/*
		var color = new RGB(0x00AAFF);
		Assert.equals("#00AAFF", color.toCss());
		Assert.equals("rgb(0,170,255)", color.toString());
		*/
	}
	
	public function testToRgb64()
	{
		
	}
}
