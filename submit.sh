#!/bin/sh
rm thx.color.zip
zip -r thx.color.zip hxml src test doc/ImportColor.hx extraParams.hxml haxelib.json LICENSE README.md demo demo.hxml -x "*/\.*"
haxelib submit thx.color.zip
