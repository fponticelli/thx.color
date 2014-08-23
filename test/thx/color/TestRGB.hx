/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import utest.Assert;
import thx.color.RGBA;

class TestRGB {
	public function new() { }

	public function testBasics() {
		var red = new RGB(0xFF0000);
		Assert.equals(0xFF, red.red);
		Assert.equals(0x00, red.green);
		Assert.equals(0x00, red.blue);

		var green = new RGB(0x00FF00);
		Assert.equals(0x00, green.red);
		Assert.equals(0xFF, green.green);
		Assert.equals(0x00, green.blue);

		var blue = new RGB(0x0000FF);
		Assert.equals(0x00, blue.red);
		Assert.equals(0x00, blue.green);
		Assert.equals(0xFF, blue.blue);

		var cyan = new RGB(0x00FFFF);
		Assert.equals(0x00, cyan.red);
		Assert.equals(0xFF, cyan.green);
		Assert.equals(0xFF, cyan.blue);

		var yellow = new RGB(0xFFFF00);
		Assert.equals(0xFF, yellow.red);
		Assert.equals(0xFF, yellow.green);
		Assert.equals(0x00, yellow.blue);

		var magenta = new RGB(0xFF00FF);
		Assert.equals(0xFF, magenta.red);
		Assert.equals(0x00, magenta.green);
		Assert.equals(0xFF, magenta.blue);

		var white = new RGB(0xFFFFFF);
		Assert.equals(0xFF, white.red);
		Assert.equals(0xFF, white.green);
		Assert.equals(0xFF, white.blue);

		var black = new RGB(0x000000);
		Assert.equals(0x00, black.red);
		Assert.equals(0x00, black.green);
		Assert.equals(0x00, black.blue);
	}

	public function testStrings() {
		var color = new RGB(0x00AAFF);
		Assert.equals("#00AAFF", color.toHex());
		Assert.equals("rgb(0,170,255)", color.toString());
	}
}