import utest.Runner;
import utest.ui.Report;

class TestAll
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new thx.color.TestColorParser());
		runner.addCase(new thx.color.TestCMYK());
		//runner.addCase(new thx.color.TestHSL());
		//runner.addCase(new thx.color.TestHSV());
		//runner.addCase(new thx.color.TestRGB());
		//runner.addCase(new thx.color.TestRGBX());
		//runner.addCase(new thx.color.TestConvert());
		//runner.addCase(new thx.color.TestColor());
		//runner.addCase(new thx.color.TestColorAlpha());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
/*
		// cheap testing
		var rgb = new thx.color.RGBX(.4,.3,1);
		var hsl = new thx.color.HSL(.2,.4,.4);
		var cmyk = new thx.color.CMYK(.4,.3,1,.5);
		var hsv = new thx.color.HSV(.1,.2,.4);
		trace(rgb + " is the value for rgb");
		trace(hsl + " is the value for hsl");
		trace(cmyk + " is the value for cmyk");
		trace(hsv + " is the value for hsv");
*/
	}
}
