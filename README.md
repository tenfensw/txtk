# TXTk
*TXTk* is an experimental port of TXLib to Tcl programming language using the Tk toolkit. Rather than being a so-called "sandbox" for beginners, TXTk tries to be a portable prototyping framework for both novice and advanced programmers and, as such, focuses on adding support for necessary features right in the library rather than encourage the user to reinvent the wheel by implementing the necessary features themselves. Oh, and yes, this is Tcl, so there's no need to run ``malloc`` or ``calloc`` everytime you need a string or an array and you don't need quotes to specify a string without a space. 

## What works?
- Drawing circles, lines, ovals, etc
- Drawing text
- Message boxes
- CLI colors

## What doesn't work?
- In-memory canvases
- txDrawText and other hardcore text-related
- Some other stuff

## Example
See the ``examples`` folder for more info.

## Docs
See https://github.com/timkoi/txtk/wiki/API-reference for more info.

