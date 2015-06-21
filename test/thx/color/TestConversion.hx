package thx.color;

import thx.color.Color;
import utest.Assert;
using thx.Iterators;

class TestConversion {
  public function new() {}

  public function testCieLab() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : CieLab = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCieLCh() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : CieLCh = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCieLuv() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : CieLuv = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCmy() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Cmy = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCmyk() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Cmyk = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCubehelix() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : CubeHelix = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHcl() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Hcl = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHsl() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Hsl = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHsv() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Hsv = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHunterLab() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : HunterLab = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testRgbx() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Rgbx = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testXyz() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Xyz = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testYuv() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Yuv = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testYxy() {
    Color.names.keys().map(function(name) {
      var expected : Rgb = Color.names.get(name),
          color : Yxy = expected,
          test : Rgb = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }
}
