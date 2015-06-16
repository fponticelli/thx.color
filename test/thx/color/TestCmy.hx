package thx.color;

import utest.Assert;

class TestCmy {
  public function new() { }

  public function testBasics() {
    var color = Cmy.create(0.5,0.5,0.5);
    Assert.equals(0.5, color.cyan);
    Assert.equals(0.5, color.magenta);
    Assert.equals(0.5, color.yellow);

    color = Cmy.create(2,-2,2).normalize();
    Assert.equals(1, color.cyan);
    Assert.equals(0, color.magenta);
    Assert.equals(1, color.yellow);
  }

  public function testString() {
    var color = Cmy.create(0.5,0.5,0.5);
    Assert.equals("cmy(0.5,0.5,0.5)", color.toString());
  }

  public function testParse() {
    var color : Cmy = "cmy(0.5,0.5,0.5)";
    Assert.equals("cmy(0.5,0.5,0.5)", color.toString());
  }

  public function testFromFloat() {
    var s : Cmy = "cmy(0.5,0.5,0.5)",
        f : Cmy = [0.5,0.5,0.5];
    Assert.isTrue(s == f);
  }
}
