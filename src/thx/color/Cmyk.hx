/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using thx.core.Floats;

class Cmyk extends Color
{
	@:isVar public var black(get, set): Float;
	@:isVar public var cyan(get, set): Float;
	@:isVar public var magenta(get, set): Float;
	@:isVar public var yellow(get, set): Float;
	
	public function new(cyan: Float, magenta: Float, yellow: Float, black: Float)
	{
		this.cyan    = cyan.normalize();
		this.magenta = magenta.normalize();
		this.yellow  = yellow.normalize();
		this.black   = black.normalize();
	}
	
	override public function toRgb64()
	{
		return new Rgb64(
			(1 - cyan    - black).normalize(),
			(1 - magenta - black).normalize(),
			(1 - yellow  - black).normalize()
		);
	}

	override public function toString() return 'cmyk($cyan,$magenta,$yellow,$black)'
	override public function toStringAlpha(alpha : Float) return 'cmyka($cyan,$magenta,$yellow,$black,$(alpha.normalize()))'
	
	function get_black() return black
	function set_black(value : Float) return black = value.normalize()
	function get_cyan() return cyan
	function set_cyan(value : Float) return cyan = value.normalize()
	function get_magenta() return magenta
	function set_magenta(value : Float) return magenta = value.normalize()
	function get_yellow() return yellow
	function set_yellow(value : Float) return yellow = value.normalize()
}
