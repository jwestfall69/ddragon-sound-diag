# ddragon-sound-diag
This is a sound diagnostics program that can be run on the sound cpu of the
original double dragon jamma/arcade boards.  This is a sister project to
[ddragon-diag](https://github.com/jwestfall69/ddragon-diag) which targets the
main cpu.

The sound diag rom tries to verify core functionality of the sound subsystem, ie:

* Sound cpu functioning
* Sound ram is good
* YM2151 is alive

Such that ddragon's sound rom should be functional when used and any sound
issue is being caused by a non-core fault (ie bad YM3012).  In this case its
best to use the ddragon-diag with ddragon's sound rom.  Using the sound test
to repeatedly play a PCM or FM sound over and over, tracing its path and where
it dies.

In order to make use of this diag rom you will need a logic probe.  Error codes
(and success code) are determined by probing what address the diag rom stops on.

Please refer to the [error addresses](docs/error_addresses.md) docs for the
mapping between errors codes and stop addresses.

## Usage
#### MAME
Copy ddragon-sound-diag.bin over 21j-0-1 rom file in ddragon, and fire up
ddragon.

#### Hardware
Burn the ddragon-sound-diag.bin to a 27C256 or a 27c512 (if you double it up).
Install the eprom into IC30.  No other sound related eproms are required.

## Pre-Built
You can grab the latest build from the main branch at

https://www.mvs-scans.com/ddragon-sound-diag/ddragon-sound-diag-main.zip

## Building
Building requires vasm (vasm6809_oldstyle) and vlink which are available here

http://sun.hasenbraten.de/vasm/<br>
http://sun.hasenbraten.de/vlink/
