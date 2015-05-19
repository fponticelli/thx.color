package thx.color;

import utest.Assert;

class TestCieLCh {
  public function new() { }

  public function testBasics() {
    var color = CieLCh.create(100, 10, -10);
    Assert.equals(100, color.lightness);
    Assert.equals(10,  color.chroma);
    Assert.equals(350, color.hue);
  }

  public function testString() {
    var color = CieLCh.create(100, 10, -10);
    Assert.equals("CieLCh(100,10,350)", color.toString());
  }

  public function testParse() {
    var color : CieLCh = "CieLCh(100,10,-10)";
    Assert.equals("CieLCh(100,10,350)", color.toString());
  }

  public function testFromFloat() {
    var s : CieLCh = "CieLCh(100,10,-10)",
        f : CieLCh = [100.0,10.0,-10.0];
    Assert.isTrue(s == f);
  }
}
