
package thx.color;

import utest.Assert;

class TestCmyk {
  public function new() { }

  public function testBasics() {
    var cmyk = Cmyk.create(0.1, 0.2, 0.3, 0.4);
    Assert.equals(0.1, cmyk.cyan);
    Assert.equals(0.2, cmyk.magenta);
    Assert.equals(0.3, cmyk.yellow);
    Assert.equals(0.4, cmyk.black);
  }

  public function testStrings() {
    var cmyk = Cmyk.create(0,1,1,0);
    Assert.equals("cmyk(0,1,1,0)", cmyk.toString());
  }

  public function testWhite() {
    Assert.isTrue(thx.color.palettes.Web.white.toCmyk().equals(Cmyk.create(0,0,0,0)));
  }

  public function testFromString() {
    Assert.isTrue(Cmyk.create(0.5, 0.2, 0.1, 0.3).equals("cmyk(50%,0.2,10%,0.3)"));
  }
}
