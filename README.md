# thx.color

[![Build Status](https://travis-ci.org/fponticelli/thx.color.svg)](https://travis-ci.org/fponticelli/thx.color)

Color library for Haxe. Supports the following color spaces:

  * Lab (AKA Lab)
  * LCh (AKA HCL)
  * Luv (or LUV)
  * Cmy
  * Cmyk
  * CubeHelix
  * Grey
  * Hsl(a)
  * Hsv(a) (AKA HSB)
  * HunterLab
  * Rgb(a)
  * Rgbx(a) (an high resolution version of RGB)
  * Temperature
  * Xyz
  * Yuv
  * Yxy

With conversion from/to any color space (notice that you can lose some information in the conversion).

## intro

API uses abstracts to make it easy to create colors from strings and numbers.

```haxe
    var rgb : Rgb = "#cf8700";
    trace(rgb.green);
```

Some examples from [Demo](https://github.com/fponticelli/thx.color/raw/master/demo/Demo.hx).

### Hsl Rainbow

```haxe
var left  : Hsl = 'hsl(0,100%,0%)',
    right : Hsl = 'hsl(359.99,100%,0%)';
return function(x : Float, y : Float) : Rgb {
  return left.interpolate(right, x).lighter(y);
};
```

![Alt text](https://github.com/fponticelli/thx.color/raw/master/images/rainbowhsl.png?raw=true "Hsl Rainbow")

### Hsv Interpolation

```haxe
var left  : Hsv = 'hsv(160deg,100%,63%)',
    right : Hsv = 'hsv(345deg,88%,77%)';
return function(t : Float) : Rgb
    return (left : Hsv).interpolate(right, t);
```

![Alt text](https://github.com/fponticelli/thx.color/raw/master/images/interpolatehsv.png?raw=true "Hsv Interpolation")

### Lighter Rgb

```haxe
var left : Rgb = '#0000ff';
return left.lighter;
```

![Alt text](https://github.com/fponticelli/thx.color/raw/master/images/lighterrgb.png?raw=true "Lighter Rgb")

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

    ctx.fillStyle = color.toRgbx()
        .toPerceivedGrey()
        .contrast()
        .toRgb().toString();
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
haxelib git thx.color https://github.com/fponticelli/thx.color.git
```
