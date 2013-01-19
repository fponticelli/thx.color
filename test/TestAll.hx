import utest.Runner;
import utest.ui.Report;

class TestAll
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new thx.color.TestRgb8());
		runner.addCase(new thx.color.TestRgb64());
		runner.addCase(new thx.color.TestHsv());
		runner.addCase(new thx.color.TestConvert());
		runner.addCase(new thx.color.TestColor());
		runner.addCase(new thx.color.TestColorAlpha());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();

		// cheap testing
		var rgb = new thx.color.Rgb64(.4,.3,1);
		var hsl = new thx.color.Hsl(.2,.4,.4);
		var cmyk = new thx.color.Cmyk(.4,.3,1,.5);
		var hsv = new thx.color.Hsv(.1,.2,.4);
		trace(rgb + " is the value for rgb");
		trace(hsl + " is the value for hsl");
		trace(cmyk + " is the value for cmyk");
		trace(hsv + " is the value for hsv");

	}
}
