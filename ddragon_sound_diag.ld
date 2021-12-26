MEMORY {
  NOERR: org=0x8000, len=0x2
  PRG: org=0x8002, len=0x3fee
  ERR: org=0xbff0, len=0x4002
  VEC: org=0xfff2, len=0xe
}

SECTIONS {
  .noerr: {
    *(no_errors)
  } >NOERR
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
