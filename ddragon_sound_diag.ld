MEMORY {
  RESET: org=0x8000, len=0x100
  PRG: org=0x8100, len=0x1f00
  ERR: org=0xa000, len=0x5ff2
  VEC: org=0xfff2, len=0xe
}

SECTIONS {
  .reset: {
    FILL8(0x12);
    RESERVE(0x5a);
    *(reset)
  } >RESET
  .prg: {
    *(text)
  } >PRG
  .errs: {
    *(errors)
  } >ERR
  .vecs: {
    *(vectors)
  } >VEC
}
