# thx.color

[![Build Status](https://travis-ci.org/fponticelli/thx.color.svg)](https://travis-ci.org/fponticelli/thx.color)

General purpose color library for Haxe.

## intro

API uses abstracts to make it easy to use colors with strings and numbers.

```haxe
    var rgb : RGB = "#cf8700";
    trace(rgb.green);
```

Some examples from [Demo](https://github.com/fponticelli/thx.color/raw/master/demo/Demo.hx).

### HSL Rainbow

```haxe
var left  : HSL = 'hsl(0,100%,0%)',
    right : HSL = 'hsl(359.99,100%,0%)';
return function(x : Float, y : Float) : RGB {
  return left.interpolate(right, x).lighter(y);
};
```

![Alt text](https://github.com/fponticelli/thx.color/raw/master/images/rainbowhsl.png?raw=true "HSL Rainbow")

### HSV Interpolation

```haxe
var left  : HSV = 'hsv(160deg,100%,63%)',
    right : HSV = 'hsv(345deg,88%,77%)';
return function(t : Float) : RGB
    return (left : HSV).interpolate(right, t));
```

![Alt text](https://github.com/fponticelli/thx.color/raw/master/images/interpolatehsv.png?raw=true "HSV Interpolation")

### Lighter RGB

```haxe
var left : RGB = '#0000ff';
return left.lighter;
```

![Alt text](https://github.com/fponticelli/thx.color/raw/master/images/lighterrgb.png?raw=true "Lighter RGB")

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

<img src="https://github.com/fponticelli/thx.color/raw/master/images/colortable.png?raw=true" alt="color table" width="450" height="600">

To run [Demo](/demo/Demo.hx), you need `nodejs` and the Canvas library (`npm install canvas`);

*Note:* API might still change before version 1.

## install

From the command line just type:

```bash
haxelib install thx.color
```

To use the `dev` version do:

```bash
haxelib git thx.core https://github.com/fponticelli/thx.color.git
```