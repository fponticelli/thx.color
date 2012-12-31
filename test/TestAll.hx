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
		
		runner.addCase(new thx.color.TestConvert());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}