import MiniCanvas;

import thx.color.*;
using thx.core.Iterators;
using thx.core.Arrays;
import thx.core.Ints;

class Demo {
	public static function main() {
		MiniCanvas.create('rainbow', 400, 400, rainbowBox);
		MiniCanvas.gradient('gradienthsl', 400, 20,
			(function() {
				var left  : HSL = 'hsl(0º,100%,50%)',
					right : HSL = 'hsl(359.99º,100%,50%)';
				return function(t)
					return left.interpolate(right, t).toRGB();
			})());
		MiniCanvas.gradient('gradienthsv', 400, 20,
			(function() {
				var left  : HSV = 'hsv(0º,100%,100%)',
					right : HSV = 'hsv(359.99º,100%,100%)';
				return function(t)
					return left.interpolate(right, t).toRGB();
			})());
		MiniCanvas.gradient('gradientrgb', 400, 20,
			(function() {
				var left  : RGB = '#ff0000',
					right : RGB = '#00ff00';
				return left.interpolate.bind(right, _);
			})());
		MiniCanvas.gradient('gradientcmyk', 400, 20,
			(function() {
				var left  : CMYK = 'cmyk(50%,20%,10%,5%)',
					right : CMYK = 'cmyk(50%,20%,70%,0%)';
				return function(t)
					return left.interpolate(right, t).toRGB();
			})());
		MiniCanvas.gradient('darkerrgb', 400, 20,
			(function() {
				var left : RGB = '#ff0000';
				return left.darker;
			})());
		MiniCanvas.gradient('lighterrgb', 400, 20,
			(function() {
				var left : RGB = '#0000ff';
				return left.lighter;
			})());
		MiniCanvas.create('colortable', 900, 1200, colorTable);
	}

	public static function colorTable(ctx, w, h) {
		var columns = 5,
			colors  = Color.names.keys().toArray().filter(function(n) return n.indexOf(' ') < 0),
			cellw   = w / columns,
			cellh   = h / Math.ceil(colors.length / columns);
		trace(colors.length);
		ctx.textAlign = "center";
		ctx.textBaseline = "middle";
		ctx.font = '${Math.round(cellh*0.4)}px Verdana, sans-serif';
		colors.mapi(function(name, i) {
			var col   = i % columns,
				row   = Math.floor(i / columns),
				color = Color.names.get(name);

			ctx.fillStyle = color.toString();
			ctx.fillRect(col * cellw, row * cellh, cellw, cellh);

			ctx.fillStyle = color.toRGBX()
				.toPerceivedGrey()
				.contrast()
				.toRGB().toString();
			ctx.fillText(
				name,
				Math.round(col * cellw + cellw / 2) + 0.5,
				Math.round(row * cellh + cellh / 2) + 0.5,
				cellw);
		});
	}

	public static function rainbowBox(ctx, w, h) {
		var left  : HSL = 'hsl(0º,100%,0%)',
			right : HSL = 'hsl(359.99º,100%,0%)',
			interpolate = left.interpolate.bind(right, _);
		Ints.range(0, w)
			.map(function(x) {
				var color = interpolate(x/w);
				Ints.range(0, h).map(function(y) {
					ctx.fillStyle = color.lighter(y/h).toRGB().toString();
					ctx.fillRect(x, y, 1, 1);
				});
			});
	}
}