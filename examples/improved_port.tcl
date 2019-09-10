#!/usr/bin/env wish
# NOTICE. You need wish, not the regular tclsh to run this.

source txtk.tcl

txCreateWindow 800 600
txSetColor [RGB 255 255 255]
txSetFillColor [RGB 0 0 0]
txRectangle 10 10 790 590

txSetColor [RGB 224 255 255]
txCircle 400 300 30
txLine 400 330 400 390
txLine 400 390 350 440
txLine 400 390 450 440
txLine 350 340 400 330
txLine 400 330 472 300

txLine 400 210 387 250
txTextOut 350 199 "Hello Tcl, goodbye C++!"
