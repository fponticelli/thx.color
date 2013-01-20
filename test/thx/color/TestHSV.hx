
package thx.color;

import utest.Assert;

class TestHSV
{
	public function new() { }
	
	public function testBasics()
	{
		var hsv = new HSV(1, 0, 0);
		Assert.equals(1, hsv.hue);
		Assert.equals(0, hsv.saturation);
		Assert.equals(0, hsv.value);
	}
	
	public function testSetHsv()
	{
		/*
		var color = new RGB(0x000000);
		color.red   = 0xCC;
		color.green = 0xDD;
		color.blue  = 0xEE;
		
		Assert.equals(0xCC, color.red);
		Assert.equals(0xDD, color.green);
		Assert.equals(0xEE, color.blue);
		*/
	}
	
	public function testSetHsvf()
	{
		/*
		var color = new RGB(0x000000);
		color.red   = 0xCC;
		color.green = 0xDD;
		color.blue  = 0xEE;
		
		Assert.equals(0xCC, color.red);
		Assert.equals(0xDD, color.green);
		Assert.equals(0xEE, color.blue);
		*/
	}
	
	public function testStrings()
	{
		/*
		var color = new RGB(0x00AAFF);
		Assert.equals("#00AAFF", color.toCss());
		Assert.equals("rgb(0,170,255)", color.toString());
		*/
	}
	
	public function testFromInts()
	{
		
	}
	
	public function testFromInt()
	{
		
	}
	
	public function testToRGBX()
	{
		
	}
	
	public function testToRgb8()
	{
		
	}
}
