package thx.color;

import thx.color.Color;
import thx.color.palettes.Web;
import utest.Assert;
using thx.Iterators;

class TestConversion {
  public function new() {}

  public function testCieLab() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : CieLab = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCieLCh() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : CieLCh = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCieLuv() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : CieLuv = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCmy() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Cmy = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCmyk() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Cmyk = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCubehelix() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : CubeHelix = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHsl() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Hsl = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHsv() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Hsv = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHunterLab() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : HunterLab = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testRgbx() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Rgbx = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testXyz() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Xyz = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testYuv() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Yuv = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testYxy() {
    Web.names.keys().map(function(name) {
      var expected : Rgb = Web.names.get(name),
          color : Yxy = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }
}
