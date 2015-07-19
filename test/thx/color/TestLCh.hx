package thx.color;

import utest.Assert;

class TestLCh {
  public function new() { }

  public function testBasics() {
    var color = LCh.create(0.5, 0.4, -10).normalize();
    Assert.equals(0.5, color.lightness);
    Assert.equals(0.4,  color.chroma);
    Assert.equals(350, color.hue);
  }

  public function testString() {
    var color = LCh.create(0.5, 0.4, -10).normalize();
    Assert.equals("lch(0.5,0.4,350)", color.toString());
  }

  public function testParse() {
    var color : LCh = "cielch(100,10,-10)";
    Assert.equals("lch(100,10,-10)", color.toString());
  }

  public function testFromFloat() {
    var s : LCh = "cielch(100,10,-10)",
        f : LCh = [100.0,10.0,-10.0];
    Assert.isTrue(s == f);
  }
}
