package thx.color;

import utest.Assert;

class TestCIELCh {
  public function new() { }

  public function testBasics() {
    var color = CIELCh.create(100, 10, -10);
    Assert.equals(100, color.lightness);
    Assert.equals(10,  color.chroma);
    Assert.equals(350, color.hue);
  }

  public function testString() {
    var color = CIELCh.create(100, 10, -10);
    Assert.equals("CIELCh(100,10,350)", color.toString());
  }

  public function testParse() {
    var color : CIELCh = "CIELCh(100,10,-10)";
    Assert.equals("CIELCh(100,10,350)", color.toString());
  }

  public function testFromFloat() {
    var s : CIELCh = "CIELCh(100,10,-10)",
        f : CIELCh = [100.0,10.0,-10.0];
    Assert.isTrue(s == f);
  }
}
