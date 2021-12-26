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

|   Hex  |   Binary (A15...A0) | Error |
|-------:|---------------------|-------|
| 0x8000 | 1000 0000 0000 0000 | No error, all tests passed |
| 0xBBF0 | 1011 1111 1111 0000 | Some type of internal fault happed in the diag rom |
| 0xC010 | 1100 0000 0001 0000 | Ram address error |
| 0xC030 | 1100 0000 0011 0000 | Ram data error |
| 0xC070 | 1100 0000 0111 0000 | Ram dead output (not implemented yet) |
| 0xC0f0 | 1100 0000 1111 0000 | Ram unwriteable |
| 0xC310 | 1100 0011 0001 0000 | YM2151 already busy (busy flag was set before we even started using it) |
| 0xC330 | 1100 0011 0011 0000 | YM2151 busy (been stuck in a busy state for to long) |
| 0xC370 | 1100 0011 0111 0000 | YM2151 timerA didn't generate any firqs |
| 0xCC10 | 1100 1100 0001 0000 | ADPCM already busy (busy flag was set before we even started using it) |
| 0xCC30 | 1100 1100 0011 0000 | ADPCM1 status was idle when we did a quick sound play |
| 0xCC70 | 1100 1100 0111 0000 | ADPCM1 status was idle when we did a quick sound play |
