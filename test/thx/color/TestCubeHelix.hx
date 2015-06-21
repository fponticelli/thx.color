package thx.color;

import utest.Assert;
import thx.color.CubeHelix;

class TestCubeHelix {
  public function new() { }

  public function testBasics() {
    var cubeHelix = CubeHelix.create(1, 0, 0);
    Assert.equals(1, cubeHelix.hue);
    Assert.equals(0, cubeHelix.saturation);
    Assert.equals(0, cubeHelix.lightness);
  }

  public function testStrings() {
    var cubeHelix = CubeHelix.create(0, 0, 1);
    Assert.equals("cubehelix(0,0,1)", cubeHelix.toString());
  }

  public function testFromString() {
    Assert.isTrue(CubeHelix.create(0.5, 0.2, 0.1).equals("cubehelix(50%,0.2,10%)"));
  }

  public function testNearEquals() {
    var c1 = CubeHelix.create(206.182, 0.441, 0.090),
        c2 = CubeHelix.create(206.181, 0.440, 0.090);
    Assert.isFalse(c1 == c2);
    Assert.isTrue(c1.nearEquals(c2, 0.01));
  }
}
