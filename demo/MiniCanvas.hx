import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Element;

import thx.core.Ints;
import thx.color.RGB;

class MiniCanvas {
	public static function create(name : String, width : Int, height : Int, handler : CanvasRenderingContext2D -> Int -> Int -> Void) {
		var mini = new MiniCanvas(width, height);
		handler(mini.ctx, width, height);
		mini.save(name);
	}

	public static function gradient(name : String, width : Int, height : Int, handler : Float-> RGB) {
		create(name, width, height, function(ctx, w, h) {
			Ints.range(0, w)
				.map(function(x) {
					ctx.fillStyle = handler(x/w).toString();
					ctx.fillRect(x, 0, 1, h);
				});
		});
	}

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var canvas(default, null) : CanvasElement;
	public var ctx(default, null) : CanvasRenderingContext2D;
	public function new(width : Int, height : Int) {
		var Canvas = untyped __js__('require("canvas")');
		canvas = untyped __js__("new Canvas")(width, height);
		ctx = canvas.getContext2d();
	}


	public function save(name : String) untyped {
		var fs = require('fs'),
			out = fs.createWriteStream(__dirname + '/../images/$name.png'),
			stream = canvas.pngStream();

		stream.on('data', function(chunk) out.write(chunk));
		stream.on('end', function(_) console.log('saved $name.png'));
	}
}