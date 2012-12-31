/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import utest.Assert;

class TestRgb8 
{
	public function new() { }
	
	public function testBasics() 
	{
		var red = new Rgb8(0xFF0000);
		Assert.equals(0xFF, red.red);
		Assert.equals(0x00, red.green);
		Assert.equals(0x00, red.blue);
		
		var green = new Rgb8(0x00FF00);
		Assert.equals(0x00, green.red);
		Assert.equals(0xFF, green.green);
		Assert.equals(0x00, green.blue);
		
		var blue = new Rgb8(0x0000FF);
		Assert.equals(0x00, blue.red);
		Assert.equals(0x00, blue.green);
		Assert.equals(0xFF, blue.blue);
		
		var cyan = new Rgb8(0x00FFFF);
		Assert.equals(0x00, cyan.red);
		Assert.equals(0xFF, cyan.green);
		Assert.equals(0xFF, cyan.blue);
		
		var yellow = new Rgb8(0xFFFF00);
		Assert.equals(0xFF, yellow.red);
		Assert.equals(0xFF, yellow.green);
		Assert.equals(0x00, yellow.blue);
		
		var magenta = new Rgb8(0xFF00FF);
		Assert.equals(0xFF, magenta.red);
		Assert.equals(0x00, magenta.green);
		Assert.equals(0xFF, magenta.blue);
		
		var white = new Rgb8(0xFFFFFF);
		Assert.equals(0xFF, white.red);
		Assert.equals(0xFF, white.green);
		Assert.equals(0xFF, white.blue);
		
		var black = new Rgb8(0x000000);
		Assert.equals(0x00, black.red);
		Assert.equals(0x00, black.green);
		Assert.equals(0x00, black.blue);
	}
	
	public function testSet()
	{
		var color = new Rgb8(0x000000);
		color.red   = 0xCC;
		color.green = 0xDD;
		color.blue  = 0xEE;
		
		Assert.equals(0xCC, color.red);
		Assert.equals(0xDD, color.green);
		Assert.equals(0xEE, color.blue);
	}
	
	public function testStrings()
	{
		var color = new Rgb8(0x00AAFF);
		Assert.equals("#00AAFF", color.toHex());
		Assert.equals("rgb(0,170,255)", color.toString());
	}
	
	public function testFromInts()
	{
		
	}
	
	public function testFromFloats()
	{
		
	}
	
	public function testToRgb64()
	{
		
	}
}