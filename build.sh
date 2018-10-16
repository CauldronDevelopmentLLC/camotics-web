#!/bin/bash -e

JADE="$(dirname "$0")"/node_modules/.bin/jade
STYLUS="$(dirname "$0")"/node_modules/.bin/stylus

declare -A PAGES

PAGES[main]="about quick-start mission screenshots status donate community "
PAGES[main]+="legal contact"
PAGES[download]="current install run source debug previous"
PAGES[manual]="overview projects simulation layout playback nc-files tools "
PAGES[manual]+="workpiece export docks toolbars"
PAGES[gcode]="supported gcodes missing other"

# Compile styles
mkdir -p http/css
for i in stylus/*.styl; do
    $STYLUS $i -o http/css
done

# Create Menus
for PAGE in ${!PAGES[@]}; do
    "$(dirname "$0")"/create_menu.sh $PAGE ${PAGES[$PAGE]} \
        >jade/$PAGE/menu.jade
done

# Create Templates
for PAGE in ${!PAGES[@]}; do
    "$(dirname "$0")"/create_template.sh $PAGE ${PAGES[$PAGE]} \
        >jade/$PAGE/template.jade
done

mkdir -p http

for PAGE in ${!PAGES[@]}; do
    TEMPLATE=jade/$PAGE/template.jade
    TARGET=http/$PAGE.html
    echo Building $TARGET from $TEMPLATE...
	$JADE -P -p $TEMPLATE -O "$(cat config.json)" <$TEMPLATE >$TARGET
done

$JADE -P <jade/notfound.jade >http/notfound.html

ln -sf main.html http/index.html
for i in css/*.css js/*.js $(find images -type f); do
  install -D $i http/$i
done

touch http
