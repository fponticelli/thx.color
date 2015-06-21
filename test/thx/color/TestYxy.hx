package thx.color;

import utest.Assert;

class TestYxy {
  public function new() { }

  public function testBasics() {
    var color = Yxy.create(0.5, 0.4, 0.3);
    Assert.equals(0.5, color.y1);
    Assert.equals(0.4, color.x);
    Assert.equals(0.3, color.y2);
  }

  public function testString() {
    var color = Yxy.create(0.5, 0.4, 0.3);
    Assert.equals("yxy(0.5,0.4,0.3)", color.toString());
  }

  public function testParse() {
    var color : Yxy = "yxy(0.5,0.4,0.3)";
    Assert.equals("yxy(0.5,0.4,0.3)", color.toString());
  }

  public function testFromFloat() {
    var s : Yxy = "yxy(0.5,0.4,0.3)",
        f : Yxy = [0.5,0.4,0.3];
    Assert.isTrue(s == f);
  }
}
