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

  public function testFromFloat() {
    var s : CIELab = "CIELab(50,10,-10)",
        f : CIELab = [50.0,10.0,-10.0];
    Assert.isTrue(s == f);
  }

  public function testDistance() {
    var orange : CIELab = Color.orange,
        red : CIELab = Color.red,
        blue : CIELab = Color.blue,
        distOrangeRed = orange.distance(red),
        distOrangeBlue = orange.distance(blue);
    Assert.isTrue(distOrangeRed < distOrangeBlue);
  }

  public function testMatch() {
    var arr : Array<CIELab> = [Color.red, Color.blue];
    Assert.isTrue((Color.orange : CIELab).match(arr) == (Color.red : CIELab));
  }
}
