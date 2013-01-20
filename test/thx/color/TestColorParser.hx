/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

import haxe.PosInfos;
import thx.core.Floats;
import utest.Assert;
import thx.color.ColorParser;

class TestColorParser
{
	public function new() {}
	
	public function testFeatures()
	{
		assert(
			"a",	false,	[CIInt8(2)],
			"a(2)");
		assert(
			"a",	true,	[CIInt8(2)],
			"aa(2)");
		assert(
			"rgb",	false,	[CIInt8(2)],
			"rgb(2)");
		assert(
			"rgb",	true,	[CIInt8(2)],
			"rgba(2)");
		assert(
			"hsl",	true,	[CIDegree(1), CIPercent(2), CIPercent(3), CIFloat(0.5)],
			"hsla(1º,2%,3%,0.5)");
	}
	
	public function testChannels()
	{
		assertStringChannel(CIDegree(1),	"1º");
		assertStringChannel(CIDegree(1),	"1deg");
		assertStringChannel(CIPercent(1),	"1%");
		assertStringChannel(CIFloat(0.1),	"0.1");
		assertStringChannel(CI0or1(0),		"0");
		assertStringChannel(CI0or1(1),		"1");
		assertStringChannel(CIInt8(2),		"2");
		assertStringChannel(CIInt(256),		"256");
	}
	
	public function testInvalidColor()
	{
		Assert.isNull(ColorParser.parseColor("x"));
		Assert.isNull(ColorParser.parseColor("x[]"));
		Assert.isNull(ColorParser.parseColor("x(x)"));
	}
	
	public function testInvalidChannel()
	{
		Assert.isNull(ColorParser.parseChannel("x"));
	}
	
	public function assertStringChannel(expected : ChannelInfo, test : String, ?pos : PosInfos)
	{
		assertChannel(expected, ColorParser.parseChannel(test), pos);
	}
	
	public function assertChannel(expected : ChannelInfo, test : ChannelInfo, ?pos : PosInfos)
	{
		if (null == test)
		{
			Assert.fail('channel is null', pos);
			return;
		}
		var ec = Type.enumConstructor(expected),
			tc = Type.enumConstructor(test),
			ep = Type.enumParameters(expected)[0],
			tp = Type.enumParameters(test)[0];
		Assert.equals(ec, tc, 'expected $ec but is $tc', pos);
		Assert.equals(ep, tp, 'expected $ep but is $tp', pos);
	}
	
	public function assert(name : String, has_alpha : Bool, channels : Array<ChannelInfo>, test_string : String, ?pos : PosInfos)
	{
		var expected = new ColorInfo(name, has_alpha, channels),
			test = ColorParser.parseColor(test_string);
		if (null == test)
		{
			Assert.fail("test is null", pos);
			return;
		}
		Assert.equals(expected.name, test.name, pos);
		Assert.equals(expected.hasAlpha, test.hasAlpha, pos);
		for (i in 0...expected.channels.length)
		{
			assertChannel(expected.channels[i], test.channels[i], pos);
		}
	}
}