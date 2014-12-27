package thx.color;

import utest.Assert;

class TestXYZ {
  public function new() { }

  public function testBasics() {
    var color = XYZ.create(0.5, 0.4, 0.3);
    Assert.equals(0.5, color.x);
    Assert.equals(0.4, color.y);
    Assert.equals(0.3, color.z);
  }

  public function testString() {
    var color = XYZ.create(0.5, 0.4, 0.3);
    Assert.equals("XYZ(0.5,0.4,0.3)", color.toString());
  }

  public function testParse() {
    var color : XYZ = "XYZ(0.5,0.4,0.3)";
    Assert.equals("XYZ(0.5,0.4,0.3)", color.toString());
  }

  public function testFromFloat() {
    var s : XYZ = "XYZ(0.5,0.4,0.3)",
        f : XYZ = [0.5,0.4,0.3];
    Assert.isTrue(s == f);
  }
}
