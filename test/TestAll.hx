import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function addTests(runner : Runner) {
    runner.addCase(new thx.color.TestCIELab());
    runner.addCase(new thx.color.TestCIELCh());
    runner.addCase(new thx.color.TestColor());
    runner.addCase(new thx.color.TestColorParser());
    runner.addCase(new thx.color.TestConversion());
    runner.addCase(new thx.color.TestCMYK());
    runner.addCase(new thx.color.TestGrey());
    runner.addCase(new thx.color.TestHSL());
    runner.addCase(new thx.color.TestHSV());
    runner.addCase(new thx.color.TestRGB());
    runner.addCase(new thx.color.TestRGBX());
  }

  public static function main() {
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }
}
