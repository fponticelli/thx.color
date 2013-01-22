
package thx.color;

import utest.Assert;
using thx.color.Convert;

class TestGrey
{
	public function new() { }
	
	public function testBasics()
	{
		var grey = new Grey(0.2);
		Assert.equals(0.2, grey.grey);
	}
	
	public function testParse()
	{
		var grey = Grey.parseGrey("grey(0.2)");
		Assert.equals(0.2, grey.grey);
		
		Assert.equals("grey(20%)", grey.toString());
		Assert.equals("greya(40%,0.5)", Grey.parse("graya(0.4,0.5)").toString());
	}
	
	public function testStrings()
	{
		var grey = Grey.parse("grey(0.5)");
		Assert.equals("grey(50%)", grey.toString());
		Assert.equals("greya(50%,0.5)", grey.toStringAlpha(0.5));
		
		Assert.equals("#808080", grey.toHex());
		Assert.equals("rgb(50%,50%,50%)", grey.toCSS3());
		Assert.equals("rgba(50%,50%,50%,0.5)", grey.toCSS3Alpha(0.5));
	}
}
