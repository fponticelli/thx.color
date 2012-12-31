package thx.color;

/**
 * ...
 * @author Franco Ponticelli
 */

interface IRgba implements IRgb, implements IColorAlpha
{
	public var alpha(get, set) : Float;
}