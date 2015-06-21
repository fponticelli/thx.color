package thx.color;

import utest.Assert;

class TestXyz {
  public function new() { }

  public function testBasics() {
    var color = Xyz.create(0.5, 0.4, 0.3);
    Assert.equals(0.5, color.x);
    Assert.equals(0.4, color.y);
    Assert.equals(0.3, color.z);
  }

  public function testString() {
    var color = Xyz.create(0.5, 0.4, 0.3);
    Assert.equals("xyz(0.5,0.4,0.3)", color.toString());
  }

  public function testParse() {
    var color : Xyz = "xyz(0.5,0.4,0.3)";
    Assert.equals("xyz(0.5,0.4,0.3)", color.toString());
  }

  public function testFromFloat() {
    var s : Xyz = "xyz(0.5,0.4,0.3)",
        f : Xyz = [0.5,0.4,0.3];
    Assert.isTrue(s == f);
  }
}
