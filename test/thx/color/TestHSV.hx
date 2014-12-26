package thx.color;

import utest.Assert;
import thx.color.HSVA;

class TestHSV {
  public function new() { }

  public function testBasics() {
    var hsv = HSV.create(1, 0, 0);
    Assert.equals(1, hsv.hue);
    Assert.equals(0, hsv.saturation);
    Assert.equals(0, hsv.value);
  }

  public function testStrings() {
    var hsv = HSV.create(0, 0, 1);
    Assert.equals("hsv(0,0%,100%)", hsv.toString());
  }

  public function testFromString() {
    Assert.isTrue(HSV.create(0.5, 0.2, 0.1).equals("hsv(50%,0.2,10%)"));
    Assert.isTrue(HSVA.create(0.5, 0.2, 0.1, 0.3).equals("hsva(50%,0.2,10%,0.3)"));
  }
}
