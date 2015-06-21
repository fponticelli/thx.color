package thx.color;

import utest.Assert;
import thx.color.Hsva;

class TestHsv {
  public function new() { }

  public function testBasics() {
    var hsv = Hsv.create(1, 0, 0);
    Assert.equals(1, hsv.hue);
    Assert.equals(0, hsv.saturation);
    Assert.equals(0, hsv.value);
  }

  public function testHsb() {
    var hsb = Hsb.create(1, 0, 0);
    Assert.equals(1, hsb.hue);
    Assert.equals(0, hsb.saturation);
    Assert.equals(0, hsb.value);
  }

  public function testStrings() {
    var hsv = Hsv.create(0, 0, 1);
    Assert.equals("hsv(0,0%,100%)", hsv.toString());
  }

  public function testFromString() {
    Assert.isTrue(Hsv.create(0.5, 0.2, 0.1).equals("hsv(50%,0.2,10%)"));
    Assert.isTrue(Hsva.create(0.5, 0.2, 0.1, 0.3).equals("hsva(50%,0.2,10%,0.3)"));
  }
}
