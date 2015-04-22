package thx.color;

import haxe.PosInfos;
import thx.Floats;
import utest.Assert;
import thx.color.parse.ColorParser;

class TestColorParser {
  public function new() {}

  public function testFeatures() {
    assert(
      "a",  [CIInt8(2)],
      "a(2)");
    assert(
      "aa", [CIInt8(2)],
      "aa(2)");
    assert(
      "rgb",  [CIInt8(2)],
      "rgb(2)");
    assert(
      "rgba", [CIInt8(2)],
      "rgba(2)");
    assert(
      "hsla", [CIDegree(1), CIPercent(2), CIPercent(3), CIFloat(0.5)],
      "hsla(1deg,2%,3%,0.5)");
  }

  public function testChannels() {
    assertStringChannel(CIDegree(1),  "1deg");
    assertStringChannel(CIPercent(1), "1%");
    assertStringChannel(CIFloat(0.1), "0.1");
    assertStringChannel(CIBool(false),  "0");
    assertStringChannel(CIBool(true), "1");
    assertStringChannel(CIInt8(2),    "2");
    assertStringChannel(CIInt(256),   "256");
  }

  public function testInvalidColor() {
    Assert.isNull(ColorParser.parseColor("x"));
    Assert.isNull(ColorParser.parseColor("x[]"));
    Assert.isNull(ColorParser.parseColor("x(x)"));
  }

  public function testInvalidChannel()
    Assert.isNull(ColorParser.parseChannel("x"));

  public function assertStringChannel(expected : ChannelInfo, test : String, ?pos : PosInfos)
    assertChannel(expected, ColorParser.parseChannel(test), pos);

  public function assertChannel(expected : ChannelInfo, test : ChannelInfo, ?pos : PosInfos) {
    if (null == test) {
      Assert.fail('channel is null', pos);
      return;
    }
    var ec = Type.enumConstructor(expected),
        tc = Type.enumConstructor(test),
        ep = Type.enumParameters(expected)[0],
        tp = Type.enumParameters(test)[0];
    Assert.equals(ec, tc, pos);
    Assert.equals(ep, tp, pos);
  }

  public function assert(name : String, channels : Array<ChannelInfo>, test_string : String, ?pos : PosInfos) {
    var expected = new ColorInfo(name, channels),
        test = ColorParser.parseColor(test_string);
    if (null == test) {
      Assert.fail("test is null", pos);
      return;
    }
    Assert.equals(expected.name, test.name, pos);
    for (i in 0...expected.channels.length) {
      assertChannel(expected.channels[i], test.channels[i], pos);
    }
  }
}