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
    Assert.equals("cubehelix(0,0%,100%)", cubeHelix.toString());
  }

  public function testFromString() {
    Assert.isTrue(CubeHelix.create(0.5, 0.2, 0.1).equals("cubehelix(50%,0.2,10%)"));
  }
}
