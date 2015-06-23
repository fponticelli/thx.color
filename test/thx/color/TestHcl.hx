package thx.color;

import utest.Assert;
import thx.color.CieLCh;

class TestHcl {
  public function new() { }

  public function testParse() {
    var hcl = CieLCh.fromString("hcl(0.5,0,1)");
    Assert.equals(0.5, hcl.hue);
    Assert.equals(0, hcl.chroma);
    Assert.equals(1, hcl.lightness);
  }

  public function testStrings() {
    var hcl = CieLCh.create(1, 0.5, 0);
    Assert.equals("hcl(0,0.5,1)", hcl.toHclString());
  }
}
