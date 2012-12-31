import utest.Runner;
import utest.ui.Report;

class TestAll 
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new thx.color.TestRgb8());
		runner.addCase(new thx.color.TestRgba8());
		runner.addCase(new thx.color.TestRgb64());
		runner.addCase(new thx.color.TestRgba64());
		runner.addCase(new thx.color.TestHsv());
		runner.addCase(new thx.color.TestConvert());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();

		// cheap testing
		var rgb = new thx.color.Rgb64(.4,.3,1);
		var rgba = new thx.color.Rgba64(.4,.3,1, .5);
		var hsl = new thx.color.Hsl(.2,.4,.4);
		var hsla = new thx.color.Hsla(.2,.4,.4,.9);
		var cmyk = new thx.color.Cmyk(.4,.3,1,.5);
		var hsv = new thx.color.Hsv(.1,.2,.4);
		trace(rgb + " is the value for rgb");
		trace(rgba + " is the value for rgba");
		trace(hsl + " is the value for hsl");
		trace(hsla + " is the value for hsla");
		trace(cmyk + " is the value for cmyk");
		trace(hsv + " is the value for hsv");

	}
}
