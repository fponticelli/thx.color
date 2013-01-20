/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import utest.Assert;

class TestRGBX
{
	public function new() { }
	
	public function testBasics()
	{
		var red = new RGBX(1, 0, 0);
		Assert.equals(0xFF, red.red);
		Assert.equals(0x00, red.green);
		Assert.equals(0x00, red.blue);
	}
	
	public function testStrings()
	{
		var color = new RGBX(0, 0, 1);
		Assert.equals("rgb(0%,0%,100%)", color.toCSS3());
		Assert.equals("rgba(0%,0%,100%,0.5)", color.toCSS3Alpha(0.5));
		Assert.equals("#0000FF", color.toHex());
		Assert.equals("rgb(0%,0%,100%)", color.toString());
		Assert.equals("rgba(0%,0%,100%,0.5)", color.toStringAlpha(0.5));
	}
}