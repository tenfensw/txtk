#!/usr/bin/env tclsh
# Port of TXLib to Tcl
# Copyright (C) Tim K 2018-2019 <timprogrammer@rambler.ru>.
# 
# Licensed under 2-clause BSD License. See LICENSE for more
# info.

package require Tk

set txAlredyCreatedCanvases -1
set txVersionInfo "TXTk 2.00 for Tcl"
set txAllowUpdates 1
set txGlobalPen {65535 65535 65535 1}
set txFillPen {65535 65535 65535 1}
set txConsoleColor default
font create .txFont -size 12 -family Helvetica

proc txCreateWindow {sizeX sizeY} {
    global txAlredyCreatedCanvases
    incr txAlredyCreatedCanvases
    set nm .wnd$txAlredyCreatedCanvases
    canvas $nm -background black -width $sizeX -height $sizeY
    grid $nm
    return $nm
}

proc txDC {} {
    global txAlredyCreatedCanvases
    if {$txAlreadyCreatedCanvases < 0} {
        return ""
    }
    return ".wnd$txAlreadyCreatedCanvases"
}


proc txWindow {} {
    return [txDC]
}

proc txGetExtent {wdesc} {
    set wd [winfo width $wdesc]
    set ht [winfo height $wdesc]
    return [list $wd $ht]
}

proc txGetExtentX {wdesc} {
    set rs [txGetExtent $wdesc]
    return [lindex $rs 0]
}

proc txGetExtentY {wdesc} {
    set rs [txGetExtent $wdesc]
    return [lindex $rs 1]
}

proc txVersion {} {
    global txVersionInfo
    return $txVersionInfo
}

proc txVersionNumber {} {
    return 200
}

proc txUpdateWindow {hd} {
    global txAllowUpdates
    set txAllowUpdates $jd
}

proc RGB {r g b} {
    return [list [expr {$r * 257}] [expr {$g * 257}] [expr {$b * 257}] 1]
}

proc _txSetColor {clr thickness} {
    if {$clr == 0} {
        set clr [list 255 255 0]
    }
    set finalList [list [lindex $clr 0] [lindex $clr 1] [lindex $clr 2] $thickness]
    return $finalList
}

proc txSetColor {{clr 0} {thickness 1}} {
    global txGlobalPen
    set txGlobalPen [_txSetColor $clr $thickness]
    return $txGlobalPen
}

proc txGetColor {} {
    global txGlobalPen
    return $txGlobalPen
}

proc txSetFillColor {{clr 0}} {
    global txFillPen
    set txFillPen [_txSetColor $clr 1]
    return $txFillPen
}

proc txGetFillColor {} {
    global txFillPen
    return $txFillPen
}

proc _tkRgb {pen} {
    return [format "#%02x%02x%02x" [expr {[lindex $pen 0]/256}] [expr {[lindex $pen 1]/256}] [expr {[lindex $pen 2]/256}]]
}

proc txClear {{wd .wnd0}} {
    set thePen [txGetColor]
    $wd delete all
    $wd configure -fill [_tkRgb $thePen]
}

proc txSetPixel {x y {color [txGetColor]} {where .wnd0}} {
    set actualColor [_tkRgb $color]
    $where create line $x $y [expr {$x + 1}] [expr {$y + 1}] -fill $color -smooth 1
}

proc txLine {x0 y0 x1 y1 {where .wnd0}} {
    set color [txGetColor]
    set actualColor [_tkRgb $color]
    $where create line $x0 $y0 $x1 $y1 -fill $actualColor -smooth 1
    update
}

proc txRectangle {x0 y0 x1 y1 {where .wnd0}} {
    set color [txGetColor]
    set fColor [txGetFillColor]
    set actualColor [_tkRgb $color]
    set actualFColor [_tkRgb $fColor]
    $where create rectangle $x0 $y0 $x1 $y1 -outline $actualColor -fill $actualFColor
}

proc txPolygon {points {where .wnd0}} {
    set xPrev 0
    set yPrev 0
    set x 0
    set y 0
    set odd 0
    set first 1
    foreach ptc $points {
        if {$odd} {
            set yPrev $y
            set y $ptc
            if {$first} {
                txSetPixel $x $y [txGetColor] $where
                set first 0
            } else {
                txLine $xPrev $yPrev $x $y
            }
            set x 0
            set y 0
            set odd 0   
        } else {
            set xPrev $x
            set x $ptc
            set odd 1
        }
    }
}

proc txEllipse {x0 y0 x1 y1 {where .wnd0}} {
    set color [txGetColor]
    set fColor [txGetFillColor]
    set actualColor [_tkRgb $color]
    set actualFColor [_tkRgb $fColor]
    $where create oval $x0 $y0 $x1 $y1 -outline $actualColor -fill $actualFColor
}

proc txCircle {xc yc radius {where .wnd0}} {
    set xa [expr {$xc - $radius}]
    set ya [expr {$yc - $radius}]
    set xe [expr {$xc + $radius}]
    set ye [expr {$yc + $radius}]
    txEllipse $xa $ya $xe $ye $where
}

proc txMessageBox {{txt "Greetings, ded32!"} {title "TXTk tells you something"} {flag ok} {icon info}} {
    return [tk_messageBox -type $flag -icon $icon -title $title -message $txt ]
}

proc _txNoFuncMsg {funcn funca} {
    txMessageBox "Basically, \"$funcn\" is its TXLib-ish form is absent from TXTk due to Tk canvas widget limitations. You should use \"$funca\" instead (see the docs for usage info)." "TXTk Internal Error" ok error
    exit 1
}

proc txArc {x0 y0 x1 y1 startAngle totalAngle {where .wnd0} {arctype arc}} {
    set color [txGetColor]
    set fColor [txGetFillColor]
    set actualColor [_tkRgb $color]
    set actualFColor [_tkRgb $fColor]
    $where create arc $x0 $y0 $x1 $y1 -start $startAngle -extent $totalAngle -fill $actualFColor -outline $actualColor -style $arctype
}

proc txPie {x0 y0 x1 y1 startAngle totalAngle {where .wnd0}} {
    txArc $x0 $y0 $x1 $y1 $startAngle $totalAngle $where pieslice 
}

proc txChord {x0 y0 x1 y1 startAngle totalAngle {where .wnd0}} {
    txArc $x0 $y0 $x1 $y1 $startAngle $totalAngle $where chord 
}

proc txYourOwnHands {} {
    txMessageBox "I see you didn't get the joke."
}

proc txDrawMan {x y sizeX sizeY color handL handR twist head eyes wink crazy smile hair wind} {
    _txNoFuncMsg txDrawMan txYourOwnHands
}

proc txTriangle {x1 y1 x2 y2 x3 y3 {where .wnd0}} {
    # Let's make life for people easier and implement txTriangle.
    
    txLine $x1 $y1 $x2 $y2 $where
    txLine $x2 $y2 $x3 $y3 $where
    txLine $x3 $y3 $x1 $y1 $where
}

proc txBegin {} {
    # this was easy to implement
    txUpdateWindow 0
}

proc txEnd {} {
    txUpdateWindow 1
}

proc txRedrawWindow {} {
    update
}

proc txDestroyWindow {{which_one .wnd0}} {
    grid remove $which_one
}

proc txQueryPerformance {} {
    txMessageBox "Admit it already that Tcl/Tk/TXTk is way faster than C++/GDI/TXLib or C++/SDL2/TXLin." "For the confused ones" ok error
    return 7
}

proc txTextOut {x y textv {where .wnd0}} {
    set color [txGetColor]
    set actualColor [_tkRgb $color]
    $where create text $x $y -fill $actualColor -justify left -text "$textv\n"
}

proc txDrawText {x0 y0 x1 y1 textv formatv {where .wnd0}} {
    _txNoFuncMsg txDrawText txTextOut
}

proc txSelectFont {name sizeY {sizeX -1} {bold 0} {italic 0} {underline 0} {strikeout 0} {angle 0} {where .wnd0}} {
    _txNoFuncMsg txSelectFont txReplaceFont
}

proc txReplaceFont {name sizeY {weight bold}} {
    font configure .txFont -family $name
    font configure .txFont -size $sizeY
    font configure .txFont -weight bold
}

proc txFontExist {name} {
    if {[lsearch -exact [font families] $name] >= 0} {
        return 1
    }
    return 0
}

proc txImage {x0 y0 filename {where .wnd0}} {
    $where create image $x0 $y0 -image $filename
}

proc txMousePos {} {
    set out [list [winfo pointerx .] [winfo pointery .]]
    return $out
}

proc txMouseX {} {
    return [lindex [txMousePos] 0]
}

proc txMouseY {} {
    return [lindex [txMousePos] 1]
}

proc txCatchMouse {{shouldEat 1}} {
    global isCat
    if {! [info exists isCat]} {
        set isCat 0
    }
    if {$isCat} {
        txMessageBox "You're a furry. That's what I can tell you. Because only a human can write code." "Roasts from TXTk"
    } else {
        txMessageBox "You're not a cat and I would not recommend you to touch a dirty rat that had just ran out from your local dumpster with your hands." "TXTk cares about your health"
    }
}

proc txSetConsoleColor {{fg default}} {
    # not the best solution so far, but it is acceptable
    set realColor "\033\[0m"
    global txConsoleColor
    set txConsoleColor $fg
    if {$fg == "red"} {
        set realColor "\033\[1;31m"
    } elseif {$fg == "green"} {
        set realColor "\033\[1;32m"
    } elseif {$fg == "yellow"} {
        set realColor "\033\[1;33m"
    } elseif {$fg == "blue"} {
        set realColor "\033\[1;34m"
    } elseif {$fg == "magenta"} {
        set realColor "\033\[1;35m"
    } elseif {$fg == "cyan"} {
        set realColor "\033\[1;36m"
    } elseif {$fg == "gray" || $fg == "grey"} {
        set realColor "\033\[1;90m"
    } elseif {$fg == "white"} {
        set realColor "\033\[1;97m"
    }
    puts -nonewline $realColor
}

proc txGetConsoleColor {} {
    global txConsoleColor
    return $txConsoleColor
}

