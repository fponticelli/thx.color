package thx.color;

import haxe.PosInfos;
import utest.Assert;
import thx.color.palettes.Web;

class TestColor {
  public function new() {}

  public function testParseHex() {
    assertEquals(Web.red, Color.parse("#ff0000"));
    assertEquals(Web.red.withAlpha(0), Color.parse("#00ff0000"));
    assertEquals(Web.red, Color.parse("#FF0000"));
    assertEquals(Web.red.withAlpha(0), Color.parse("#00FF0000"));
    assertEquals(Web.red, Color.parse("ff0000"));
    assertEquals(Web.red.withAlpha(0), Color.parse("00ff0000"));
    assertEquals(Web.red, Color.parse("0xff0000"));
    assertEquals(Web.red.withAlpha(0), Color.parse("0x00ff0000"));
  }

  public function testParseGrey() {
    assertEquals(new Grey(0.5), Color.parse("grey(0.5)"));
    assertEquals(new Grey(0.5), Color.parse("grey(50%)"));
  }

  public function testParseCmyk() {
    assertEquals(Cmyk.create(1,0.5,0.25,0.1), Color.parse("cmyk(100%,0.5,25%,0.1)"));
  }

  public function testParseHsl() {
    assertEquals(Web.red, Color.parse("hsl(0,100%,50%)"));
    assertEquals(Web.red, Color.parse("hsl(0deg,100%,50%)"));
    assertEquals(Web.red, Color.parse("hsla(0deg,100%,50%,1)"));
    assertEquals(Web.red, Color.parse("hsla(0,100%,50%,100%)"));
  }

  public function testParseHsv() {
    assertEquals(Web.red, Color.parse("hsv(0,100%, 100%)"));
    assertEquals(Web.red, Color.parse("hsv(0deg,100%,100%)"));
  }

  public function testParseRgb() {
    assertEquals(Web.red, Color.parse("rgb(255,0,0)"));
    assertEquals(Web.red, Color.parse("rgb(100%,0,0)"));
    assertEquals(Rgbx.create(0.5,0,0), Color.parse("rgb(0.5,0,0)"));
    assertEquals(new Rgba(0x00FF00FF), Color.parse("rgba(0,255,0,1)"));
    assertEquals(new Rgba(0x00FF00FF), Color.parse("rgba(0,100%,0,1)"));
  }

  public function assertEquals(a : Rgbxa, b : Rgbxa, ?pos : PosInfos)
    Assert.isTrue(a.equals(b), 'expected $a but was $b', pos);
}
