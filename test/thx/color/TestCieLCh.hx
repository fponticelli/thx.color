package thx.color;

import utest.Assert;

class TestCieLCh {
  public function new() { }

  public function testBasics() {
    var color = CieLCh.create(0.5, 0.4, -10).normalize();
    Assert.equals(0.5, color.lightness);
    Assert.equals(0.4,  color.chroma);
    Assert.equals(350, color.hue);
  }

  public function testString() {
    var color = CieLCh.create(0.5, 0.4, -10).normalize();
    Assert.equals("cielch(0.5,0.4,350)", color.toString());
  }

  public function testParse() {
    var color : CieLCh = "cielch(100,10,-10)";
    Assert.equals("cielch(100,10,-10)", color.toString());
  }

  public function testFromFloat() {
    var s : CieLCh = "cielch(100,10,-10)",
        f : CieLCh = [100.0,10.0,-10.0];
    Assert.isTrue(s == f);
  }
}
