#!/usr/bin/env tclsh

source txtk.tcl

foreach clr {red green blue magenta cyan grey white default} {
	txSetConsoleColor $clr
	puts "Look, I am $clr!"
}

exit 0
