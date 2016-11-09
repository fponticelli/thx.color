import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function addTests(runner : Runner) {
    runner.addCase(new thx.color.TestArgb());
    runner.addCase(new thx.color.TestLab());
    runner.addCase(new thx.color.TestLCh());
    runner.addCase(new thx.color.TestLuv());
    runner.addCase(new thx.color.TestColor());
    runner.addCase(new thx.color.TestColorParser());
    runner.addCase(new thx.color.TestConversion());
    runner.addCase(new thx.color.TestCmy());
    runner.addCase(new thx.color.TestCmyk());
    runner.addCase(new thx.color.TestCubeHelix());
    runner.addCase(new thx.color.TestGrey());
    runner.addCase(new thx.color.TestHcl());
    runner.addCase(new thx.color.TestHsl());
    runner.addCase(new thx.color.TestHsv());
    runner.addCase(new thx.color.TestRgb());
    runner.addCase(new thx.color.TestRgbx());
    runner.addCase(new thx.color.TestTemperature());
    runner.addCase(new thx.color.TestXyz());
    runner.addCase(new thx.color.TestYxy());

    runner.addCase(new thx.color.TestIssues());

    runner.addCase(new thx.color.TestRoundTrip());
  }

  public static function main() {
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }
}
