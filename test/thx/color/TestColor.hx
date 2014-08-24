package thx.color;

import haxe.PosInfos;
import utest.Assert;

class TestColor {
	public function new() {}

	public function testParseNamedColor() {
		assertEquals(Color.red, Color.parse("red"));
	}

	public function testParseHex() {
		assertEquals(Color.red, Color.parse("#ff0000"));
		assertEquals(Color.red.withAlpha(0), Color.parse("#00ff0000"));
		assertEquals(Color.red, Color.parse("#FF0000"));
		assertEquals(Color.red.withAlpha(0), Color.parse("#00FF0000"));
		assertEquals(Color.red, Color.parse("ff0000"));
		assertEquals(Color.red.withAlpha(0), Color.parse("00ff0000"));
		assertEquals(Color.red, Color.parse("0xff0000"));
		assertEquals(Color.red.withAlpha(0), Color.parse("0x00ff0000"));
	}

	public function testParseGrey() {
		assertEquals(new Grey(0.5), Color.parse("grey(0.5)"));
		assertEquals(new Grey(0.5), Color.parse("grey(50%)"));
	}

	public function testParseCMYK() {
		assertEquals(CMYK.fromFloats(1,0.5,0.25,0.1), Color.parse("cmyk(100%,0.5,25%,0.1)"));
	}

	public function testParseHSL() {
		assertEquals(Color.red, Color.parse("hsl(0,100%,50%)"));
		assertEquals(Color.red, Color.parse("hsl(0º,100%,50%)"));
		assertEquals(Color.red, Color.parse("hsl(0deg,100%,50%)"));
		assertEquals(Color.red, Color.parse("hsla(0deg,100%,50%,1)"));
		assertEquals(Color.red, Color.parse("hsla(0,100%,50%,100%)"));
	}

	public function testParseHSV() {
		assertEquals(Color.red, Color.parse("hsv(0,100%, 100%)"));
		assertEquals(Color.red, Color.parse("hsv(0º,100%,100%)"));
		assertEquals(Color.red, Color.parse("hsv(0deg,100%,100%)"));
	}

	public function testParseRGB() {
		assertEquals(Color.red, Color.parse("rgb(255,0,0)"));
		assertEquals(Color.red, Color.parse("rgb(100%,0,0)"));
		assertEquals(RGBX.fromFloats(0.5,0,0), Color.parse("rgb(0.5,0,0)"));
		assertEquals(new RGBA(0xFF00FF00), Color.parse("rgba(0,255,0,1)"));
		assertEquals(new RGBA(0xFF00FF00), Color.parse("rgba(0,100%,0,1)"));
	}

	public function assertEquals(a : RGBXA, b : RGBXA, ?pos : PosInfos)
		Assert.isTrue(a.equals(b), 'expected $a but was $b', pos);
}