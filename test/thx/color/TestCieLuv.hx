package thx.color;

import utest.Assert;

class TestCieLuv {
  public function new() { }

  public function testBasics() {
    var color = CieLuv.create(0.5, 0.4, 0.6).normalize();
    Assert.equals(0.5, color.l);
    Assert.equals(0.4, color.u);
    Assert.equals(0.6, color.v);
  }

  public function testString() {
    var color = CieLuv.create(0.5, 0.4, 0.6).normalize();
    Assert.equals("cieluv(0.5,0.4,0.6)", color.toString());
  }

  public function testParse() {
    var color : CieLuv = "cieluv(0.5,0.4,0.6)";
    Assert.equals("cieluv(0.5,0.4,0.6)", color.toString());
  }

  public function testFromFloat() {
    var s : CieLuv = "cieluv(0.5,0.4,0.6)",
        f : CieLuv = [0.5,0.4,0.6];
    Assert.isTrue(s == f);
  }

  public function testXyz() {
    var luv = CieLuv.create(0.5, 0.4, 0.6),
        xyz = (luv : Xyz),
        out = (xyz : CieLuv);
    Assert.isTrue(luv.nearEquals(xyz));
  }
}
