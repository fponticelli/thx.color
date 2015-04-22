package thx.color;

import thx.color.Color;
import utest.Assert;
using thx.Iterators;

class TestConversion {
  public function new() {}

  public function testRGBX() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : RGBX = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCMY() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : CMY = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCMYK() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : CMYK = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHSL() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : HSL = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testHSV() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : HSV = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testXYZ() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : XYZ = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCIELab() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : CIELab = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testCIELCh() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : CIELCh = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }

  public function testXyx() {
    Color.names.keys().map(function(name) {
      var expected : RGB = Color.names.get(name),
          color : Yxy = expected,
          test : RGB = color;
      Assert.equals(expected.toString(), test.toString(), 'expected $expected but was $test for $name');
    });
  }
}