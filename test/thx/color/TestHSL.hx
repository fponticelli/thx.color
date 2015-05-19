package thx.color;

import utest.Assert;
import thx.color.Hsla;

class TestHsl {
  public function new() { }

  public function testBasics() {
    var hsl = Hsl.create(1, 0, 0);
    Assert.equals(1, hsl.hue);
    Assert.equals(0, hsl.saturation);
    Assert.equals(0, hsl.lightness);
  }

  public function testStrings() {
    var hsl = Hsl.create(0, 0, 1);
    Assert.equals("hsl(0,0%,100%)", hsl.toString());
    Assert.equals("hsl(0,0%,100%)", hsl.toCss3());
  }

  public function testFromString() {
    Assert.isTrue(Hsl.create(0.5, 0.2, 0.1).equals("hsl(50%,0.2,10%)"));
    Assert.isTrue(Hsla.create(0.5, 0.2, 0.1, 0.3).equals("hsla(50%,0.2,10%,0.3)"));
  }
}
