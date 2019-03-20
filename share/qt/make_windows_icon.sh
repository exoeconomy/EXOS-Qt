#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/exos.ico

convert ../../src/qt/res/icons/exos-16.png ../../src/qt/res/icons/exos-32.png ../../src/qt/res/icons/exos-48.png ${ICON_DST}
