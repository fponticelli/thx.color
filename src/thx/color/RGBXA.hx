/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using StringTools;
using thx.core.Floats;
using thx.core.Ints;
using Math;
import thx.color.parse.ColorParser;

@:access(thx.color.HSLA)
@:access(thx.color.HSVA)
@:access(thx.color.RGBA)
@:access(thx.color.RGBX)
abstract RGBXA(Array<Float>) {
	@:from public static function parse(color : String) : RGBXA {
		var info = ColorParser.parseHex(color);
		if(null == info)
			info = ColorParser.parseColor(color);
		if(null == info)
			return null;

		return try switch info.name {
			case 'rgba':
				thx.color.RGBXA.fromArray(ColorParser.getFloatChannels(info.channels, 4));
			case _:
				null;
		} catch(e : Dynamic) null;
	}
	public static function fromArray(values : Array<Float>) : RGBXA
		return new RGBXA(values.map(function(v) return v.normalize()).concat([0,0,0,0]).slice(0,4));

	inline public static function fromInts(red : Int, green : Int, blue : Int, alpha : Int) : RGBXA
		return new RGBXA([red / 255, green / 255, blue / 255, alpha / 255]);

	inline public static function fromFloats(red : Float, green : Float, blue : Float, alpha : Float) : RGBXA
		return new RGBXA([red,green,blue,alpha]);

	public var red(get, never) : Int;
	public var green(get, never) : Int;
	public var blue(get, never) : Int;
	public var alpha(get, never) : Int;
	public var redf(get, never) : Float;
	public var greenf(get, never) : Float;
	public var bluef(get, never) : Float;
	public var alphaf(get, never) : Float;

	inline function new(channels : Array<Float>) : RGBXA
		this = channels;

	inline public function toCSS3() : String
		return toString();
	@:to inline public function toString() : String
		return 'rgba(${redf*100}%,${greenf*100}%,${bluef*100}%,$alphaf)';
	inline public function toHex(prefix = "#") : String
		return '$prefix${alpha.hex(2)}${red.hex(2)}${green.hex(2)}${blue.hex(2)}';

	@:to public function toHSLA() : HSLA
		return toRGBX().toHSL().withAlpha(alpha);

	@:to public function toHSVA() : HSVA
		return toRGBX().toHSV().withAlpha(alpha);

	@:to inline public function toRGBX() : RGBX
		return new RGBX(this.slice(0,3));

	@:to inline public function toRGBA() : RGBA
		return RGBA.fromFloats(redf, greenf, bluef, alphaf);

	@:op(A==B) public function equals(other : RGBXA) : Bool
		return redf == other.redf && greenf == other.greenf && bluef == other.bluef && alphaf == other.alphaf;

	public function darker(t : Float) : RGBXA
		return toRGBX().darker(t).withAlpha(alpha);

	public function lighter(t : Float) : RGBXA
		return toRGBX().lighter(t).withAlpha(alpha);

	public function transparent(t : Float) : RGBXA
		return new RGBXA([
			redf,
			greenf,
			bluef,
			t.interpolateBetween(alphaf, 0)
		]);

	public function opaque(t : Float) : RGBXA
		return new RGBXA([
			redf,
			greenf,
			bluef,
			t.interpolateBetween(alphaf, 1)
		]);

	public function interpolate(other : RGBXA, t : Float) : RGBXA
		return new RGBXA([
			t.interpolateBetween(redf, other.redf),
			t.interpolateBetween(greenf, other.greenf),
			t.interpolateBetween(bluef, other.bluef),
			t.interpolateBetween(alphaf, other.alphaf)
		]);

	inline function get_red() : Int
		return (redf   * 255).round();
	inline function get_green() : Int
		return (greenf * 255).round();
	inline function get_blue() : Int
		return (bluef  * 255).round();
	inline function get_alpha() : Int
		return (alphaf  * 255).round();

	inline function get_redf() : Float
		return this[0];
	inline function get_greenf() : Float
		return this[1];
	inline function get_bluef() : Float
		return this[2];
	inline function get_alphaf() : Float
		return this[3];

}