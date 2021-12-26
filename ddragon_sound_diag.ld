MEMORY {
  PRG: org=0x8000, len=0x2000
  ERR: org=0xa000, len=0x5ff2
  VEC: org=0xfff2, len=0xe
}

SECTIONS {
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
