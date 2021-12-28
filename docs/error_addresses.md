# Error Addresses
---
The only output the sound cpu has is sound, but the only reason to run the sound
diag is if you have no sound.  So in order to communicate errors (or success) to
user, the sound diag will jump to a specific address and then continually loop
at that address.  This will make the sound cpu's address lines become static
with the exception of a0.

A logic probe is need to probe each of the address lines to determine what
address the sound diag stopped on.  When doing this its best to start with A15
and work your ways backward.

Address lines that are stuck high should be considered a 1, while pulsing
address lines should be considered a 0.

|  Hex |   Binary (A15...A0) | Error |
|-----:|---------------------|-------|
| a000 | 1010 0000 0000 0000 | Some type of internal fault happened in the diag rom might have happened |
| aaa0 | 1010 1010 1010 0000 | No errors, all tests passed |
| c010 | 1100 0000 0001 0000 | Ram address error |
| c030 | 1100 0000 0011 0000 | Ram data error |
| c070 | 1100 0000 0111 0000 | Ram dead output |
| c0f0 | 1100 0000 1111 0000 | Ram unwriteable |
| c310 | 1100 0011 0001 0000 | YM2151 already busy (busy flag was set before we even started using YM2151) |
| c330 | 1100 0011 0011 0000 | YM2151 busy (been stuck in a busy state for to long) |
| c370 | 1100 0011 0111 0000 | YM2151 timerA didn't generate any firqs |
| cc10 | 1100 1100 0001 0000 | ADPCM already busy (busy flag was set before we even started using ADPCM) |
| cc30 | 1100 1100 0011 0000 | ADPCM1 status was idle when we did a quick sound play |
| cc70 | 1100 1100 0111 0000 | ADPCM1 status was idle when we did a quick sound play |
