package thx.color;

import utest.Assert;

class TestCieLab {
  public function new() { }

  public function testBasics() {
    var color = CieLab.create(100, 10, -10);
    Assert.equals(100, color.l);
    Assert.equals(10,  color.a);
    Assert.equals(-10, color.b);
  }

  public function testString() {
    var color = CieLab.create(100, 10, -10);
    Assert.equals("cielab(100,10,-10)", color.toString());
  }

  public function testParse() {
    var color : CieLab = "cielab(100,10,-10)";
    Assert.equals("cielab(100,10,-10)", color.toString());
  }

  public function testFromFloat() {
    var s : CieLab = "cielab(50,10,-10)",
        f : CieLab = [50.0,10.0,-10.0];
    Assert.isTrue(s == f);
  }

  public function testDistance() {
    var orange : CieLab = Color.orange,
        red : CieLab = Color.red,
        blue : CieLab = Color.blue,
        distOrangeRed = orange.distance(red),
        distOrangeBlue = orange.distance(blue);
    Assert.isTrue(distOrangeRed < distOrangeBlue);
  }

  public function testMatch() {
    var arr : Array<CieLab> = [Color.red, Color.blue];
    Assert.isTrue((Color.orange : CieLab).match(arr) == (Color.red : CieLab));
  }
}
