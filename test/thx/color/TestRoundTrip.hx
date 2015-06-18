package thx.color;

import utest.Assert;
import thx.color.*;
using thx.Arrays;
using thx.Functions;
using thx.Floats;

class TestRoundTrip {
  public function new() { }

  public function testRoundtrip() {
    var colors : Array<Rgbx> = [
      Rgbx.create(0, 0, 0),
      Rgbx.create(1, 0, 0),
      Rgbx.create(0, 1, 0),
      Rgbx.create(0, 0, 1),
      Rgbx.create(1, 1, 1),
      Rgbx.create(0.2, 0.4, 0.5)
    ];

    colors
      .map.fn({
        rgbx: (_ : Rgbx),
        rgb:  (_ : Rgb),
        lab:  (_ : CieLab),
        lch:  (_ : CieLCh),
        cmy:  (_ : Cmy),
        cmyk: (_ : Cmyk),
        ch:   (_ : CubeHelix),
        g:    (_ : Grey),
        hcl:  (_ : Hcl),
        hsl:  (_ : Hsl),
        hsv:  (_ : Hsv),
        xyz:  (_ : Xyz),
        yxy:  (_ : Yxy)
      })
      .map.fn({
        // Color Space -> Rgbx -> Color Space
        assertRgbx(_.rgbx, _.lab, _.lab);
        assertRgbx(_.rgbx, _.lch, _.lch);
        assertRgbx(_.rgbx, _.cmy, _.cmy);
        assertRgbx(_.rgbx, _.cmyk, _.cmyk);
        assertRgbx(_.rgbx, _.ch, _.ch);
        assertRgbx(_.rgbx, _.hcl, _.hcl);
        assertRgbx(_.rgbx, _.hsl, _.hsl);
        assertRgbx(_.rgbx, _.hsv, _.hsv);
        assertRgbx(_.rgbx, _.xyz, _.xyz);
        assertRgbx(_.rgbx, _.yxy, _.yxy);

        return _;
      })
      .map.fn({
        var t : CieLab = _.lab.toString();
        Assert.isTrue(_.lab == t, 'expected ${_.lab} but was $t');
        var t : CieLCh = _.lch.toString();
        Assert.isTrue(_.lch == t, 'expected ${_.lch} but was $t');
        var t : Cmy = _.cmy.toString();
        Assert.isTrue(_.cmy == t, 'expected ${_.cmy} but was $t');
        var t : Cmyk = _.cmyk.toString();
        Assert.isTrue(_.cmyk == t, 'expected ${_.cmyk} but was $t');
        var t : CubeHelix = _.ch.toString();
        Assert.isTrue(_.ch == t, 'expected ${_.ch} but was $t');
        var t : Grey = _.g.toString();
        Assert.isTrue(_.g == t, 'expected ${_.g} but was $t');
        var t : Hcl = _.hcl.toString();
        Assert.isTrue(_.hcl == t, 'expected ${_.hcl} but was $t');
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

        return _;
      })
      //.map.fn(trace(_))
     ;
  }

  static function assertRgbx(e : Rgbx, t : Rgbx, s : String) {
    Assert.isTrue(
      e.redf.roundTo(3) == t.redf.roundTo(3) &&
      e.greenf.roundTo(3) == t.greenf.roundTo(3) &&
      e.bluef.roundTo(3) == t.bluef.roundTo(3),
      'expected $e but was $t for $s');
  }
}
