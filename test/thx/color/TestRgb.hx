package thx.color;

import utest.Assert;
import thx.color.Rgba;

class TestRgb {
  public function new() { }

  public function testBasics() {
    var red = new Rgb(0xFF0000);
    Assert.equals(0xFF, red.red);
    Assert.equals(0x00, red.green);
    Assert.equals(0x00, red.blue);

    var green = new Rgb(0x00FF00);
    Assert.equals(0x00, green.red);
    Assert.equals(0xFF, green.green);
    Assert.equals(0x00, green.blue);

    var blue = new Rgb(0x0000FF);
    Assert.equals(0x00, blue.red);
    Assert.equals(0x00, blue.green);
    Assert.equals(0xFF, blue.blue);

    var cyan = new Rgb(0x00FFFF);
    Assert.equals(0x00, cyan.red);
    Assert.equals(0xFF, cyan.green);
    Assert.equals(0xFF, cyan.blue);

    var yellow = new Rgb(0xFFFF00);
    Assert.equals(0xFF, yellow.red);
    Assert.equals(0xFF, yellow.green);
    Assert.equals(0x00, yellow.blue);

    var magenta = new Rgb(0xFF00FF);
    Assert.equals(0xFF, magenta.red);
    Assert.equals(0x00, magenta.green);
    Assert.equals(0xFF, magenta.blue);

    var white = new Rgb(0xFFFFFF);
    Assert.equals(0xFF, white.red);
    Assert.equals(0xFF, white.green);
    Assert.equals(0xFF, white.blue);

    var black = new Rgb(0x000000);
    Assert.equals(0x00, black.red);
    Assert.equals(0x00, black.green);
    Assert.equals(0x00, black.blue);
  }

  public function testStrings() {
    var color = new Rgb(0x00AAFF);
    Assert.equals("#00AAFF", color.toHex());
    Assert.equals("#00AAFF", color.toString());
    Assert.equals("rgb(0,170,255)", color.toCss3());
  }

  public function testFromString() {
    Assert.isTrue(new Rgb(0xFF0000).equals("#ff0000"));
    Assert.isTrue(new Rgb(0xFF0000).equals("#f00"));
    Assert.isTrue(new Rgb(0xFF0000).equals("rgb(255,0,0)"));
    Assert.isTrue(new Rgb(0xFF0000).equals("rgb(100%,0,0)"));

    Assert.isTrue(new Rgba(0x00FF00FF).equals("#ff00ff00"));
    Assert.isTrue(new Rgba(0x00FF00FF).equals("#f0f0"));
    Assert.isTrue(new Rgba(0x00FF00FF).equals("rgba(0,255,0,1)"));
    Assert.isTrue(new Rgba(0x00FF00FF).equals("rgba(0,100%,0,1)"));
  }

  public function testCombineColor() {
    var rgba     = Rgb.fromInts([255, 0, 0]).withAlphaf(.42),
        bg       = Rgb.fromInts([153, 200, 224]),
        combined = rgba.combineColor(bg),
        result   = Rgb.fromInts([196, 116, 130]);

    Assert.isTrue(result.equals(combined), 'expected ${result} but it is ${combined}');
  }
}
