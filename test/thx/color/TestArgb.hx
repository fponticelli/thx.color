package thx.color;

import utest.Assert;
import thx.color.Argb;

class TestArgb {
  public function new() { }

  public function testBasics() {
    var red = new Argb(0xFFFF0000);
    Assert.equals(0xFF, red.alpha);
    Assert.equals(0xFF, red.red);
    Assert.equals(0x00, red.green);
    Assert.equals(0x00, red.blue);

    var green = new Argb(0xCC00FF00);
    Assert.equals(0xCC, green.alpha);
    Assert.equals(0x00, green.red);
    Assert.equals(0xFF, green.green);
    Assert.equals(0x00, green.blue);

    var blue = new Argb(0x000000FF);
    Assert.equals(0x00, blue.alpha);
    Assert.equals(0x00, blue.red);
    Assert.equals(0x00, blue.green);
    Assert.equals(0xFF, blue.blue);

    var cyan = new Argb(0xCC00FFFF);
    Assert.equals(0xCC, cyan.alpha);
    Assert.equals(0x00, cyan.red);
    Assert.equals(0xFF, cyan.green);
    Assert.equals(0xFF, cyan.blue);

    var yellow = new Argb(0xCCFFFF00);
    Assert.equals(0xCC, yellow.alpha);
    Assert.equals(0xFF, yellow.red);
    Assert.equals(0xFF, yellow.green);
    Assert.equals(0x00, yellow.blue);

    var magenta = new Argb(0xCCFF00FF);
    Assert.equals(0xCC, magenta.alpha);
    Assert.equals(0xFF, magenta.red);
    Assert.equals(0x00, magenta.green);
    Assert.equals(0xFF, magenta.blue);

    var white = new Argb(0xCCFFFFFF);
    Assert.equals(0xCC, white.alpha);
    Assert.equals(0xFF, white.red);
    Assert.equals(0xFF, white.green);
    Assert.equals(0xFF, white.blue);

    var black = new Argb(0xCC000000);
    Assert.equals(0xCC, black.alpha);
    Assert.equals(0x00, black.red);
    Assert.equals(0x00, black.green);
    Assert.equals(0x00, black.blue);
  }

  public function testStrings() {
    var color = new Argb(0xCC00AAFF);
    Assert.equals("#CC00AAFF", color.toHex());
    Assert.equals("argb(204,0,170,255)", color.toString());
  }

  public function testFromString() {
    Assert.isTrue(new Argb(0xCCFF00FF).equals("argb(204,255,0,255)"));
    Assert.isTrue(new Argb(0xCCFF00FF).equals("argb(80%,100%,0,255)"));
  }

  public function testCombineColor() {
    var argb     = Argb.fromInts([0, 255, 0, 0]).withAlphaf(.42),
        bg       = Rgb.fromInts([153, 200, 224]),
        combined = argb.combineColor(bg),
        result   = Rgb.fromInts([196, 116, 130]);

    Assert.isTrue(result.equals(combined), 'expected ${result} but it is ${combined}');
  }
}
