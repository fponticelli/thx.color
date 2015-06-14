package thx.color;

import utest.Assert;
import thx.color.Hcl;

class TestHcl {
  public function new() { }

  public function testBasics() {
    var hcl = Hcl.create(1, 0, 0);
    Assert.equals(1, hcl.hue);
    Assert.equals(0, hcl.chroma);
    Assert.equals(0, hcl.luminance);
  }

  public function testStrings() {
    var hcl = Hcl.create(0, 0, 1);
    Assert.equals("hcl(0,0%,100%)", hcl.toString());
  }

  public function testFromString() {
    Assert.isTrue(Hcl.create(0.5, 0.2, 0.1).equals("hcl(50%,0.2,10%)"));
  }
}
