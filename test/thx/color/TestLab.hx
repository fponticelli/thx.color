package thx.color;

import utest.Assert;
import thx.color.palettes.Web;

class TestLab {
  public function new() { }

  public function testBasics() {
    var color = Lab.create(100, 10, -10);
    Assert.equals(100, color.l);
    Assert.equals(10,  color.a);
    Assert.equals(-10, color.b);
  }

  public function testString() {
    var color = Lab.create(100, 10, -10);
    Assert.equals("lab(100,10,-10)", color.toString());
  }

  public function testParse() {
    var color : Lab = "lab(100,10,-10)";
    Assert.equals("lab(100,10,-10)", color.toString());
  }

  public function testFromFloat() {
    var s : Lab = "lab(50,10,-10)",
        f : Lab = [50.0,10.0,-10.0];
    Assert.same(s, f);
  }

  public function testFromString() {
    var s = "lab(50,10,-10)";
    var color = Lab.create(50, 10, -10);
    Assert.same(color, Lab.fromString(s));
  }

  public function testDistance() {
    var orange : Lab = Web.orange,
        red : Lab = Web.red,
        blue : Lab = Web.blue,
        distOrangeRed = orange.distance(red),
        distOrangeBlue = orange.distance(blue);
    Assert.isTrue(distOrangeRed < distOrangeBlue);
  }

  public function testMatch() {
    var arr : Array<Lab> = [Web.red, Web.blue];
    Assert.isTrue((Web.orange : Lab).match(arr) == (Web.red : Lab));
  }
}
