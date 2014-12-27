package thx.color;

import utest.Assert;

class TestCIELab {
  public function new() { }

  public function testBasics() {
    var color = CIELab.create(100, 10, -10);
    Assert.equals(100, color.l);
    Assert.equals(10,  color.a);
    Assert.equals(-10, color.b);
  }

  public function testString() {
    var color = CIELab.create(100, 10, -10);
    Assert.equals("CIELab(100,10,-10)", color.toString());
  }

  public function testParse() {
    var color : CIELab = "CIELab(100,10,-10)";
    Assert.equals("CIELab(100,10,-10)", color.toString());
  }

/*
  public function testWhite() {
    Assert.isTrue(Color.white.toCIELab().equals(CIELab.fromFloats(0,0,0,0)));
  }

  public function testFromString() {
    Assert.isTrue(CIELab.fromFloats(0.5, 0.2, 0.1, 0.3).equals("CIELab(50%,0.2,10%,0.3)"));
  }
*/
}
