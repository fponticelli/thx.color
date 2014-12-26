package thx.color;

import utest.Assert;

class TestCIELCh {
  public function new() { }

  public function testBasics() {
    var color = CIELCh.create(100, 10, -10);
    Assert.equals(100, color.l);
    Assert.equals(10,  color.c);
    Assert.equals(350, color.h);

    color = CIELCh.create(120, 150, -150);
    Assert.equals(100, color.l);
    Assert.equals(150,  color.c);
    Assert.equals(210, color.h);
  }

  public function testString() {
    var color = CIELCh.create(100, 10, -10);
    Assert.equals("CIELCh(100,10,350)", color.toString());
  }

  public function testParse() {
    var color : CIELCh = "CIELCh(100,10,-10)";
    Assert.equals("CIELCh(100,10,350)", color.toString());
  }
}
