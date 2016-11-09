package thx.color;

import utest.Assert;

class TestIssues {
  public function new() {}

  public function testIssue29() {
    var c1 = Rgba.create(0, 125, 255, 255);
    Assert.equals(255, c1.alpha);
    var rgbxa = c1.toRgbxa();
    Assert.equals(255, rgbxa.alpha);
    Assert.equals(1, rgbxa.alphaf);
    var hsla = c1.toHsla();
    Assert.equals(c1.alpha, hsla.alpha * 255);
    var rgba = hsla.toRgba();
    Assert.equals(c1.alpha, rgba.alpha);

    var c2 = Rgba.create(0, 125, 255, 255).toHsla().toRgba();
    Assert.equals(c1.toString(), c2.toString());
    Assert.equals(c1.toInt(), c2.toInt());
  }
}
