# thx.color

[![Build Status](https://travis-ci.org/fponticelli/thx.color.svg)](https://travis-ci.org/fponticelli/thx.color)

General purpose color library for Haxe.

API uses abstracts to make it easy to use colors with strings and numbers.

```haxe
    var rgb : RGB = "#cf8700";
    trace(rgb.green);
```

## Some examples from [Demo](https://github.com/fponticelli/thx.color/fponticelli/thx.color/raw/master/demo/Demo.hx)

### HSL Rainbow

```haxe
var left  : HSL = 'hsl(0,100%,0%)',
    right : HSL = 'hsl(359.99,100%,0%)',
    interpolate = left.interpolate.bind(right, _);
Ints.range(0, w)
    .map(function(x) {
        var color = interpolate(x/w);
        Ints.range(0, h).map(function(y) {
            ctx.fillStyle = color.lighter(y/h).toRGB().toString();
            ctx.fillRect(x, y, 1, 1);
        });
    });
```

![Alt text](https://github.com/fponticelli/thx.color/fponticelli/thx.color/raw/master/images/rainbow.png?raw=true "HSL Rainbow")

### HSV Gradient

```haxe
var left  : HSV = 'hsv(0,100%,100%)',
    right : HSV = 'hsv(359.99,100%,100%)';
return function(t)
    return left.interpolate(right, t).toRGB();
```

![Alt text](https://github.com/fponticelli/thx.color/fponticelli/thx.color/raw/master/images/gradienthsv.png?raw=true "HSV Gradient")

### Lighter RGB

```haxe
var left : RGB = '#0000ff';
return left.lighter;
```

![Alt text](https://github.com/fponticelli/thx.color/fponticelli/thx.color/raw/master/images/lighterrgb.png?raw=true "Lighter RGB")

### Named Colors Table

```haxe
var columns = 5,
    colors  = Color.names.keys().toArray().filter(function(n) return n.indexOf(' ') < 0),
    cellw   = w / columns,
    cellh   = h / Math.ceil(colors.length / columns);
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
```

<img src="https://github.com/fponticelli/thx.color/fponticelli/thx.color/raw/master/images/colortable.png?raw=true" alt="color table" width="450" height="600"">

To run [Demo](/demo/Demo.hx), you need `nodejs` and the Canvas library (`npm install canvas`);

*Note:* API might still change before version 1.
