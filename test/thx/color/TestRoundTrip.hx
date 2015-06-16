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
        rgbx: _,
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
      /*

        var t : CieLCh = _.lch.toString();
        Assert.isTrue(_.lch == t, 'expected ${_.lch} but was $t');

        var t : Hsl = _.hsl.toString();
        Assert.isTrue(_.hsl == t, 'expected ${_.hsl} but was $t');
      */
        return _;
      })
      .map.fn(trace(_))
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
