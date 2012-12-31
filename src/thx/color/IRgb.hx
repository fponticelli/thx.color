package thx.color;

/**
 * ...
 * @author Franco Ponticelli
 */

interface IRgb implements IColor
{
	public var red(get, set) : Int;
	public var green(get, set) : Int;
	public var blue(get, set) : Int;
	
	public function toHex(prefix : String = "#") : String;
}