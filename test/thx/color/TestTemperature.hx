package thx.color;

import utest.Assert;

class TestTemperature {
  public function new() { }

  public function testBasics() {
    var t = new Temperature(5000);
    Assert.equals(5000, t.kelvin);
  }

  public function testStrings() {
    var t = new Temperature(5000);
    Assert.equals("temperature(5000)", t.toString());
  }

  public function testFromString() {
    Assert.isTrue(new Temperature(5000).equals("temperature(5000)"));
  }
}
