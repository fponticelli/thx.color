/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import utest.Assert;

class TestRGBHR
{
	public function new() { }
	
	public function testBasics()
	{
		var red = new RGBHR(1, 0, 0);
		Assert.equals(0xFF, red.red);
		Assert.equals(0x00, red.green);
		Assert.equals(0x00, red.blue);
	}
	
	public function testSetRgb()
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
	
	public function testSetRgbf()
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
	
	public function testToRgb64()
	{
		
	}
	
	public function testToRgb8()
	{
		
	}
}