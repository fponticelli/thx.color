package thx.color;

import utest.Assert;
import thx.color.*;
using thx.Arrays;
using thx.Iterators;
using thx.Functions;
using thx.Floats;

class TestRoundTrip {
  public function new() {
    tests = [
        Rgbx.create(0.05, 0.10, 0.15), // pure black is not guaranteed to make a clean roundtrip
        Rgbx.create(1, 0, 0),
        Rgbx.create(0, 1, 0),
        Rgbx.create(0.2, 0.2, 1),
        Rgbx.create(0.9, 0.9, 1), // pure white is not guaranteed to make a clean roundtrip
        Rgbx.create(0.2, 0.4, 0.52)
      ]
      .map.fn({
        rgbx: (_ : Rgbx),
        rgb:  (_ : Rgb),
        lab:  (_ : Lab),
        lch:  (_ : LCh),
        cmy:  (_ : Cmy),
        cmyk: (_ : Cmyk),
        ch:   (_ : CubeHelix),
        g:    (_ : Grey),
        hsl:  (_ : Hsl),
        hsv:  (_ : Hsv),
        hl:   (_ : HunterLab),
        xyz:  (_ : Xyz),
        yuv:  (_ : Yuv),
        yxy:  (_ : Yxy)
      });
  }

  var tests : Array<{
    rgbx : Rgbx,
    rgb  : Rgb,
    lab  : Lab,
    lch  : LCh,
    cmy  : Cmy,
    cmyk : Cmyk,
    ch   : CubeHelix,
    g    : Grey,
    hsl  : Hsl,
    hsv  : Hsv,
    hl   : HunterLab,
    xyz  : Xyz,
    yuv  : Yuv,
    yxy  : Yxy
  }>;

  public function testRgbxRoundtrip() {
    tests
      .map.fn({
        // Color Space -> Rgbx -> Color Space
        assertRgbx(_.rgbx, _.lab, _.lab);
        assertRgbx(_.rgbx, _.lch, _.lch);
        assertRgbx(_.rgbx, _.cmy, _.cmy);
        assertRgbx(_.rgbx, _.cmyk, _.cmyk);
        assertRgbx(_.rgbx, _.ch, _.ch);
        assertRgbx(_.rgbx, _.hsl, _.hsl);
        assertRgbx(_.rgbx, _.hsv, _.hsv);
        assertRgbx(_.rgbx, _.hl, _.hl);
        assertRgbx(_.rgbx, _.xyz, _.xyz);
        assertRgbx(_.rgbx, _.yuv, _.yuv);
        assertRgbx(_.rgbx, _.yxy, _.yxy);
      });
  }

  public function testLabRoundtrip() {
    tests
      .map.fn({
        assertLab(_.lab, _.rgbx, _.rgbx);
        assertLab(_.lab, _.lch, _.lch);
        assertLab(_.lab, _.cmy, _.cmy);
        assertLab(_.lab, _.cmyk, _.cmyk);
        assertLab(_.lab, _.ch, _.ch);
        assertLab(_.lab, _.hsl, _.hsl);
        assertLab(_.lab, _.hsv, _.hsv);
        assertLab(_.lab, _.hl, _.hl);
        assertLab(_.lab, _.xyz, _.xyz);
        assertLab(_.lab, _.yuv, _.yuv);
        assertLab(_.lab, _.yxy, _.yxy);
      });
  }

  public function testLChRoundtrip() {
    tests
      .map.fn({
        assertLCh(_.lch, _.lab, _.lab);
        assertLCh(_.lch, _.rgbx, _.rgbx);
        assertLCh(_.lch, _.cmy, _.cmy);
        assertLCh(_.lch, _.cmyk, _.cmyk);
        assertLCh(_.lch, _.ch, _.ch);
        assertLCh(_.lch, _.hsl, _.hsl);
        assertLCh(_.lch, _.hsv, _.hsv);
        assertLCh(_.lch, _.hl, _.hl);
        assertLCh(_.lch, _.xyz, _.xyz);
        assertLCh(_.lch, _.yuv, _.yuv);
        assertLCh(_.lch, _.yxy, _.yxy);
      });
  }

  public function testCmyRoundtrip() {
    tests
      .map.fn({
        assertCmy(_.cmy, _.lab, _.lab);
        assertCmy(_.cmy, _.lch, _.lch);
        assertCmy(_.cmy, _.rgbx, _.rgbx);
        assertCmy(_.cmy, _.cmyk, _.cmyk);
        assertCmy(_.cmy, _.ch, _.ch);
        assertCmy(_.cmy, _.hsl, _.hsl);
        assertCmy(_.cmy, _.hsv, _.hsv);
        assertCmy(_.cmy, _.hl, _.hl);
        assertCmy(_.cmy, _.xyz, _.xyz);
        assertCmy(_.cmy, _.yuv, _.yuv);
        assertCmy(_.cmy, _.yxy, _.yxy);
      });
  }

  public function testCmykRoundtrip() {
    tests
      .map.fn({
        assertCmyk(_.cmyk, _.lab, _.lab);
        assertCmyk(_.cmyk, _.lch, _.lch);
        assertCmyk(_.cmyk, _.cmy, _.cmy);
        assertCmyk(_.cmyk, _.rgbx, _.rgbx);
        assertCmyk(_.cmyk, _.ch, _.ch);
        assertCmyk(_.cmyk, _.hsl, _.hsl);
        assertCmyk(_.cmyk, _.hsv, _.hsv);
        assertCmyk(_.cmyk, _.hl, _.hl);
        assertCmyk(_.cmyk, _.xyz, _.xyz);
        assertCmyk(_.cmyk, _.yuv, _.yuv);
        assertCmyk(_.cmyk, _.yxy, _.yxy);
      });
  }

  public function testCubeHelixRoundtrip() {
    tests
      .map.fn({
        assertCubeHelix(_.ch, _.lab, _.lab);
        assertCubeHelix(_.ch, _.lch, _.lch);
        assertCubeHelix(_.ch, _.cmy, _.cmy);
        assertCubeHelix(_.ch, _.cmyk, _.cmyk);
        assertCubeHelix(_.ch, _.rgbx, _.rgbx);
        assertCubeHelix(_.ch, _.hsl, _.hsl);
        assertCubeHelix(_.ch, _.hsv, _.hsv);
        assertCubeHelix(_.ch, _.hl, _.hl);
        assertCubeHelix(_.ch, _.xyz, _.xyz);
        assertCubeHelix(_.ch, _.yuv, _.yuv);
        assertCubeHelix(_.ch, _.yxy, _.yxy);
      });
  }

  public function testHslRoundtrip() {
    tests
      .map.fn({
        assertHsl(_.hsl, _.lab, _.lab);
        assertHsl(_.hsl, _.lch, _.lch);
        assertHsl(_.hsl, _.cmy, _.cmy);
        assertHsl(_.hsl, _.cmyk, _.cmyk);
        assertHsl(_.hsl, _.ch, _.ch);
        assertHsl(_.hsl, _.rgbx, _.rgbx);
        assertHsl(_.hsl, _.hsv, _.hsv);
        assertHsl(_.hsl, _.hl, _.hl);
        assertHsl(_.hsl, _.xyz, _.xyz);
        assertHsl(_.hsl, _.yuv, _.yuv);
        assertHsl(_.hsl, _.yxy, _.yxy);
      });
  }

  public function testHsvRoundtrip() {
    tests
      .map.fn({
        assertHsv(_.hsv, _.lab, _.lab);
        assertHsv(_.hsv, _.lch, _.lch);
        assertHsv(_.hsv, _.cmy, _.cmy);
        assertHsv(_.hsv, _.cmyk, _.cmyk);
        assertHsv(_.hsv, _.ch, _.ch);
        assertHsv(_.hsv, _.hsl, _.hsl);
        assertHsv(_.hsv, _.hl, _.hl);
        assertHsv(_.hsv, _.rgbx, _.rgbx);
        assertHsv(_.hsv, _.xyz, _.xyz);
        assertHsv(_.hsv, _.yuv, _.yuv);
        assertHsv(_.hsv, _.yxy, _.yxy);
      });
  }

  public function testXyzRoundtrip() {
    tests
      .map.fn({
        assertXyz(_.xyz, _.lab, _.lab);
        assertXyz(_.xyz, _.lch, _.lch);
        assertXyz(_.xyz, _.cmy, _.cmy);
        assertXyz(_.xyz, _.cmyk, _.cmyk);
        assertXyz(_.xyz, _.ch, _.ch);
        assertXyz(_.xyz, _.hsl, _.hsl);
        assertXyz(_.xyz, _.hsv, _.hsv);
        assertXyz(_.xyz, _.hl, _.hl);
        assertXyz(_.xyz, _.rgbx, _.rgbx);
        assertXyz(_.xyz, _.yuv, _.yuv);
        assertXyz(_.xyz, _.yxy, _.yxy);
      });
  }

  public function testYuvRoundtrip() {
    tests
      .map.fn({
        assertYuv(_.xyz, _.lab, _.lab);
        assertYuv(_.xyz, _.lch, _.lch);
        assertYuv(_.xyz, _.cmy, _.cmy);
        assertYuv(_.xyz, _.cmyk, _.cmyk);
        assertYuv(_.xyz, _.ch, _.ch);
        assertYuv(_.xyz, _.hsl, _.hsl);
        assertYuv(_.xyz, _.hsv, _.hsv);
        assertYuv(_.xyz, _.hl, _.hl);
        assertYuv(_.xyz, _.rgbx, _.rgbx);
        assertYuv(_.xyz, _.xyz, _.xyz);
        assertYuv(_.xyz, _.yxy, _.yxy);
      });
  }

  public function testYxyRoundtrip() {
    tests
      .map.fn({
        assertYxy(_.yxy, _.lab, _.lab);
        assertYxy(_.yxy, _.lch, _.lch);
        assertYxy(_.yxy, _.cmy, _.cmy);
        assertYxy(_.yxy, _.cmyk, _.cmyk);
        assertYxy(_.yxy, _.ch, _.ch);
        assertYxy(_.yxy, _.hsl, _.hsl);
        assertYxy(_.yxy, _.hsv, _.hsv);
        assertYxy(_.yxy, _.hl, _.hl);
        assertYxy(_.yxy, _.xyz, _.xyz);
        assertYxy(_.yxy, _.rgbx, _.rgbx);
        assertYxy(_.yxy, _.yuv, _.yuv);
      });
  }

  public function testToStringRoundtrip() {
    tests
      .map.fn({
        var t : Lab = _.lab.toString();
        Assert.isTrue(_.lab == t, 'expected ${_.lab} but was $t');
        var t : LCh = _.lch.toString();
        Assert.isTrue(_.lch == t, 'expected ${_.lch} but was $t');
        var t : Cmy = _.cmy.toString();
        Assert.isTrue(_.cmy == t, 'expected ${_.cmy} but was $t');
        var t : Cmyk = _.cmyk.toString();
        Assert.isTrue(_.cmyk == t, 'expected ${_.cmyk} but was $t');
        var t : CubeHelix = _.ch.toString();
        Assert.isTrue(_.ch == t, 'expected ${_.ch} but was $t');
        var t : Grey = _.g.toString();
        Assert.isTrue(_.g == t, 'expected ${_.g} but was $t');
        var t : Hsl = _.hsl.toString();
        Assert.isTrue(_.hsl == t, 'expected ${_.hsl} but was $t');
        var t : Hsv = _.hsv.toString();
        Assert.isTrue(_.hsv == t, 'expected ${_.hsv} but was $t');
        var t : Rgbx = _.rgbx.toString();
        Assert.isTrue(_.rgbx == t, 'expected ${_.rgbx} but was $t');
        var t : Xyz = _.xyz.toString();
        Assert.isTrue(_.xyz == t, 'expected ${_.xyz} but was $t');
        var t : Yxy = _.yxy.toString();
        Assert.isTrue(_.yxy == t, 'expected ${_.yxy} but was $t');
        var t : Yuv = _.yuv.toString();
        Assert.isTrue(_.yuv == t, 'expected ${_.yuv} but was $t');
      });
  }

  static function assertRgbx(e : Rgbx, t : Rgbx, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertLab(e : Lab, t : Lab, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertLCh(e : LCh, t : LCh, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertCmy(e : Cmy, t : Cmy, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertCmyk(e : Cmyk, t : Cmyk, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertCubeHelix(e : CubeHelix, t : CubeHelix, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.1),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertHsl(e : Hsl, t : Hsl, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.1),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertHsv(e : Hsv, t : Hsv, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.1),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertXyz(e : Xyz, t : Xyz, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertYuv(e : Yuv, t : Yuv, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }

  static function assertYxy(e : Yxy, t : Yxy, s : String, ?pos : haxe.PosInfos) {
    Assert.isTrue(e.nearEquals(t, 0.01),
      '\n      $e expected, but was\n      $t for\n      $s', pos);
  }
}
