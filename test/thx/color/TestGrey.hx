package thx.color;

import utest.Assert;

class TestGrey {
  public function new() { }

  public function testBasics() {
    var grey = new Grey(0.2);
    Assert.equals(0.2, grey.grey);
  }

  public function testStrings() {
    var grey = new Grey(0.5);
    Assert.equals("grey(50%)", grey.toString());
  }

  public function testFromString() {
    Assert.isTrue(new Grey(0.2).equals("grey(20%)"));
  }
}
