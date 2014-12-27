package thx.color;

import utest.Assert;

class TestCMY {
  public function new() { }

  public function testBasics() {
    var color = CMY.create(0.5,0.5,0.5);
    Assert.equals(0.5, color.cyan);
    Assert.equals(0.5, color.magenta);
    Assert.equals(0.5, color.yellow);

    color = CMY.create(2,-2,2);
    Assert.equals(1, color.cyan);
    Assert.equals(0, color.magenta);
    Assert.equals(1, color.yellow);
  }

  public function testString() {
    var color = CMY.create(0.5,0.5,0.5);
    Assert.equals("cmy(0.5,0.5,0.5)", color.toString());
  }

  public function testParse() {
    var color : CMY = "cmy(0.5,0.5,0.5)";
    Assert.equals("cmy(0.5,0.5,0.5)", color.toString());
  }

  public function testFromFloat() {
    var s : CMY = "cmy(0.5,0.5,0.5)",
        f : CMY = [0.5,0.5,0.5];
    Assert.isTrue(s == f);
  }
}
