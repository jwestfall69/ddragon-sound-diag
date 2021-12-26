from mame..
void ddragon_state::sound_map(address_map &map)
{
	map(0x0000, 0x0fff).ram(); // ram is actually 0x000 to 0x7ff
	map(0x1000, 0x1000).r(m_soundlatch, FUNC(generic_latch_8_device::read));
	map(0x1800, 0x1800).r(FUNC(ddragon_state::dd_adpcm_status_r));
	map(0x2800, 0x2801).rw("fmsnd", FUNC(ym2151_device::read), FUNC(ym2151_device::write));
	map(0x3800, 0x3807).w(FUNC(ddragon_state::dd_adpcm_w));
	map(0x8000, 0xffff).rom();
}


8000: 1a 50           ORCC  #$50	; disable interrupts
8002: 10 ce 07 00     LDS   #$0700 	; init stack
8006: 17 08 1d        LBSR  $8826 - do_init
8009: 0f 74           CLR   $74

main_loop:
800b: 8d 05           BSR   $8012
800d: 17 03 86        LBSR  $8396
8010: 20 f9           BRA   $800B	; main_loop

8012: 1a 10           ORCC  #$10
8014: 96 0a           LDA   $0A
8016: 97 00           STA   $00
8018: 0f 0a           CLR   $0A
801a: 1c ef           ANDCC #$EF
801c: d6 00           LDB   $00
801e: 27 65           BEQ   $8085
8020: c1 ff           CMPB  #$FF
8022: 10 27 02 f3     LBEQ  $8319
8026: c1 fe           CMPB  #$FE
8028: 10 27 03 21     LBEQ  $834D
802c: c1 fd           CMPB  #$FD
802e: 10 27 02 e2     LBEQ  $8314
8032: c4 f0           ANDB  #$F0
8034: c1 f0           CMPB  #$F0
8036: 10 27 02 fe     LBEQ  $8338
803a: d6 00           LDB   $00
803c: c4 80           ANDB  #$80
803e: 10 26 08 a3     LBNE  $88E5
8042: d6 00           LDB   $00
8044: c1 7f           CMPB  #$7F
8046: 25 0a           BCS   $8052
8048: c4 80           ANDB  #$80
804a: 27 39           BEQ   $8085
804c: d6 00           LDB   $00
804e: c1 bd           CMPB  #$BD
8050: 24 33           BCC   $8085
8052: c5 80           BITB  #$80
8054: 26 41           BNE   $8097
8056: 86 ff           LDA   #$FF
8058: 97 74           STA   $74
805a: 17 02 9a        LBSR  $82F7
805d: d6 00           LDB   $00
805f: 27 24           BEQ   $8085
8061: 0f 4b           CLR   $4B
8063: 58              ASLB
8064: 8e 90 00        LDX   #$9000
8067: 10 ae 85        LDY   B,X
806a: a6 a0           LDA   ,Y+
806c: 97 61           STA   $61
806e: 84 80           ANDA  #$80
8070: 26 18           BNE   $808A
8072: 8e 00 0b        LDX   #$000B
8075: a6 a0           LDA   ,Y+
8077: 97 67           STA   $67
8079: 17 02 38        LBSR  $82B4
807c: 17 00 70        LBSR  $80EF
807f: 0c 4b           INC   $4B
8081: 0a 61           DEC   $61
8083: 26 f4           BNE   $8079
8085: 0f 74           CLR   $74
8087: 0f 00           CLR   $00
8089: 39              RTS


808a: 86 01           LDA   #$01
808c: 97 61           STA   $61
808e: 86 07           LDA   #$07
8090: 97 4b           STA   $4B
8092: 8e 00 19        LDX   #$0019
8095: 20 de           BRA   $8075
8097: c4 7f           ANDB  #$7F
8099: 8e 00 00        LDX   #$0000
809c: 3a              ABX
809d: 3a              ABX
809e: 3a              ABX
809f: 10 ae 81        LDY   ,X++
80a2: a6 84           LDA   ,X
80a4: 97 4d           STA   $4D
80a6: a6 a0           LDA   ,Y+
80a8: 97 61           STA   $61
80aa: 17 02 ab        LBSR  $8358
80ad: 96 00           LDA   $00
80af: 27 07           BEQ   $80B8
80b1: 17 00 07        LBSR  $80BB
80b4: 0a 61           DEC   $61
80b6: 26 f9           BNE   $80B1
80b8: 0f 00           CLR   $00
80ba: 39              RTS
80bb: ec a1           LDD   ,Y++
80bd: 34 20           PSHS  Y
80bf: 1f 02           TFR   D,Y
80c1: e6 a4           LDB   ,Y
80c3: c4 80           ANDB  #$80
80c5: 1f 98           TFR   B,A
80c7: e6 a0           LDB   ,Y+
80c9: c4 0f           ANDB  #$0F
80cb: d7 4b           STB   $4B
80cd: 8e 00 6c        LDX   #$006C
80d0: a7 85           STA   B,X
80d2: a6 a0           LDA   ,Y+
80d4: 97 67           STA   $67
80d6: ec a1           LDD   ,Y++
80d8: 34 20           PSHS  Y
80da: 17 00 18        LBSR  $80F5
80dd: 35 20           PULS  Y
80df: d6 4b           LDB   $4B
80e1: 58              ASLB
80e2: 8e 00 0b        LDX   #$000B
80e5: 3a              ABX
80e6: ec a4           LDD   ,Y
80e8: ed 84           STD   ,X
80ea: 17 01 c7        LBSR  $82B4
80ed: 35 a0           PULS  Y,PC	; rts

80ef: ec a1           LDD   ,Y++
80f1: ed 81           STD   ,X++
80f3: ec a1           LDD   ,Y++
80f5: 34 30           PSHS  Y,X
80f7: 1f 02           TFR   D,Y
80f9: a6 a0           LDA   ,Y+
80fb: 27 05           BEQ   $8102
80fd: 17 00 84        LBSR  $8184
8100: 20 04           BRA   $8106
8102: a6 a1           LDA   ,Y++
8104: a6 a1           LDA   ,Y++
8106: 8e 00 59        LDX   #$0059
8109: d6 4b           LDB   $4B
810b: a6 a0           LDA   ,Y+
810d: a7 85           STA   B,X
810f: a6 a4           LDA   ,Y
8111: 84 07           ANDA  #$07
8113: 8e 00 50        LDX   #$0050
8116: d6 4b           LDB   $4B
8118: a7 85           STA   B,X
811a: cb 20           ADDB  #$20
811c: 1f 98           TFR   B,A
811e: 17 00 87        LBSR  $81A8
8121: cb 10           ADDB  #$10
8123: 1f 98           TFR   B,A
8125: 8d 6b           BSR   $8192
8127: cb 08           ADDB  #$08
8129: 1f 98           TFR   B,A
812b: 8d 65           BSR   $8192
812d: 1f 21           TFR   Y,X
812f: 86 40           LDA   #$40
8131: 17 00 d0        LBSR  $8204
8134: 10 8e 00 ee     LDY   #$00EE
8138: 17 00 af        LBSR  $81EA
813b: 10 8e 00 ce     LDY   #$00CE
813f: 17 00 89        LBSR  $81CB
8142: 34 30           PSHS  Y,X
8144: 8e 00 ce        LDX   #$00CE
8147: d6 4b           LDB   $4B
8149: 58              ASLB
814a: 58              ASLB
814b: 3a              ABX
814c: 34 10           PSHS  X
814e: 17 06 3c        LBSR  $878D
8151: 35 10           PULS  X
8153: 86 82           LDA   #$82
8155: 17 05 db        LBSR  $8733
8158: 35 30           PULS  X,Y
815a: 86 60           LDA   #$60
815c: 34 10           PSHS  X

815e: 8e 81 80        LDX   #$8180
8161: 17 00 a0        LBSR  $8204
8164: 35 10           PULS  X
8166: a6 81           LDA   ,X++
8168: a6 81           LDA   ,X++
816a: 86 80           LDA   #$80
816c: 17 00 95        LBSR  $8204
816f: 86 a0           LDA   #$A0
8171: 17 00 90        LBSR  $8204
8174: 86 c0           LDA   #$C0
8176: 17 00 8b        LBSR  $8204
8179: 86 e0           LDA   #$E0
817b: 17 00 b3        LBSR  $8231
817e: 35 b0           PULS  X,Y,PC	; rts

8180: 7f 7f 7f        CLR   $7F7F
8183: 7f 86 18        CLR   $8618

8186: 8d 0a           BSR   $8192
8188: 86 19           LDA   #$19
818a: 8d 06           BSR   $8192
818c: 86 19           LDA   #$19
818e: 8d 02           BSR   $8192
8190: 86 1b           LDA   #$1B

8192: 1a 40           ORCC  #$40
8194: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
8197: 8d 07           BSR   $81A0 - wait_ym2151_not_busy
8199: a6 a0           LDA   ,Y+
819b: b7 28 01        STA   $2801 - REG_YM2151_DATA
819e: 1c bf           ANDCC #$BF

wait_ym2151_not_busy:
81a0: b6 28 01        LDA   $2801 - REG_YM2151_DATA
81a3: 84 80           ANDA  #$80
81a5: 26 f9           BNE   $81A0 - wait_ym2151_not_busy
81a7: 39              RTS

81a8: 1a 40           ORCC  #$40
81aa: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
81ad: 8d f1           BSR   $81A0 - wait_ym2151_not_busy
81af: a6 a0           LDA   ,Y+
81b1: 8a c0           ORA   #$C0
81b3: b7 28 01        STA   $2801 - REG_YM2151_DATA
81b6: 1c bf           ANDCC #$BF
81b8: 20 e6           BRA   $81A0 - wait_ym2151_not_busy
81ba: 1a 40           ORCC  #$40
81bc: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
81bf: 8d df           BSR   $81A0 - wait_ym2151_not_busy
81c1: a6 a0           LDA   ,Y+
81c3: 44              LSRA
81c4: b7 28 01        STA   $2801 - REG_YM2151_DATA
81c7: 1c bf           ANDCC #$BF
81c9: 20 d5           BRA   $81A0 - wait_ym2151_not_busy
81cb: 34 10           PSHS  X
81cd: d6 4b           LDB   $4B
81cf: 1e 12           EXG   X,Y
81d1: 58              ASLB
81d2: 58              ASLB
81d3: 3a              ABX
81d4: a6 a0           LDA   ,Y+
81d6: 48              ASLA
81d7: a7 80           STA   ,X+
81d9: a6 a0           LDA   ,Y+
81db: 48              ASLA
81dc: a7 80           STA   ,X+
81de: a6 a0           LDA   ,Y+
81e0: 48              ASLA
81e1: a7 80           STA   ,X+
81e3: a6 a4           LDA   ,Y
81e5: 48              ASLA
81e6: a7 84           STA   ,X
81e8: 35 90           PULS  X,PC	; rts

81ea: d6 4b           LDB   $4B
81ec: 58              ASLB
81ed: 58              ASLB
81ee: 1e 12           EXG   X,Y
81f0: 3a              ABX
81f1: a6 a0           LDA   ,Y+
81f3: a7 80           STA   ,X+
81f5: a6 a0           LDA   ,Y+
81f7: a7 80           STA   ,X+
81f9: a6 a0           LDA   ,Y+
81fb: a7 80           STA   ,X+
81fd: a6 a0           LDA   ,Y+
81ff: a7 80           STA   ,X+
8201: 1e 12           EXG   X,Y
8203: 39              RTS

8204: 10 8e 82 9a     LDY   #$829a - YM2151_REGISTER_LIST
8208: 34 26           PSHS  Y,B,A
820a: 8d 08           BSR   $8214
820c: 8d 06           BSR   $8214
820e: 8d 04           BSR   $8214
8210: 8d 02           BSR   $8214
8212: 35 a6           PULS  A,B,Y,PC	; rts

8214: 34 02           PSHS  A
8216: ab a0           ADDA  ,Y+
8218: 9b 4b           ADDA  $4B
821a: 1a 40           ORCC  #$40
821c: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
821f: 17 ff 7e        LBSR  $81A0 - wait_ym2151_not_busy
8222: e6 80           LDB   ,X+
8224: f7 28 01        STB   $2801 - REG_YM2151_DATA
8227: 1c bf           ANDCC #$BF
8229: 17 ff 74        LBSR  $81A0 - wait_ym2151_not_busy
822c: 12              NOP
822d: 12              NOP
822e: 35 02           PULS  A
8230: 39              RTS

8231: 10 8e 82 9a     LDY   #$829a - YM2151_REGISTER_LIST
8235: 34 26           PSHS  Y,B,A
8237: 8d 08           BSR   $8241
8239: 8d 06           BSR   $8241
823b: 8d 04           BSR   $8241
823d: 8d 02           BSR   $8241
823f: 35 a6           PULS  A,B,Y,PC 	; rts

8241: 34 02           PSHS  A
8243: ab a0           ADDA  ,Y+
8245: 9b 4b           ADDA  $4B
8247: 1a 40           ORCC  #$40
8249: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
824c: 17 ff 51        LBSR  $81A0 - wait_ym2151_not_busy
824f: e6 80           LDB   ,X+
8251: 53              COMB
8252: c4 f0           ANDB  #$F0
8254: d7 63           STB   $63
8256: e6 1f           LDB   -$1,X
8258: c4 0f           ANDB  #$0F
825a: da 63           ORB   $63
825c: f7 28 01        STB   $2801 - REG_YM2151_DATA
825f: 1c bf           ANDCC #$BF
8261: 17 ff 3c        LBSR  $81A0 - wait_ym2151_not_busy
8264: 12              NOP
8265: 12              NOP
8266: 35 02           PULS  A
8268: 39              RTS

8269: 10 8e 82 9a     LDY   #$829a - YM2151_REGISTER_LIST
826d: 34 26           PSHS  Y,B,A
826f: 8d 08           BSR   $8279
8271: 8d 06           BSR   $8279
8273: 8d 04           BSR   $8279
8275: 8d 02           BSR   $8279
8277: 35 a6           PULS  A,B,Y,PC ; rts

8279: 34 02           PSHS  A
827b: ab a0           ADDA  ,Y+
827d: 9b 4b           ADDA  $4B
827f: 1a 40           ORCC  #$40
8281: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
8284: 17 ff 19        LBSR  $81A0 - wait_ym2151_not_busy
8287: e6 80           LDB   ,X+
8289: 53              COMB
828a: 54              LSRB
828b: c4 7f           ANDB  #$7F
828d: f7 28 01        STB   $2801 - REG_YM2151_DATA
8290: 1c bf           ANDCC #$BF
8292: 17 ff 0b        LBSR  $81A0 - wait_ym2151_not_busy
8295: 12              NOP
8296: 12              NOP
8297: 35 02           PULS  A
8299: 39              RTS

YM2151_REGISTER_LIST	00 08 10 18
#829a: 00 08           NEG   $08
#829c: 10 18           FCB   $10,$18

829e: 96 4b           LDA   $4B		; channel number?
82a0: 8b 28           ADDA  #$28  - REG_YM2151_KEY_CODE_BASE
82a2: 1a 40           ORCC  #$40
82a4: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
82a7: 17 fe f6        LBSR  $81A0 - wait_ym2151_not_busy
82aa: e6 80           LDB   ,X+
82ac: f7 28 01        STB   $2801 - REG_YM2151_DATA
82af: 1c bf           ANDCC #$BF
82b1: 16 fe ec        LBRA  $81A0 - wait_ym2151_not_busy
82b4: 34 30           PSHS  Y,X
82b6: 8e 00 ae        LDX   #$00AE	; clear data related to channel number
82b9: d6 4b           LDB   $4B
82bb: 6f 85           CLR   B,X
82bd: 8e 00 be        LDX   #$00BE	; clear data related to channel number
82c0: 6f 85           CLR   B,X
82c2: 8e 00 1b        LDX   #$001B	; ?
82c5: 58              ASLB		; channel number * 2
82c6: 3a              ABX		; 
82c7: 6f 80           CLR   ,X+		; clear 2 bytes
82c9: 6f 84           CLR   ,X
82cb: 8e 00 2b        LDX   #$002B
82ce: 58              ASLB		; channel number * 4
82cf: 3a              ABX
82d0: 86 ff           LDA   #$FF	; #ff<addres67>0100
82d2: a7 80           STA   ,X+
82d4: 96 67           LDA   $67
82d6: a7 80           STA   ,X+
82d8: 86 01           LDA   #$01
82da: a7 80           STA   ,X+
82dc: 6f 84           CLR   ,X
82de: 96 00           LDA   $00
82e0: 8e 00 02        LDX   #$0002
82e3: d6 4b           LDB   $4B
82e5: a7 85           STA   B,X		; same $00 to $02 + channel number
82e7: 8e 00 76        LDX   #$0076
82ea: 58              ASLB
82eb: db 4b           ADDB  $4B
82ed: 3a              ABX		; $0076 + (3* channel number)
82ee: 96 67           LDA   $67
82f0: 4c              INCA
82f1: a7 80           STA   ,X+		; $67+1
82f3: a7 80           STA   ,X+		; $67+1
82f5: 35 b0           PULS  X,Y,PC	;rts

82f7: d6 00           LDB   $00
82f9: 58              ASLB
82fa: 8e 90 00        LDX   #$9000
82fd: 10 ae 85        LDY   B,X
8300: a6 a4           LDA   ,Y
8302: 84 80           ANDA  #$80
8304: 26 49           BNE   $834F
8306: 96 02           LDA   $02
8308: 27 06           BEQ   $8310
830a: 91 00           CMPA  $00
830c: 27 03           BEQ   $8311
830e: 8d 0b           BSR   $831B
8310: 39              RTS
8311: 0f 00           CLR   $00
8313: 39              RTS
8314: 8d 03           BSR   $8319
8316: 8d 35           BSR   $834D
8318: 39              RTS

8319: 0f 00           CLR   $00
831b: 34 30           PSHS  Y,X
831d: 0f 4b           CLR   $4B
831f: 8e 00 02        LDX   #$0002
8322: 8d 0a           BSR   $832E
8324: 0c 4b           INC   $4B
8326: 96 4b           LDA   $4B
8328: 81 07           CMPA  #$07
832a: 26 f6           BNE   $8322
832c: 35 b0           PULS  X,Y,PC	; rts

832e: a6 80           LDA   ,X+
8330: 27 05           BEQ   $8337
8332: 6f 1f           CLR   -$1,X
8334: 17 04 c1        LBSR  $87f8 - ym2151_write_key_on
8337: 39              RTS

8338: 34 30           PSHS  Y,X
833a: 96 00           LDA   $00
833c: 0f 00           CLR   $00
833e: 84 0f           ANDA  #$0F
8340: 97 4b           STA   $4B
8342: 8e 00 02        LDX   #$0002
8345: 6f 86           CLR   A,X
8347: 17 04 ae        LBSR  $87f8 - ym2151_write_key_on
834a: 35 30           PULS  X,Y
834c: 39              RTS

834d: 0f 00           CLR   $00
834f: 8e 00 09        LDX   #$0009
8352: 86 07           LDA   #$07
8354: 97 4b           STA   $4B
8356: 20 da           BRA   $8332
8358: 34 30           PSHS  Y,X
835a: a6 b4           LDA   [,Y]
835c: 84 0f           ANDA  #$0F
835e: 97 4b           STA   $4B
8360: 96 4b           LDA   $4B
8362: 8e 00 02        LDX   #$0002
8365: e6 86           LDB   A,X
8367: 27 1e           BEQ   $8387
8369: d1 00           CMPB  $00
836b: 27 1f           BEQ   $838C
836d: c4 7f           ANDB  #$7F
836f: 8e 00 02        LDX   #$0002
8372: 3a              ABX
8373: 3a              ABX
8374: 3a              ABX
8375: a6 84           LDA   ,X
8377: 84 7f           ANDA  #$7F
8379: d6 4d           LDB   $4D
837b: c4 7f           ANDB  #$7F
837d: d7 4d           STB   $4D
837f: 91 4d           CMPA  $4D
8381: 24 04           BCC   $8387
8383: 0f 00           CLR   $00
8385: 35 b0           PULS  X,Y,PC	; rts
8387: 17 04 6e        LBSR  $87f8 - ym2151_write_key_on
838a: 35 b0           PULS  X,Y,PC	; rts

838c: 96 4d           LDA   $4D
838e: 84 80           ANDA  #$80
8390: 27 f5           BEQ   $8387
8392: 0f 00           CLR   $00
8394: 35 b0           PULS  X,Y,PC	; rts

8396: 0f 4b           CLR   $4B
8398: 8e 00 02        LDX   #$0002
839b: 10 8e 00 2e     LDY   #$002E
839f: e6 80           LDB   ,X+
83a1: 27 06           BEQ   $83A9
83a3: a6 a4           LDA   ,Y
83a5: 27 02           BEQ   $83A9
83a7: 8d 0d           BSR   $83B6
83a9: a6 a1           LDA   ,Y++
83ab: a6 a1           LDA   ,Y++
83ad: 0c 4b           INC   $4B
83af: 96 4b           LDA   $4B
83b1: 81 08           CMPA  #$08
83b3: 26 ea           BNE   $839F
83b5: 39              RTS

83b6: c5 80           BITB  #$80
83b8: 10 26 02 04     LBNE  $85C0
83bc: 85 80           BITA  #$80
83be: 27 0e           BEQ   $83CE
83c0: 34 02           PSHS  A
83c2: 17 04 33        LBSR  $87f8 - ym2151_write_key_on
83c5: 35 02           PULS  A
83c7: 84 7f           ANDA  #$7F
83c9: 26 03           BNE   $83CE
83cb: a7 a4           STA   ,Y
83cd: 39              RTS

83ce: 34 30           PSHS  Y,X
83d0: 8e 00 50        LDX   #$0050
83d3: d6 4b           LDB   $4B
83d5: 3a              ABX
83d6: a6 84           LDA   ,X
83d8: 84 07           ANDA  #$07
83da: 97 58           STA   $58
83dc: 8e 00 0b        LDX   #$000B
83df: 58              ASLB
83e0: 3a              ABX
83e1: 1f 12           TFR   X,Y
83e3: 8e 00 1b        LDX   #$001B
83e6: 3a              ABX
83e7: 34 10           PSHS  X
83e9: ec a4           LDD   ,Y
83eb: e3 84           ADDD  ,X
83ed: 1f 01           TFR   D,X
83ef: a6 84           LDA   ,X
83f1: 85 80           BITA  #$80
83f3: 27 28           BEQ   $841D
83f5: 84 0f           ANDA  #$0F
83f7: 48              ASLA
83f8: 10 8e 84 09     LDY   #$8409	; JUMP_TABLE
83fc: e6 a6           LDB   A,Y
83fe: d7 4e           STB   $4E
8400: 4c              INCA
8401: e6 a6           LDB   A,Y
8403: d7 4f           STB   $4F
8405: 6e 9f 00 4e     JMP   [$004E]	; jump to location in JUMP_TABLE

JUMP_TABLE:
8409: 84 8b           ANDA  #$8B
840b: 84 86           ANDA  #$86
840d: 84 ad           ANDA  #$AD
840f: 84 a2           ANDA  #$A2
8411: 84 ec           ANDA  #$EC
8413: 85 14           BITA  #$14
8415: 85 3a           BITA  #$3A
8417: 85 ac           BITA  #$AC
8419: 85 55           BITA  #$55
841b: 85 01           BITA  #$01

841d: a6 84           LDA   ,X
841f: 34 02           PSHS  A
8421: a6 01           LDA   $1,X
8423: 8e 00 76        LDX   #$0076
8426: d6 4b           LDB   $4B
8428: 3a              ABX
8429: 3a              ABX
842a: 3a              ABX
842b: a7 02           STA   $2,X
842d: 26 06           BNE   $8435
842f: 86 20           LDA   #$20
8431: a7 02           STA   $2,X
8433: 86 08           LDA   #$08
8435: e6 01           LDB   $1,X
8437: e7 84           STB   ,X
8439: 8e 00 2d        LDX   #$002D
843c: d6 4b           LDB   $4B
843e: 58              ASLB
843f: 58              ASLB
8440: 3a              ABX
8441: 6d 84           TST   ,X
8443: 27 0a           BEQ   $844F
8445: ab 84           ADDA  ,X
8447: 27 02           BEQ   $844B
8449: 25 04           BCS   $844F
844b: a7 84           STA   ,X
844d: 20 04           BRA   $8453
844f: a7 84           STA   ,X
8451: 6f 01           CLR   $1,X
8453: 35 02           PULS  A
8455: 4d              TSTA
8456: 27 23           BEQ   $847B
8458: d6 4b           LDB   $4B		; ym2151 channel to use?
845a: 8e 00 59        LDX   #$0059	; address $59 + channel number = sound to play?
845d: ab 85           ADDA  B,X
845f: 24 08           BCC   $8469
8461: 81 5f           CMPA  #$5F
8463: 25 0a           BCS   $846F
8465: 86 01           LDA   #$01
8467: 20 06           BRA   $846F

8469: 81 5f           CMPA  #$5F
846b: 25 02           BCS   $846F
846d: 86 5f           LDA   #$5F
846f: 8e 89 b7        LDX   #$89B7 - YM2151_TABLE
8472: 1f 89           TFR   A,B
8474: 3a              ABX		; offset in table to be between 1 and $5f
8475: 17 fe 26        LBSR  $829E
8478: 17 03 69        LBSR  $87e4 - ym2151_key_on_all:
847b: 35 20           PULS  Y
847d: ec a4           LDD   ,Y
847f: c3 00 02        ADDD  #$0002
8482: ed a4           STD   ,Y
8484: 35 b0           PULS  X,Y,PC	; rts

8486: 8e 00 9e        LDX   #$009E
8489: 20 03           BRA   $848E
848b: 8e 00 8e        LDX   #$008E
848e: d6 4b           LDB   $4B
8490: 58              ASLB
8491: 3a              ABX
8492: 35 20           PULS  Y
8494: ec a4           LDD   ,Y
8496: c3 00 01        ADDD  #$0001
8499: ed 84           STD   ,X
849b: ed a4           STD   ,Y
849d: 35 30           PULS  X,Y
849f: 16 ff 2c        LBRA  $83CE

84a2: e6 01           LDB   $1,X
84a4: 10 8e 00 9e     LDY   #$009E
84a8: 8e 00 be        LDX   #$00BE
84ab: 20 09           BRA   $84B6

84ad: e6 01           LDB   $1,X
84af: 10 8e 00 8e     LDY   #$008E
84b3: 8e 00 ae        LDX   #$00AE
84b6: 34 04           PSHS  B
84b8: d6 4b           LDB   $4B
84ba: 3a              ABX
84bb: 35 04           PULS  B
84bd: a6 84           LDA   ,X
84bf: 27 13           BEQ   $84D4
84c1: 4a              DECA
84c2: 26 15           BNE   $84D9
84c4: 6f 84           CLR   ,X
84c6: 35 20           PULS  Y
84c8: ec a4           LDD   ,Y
84ca: c3 00 02        ADDD  #$0002
84cd: ed a4           STD   ,Y
84cf: 35 30           PULS  X,Y
84d1: 16 fe fa        LBRA  $83CE
84d4: 5a              DECB
84d5: 27 ed           BEQ   $84C4
84d7: 1f 98           TFR   B,A
84d9: a7 84           STA   ,X
84db: d6 4b           LDB   $4B
84dd: 58              ASLB
84de: 1f 21           TFR   Y,X
84e0: 3a              ABX
84e1: ec 84           LDD   ,X
84e3: 35 20           PULS  Y
84e5: ed a4           STD   ,Y
84e7: 35 30           PULS  X,Y
84e9: 16 fe e2        LBRA  $83CE
84ec: a6 80           LDA   ,X+
84ee: ec 84           LDD   ,X
84f0: 17 fc 02        LBSR  $80F5
84f3: 35 20           PULS  Y
84f5: ec a4           LDD   ,Y
84f7: c3 00 03        ADDD  #$0003
84fa: ed a4           STD   ,Y
84fc: 35 30           PULS  X,Y
84fe: 16 fe cd        LBRA  $83CE
8501: a6 80           LDA   ,X+
8503: a6 84           LDA   ,X
8505: 8e 00 ce        LDX   #$00CE
8508: d6 4b           LDB   $4B
850a: 58              ASLB
850b: 58              ASLB
850c: 3a              ABX
850d: 34 10           PSHS  X
850f: 17 02 21        LBSR  $8733
8512: 20 11           BRA   $8525
8514: a6 80           LDA   ,X+
8516: a6 84           LDA   ,X
8518: 8e 00 ce        LDX   #$00CE
851b: d6 4b           LDB   $4B
851d: 58              ASLB
851e: 58              ASLB
851f: 3a              ABX
8520: 34 10           PSHS  X
8522: 17 01 e7        LBSR  $870C
8525: 35 10           PULS  X
8527: 86 60           LDA   #$60
8529: 17 fd 3d        LBSR  $8269
852c: 35 20           PULS  Y
852e: ec a4           LDD   ,Y
8530: c3 00 02        ADDD  #$0002
8533: ed a4           STD   ,Y
8535: 35 30           PULS  X,Y
8537: 16 fe 94        LBRA  $83CE
853a: a6 80           LDA   ,X+
853c: a6 84           LDA   ,X
853e: 8e 00 59        LDX   #$0059
8541: d6 4b           LDB   $4B
8543: ab 85           ADDA  B,X
8545: a7 85           STA   B,X
8547: 35 20           PULS  Y
8549: ec a4           LDD   ,Y
854b: c3 00 02        ADDD  #$0002
854e: ed a4           STD   ,Y
8550: 35 30           PULS  X,Y
8552: 16 fe 79        LBRA  $83CE
8555: a6 80           LDA   ,X+
8557: a6 84           LDA   ,X
8559: 49              ROLA
855a: 49              ROLA
855b: 49              ROLA
855c: 84 03           ANDA  #$03
855e: 8e 00 2b        LDX   #$002B
8561: d6 4b           LDB   $4B
8563: 58              ASLB
8564: 58              ASLB
8565: 3a              ABX
8566: e6 01           LDB   $1,X
8568: d7 67           STB   $67
856a: 4d              TSTA
856b: 27 10           BEQ   $857D
856d: 4a              DECA
856e: 27 13           BEQ   $8583
8570: 4a              DECA
8571: 27 17           BEQ   $858A
8573: d6 67           LDB   $67
8575: cb 05           ADDB  #$05
8577: 24 19           BCC   $8592
8579: c6 ff           LDB   #$FF
857b: 20 15           BRA   $8592
857d: 53              COMB
857e: 54              LSRB
857f: 27 f2           BEQ   $8573
8581: 20 0d           BRA   $8590
8583: 53              COMB
8584: 54              LSRB
8585: 54              LSRB
8586: 27 eb           BEQ   $8573
8588: 20 06           BRA   $8590
858a: 53              COMB
858b: 54              LSRB
858c: 54              LSRB
858d: 54              LSRB
858e: 27 e3           BEQ   $8573
8590: db 67           ADDB  $67
8592: 1f 98           TFR   B,A
8594: 8e 00 76        LDX   #$0076
8597: d6 4b           LDB   $4B
8599: 3a              ABX
859a: 3a              ABX
859b: 3a              ABX
859c: a7 01           STA   $1,X
859e: 35 20           PULS  Y
85a0: ec a4           LDD   ,Y
85a2: c3 00 02        ADDD  #$0002
85a5: ed a4           STD   ,Y
85a7: 35 30           PULS  X,Y
85a9: 16 fe 22        LBRA  $83CE
85ac: d6 4b           LDB   $4B
85ae: 8e 00 02        LDX   #$0002
85b1: 6f 85           CLR   B,X
85b3: 8e 00 76        LDX   #$0076
85b6: 58              ASLB
85b7: 6f 85           CLR   B,X
85b9: 5c              INCB
85ba: 6f 85           CLR   B,X
85bc: 35 20           PULS  Y
85be: 35 b0           PULS  X,Y,PC	; rts

85c0: 34 30           PSHS  Y,X
85c2: 8e 00 50        LDX   #$0050
85c5: d6 4b           LDB   $4B
85c7: 3a              ABX
85c8: a6 84           LDA   ,X
85ca: 84 07           ANDA  #$07
85cc: 97 58           STA   $58
85ce: 8e 00 0b        LDX   #$000B
85d1: 58              ASLB
85d2: 3a              ABX
85d3: 1f 12           TFR   X,Y
85d5: 8e 00 1b        LDX   #$001B
85d8: 3a              ABX
85d9: 34 10           PSHS  X
85db: ec a4           LDD   ,Y
85dd: e3 84           ADDD  ,X
85df: 1f 01           TFR   D,X
85e1: a6 84           LDA   ,X
85e3: 85 80           BITA  #$80
85e5: 27 28           BEQ   $860F
85e7: 81 80           CMPA  #$80
85e9: 10 27 00 a5     LBEQ  $8692
85ed: 81 81           CMPA  #$81
85ef: 10 27 00 9a     LBEQ  $868D
85f3: 81 82           CMPA  #$82
85f5: 10 27 00 bb     LBEQ  $86B4
85f9: 81 83           CMPA  #$83
85fb: 10 27 00 aa     LBEQ  $86A9
85ff: 81 86           CMPA  #$86
8601: 10 27 00 ee     LBEQ  $86F3
8605: 81 8a           CMPA  #$8A
8607: 27 a3           BEQ   $85AC
8609: 17 01 ec        LBSR  $87f8 - ym2151_write_key_on
860c: 16 ff 9d        LBRA  $85AC
860f: 17 01 e6        LBSR  $87f8 - ym2151_write_key_on
8612: 10 8e 00 6c     LDY   #$006C
8616: 96 4b           LDA   $4B
8618: e6 a6           LDB   A,Y
861a: d7 6b           STB   $6B
861c: e6 02           LDB   $2,X
861e: 10 8e 00 2d     LDY   #$002D
8622: 48              ASLA
8623: 48              ASLA
8624: 6d a6           TST   A,Y
8626: 27 0a           BEQ   $8632
8628: eb a6           ADDB  A,Y
862a: 27 02           BEQ   $862E
862c: 25 04           BCS   $8632
862e: e7 a6           STB   A,Y
8630: 20 05           BRA   $8637
8632: e7 a6           STB   A,Y
8634: 4c              INCA
8635: 6f a6           CLR   A,Y
8637: 96 6b           LDA   $6B
8639: 27 15           BEQ   $8650
863b: a6 80           LDA   ,X+
863d: 34 10           PSHS  X
863f: d6 4b           LDB   $4B
8641: 8e 00 59        LDX   #$0059
8644: ab 85           ADDA  B,X
8646: 8e 89 b7        LDX   #$89B7 - YM2151_TABLE
8649: 1f 89           TFR   A,B
864b: 3a              ABX
864c: a6 84           LDA   ,X
864e: 20 0c           BRA   $865C
8650: a6 80           LDA   ,X+
8652: 34 10           PSHS  X
8654: 10 8e 00 59     LDY   #$0059
8658: d6 4b           LDB   $4B
865a: ab a5           ADDA  B,Y
865c: 8e 00 67        LDX   #$0067
865f: d6 4b           LDB   $4B
8661: 3a              ABX
8662: a7 84           STA   ,X
8664: 17 fc 37        LBSR  $829E
8667: 35 10           PULS  X
8669: a6 84           LDA   ,X
866b: d6 4b           LDB   $4B
866d: 58              ASLB
866e: 58              ASLB
866f: 8e 00 ce        LDX   #$00CE
8672: 3a              ABX
8673: 34 10           PSHS  X
8675: 17 00 94        LBSR  $870C
8678: 35 10           PULS  X
867a: 86 60           LDA   #$60
867c: 17 fb 85        LBSR  $8204
867f: 17 01 62        LBSR  $87e4 - ym2151_key_on_all:
8682: 35 20           PULS  Y
8684: ec a4           LDD   ,Y
8686: c3 00 03        ADDD  #$0003
8689: ed a4           STD   ,Y
868b: 35 b0           PULS  X,Y,PC	; rts

868d: 8e 00 9e        LDX   #$009E
8690: 20 03           BRA   $8695
8692: 8e 00 8e        LDX   #$008E
8695: d6 4b           LDB   $4B
8697: 58              ASLB
8698: 3a              ABX
8699: 35 20           PULS  Y
869b: ec a4           LDD   ,Y
869d: c3 00 01        ADDD  #$0001
86a0: ed a4           STD   ,Y
86a2: ed 84           STD   ,X
86a4: 35 30           PULS  X,Y
86a6: 16 ff 17        LBRA  $85C0
86a9: e6 01           LDB   $1,X
86ab: 10 8e 00 9e     LDY   #$009E
86af: 8e 00 be        LDX   #$00BE
86b2: 20 09           BRA   $86BD
86b4: e6 01           LDB   $1,X
86b6: 10 8e 00 8e     LDY   #$008E
86ba: 8e 00 ae        LDX   #$00AE
86bd: 34 04           PSHS  B
86bf: d6 4b           LDB   $4B
86c1: 3a              ABX
86c2: 35 04           PULS  B
86c4: a6 84           LDA   ,X
86c6: 27 13           BEQ   $86DB
86c8: 4a              DECA
86c9: 26 15           BNE   $86E0
86cb: 6f 84           CLR   ,X
86cd: 35 20           PULS  Y
86cf: ec a4           LDD   ,Y
86d1: c3 00 02        ADDD  #$0002
86d4: ed a4           STD   ,Y
86d6: 35 30           PULS  X,Y
86d8: 16 fe e5        LBRA  $85C0
86db: 5a              DECB
86dc: 27 ed           BEQ   $86CB
86de: 1f 98           TFR   B,A
86e0: a7 84           STA   ,X
86e2: d6 4b           LDB   $4B
86e4: 58              ASLB
86e5: 1f 21           TFR   Y,X
86e7: 3a              ABX
86e8: ec 84           LDD   ,X
86ea: 35 20           PULS  Y
86ec: ed a4           STD   ,Y
86ee: 35 30           PULS  X,Y
86f0: 16 fe cd        LBRA  $85C0
86f3: a6 80           LDA   ,X+
86f5: a6 84           LDA   ,X
86f7: 8e 00 59        LDX   #$0059
86fa: d6 4b           LDB   $4B
86fc: a7 85           STA   B,X
86fe: 35 20           PULS  Y
8700: ec a4           LDD   ,Y
8702: c3 00 02        ADDD  #$0002
8705: ed a4           STD   ,Y
8707: 35 30           PULS  X,Y
8709: 16 fe b4        LBRA  $85C0
870c: d6 58           LDB   $58
870e: c1 07           CMPB  #$07
8710: 27 18           BEQ   $872A
8712: c1 04           CMPB  #$04
8714: 27 0e           BEQ   $8724
8716: 24 08           BCC   $8720
8718: e6 80           LDB   ,X+
871a: e6 80           LDB   ,X+
871c: e6 80           LDB   ,X+
871e: 20 10           BRA   $8730
8720: e6 80           LDB   ,X+
8722: 20 08           BRA   $872C
8724: e6 80           LDB   ,X+
8726: e6 80           LDB   ,X+
8728: 20 04           BRA   $872E
872a: a7 80           STA   ,X+
872c: a7 80           STA   ,X+
872e: a7 80           STA   ,X+
8730: a7 84           STA   ,X
8732: 39              RTS
8733: 44              LSRA
8734: 44              LSRA
8735: 44              LSRA
8736: 84 1f           ANDA  #$1F
8738: 1f 12           TFR   X,Y
873a: 8e 00 ee        LDX   #$00EE
873d: d6 4b           LDB   $4B
873f: 58              ASLB
8740: 58              ASLB
8741: 3a              ABX
8742: e6 80           LDB   ,X+
8744: 8d 0a           BSR   $8750
8746: e6 80           LDB   ,X+
8748: 8d 06           BSR   $8750
874a: e6 80           LDB   ,X+
874c: 8d 02           BSR   $8750
874e: e6 80           LDB   ,X+
8750: 34 10           PSHS  X
8752: c4 07           ANDB  #$07
8754: 27 33           BEQ   $8789
8756: 8e 8a 18        LDX   #$8A18
8759: 5a              DECB
875a: 27 21           BEQ   $877D
875c: 8e 8a 38        LDX   #$8A38
875f: 5a              DECB
8760: 27 1b           BEQ   $877D
8762: 8e 8a 58        LDX   #$8A58
8765: 5a              DECB
8766: 27 15           BEQ   $877D
8768: 8e 8a 78        LDX   #$8A78
876b: 5a              DECB
876c: 27 0f           BEQ   $877D
876e: 8e 8a 98        LDX   #$8A98
8771: 5a              DECB
8772: 27 09           BEQ   $877D
8774: 8e 8a b8        LDX   #$8AB8
8777: 5a              DECB
8778: 27 03           BEQ   $877D
877a: 8e 8a d8        LDX   #$8AD8
877d: e6 86           LDB   A,X
877f: eb a4           ADDB  ,Y
8781: 24 02           BCC   $8785
8783: c6 ff           LDB   #$FF
8785: e7 a0           STB   ,Y+
8787: 35 90           PULS  X,PC	; rts

8789: e6 a0           LDB   ,Y+
878b: 35 90           PULS  X,PC	; rts

878d: 86 1f           LDA   #$1F
878f: 1f 12           TFR   X,Y
8791: 8e 00 ee        LDX   #$00EE
8794: d6 4b           LDB   $4B
8796: 58              ASLB
8797: 58              ASLB
8798: 3a              ABX
8799: e6 80           LDB   ,X+
879b: 8d 0a           BSR   $87A7
879d: e6 80           LDB   ,X+
879f: 8d 06           BSR   $87A7
87a1: e6 80           LDB   ,X+
87a3: 8d 02           BSR   $87A7
87a5: e6 80           LDB   ,X+
87a7: 34 10           PSHS  X
87a9: c4 07           ANDB  #$07
87ab: 27 33           BEQ   $87E0
87ad: 8e 8a 18        LDX   #$8A18
87b0: 5a              DECB
87b1: 27 21           BEQ   $87D4
87b3: 8e 8a 38        LDX   #$8A38
87b6: 5a              DECB
87b7: 27 1b           BEQ   $87D4
87b9: 8e 8a 58        LDX   #$8A58
87bc: 5a              DECB
87bd: 27 15           BEQ   $87D4
87bf: 8e 8a 78        LDX   #$8A78
87c2: 5a              DECB
87c3: 27 0f           BEQ   $87D4
87c5: 8e 8a 98        LDX   #$8A98
87c8: 5a              DECB
87c9: 27 09           BEQ   $87D4
87cb: 8e 8a b8        LDX   #$8AB8
87ce: 5a              DECB
87cf: 27 03           BEQ   $87D4
87d1: 8e 8a d8        LDX   #$8AD8
87d4: e6 a4           LDB   ,Y
87d6: e0 86           SUBB  A,X
87d8: 24 02           BCC   $87DC
87da: c6 00           LDB   #$00
87dc: e7 a0           STB   ,Y+
87de: 35 90           PULS  X,PC	; rts
87e0: e6 a0           LDB   ,Y+
87e2: 35 90           PULS  X,PC	; rts

; $4b channel(s) to be on
ym2151_key_on_all:
87e4: c6 08           LDB   #$08
87e6: 1a 40           ORCC  #$40
87e8: f7 28 00        STB   $2800 - REG_YM2151_ADDRESS
87eb: 17 f9 b2        LBSR  $81A0 - wait_ym2151_not_busy
87ee: 96 4b           LDA   $4B
87f0: 8a f0           ORA   #$F0
87f2: b7 28 01        STA   $2801 - REG_YM2151_DATA
87f5: 1c bf           ANDCC #$BF
87f7: 39              RTS

; $4b data to write
ym2151_write_key_on:
87f8: c6 08           LDB   #$08
87fa: 1a 40           ORCC  #$40
87fc: f7 28 00        STB   $2800 - REG_YM2151_ADDRESS
87ff: 17 f9 9e        LBSR  $81A0 - wait_ym2151_not_busy
8802: 96 4b           LDA   $4B
8804: b7 28 01        STA   $2801 - REG_YM2151_DATA
8807: 1c bf           ANDCC #$BF
8809: 17 f9 94        LBSR  $81A0 - wait_ym2151_not_busy
880c: 39              RTS

handle_irq:
880d: b6 10 00        LDA   $1000	; load byte from cpu
8810: 91 02           CMPA  $02		; compare to ram address $02
8812: 27 06           BEQ   $881A	; if equal return
8814: d6 00           LDB   $00		; load b with ram address $00
8816: 26 03           BNE   $881B
8818: 97 0a           STA   $0A
881a: 3b              RTI

881b: 96 0a           LDA   $0A		; load a with ram address $0a
881d: 27 f9           BEQ   $8818	; if empty return
881f: 1f 89           TFR   A,B		; 
8821: c4 80           ANDB  #$80
8823: 27 f3           BEQ   $8818
8825: 3b              RTI

do_init:
8826: 8d 2e           BSR   $8856 - clear_ram
8828: 8e 88 37        LDX   #$8837 - YM2151_INIT_TIMER_DATA
882b: a6 80           LDA   ,X+
882d: 97 61           STA   $61
882f: bd 88 3e        JSR   $883e - write_array_ym2151
8832: 8d 32           BSR   $8866 - clear_ym2151_channels
8834: 1c af           ANDCC #$AF	; enable ints
8836: 39              RTS

YM2151_INIT_TIMER_DATA
 03 = number of reg/data pairs
 10 f2 = CLKA1 to F2
 11 10 = CLKA2 to 0  should set TIMERA to once a 1ms
 14 15 = reset TIMERA enable int on it
8837: 03 10           COM   $10
8839: f2 11 10        SBCB  $1110
883c: 14              SEXW
883d: 15              FCB   $15


; $61 number of register + data pairs
write_array_ym2151:
883e: bd 81 a0        JSR   $81A0 - wait_ym2151_not_busy
8841: a6 80           LDA   ,X+
8843: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
8846: bd 81 a0        JSR   $81A0 - wait_ym2151_not_busy
8849: a6 80           LDA   ,X+
884b: b7 28 01        STA   $2801 - REG_YM2151_DATA
884e: bd 81 a0        JSR   $81A0 - wait_ym2151_not_busy
8851: 0a 61           DEC   $61
8853: 26 e9           BNE   $883e - write_array_ym2151
8855: 39              RTS

clear_ram:
8856: 1a 50           ORCC  #$50	; disable intrrupts
8858: 4f              CLRA
8859: 1f 8b           TFR   A,DP
885b: 8e 00 00        LDX   #$0000	; start of ram
885e: 6f 80           CLR   ,X+		; 
8860: 8c 01 0e        CMPX  #$010E
8863: 25 f9           BCS   $885E	; next ram address
8865: 39              RTS

clear_ym2151_channels:
8866: 0f 4b           CLR   $4B
8868: 8d 09           BSR   $8873	- clear_ym2151_channel
886a: 0c 4b           INC   $4B
886c: 96 4b           LDA   $4B
886e: 81 08           CMPA  #$08
8870: 26 f6           BNE   $8868
8872: 39              RTS

; $4b = channel to clear
clear_ym2151_channel:
8873: 86 08           LDA   #$08
8875: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
8878: 17 f9 25        LBSR  $81A0 - wait_ym2151_not_busy
887b: b6 00 4b        LDA   $004B
887e: b7 28 01        STA   $2801 - REG_YM2151_DATA
8881: 17 f9 1c        LBSR  $81A0 - wait_ym2151_not_busy
8884: 39              RTS

8885: 34 36           PSHS  Y,X,B,A
8887: 17 f9 16        LBSR  $81A0 - wait_ym2151_not_busy
888a: 86 14           LDA   #$14
888c: b7 28 00        STA   $2800 - REG_YM2151_ADDRESS
888f: 17 f9 0e        LBSR  $81A0 - wait_ym2151_not_busy
8892: 86 15           LDA   #$15
8894: b7 28 01        STA   $2801 - REG_YM2151_DATA
8897: 96 74           LDA   $74
8899: 26 47           BNE   $88E2
889b: 8e 00 2b        LDX   #$002B
889e: c6 08           LDB   #$08
88a0: 6c 80           INC   ,X+
88a2: 26 0c           BNE   $88B0
88a4: a6 80           LDA   ,X+
88a6: a7 1e           STA   -$2,X
88a8: 6a 80           DEC   ,X+
88aa: 26 06           BNE   $88B2
88ac: 6c 84           INC   ,X
88ae: 20 02           BRA   $88B2
88b0: a6 81           LDA   ,X++
88b2: a6 80           LDA   ,X+
88b4: 5a              DECB
88b5: 26 e9           BNE   $88A0
88b7: 86 08           LDA   #$08
88b9: 8e 00 2e        LDX   #$002E
88bc: 10 8e 00 76     LDY   #$0076
88c0: 6d a4           TST   ,Y
88c2: 27 14           BEQ   $88D8
88c4: 6c a4           INC   ,Y
88c6: 26 10           BNE   $88D8
88c8: 6a 22           DEC   $2,Y
88ca: 27 06           BEQ   $88D2
88cc: e6 21           LDB   $1,Y
88ce: e7 a4           STB   ,Y
88d0: 20 06           BRA   $88D8
88d2: e6 84           LDB   ,X
88d4: ca 80           ORB   #$80
88d6: e7 84           STB   ,X
88d8: e6 a1           LDB   ,Y++
88da: e6 a0           LDB   ,Y+
88dc: c6 04           LDB   #$04
88de: 3a              ABX
88df: 4a              DECA
88e0: 26 de           BNE   $88C0
88e2: 35 36           PULS  A,B,X,Y
88e4: 3b              RTI

; $00 = sound to play
play_pcm_sound:
88e5: 86 ff           LDA   #$FF
88e7: 97 74           STA   $74
88e9: d6 00           LDB   $00
88eb: c4 7f           ANDB  #$7F	; drop the PCM flag
88ed: d7 00           STB   $00
88ef: 58              ASLB
88f0: db 00           ADDB  $00		; 3x the sound number (3 bytes per pcm lookup table)
88f2: 8e 89 66        LDX   #$8966 - PCM_LOOKUP_TABLE
88f5: 3a              ABX
88f6: a6 84           LDA   ,X		; which pcm
88f8: b4 18 00        ANDA  $1800	; adpcm_status
88fb: 84 03           ANDA  #$03
88fd: 26 2a           BNE   $8929	; pcm available?

88ff: d6 64           LDB   $64
8901: 84 01           ANDA  #$01	; pcm1?
8903: 26 02           BNE   $8907
8905: d6 65           LDB   $65
8907: a6 84           LDA   ,X
8909: 84 f0           ANDA  #$F0
890b: 97 66           STA   $66
890d: d1 66           CMPB  $66
890f: 25 4e           BCS   $895F
8911: a6 84           LDA   ,X
8913: 84 01           ANDA  #$01
8915: 27 0a           BEQ   $8921
8917: b7 38 06        STA   $3806 - REG_PCM1_STOP
891a: 86 46           LDA   #$46
891c: 4a              DECA
891d: 26 fd           BNE   $891C
891f: 20 08           BRA   $8929
8921: b7 38 07        STA   $3807 - REG_PCM2_STOP
8924: 86 46           LDA   #$46
8926: 4a              DECA
8927: 26 fd           BNE   $8926

8929: a6 84           LDA   ,X
892b: 84 01           ANDA  #$01
892d: 27 19           BEQ   $8948
892f: a6 84           LDA   ,X
8931: 84 f0           ANDA  #$F0
8933: 97 64           STA   $64
8935: a6 01           LDA   $1,X
8937: 44              LSRA
8938: b7 38 04        STA   $3804 - REG_PCM1_START_LOCATION
893b: a6 02           LDA   $2,X
893d: 44              LSRA
893e: b7 38 02        STA   $3802 - REG_PCM1_STOP_LOCATION
8941: 86 01           LDA   #$01
8943: b7 38 00        STA   $3800 - REG_PCM1_START?
8946: 20 17           BRA   $895F

8948: a6 84           LDA   ,X
894a: 84 f0           ANDA  #$F0
894c: 97 65           STA   $65
894e: a6 01           LDA   $1,X
8950: 44              LSRA
8951: b7 38 05        STA   $3805 - REG_PCM2_START_LOCATION
8954: a6 02           LDA   $2,X
8956: 44              LSRA
8957: b7 38 03        STA   $3803 - REG_PCM2_STOP_LOCATION
895a: 86 01           LDA   #$01
895c: b7 38 01        STA   $3801 - REG_PCM2_START?

895f: 0f 74           CLR   $74
8961: 86 00           LDA   #$00
8963: 97 00           STA   $00
8965: 39              RTS

PCM_LOOKUP_TABLE:
; adpcm table
; {
;  byte adpcm_channel; 01 = pcm1, 02 = pcm2
;  byte start_address?
;  byte stop_address?
; }
8966: 01 00 08        OIM   #$00;$08
8969: 01 08 13        OIM   #$08;$13
896c: 01 13 1f        OIM   #$13;$1F
896f: 01 1f 33        OIM   #$1F;$33
8972: 01 33 4d        OIM   #$33;$4D
8975: 01 4d 69        OIM   #$4D;$69
8978: 02 90 99        AIM   #$90;$99
897b: 02 00 16        AIM   #$00;$16
897e: 02 99 a4        AIM   #$99;$A4
8981: 01 69 75        OIM   #$69;$75
8984: 01 75 86        OIM   #$75;$86
8987: 02 16 25        AIM   #$16;$25
898a: 02 25 35        AIM   #$25;$35
898d: 01 86 93        OIM   #$86;$93
8990: 01 93 9d        OIM   #$93;$9D
8993: 01 9d a7        OIM   #$9D;$A7
8996: 01 a7 b2        OIM   #$A7;$B2
8999: 02 a4 af        AIM   #$A4;$AF
899c: 02 af b7        AIM   #$AF;$B7
899f: 02 35 4d        AIM   #$35;$4D
89a2: 02 4d 79        AIM   #$4D;$79
89a5: 01 b2 e7        OIM   #$B2;$E7
89a8: 02 79 8f        AIM   #$79;$8F
89ab: 02 b4 ce        AIM   #$B4;$CE
89ae: 02 d1 e5        AIM   #$D1;$E5
89b1: 02 e5 f4        AIM   #$E5;$F4
89b4: 02 f4 fd        AIM   #$F4;$FD

YM2151_TABLE:
89b7: 00 00           NEG   $00
89b9: 00 01           NEG   $01
89bb: 02 04 05        AIM   #$04;$05
89be: 06 08           ROR   $08
89c0: 09 0a           ROL   $0A
89c2: 0c 0d           INC   $0D
89c4: 0e 10           JMP   $10
89c6: 11 12           FCB   $11,$12
89c8: 14              SEXW
89c9: 15              FCB   $15
89ca: 16 18 19        LBRA  $A1E6
89cd: 1a 1c           ORCC  #$1C
89cf: 1d              SEX
89d0: 1e 20           EXG   Y,D
89d2: 21 22           BRN   $89F6
89d4: 24 25           BCC   $89FB
89d6: 26 28           BNE   $8A00
89d8: 29 2a           BVS   $8A04
89da: 2c 2d           BGE   $8A09
89dc: 2e 30           BGT   $8A0E
89de: 31 32           LEAY  -$E,Y
89e0: 34 35           PSHS  Y,X,B,CC
89e2: 36 38           PSHU  Y,X,DP
89e4: 39              RTS
89e5: 3a              ABX
89e6: 3c 3d           CWAI  #$3D
89e8: 3e              FCB   $3E
89e9: 40              NEGA
89ea: 41              FCB   $41
89eb: 42              FCB   $42
89ec: 44              LSRA
89ed: 45              FCB   $45
89ee: 46              RORA
89ef: 48              ASLA
89f0: 49              ROLA
89f1: 4a              DECA
89f2: 4c              INCA
89f3: 4d              TSTA
89f4: 4e              FCB   $4E
89f5: 50              NEGB
89f6: 51              FCB   $51
89f7: 52              FCB   $52
89f8: 54              LSRB
89f9: 55              FCB   $55
89fa: 56              RORB
89fb: 58              ASLB
89fc: 59              ROLB
89fd: 5a              DECB
89fe: 5c              INCB
89ff: 5d              TSTB
8a00: 5e              FCB   $5E
8a01: 60 61           NEG   $1,S
8a03: 62 64 65        AIM   #$64;$5,S
8a06: 66 68           ROR   $8,S
8a08: 69 6a           ROL   $A,S
8a0a: 6c 6d           INC   $D,S
8a0c: 6e 70           JMP   -$10,S
8a0e: 71 72 74 75     OIM   #$72,$7475
8a12: 76 78 79        ROR   $7879
8a15: 7a 7c 7d        DEC   $7C7D
8a18: 00 00           NEG   $00
8a1a: 00 00           NEG   $00
8a1c: 00 00           NEG   $00
8a1e: 00 00           NEG   $00
8a20: 00 00           NEG   $00
8a22: 00 00           NEG   $00
8a24: 01 01 01        OIM   #$01;$01
8a27: 01 01 01        OIM   #$01;$01
8a2a: 01 01 02        OIM   #$01;$02
8a2d: 02 02 02        AIM   #$02;$02
8a30: 02 02 02        AIM   #$02;$02
8a33: 02 03 03        AIM   #$03;$03
8a36: 03 03           COM   $03
8a38: 00 00           NEG   $00
8a3a: 00 00           NEG   $00
8a3c: 00 00           NEG   $00
8a3e: 00 00           NEG   $00
8a40: 01 01 01        OIM   #$01;$01
8a43: 01 01 01        OIM   #$01;$01
8a46: 01 01 02        OIM   #$01;$02
8a49: 02 02 02        AIM   #$02;$02
8a4c: 02 02 02        AIM   #$02;$02
8a4f: 02 03 03        AIM   #$03;$03
8a52: 03 03           COM   $03
8a54: 04 04           LSR   $04
8a56: 04 04           LSR   $04
8a58: 00 00           NEG   $00
8a5a: 00 00           NEG   $00
8a5c: 01 01 01        OIM   #$01;$01
8a5f: 01 02 02        OIM   #$02;$02
8a62: 02 02 03        AIM   #$02;$03
8a65: 03 03           COM   $03
8a67: 03 04           COM   $04
8a69: 04 04           LSR   $04
8a6b: 04 05           LSR   $05
8a6d: 05 05 05        EIM   #$05;$05
8a70: 06 06           ROR   $06
8a72: 06 06           ROR   $06
8a74: 07 07           ASR   $07
8a76: 07 07           ASR   $07
8a78: 00 00           NEG   $00
8a7a: 00 00           NEG   $00
8a7c: 01 01 01        OIM   #$01;$01
8a7f: 02 02 02        AIM   #$02;$02
8a82: 03 03           COM   $03
8a84: 03 04           COM   $04
8a86: 04 04           LSR   $04
8a88: 05 05 05        EIM   #$05;$05
8a8b: 06 06           ROR   $06
8a8d: 06 06           ROR   $06
8a8f: 07 07           ASR   $07
8a91: 07 07           ASR   $07
8a93: 07 08           ASR   $08
8a95: 08 08           ASL   $08
8a97: 08 00           ASL   $00
8a99: 00 01           NEG   $01
8a9b: 01 02 02        OIM   #$02;$02
8a9e: 03 03           COM   $03
8aa0: 04 04           LSR   $04
8aa2: 05 05 06        EIM   #$05;$06
8aa5: 06 07           ROR   $07
8aa7: 07 08           ASR   $08
8aa9: 08 09           ASL   $09
8aab: 09 0a           ROL   $0A
8aad: 0a 0a           DEC   $0A
8aaf: 0a 0b           DEC   $0B
8ab1: 0b 0b 0b        TIM   #$0B;$0B
8ab4: 0c 0c           INC   $0C
8ab6: 0c 0c           INC   $0C
8ab8: 00 01           NEG   $01
8aba: 02 03 04        AIM   #$03;$04
8abd: 05 06 07        EIM   #$06;$07
8ac0: 08 09           ASL   $09
8ac2: 0a 0b           DEC   $0B
8ac4: 0c 0d           INC   $0D
8ac6: 0e 0f           JMP   $0F
8ac8: 10 11           FCB   $10,$11
8aca: 12              NOP
8acb: 13              SYNC
8acc: 14              SEXW
8acd: 15              FCB   $15
8ace: 16 17 18        LBRA  $A1E9
8ad1: 19              DAA
8ad2: 1a 1b           ORCC  #$1B
8ad4: 1c 1d           ANDCC #$1D
8ad6: 1e 1f           EXG   X,F
8ad8: 00 02           NEG   $02
8ada: 04 06           LSR   $06
8adc: 08 0a           ASL   $0A
8ade: 0c 0e           INC   $0E
8ae0: 10 12           FCB   $10,$12
8ae2: 14              SEXW
8ae3: 16 18 1a        LBRA  $A300
8ae6: 1c 1e           ANDCC #$1E
8ae8: 20 22           BRA   $8B0C
8aea: 24 26           BCC   $8B12
8aec: 28 2a           BVC   $8B18
8aee: 2c 2e           BGE   $8B1E
8af0: 30 32           LEAX  -$E,Y
8af2: 34 36           PSHS  Y,X,B,A
8af4: 38              FCB   $38
8af5: 3a              ABX
8af6: 3c 3e           CWAI  #$3E
8af8: 3c 3e           CWAI  #$3E
8afa: 00 00           NEG   $00
8afc: 00 00           NEG   $00
8afe: 00 00           NEG   $00
8b00: 00 00           NEG   $00
8b02: 00 00           NEG   $00
8b04: 00 00           NEG   $00
8b06: 00 00           NEG   $00
8b08: 00 00           NEG   $00
8b0a: 00 00           NEG   $00
8b0c: 00 00           NEG   $00
8b0e: 00 00           NEG   $00
8b10: 00 00           NEG   $00
8b12: 00 00           NEG   $00
8b14: 00 00           NEG   $00
8b16: 00 00           NEG   $00
8b18: 00 00           NEG   $00
8b1a: 00 00           NEG   $00
8b1c: 00 00           NEG   $00
8b1e: 00 00           NEG   $00
8b20: 00 00           NEG   $00
8b22: 00 00           NEG   $00
8b24: 00 00           NEG   $00
8b26: 08 84           ASL   $84
8b28: 0c 6a           INC   $6A
8b2a: 2e a6           BGT   $8AD2
8b2c: 0e 4c           JMP   $4C
8b2e: 84 88           ANDA  #$88
8b30: 00 00           NEG   $00
8b32: 00 00           NEG   $00
8b34: 0c c3           INC   $C3
8b36: 3c 87           CWAI  #$87
8b38: eb ad e1 08     ADDB  $6C44,PCR
8b3c: 84 c8           ANDA  #$C8
8b3e: cf              FCB   $CF
8b3f: 6d 00           TST   $0,X
8b41: 00 00           NEG   $00
8b43: 00 00           NEG   $00
8b45: 00 00           NEG   $00
8b47: 00 00           NEG   $00
8b49: 00 00           NEG   $00
8b4b: 00 00           NEG   $00
8b4d: 00 00           NEG   $00
8b4f: 00 00           NEG   $00
8b51: 00 00           NEG   $00
8b53: 00 00           NEG   $00
8b55: 00 00           NEG   $00
8b57: 00 00           NEG   $00
8b59: 00 00           NEG   $00
8b5b: 00 00           NEG   $00
8b5d: 00 00           NEG   $00
8b5f: 00 08           NEG   $08
8b61: 00 00           NEG   $00
8b63: 00 00           NEG   $00
8b65: 88 ee           EORA  #$EE
8b67: 22 2e           BHI   $8B97
8b69: a6 a2           LDA   ,-Y
8b6b: 4c              INCA
8b6c: 44              LSRA
8b6d: 88 88           EORA  #$88
8b6f: 00 1b           NEG   $1B
8b71: a7 d1           STA   [,U++]
8b73: d3 d3           ADDD  $D3
8b75: c0 80           SUBB  #$80
8b77: db 4a           ADDB  $4A
8b79: 0a 43           DEC   $43
8b7b: 72 98 25 42     AIM   #$98,$2542
8b7f: ff 00 00        STU   >$0000
8b82: 00 88           NEG   $88
8b84: cf              FCB   $CF
8b85: fc fe ff        LDD   $FEFF
8b88: e7 77           STB   -$9,S
8b8a: 77 7e bf        ASR   $7EBF
8b8d: 7f cc 07        CLR   $CC07
8b90: 00 00           NEG   $00
8b92: ff 13 ab        STU   $13AB
8b95: 5f              CLRB
8b96: db 39           ADDB  $39
8b98: 13              SYNC
8b99: fe cd 09        LDU   $CD09
8b9c: 1a 35           ORCC  #$35
8b9e: 2b 53           BMI   $8BF3
8ba0: 00 00           NEG   $00
8ba2: 11 22           FCB   $11,$22
8ba4: 45              FCB   $45
8ba5: 57              ASRB
8ba6: 56              RORB
8ba7: 23 13           BLS   $8BBC
8ba9: 13              SYNC
8baa: 11 11           FCB   $11,$11
8bac: 33 00           LEAU  $0,X
8bae: 11 00           FCB   $11,$00
8bb0: 00 00           NEG   $00
8bb2: 00 00           NEG   $00
8bb4: 00 00           NEG   $00
8bb6: 00 00           NEG   $00
8bb8: 00 00           NEG   $00
8bba: 00 00           NEG   $00
8bbc: 00 00           NEG   $00
8bbe: 00 00           NEG   $00
8bc0: f0 f8 7c        SUBB  $F87C
8bc3: 3e              FCB   $3E
8bc4: 76 72 72        ROR   $7272
8bc7: 76 3b 31        ROR   $3B31
8bca: 31 13           LEAY  -$D,X
8bcc: 13              SYNC
8bcd: 13              SYNC
8bce: 3b              RTI
8bcf: 37 0f           PULU  CC,A,B,DP
8bd1: 75 34 0c 88     EIM   #$34,$0C88
8bd5: 80 08           SUBA  #$08
8bd7: 80 8c           SUBA  #$8C
8bd9: 60 06           NEG   $6,X
8bdb: ec 2e           LDD   $E,Y
8bdd: 12              NOP
8bde: 01 00 01        OIM   #$00;$01
8be1: 00 00           NEG   $00
8be3: 00 00           NEG   $00
8be5: 00 00           NEG   $00
8be7: 00 00           NEG   $00
8be9: 00 08           NEG   $08
8beb: 0c 97           INC   $97
8bed: ca 0c           ORB   #$0C
8bef: 4a              DECA
8bf0: 00 00           NEG   $00
8bf2: 00 00           NEG   $00
8bf4: 00 00           NEG   $00
8bf6: 00 00           NEG   $00
8bf8: 00 00           NEG   $00
8bfa: 34 53           PSHS  U,X,A,CC
8bfc: 14              SEXW
8bfd: 05 41 52        EIM   #$41;$52
8c00: 00 00           NEG   $00
8c02: 00 00           NEG   $00
8c04: 00 00           NEG   $00
8c06: 00 00           NEG   $00
8c08: 00 00           NEG   $00
8c0a: 00 00           NEG   $00
8c0c: 00 00           NEG   $00
8c0e: 00 00           NEG   $00
8c10: 00 00           NEG   $00
8c12: 00 00           NEG   $00
8c14: 00 00           NEG   $00
8c16: 00 00           NEG   $00
8c18: 00 00           NEG   $00
8c1a: 00 88           NEG   $88
8c1c: 88 44           EORA  #$44
8c1e: 4c              INCA
8c1f: a2 00           SBCA  $0,X
8c21: 88 88           EORA  #$88
8c23: 44              LSRA
8c24: 4c              INCA
8c25: 2a a2           BPL   $8BC9
8c27: a6 a6           LDA   A,Y
8c29: 95 1d           BITA  $1D
8c2b: 86 86           LDA   #$86
8c2d: 0b bc 78        TIM   #$BC;$78
8c30: 3b              RTI
8c31: 0e c3           JMP   $C3
8c33: e1 f0           CMPB  [,--W]
8c35: f0 f0 f0        SUBB  $F0F0
8c38: f0 78 9e        SUBB  $789E
8c3b: b8 56 45        EORA  $5645
8c3e: 33 11           LEAU  -$F,X
8c40: 00 00           NEG   $00
8c42: 00 00           NEG   $00
8c44: 88 88           EORA  #$88
8c46: 88 88           EORA  #$88
8c48: 88 88           EORA  #$88
8c4a: 88 00           EORA  #$00
8c4c: 00 00           NEG   $00
8c4e: 00 00           NEG   $00
8c50: a6 e2           LDA   ,-S
8c52: d1 97           CMPB  $97
8c54: a4 42           ANDA  $2,U
8c56: 95 77           BITA  $77
8c58: dd 8a           STD   $8A
8c5a: 8e 77 19        LDX   #$7719
8c5d: ee 00           LDU   $0,X
8c5f: 00 34           NEG   $34
8c61: bc 9a 54        CMPX  $9A54
8c64: 23 22           BLS   $8C88
8c66: 11 11           FCB   $11,$11
8c68: 00 00           NEG   $00
8c6a: 11 11           FCB   $11,$11
8c6c: 22 77           BHI   $8CE5
8c6e: 00 00           NEG   $00
8c70: 11 00           FCB   $11,$00
8c72: 00 00           NEG   $00
8c74: 00 00           NEG   $00
8c76: 00 00           NEG   $00
8c78: 00 00           NEG   $00
8c7a: 00 00           NEG   $00
8c7c: 00 00           NEG   $00
8c7e: 00 00           NEG   $00
8c80: 6d f8 69        TST   [$69,S]
8c83: 14              SEXW
8c84: 9a de           ORA   $DE
8c86: dc ef           LDD   $EF
8c88: ee 99 00 00     LDU   [$0000,X]
8c8c: 00 00           NEG   $00
8c8e: 88 88           EORA  #$88
8c90: 08 f8           ASL   $F8
8c92: 8c 0e 0e        CMPX  #$0E0E
8c95: 0e 1d           JMP   $1D
8c97: 19              DAA
8c98: 33 33           LEAU  -$D,Y
8c9a: 77 ff 11        ASR   $FF11
8c9d: 1d              SEX
8c9e: 68 f0           ASL   [,--W]
8ca0: fc 23 00        LDD   $2300
8ca3: 11 22           FCB   $11,$22
8ca5: 45              FCB   $45
8ca6: 47              ASRA
8ca7: 8b 8b           ADDA  #$8B
8ca9: 04 8e           LSR   $8E
8cab: 8a 44           ORA   #$44
8cad: 45              FCB   $45
8cae: 23 22           BLS   $8CD2
8cb0: 34 00           PSHS  
8cb2: 00 00           NEG   $00
8cb4: 00 00           NEG   $00
8cb6: 00 00           NEG   $00
8cb8: 00 00           NEG   $00
8cba: 00 00           NEG   $00
8cbc: 00 00           NEG   $00
8cbe: 00 00           NEG   $00
8cc0: 88 4c           EORA  #$4C
8cc2: 4c              INCA
8cc3: 4c              INCA
8cc4: 22 22           BHI   $8CE8
8cc6: ee 66           LDU   $6,S
8cc8: 66 ee           ROR   W,S
8cca: 00 00           NEG   $00
8ccc: 00 00           NEG   $00
8cce: 00 00           NEG   $00
8cd0: 3c 70           CWAI  #$70
8cd2: bc b8 74        CMPX  $B874
8cd5: 44              LSRA
8cd6: ff 06 08        STU   $0608
8cd9: ff 00 00        STU   >$0000
8cdc: 00 00           NEG   $00
8cde: 00 00           NEG   $00
8ce0: 11 11           FCB   $11,$11
8ce2: 00 00           NEG   $00
8ce4: 00 00           NEG   $00
8ce6: 00 33           NEG   $33
8ce8: 45              FCB   $45
8ce9: 77 00 00        ASR   >$0000
8cec: 00 00           NEG   $00
8cee: 00 00           NEG   $00
8cf0: 00 00           NEG   $00
8cf2: 00 00           NEG   $00
8cf4: 00 00           NEG   $00
8cf6: 00 00           NEG   $00
8cf8: 00 00           NEG   $00
8cfa: 00 00           NEG   $00
8cfc: 00 00           NEG   $00
8cfe: 00 00           NEG   $00
8d00: 00 00           NEG   $00
8d02: 00 00           NEG   $00
8d04: 00 00           NEG   $00
8d06: 00 00           NEG   $00
8d08: 00 00           NEG   $00
8d0a: 00 00           NEG   $00
8d0c: 00 00           NEG   $00
8d0e: 00 00           NEG   $00
8d10: 00 00           NEG   $00
8d12: 00 00           NEG   $00
8d14: 00 00           NEG   $00
8d16: 00 00           NEG   $00
8d18: 00 00           NEG   $00
8d1a: 00 00           NEG   $00
8d1c: 00 00           NEG   $00
8d1e: 00 00           NEG   $00
8d20: 00 00           NEG   $00
8d22: 00 00           NEG   $00
8d24: 00 00           NEG   $00
8d26: 00 08           NEG   $08
8d28: 08 08           ASL   $08
8d2a: 00 00           NEG   $00
8d2c: 00 00           NEG   $00
8d2e: 00 00           NEG   $00
8d30: 00 88           NEG   $88
8d32: cc e6 e2        LDD   #$E6E2
8d35: a1 58           CMPA  -$8,U
8d37: bc 56 67        CMPX  $5667
8d3a: 55              FCB   $55
8d3b: 9b 53           ADDA  $53
8d3d: a6 ee           LDA   W,S
8d3f: 0c 00           INC   $00
8d41: 00 00           NEG   $00
8d43: 00 00           NEG   $00
8d45: 00 00           NEG   $00
8d47: 00 00           NEG   $00
8d49: 00 00           NEG   $00
8d4b: 00 00           NEG   $00
8d4d: 00 00           NEG   $00
8d4f: 00 00           NEG   $00
8d51: 00 00           NEG   $00
8d53: 00 00           NEG   $00
8d55: 00 00           NEG   $00
8d57: 00 00           NEG   $00
8d59: 00 00           NEG   $00
8d5b: 00 00           NEG   $00
8d5d: 00 00           NEG   $00
8d5f: 00 00           NEG   $00
8d61: 00 08           NEG   $08
8d63: 0c 06           INC   $06
8d65: 22 01           BHI   $8D68
8d67: 01 11 13        OIM   #$11;$13
8d6a: 2d 8e           BLT   $8CFA
8d6c: 00 00           NEG   $00
8d6e: 00 00           NEG   $00
8d70: 40              NEGA
8d71: 06 41           ROR   $41
8d73: 4c              INCA
8d74: 48              ASLA
8d75: c8 cc           EORB  #$CC
8d77: ec ee           LDD   W,S
8d79: ef de           STU   [W,U]
8d7b: ff ff ff        STU   $FFFF
8d7e: 33 2a           LEAU  $A,Y
8d80: 00 00           NEG   $00
8d82: 00 00           NEG   $00
8d84: 00 00           NEG   $00
8d86: 00 00           NEG   $00
8d88: 00 00           NEG   $00
8d8a: 00 00           NEG   $00
8d8c: 00 00           NEG   $00
8d8e: 00 00           NEG   $00
8d90: 00 00           NEG   $00
8d92: 00 00           NEG   $00
8d94: 00 00           NEG   $00
8d96: 00 00           NEG   $00
8d98: 00 00           NEG   $00
8d9a: 00 00           NEG   $00
8d9c: 00 88           NEG   $88
8d9e: 44              LSRA
8d9f: 4c              INCA
8da0: 00 88           NEG   $88
8da2: 88 44           EORA  #$44
8da4: 44              LSRA
8da5: 4c              INCA
8da6: 2a 2e           BPL   $8DD6
8da8: 2e 2e           BGT   $8DD8
8daa: 95 95           BITA  $95
8dac: 1d              SEX
8dad: 86 87           LDA   #$87
8daf: 1a 1d           ORCC  #$1D
8db1: 77 0e c3        ASR   $0EC3
8db4: e1 e1           CMPB  ,S++
8db6: f0 f0 f0        SUBB  $F0F0
8db9: 78 70 bc        ASL   $70BC
8dbc: ad 56           JSR   -$A,U
8dbe: 56              RORB
8dbf: 23 00           BLS   $8DC1
8dc1: 00 00           NEG   $00
8dc3: 00 00           NEG   $00
8dc5: 88 88           EORA  #$88
8dc7: 88 cc           EORA  #$CC
8dc9: cc cc cc        LDD   #$CCCC
8dcc: 88 00           EORA  #$00
8dce: 00 00           NEG   $00
8dd0: a2 a6           SBCA  A,Y
8dd2: a6 d1           LDA   [,U++]
8dd4: d3 86           ADDD  $86
8dd6: 21 60           BRN   $8E38
8dd8: ff 55 02        STU   $5502
8ddb: 06 1d           ROR   $1D
8ddd: ee 00           LDU   $0,X
8ddf: 00 bc           NEG   $BC
8de1: 78 34 b8        ASL   $34B8
8de4: 56              RORB
8de5: 23 22           BLS   $8E09
8de7: 11 00           FCB   $11,$00
8de9: 00 00           NEG   $00
8deb: 00 00           NEG   $00
8ded: 33 00           LEAU  $0,X
8def: 00 22           NEG   $22
8df1: 11 11           FCB   $11,$11
8df3: 00 00           NEG   $00
8df5: 00 00           NEG   $00
8df7: 00 00           NEG   $00
8df9: 00 00           NEG   $00
8dfb: 00 00           NEG   $00
8dfd: 00 00           NEG   $00
8dff: 00 00           NEG   $00
8e01: 00 00           NEG   $00
8e03: 00 00           NEG   $00
8e05: 00 00           NEG   $00
8e07: 00 00           NEG   $00
8e09: 00 00           NEG   $00
8e0b: 00 00           NEG   $00
8e0d: 00 6e           NEG   $6E
8e0f: 0d 00           TST   $00
8e11: 00 00           NEG   $00
8e13: 00 00           NEG   $00
8e15: 88 cc           EORA  #$CC
8e17: cc ee ee        LDD   #$EEEE
8e1a: e6 66           LDB   $6,S
8e1c: 66 6e           ROR   $E,S
8e1e: ae 6f           LDX   $F,S
8e20: 00 00           NEG   $00
8e22: 00 00           NEG   $00
8e24: ff 13 ab        STU   $13AB
8e27: 5f              CLRB
8e28: db 39           ADDB  $39
8e2a: 13              SYNC
8e2b: fe cd 09        LDU   $CD09
8e2e: 1a 35           ORCC  #$35
8e30: 00 00           NEG   $00
8e32: 00 00           NEG   $00
8e34: 11 22           FCB   $11,$22
8e36: 45              FCB   $45
8e37: 57              ASRB
8e38: 56              RORB
8e39: 23 13           BLS   $8E4E
8e3b: 13              SYNC
8e3c: 11 1d           FCB   $11,$1D
8e3e: f3 62 00        ADDD  $6200
8e41: 04 e6           LSR   $E6
8e43: ed a7           STD   E,Y
8e45: f5 f4 d6        BITB  $F4D6
8e48: fb fd fe        ADDB  $FDFE
8e4b: 7f 75 bb        CLR   $75BB
8e4e: bf fe ff        STX   $FEFF
8e51: 3f              SWI
8e52: f7 ff b5        STB   $FFB5
8e55: 13              SYNC
8e56: 13              SYNC
8e57: 31 10           LEAY  -$10,X
8e59: 09 da           ROL   $DA
8e5b: 2f af           BLE   $8E0C
8e5d: d9 57           ADCB  $57
8e5f: 33 2b           LEAU  $B,Y
8e61: 53              COMB
8e62: 0f 0f           CLR   $0F
8e64: 1f 16           TFR   X,W
8e66: b2 b0 9a        SBCA  $B09A
8e69: 19              DAA
8e6a: 8d 46           BSR   $8EB2
8e6c: 33 00           LEAU  $0,X
8e6e: 00 00           NEG   $00
8e70: 53              COMB
8e71: 42              FCB   $42
8e72: c3 f7 bf        ADDD  #$F7BF
8e75: ff 77 33        STU   $7733
8e78: 11 11           FCB   $11,$11
8e7a: 00 00           NEG   $00
8e7c: 00 00           NEG   $00
8e7e: 00 00           NEG   $00
8e80: 07 69           ASR   $69
8e82: 4b              FCB   $4B
8e83: 07 9e           ASR   $9E
8e85: 9a 47           ORA   $47
8e87: 45              FCB   $45
8e88: ee 99 11 00     LDU   [$1100,X]
8e8c: 00 00           NEG   $00
8e8e: 88 88           EORA  #$88
8e90: 22 77           BHI   $8F09
8e92: cc 06 0e        LDD   #$060E
8e95: 0f 0e           CLR   $0E
8e97: 0c 00           INC   $00
8e99: 11 77           FCB   $11,$77
8e9b: 11 1d           FCB   $11,$1D
8e9d: f1 e1 69        CMPB  $E169
8ea0: 00 00           NEG   $00
8ea2: 00 11           NEG   $11
8ea4: 11 22           FCB   $11,$22
8ea6: 45              FCB   $45
8ea7: 45              FCB   $45
8ea8: 02 47 47        AIM   #$47;$47
8eab: 44              LSRA
8eac: 44              LSRA
8ead: 22 22           BHI   $8ED1
8eaf: 22 00           BHI   $8EB1
8eb1: 00 00           NEG   $00
8eb3: 00 00           NEG   $00
8eb5: 00 00           NEG   $00
8eb7: 00 00           NEG   $00
8eb9: 00 00           NEG   $00
8ebb: 00 00           NEG   $00
8ebd: 00 00           NEG   $00
8ebf: 00 88           NEG   $88
8ec1: 4c              INCA
8ec2: 4c              INCA
8ec3: c4 4c           ANDB  #$4C
8ec5: cc cc cc        LDD   #$CCCC
8ec8: cc cc 00        LDD   #$CC00
8ecb: 00 00           NEG   $00
8ecd: 00 00           NEG   $00
8ecf: 00 70           NEG   $70
8ed1: 70 bc 9e        NEG   $BC9E
8ed4: 8f              FCB   $8F
8ed5: 77 ff 06        ASR   $FF06
8ed8: 08 ff           ASL   $FF
8eda: 00 00           NEG   $00
8edc: 00 00           NEG   $00
8ede: 00 00           NEG   $00
8ee0: 11 11           FCB   $11,$11
8ee2: 00 00           NEG   $00
8ee4: 00 00           NEG   $00
8ee6: 00 33           NEG   $33
8ee8: 45              FCB   $45
8ee9: 77 00 00        ASR   >$0000
8eec: 00 00           NEG   $00
8eee: 00 00           NEG   $00
8ef0: 00 00           NEG   $00
8ef2: 00 00           NEG   $00
8ef4: 00 00           NEG   $00
8ef6: 00 00           NEG   $00
8ef8: 00 00           NEG   $00
8efa: 00 00           NEG   $00
8efc: 00 00           NEG   $00
8efe: 00 00           NEG   $00
8f00: 00 00           NEG   $00
8f02: 00 00           NEG   $00
8f04: 00 00           NEG   $00
8f06: 00 00           NEG   $00
8f08: 00 00           NEG   $00
8f0a: 00 08           NEG   $08
8f0c: 86 7a           LDA   #$7A
8f0e: 36 24           PSHU  Y,B
8f10: 00 00           NEG   $00
8f12: 00 00           NEG   $00
8f14: 00 00           NEG   $00
8f16: 00 00           NEG   $00
8f18: 00 00           NEG   $00
8f1a: 00 e7           NEG   $E7
8f1c: 01 00 00        OIM   #$00;$00
8f1f: 0c 00           INC   $00
8f21: 00 00           NEG   $00
8f23: 00 00           NEG   $00
8f25: 00 00           NEG   $00
8f27: 00 00           NEG   $00
8f29: 00 6b           NEG   $6B
8f2b: 05 0c 4c        EIM   #$0C;$4C
8f2e: c7              FCB   $C7
8f2f: bf 00 00        STX   >$0000
8f32: 00 00           NEG   $00
8f34: 00 00           NEG   $00
8f36: 00 00           NEG   $00
8f38: 00 00           NEG   $00
8f3a: cb 8c           ADDB  #$8C
8f3c: 80 81           SUBA  #$81
8f3e: eb 52           ADDB  -$E,U
8f40: 2c f0           BGE   $8F32
8f42: fe 37 11        LDU   $3711
8f45: 00 00           NEG   $00
8f47: 00 00           NEG   $00
8f49: 00 00           NEG   $00
8f4b: 00 00           NEG   $00
8f4d: 00 00           NEG   $00
8f4f: 00 cb           NEG   $CB
8f51: 7c 23 00        INC   $2300
8f54: 00 00           NEG   $00
8f56: 00 00           NEG   $00
8f58: 00 00           NEG   $00
8f5a: 00 00           NEG   $00
8f5c: 00 00           NEG   $00
8f5e: 00 00           NEG   $00
8f60: 23 00           BLS   $8F62
8f62: 00 00           NEG   $00
8f64: 00 00           NEG   $00
8f66: 00 00           NEG   $00
8f68: 00 00           NEG   $00
8f6a: 00 00           NEG   $00
8f6c: 00 00           NEG   $00
8f6e: 00 00           NEG   $00
8f70: 33 00           LEAU  $0,X
8f72: 00 00           NEG   $00
8f74: 00 00           NEG   $00
8f76: 00 00           NEG   $00
8f78: 00 00           NEG   $00
8f7a: 00 00           NEG   $00
8f7c: 00 00           NEG   $00
8f7e: 00 00           NEG   $00
8f80: 00 00           NEG   $00
8f82: 00 00           NEG   $00
8f84: 00 00           NEG   $00
8f86: 00 00           NEG   $00
8f88: 00 00           NEG   $00
8f8a: 00 00           NEG   $00
8f8c: 00 00           NEG   $00
8f8e: 00 08           NEG   $08
8f90: 00 00           NEG   $00
8f92: 00 00           NEG   $00
8f94: 00 00           NEG   $00
8f96: 00 00           NEG   $00
8f98: 00 00           NEG   $00
8f9a: 00 00           NEG   $00
8f9c: 00 65           NEG   $65
8f9e: 1d              SEX
8f9f: 4d              TSTA
8fa0: 00 00           NEG   $00
8fa2: 00 00           NEG   $00
8fa4: 00 00           NEG   $00
8fa6: 00 00           NEG   $00
8fa8: 00 00           NEG   $00
8faa: 00 00           NEG   $00
8fac: 00 00           NEG   $00
8fae: 00 88           NEG   $88
8fb0: 00 00           NEG   $00
8fb2: 00 00           NEG   $00
8fb4: 00 88           NEG   $88
8fb6: 88 cc           EORA  #$CC
8fb8: cc cc cc        LDD   #$CCCC
8fbb: cc 88 08        LDD   #$8808
8fbe: ff b9 88        STU   $B988
8fc1: 80 88           SUBA  #$88
8fc3: 08 00           ASL   $00
8fc5: 00 00           NEG   $00
8fc7: 00 00           NEG   $00
8fc9: 00 00           NEG   $00
8fcb: 00 00           NEG   $00
8fcd: 00 00           NEG   $00
8fcf: 00 44           NEG   $44
8fd1: 4d              TSTA
8fd2: 81 9e           CMPA  #$9E
8fd4: 6d 1f           TST   -$1,X
8fd6: 24 6a           BCC   $9042
8fd8: c4 c4           ANDB  #$C4
8fda: cc 08 88        LDD   #$0888
8fdd: 00 00           NEG   $00
8fdf: 00 cc           NEG   $CC
8fe1: c4 ea           ANDB  #$EA
8fe3: 6e 7f           JMP   -$1,S
8fe5: ef cf           STU   ,W++
8fe7: 6e ee           JMP   W,S
8fe9: ef bc fc        STU   [$8FE8,PCR]
8fec: eb ff ee 00     ADDB  [$EE00]
8ff0: 3e              FCB   $3E
8ff1: 5b              FCB   $5B
8ff2: ad 9a           JSR   [F,X]
8ff4: 18              FCB   $18
8ff5: 18              FCB   $18
8ff6: 18              FCB   $18
8ff7: 99 bd           ADCA  $BD
8ff9: cf              FCB   $CF
8ffa: f5 bf 7b        BITB  $BF7B
8ffd: 3f              SWI
8ffe: f7 df 00        STB   $DF00
9001: 00 90           NEG   $90
9003: 2c 9c           BGE   $8FA1
9005: 4c              INCA
9006: 9c 63           CMPX  $63
9008: a1 31           CMPA  -$F,Y
900a: a1 47           CMPA  $7,U
900c: a2 69           SBCA  $9,S
900e: a5 5f           BITA  -$1,U
9010: b0 65 b1        SUBA  $65B1
9013: 14              SEXW
9014: bc 1d c3        CMPX  $1DC3
9017: 4a              DECA
9018: cb 8a           ADDB  #$8A
901a: cc 05 d4        LDD   #$05D4
901d: e5 d8 56        BITB  [$56,U]
9020: d8 63           EORB  $63
9022: d8 70           EORB  $70
9024: d8 7d           EORB  $7D
9026: 00 00           NEG   $00
9028: 00 00           NEG   $00
902a: 00 00           NEG   $00
902c: 07 f0           ASR   $F0
902e: 90 4a           SUBA  $4A
9030: dc bb           LDD   $BB
9032: 91 4d           CMPA  $4D
9034: da 6b           ORB   $6B
9036: 93 21           SUBD  $21
9038: dd 4f           STD   $4F
903a: 95 61           BITA  $61
903c: dd 4f           STD   $4F
903e: 97 9f           STA   $9F
9040: dd 4f           STD   $4F
9042: 98 57           EORA  $57
9044: dd e3           STD   $E3
9046: 9b 1a           ADDA  $1A
9048: de 77           LDU   $77
904a: 86 00           LDA   #$00
904c: 88 fa           EORA  #$FA
904e: 00 60           NEG   $60
9050: 80 85           SUBA  #$85
9052: c8 33           EORB  #$33
9054: 24 35           BCC   $908B
9056: 3c 36           CWAI  #$36
9058: 24 38           BCC   $9092
905a: 3c 33           CWAI  #$33
905c: 24 35           BCC   $9093
905e: 3c 36           CWAI  #$36
9060: 24 38           BCC   $909A
9062: 3c 33           CWAI  #$33
9064: 24 35           BCC   $909B
9066: 3c 36           CWAI  #$36
9068: 24 38           BCC   $90A2
906a: 3c 85           CWAI  #$85
906c: d2 2f           SBCB  $2F
906e: 08 33           ASL   $33
9070: 08 36           ASL   $36
9072: 08 3b           ASL   $3B
9074: 08 3d           ASL   $3D
9076: 08 3b           ASL   $3B
9078: 08 2f           ASL   $2F
907a: 08 31           ASL   $31
907c: 08 33           ASL   $33
907e: 08 36           ASL   $36
9080: 08 3b           ASL   $3B
9082: 08 32           ASL   $32
9084: 08 35           ASL   $35
9086: 08 3a           ASL   $3A
9088: 08 3e           ASL   $3E
908a: 08 41           ASL   $41
908c: 08 3f           ASL   $3F
908e: 08 3a           ASL   $3A
9090: 08 84           ASL   $84
9092: dc bb           LDD   $BB
9094: 85 dc           BITA  #$DC
9096: 00 18           NEG   $18
9098: 3a              ABX
9099: 0c 3d           INC   $3D
909b: 0c 3f           INC   $3F
909d: 30 00           LEAX  $0,X
909f: 0c 42           INC   $42
90a1: 0c 41           INC   $41
90a3: 12              NOP
90a4: 3f              SWI
90a5: 06 41           ROR   $41
90a7: 30 00           LEAX  $0,X
90a9: 0c 44           INC   $44
90ab: 0c 42           INC   $42
90ad: 12              NOP
90ae: 41              FCB   $41
90af: 06 42           ROR   $42
90b1: 30 00           LEAX  $0,X
90b3: 0c 46           INC   $46
90b5: 0c 44           INC   $44
90b7: 0c 42           INC   $42
90b9: 0c 44           INC   $44
90bb: 18              FCB   $18
90bc: 3f              SWI
90bd: 0c 44           INC   $44
90bf: 24 44           BCC   $9105
90c1: 0c 46           INC   $46
90c3: 0c 47           INC   $47
90c5: 30 00           LEAX  $0,X
90c7: 0c 42           INC   $42
90c9: 0c 42           INC   $42
90cb: 0c 47           INC   $47
90cd: 0c 46           INC   $46
90cf: 30 00           LEAX  $0,X
90d1: 0c 42           INC   $42
90d3: 0c 42           INC   $42
90d5: 0c 46           INC   $46
90d7: 0c 44           INC   $44
90d9: 90 00           SUBA  $00
90db: 18              FCB   $18
90dc: 3a              ABX
90dd: 0c 3d           INC   $3D
90df: 0c 3f           INC   $3F
90e1: 30 00           LEAX  $0,X
90e3: 0c 42           INC   $42
90e5: 0c 41           INC   $41
90e7: 12              NOP
90e8: 3f              SWI
90e9: 06 41           ROR   $41
90eb: 30 00           LEAX  $0,X
90ed: 0c 44           INC   $44
90ef: 0c 42           INC   $42
90f1: 12              NOP
90f2: 41              FCB   $41
90f3: 06 42           ROR   $42
90f5: 30 00           LEAX  $0,X
90f7: 0c 46           INC   $46
90f9: 0c 44           INC   $44
90fb: 0c 42           INC   $42
90fd: 0c 44           INC   $44
90ff: 18              FCB   $18
9100: 3f              SWI
9101: 0c 44           INC   $44
9103: 24 44           BCC   $9149
9105: 0c 46           INC   $46
9107: 0c 47           INC   $47
9109: 30 00           LEAX  $0,X
910b: 0c 42           INC   $42
910d: 0c 42           INC   $42
910f: 0c 47           INC   $47
9111: 0c 46           INC   $46
9113: 30 00           LEAX  $0,X
9115: 0c 42           INC   $42
9117: 0c 42           INC   $42
9119: 0c 46           INC   $46
911b: 0c 44           INC   $44
911d: 30 00           LEAX  $0,X
911f: 0c 44           INC   $44
9121: 0c 47           INC   $47
9123: 0c 49           INC   $49
9125: 6c 3f           INC   -$1,Y
9127: 24 41           BCC   $916A
9129: 24 44           BCC   $916F
912b: 0c 42           INC   $42
912d: 54              LSRB
912e: 00 18           NEG   $18
9130: 3f              SWI
9131: 24 41           BCC   $9174
9133: 24 3d           BCC   $9172
9135: 0c 42           INC   $42
9137: 3c 00           CWAI  #$00
9139: 30 3f           LEAX  -$1,Y
913b: 24 41           BCC   $917E
913d: 24 44           BCC   $9183
913f: 0c 42           INC   $42
9141: 3c 00           CWAI  #$00
9143: 0c 3f           INC   $3F
9145: 0c 42           INC   $42
9147: 0c 44           INC   $44
9149: cc 82 00        LDD   #$8200
914c: 87              FCB   $87
914d: 86 00           LDA   #$00
914f: 85 f0           BITA  #$F0
9151: 00 60           NEG   $60
9153: 80 20           SUBA  #$20
9155: 0c 20           INC   $20
9157: 0c 20           INC   $20
9159: 0c 20           INC   $20
915b: 0c 20           INC   $20
915d: 0c 20           INC   $20
915f: 0c 20           INC   $20
9161: 0c 20           INC   $20
9163: 0c 20           INC   $20
9165: 0c 20           INC   $20
9167: 0c 20           INC   $20
9169: 0c 20           INC   $20
916b: 0c 20           INC   $20
916d: 0c 20           INC   $20
916f: 0c 20           INC   $20
9171: 0c 20           INC   $20
9173: 0c 20           INC   $20
9175: 0c 20           INC   $20
9177: 0c 20           INC   $20
9179: 0c 20           INC   $20
917b: 0c 20           INC   $20
917d: 0c 20           INC   $20
917f: 0c 20           INC   $20
9181: 0c 20           INC   $20
9183: 0c 20           INC   $20
9185: 0c 20           INC   $20
9187: 0c 20           INC   $20
9189: 0c 20           INC   $20
918b: 0c 20           INC   $20
918d: 0c 20           INC   $20
918f: 0c 20           INC   $20
9191: 0c 20           INC   $20
9193: 0c 20           INC   $20
9195: 0c 20           INC   $20
9197: 0c 20           INC   $20
9199: 0c 20           INC   $20
919b: 0c 20           INC   $20
919d: 0c 20           INC   $20
919f: 0c 20           INC   $20
91a1: 0c 20           INC   $20
91a3: 0c 20           INC   $20
91a5: 0c 20           INC   $20
91a7: 0c 20           INC   $20
91a9: 0c 20           INC   $20
91ab: 0c 20           INC   $20
91ad: 0c 20           INC   $20
91af: 0c 20           INC   $20
91b1: 0c 20           INC   $20
91b3: 0c 25           INC   $25
91b5: 0c 25           INC   $25
91b7: 0c 25           INC   $25
91b9: 0c 25           INC   $25
91bb: 0c 25           INC   $25
91bd: 0c 25           INC   $25
91bf: 0c 25           INC   $25
91c1: 0c 26           INC   $26
91c3: 18              FCB   $18
91c4: 26 0c           BNE   $91D2
91c6: 26 0c           BNE   $91D4
91c8: 26 0c           BNE   $91D6
91ca: 00 30           NEG   $30
91cc: 27 0c           BEQ   $91DA
91ce: 27 0c           BEQ   $91DC
91d0: 27 0c           BEQ   $91DE
91d2: 27 0c           BEQ   $91E0
91d4: 27 0c           BEQ   $91E2
91d6: 27 0c           BEQ   $91E4
91d8: 27 0c           BEQ   $91E6
91da: 27 0c           BEQ   $91E8
91dc: 25 0c           BCS   $91EA
91de: 25 0c           BCS   $91EC
91e0: 25 0c           BCS   $91EE
91e2: 25 0c           BCS   $91F0
91e4: 25 0c           BCS   $91F2
91e6: 25 0c           BCS   $91F4
91e8: 25 0c           BCS   $91F6
91ea: 25 0c           BCS   $91F8
91ec: 1e 0c           EXG   D,0
91ee: 1e 0c           EXG   D,0
91f0: 1e 0c           EXG   D,0
91f2: 1e 0c           EXG   D,0
91f4: 1e 0c           EXG   D,0
91f6: 1e 0c           EXG   D,0
91f8: 1e 0c           EXG   D,0
91fa: 1e 0c           EXG   D,0
91fc: 20 0c           BRA   $920A
91fe: 20 0c           BRA   $920C
9200: 20 0c           BRA   $920E
9202: 20 0c           BRA   $9210
9204: 20 0c           BRA   $9212
9206: 20 0c           BRA   $9214
9208: 22 0c           BHI   $9216
920a: 22 0c           BHI   $9218
920c: 23 0c           BLS   $921A
920e: 23 0c           BLS   $921C
9210: 23 0c           BLS   $921E
9212: 23 0c           BLS   $9220
9214: 23 0c           BLS   $9222
9216: 23 0c           BLS   $9224
9218: 23 0c           BLS   $9226
921a: 23 0c           BLS   $9228
921c: 22 0c           BHI   $922A
921e: 22 0c           BHI   $922C
9220: 22 0c           BHI   $922E
9222: 22 0c           BHI   $9230
9224: 22 0c           BHI   $9232
9226: 22 0c           BHI   $9234
9228: 22 0c           BHI   $9236
922a: 22 0c           BHI   $9238
922c: 20 0c           BRA   $923A
922e: 20 0c           BRA   $923C
9230: 20 0c           BRA   $923E
9232: 20 0c           BRA   $9240
9234: 20 0c           BRA   $9242
9236: 20 0c           BRA   $9244
9238: 20 0c           BRA   $9246
923a: 20 0c           BRA   $9248
923c: 20 0c           BRA   $924A
923e: 20 0c           BRA   $924C
9240: 20 0c           BRA   $924E
9242: 20 0c           BRA   $9250
9244: 00 30           NEG   $30
9246: 27 0c           BEQ   $9254
9248: 27 0c           BEQ   $9256
924a: 27 0c           BEQ   $9258
924c: 27 0c           BEQ   $925A
924e: 27 0c           BEQ   $925C
9250: 27 0c           BEQ   $925E
9252: 27 0c           BEQ   $9260
9254: 27 0c           BEQ   $9262
9256: 25 0c           BCS   $9264
9258: 25 0c           BCS   $9266
925a: 25 0c           BCS   $9268
925c: 25 0c           BCS   $926A
925e: 25 0c           BCS   $926C
9260: 25 0c           BCS   $926E
9262: 25 0c           BCS   $9270
9264: 25 0c           BCS   $9272
9266: 1e 0c           EXG   D,0
9268: 1e 0c           EXG   D,0
926a: 1e 0c           EXG   D,0
926c: 1e 0c           EXG   D,0
926e: 1e 0c           EXG   D,0
9270: 1e 0c           EXG   D,0
9272: 1e 0c           EXG   D,0
9274: 1e 0c           EXG   D,0
9276: 20 0c           BRA   $9284
9278: 20 0c           BRA   $9286
927a: 20 0c           BRA   $9288
927c: 20 0c           BRA   $928A
927e: 20 0c           BRA   $928C
9280: 20 0c           BRA   $928E
9282: 22 0c           BHI   $9290
9284: 22 0c           BHI   $9292
9286: 23 0c           BLS   $9294
9288: 23 0c           BLS   $9296
928a: 23 0c           BLS   $9298
928c: 23 0c           BLS   $929A
928e: 23 0c           BLS   $929C
9290: 23 0c           BLS   $929E
9292: 23 0c           BLS   $92A0
9294: 23 0c           BLS   $92A2
9296: 22 0c           BHI   $92A4
9298: 22 0c           BHI   $92A6
929a: 22 0c           BHI   $92A8
929c: 22 0c           BHI   $92AA
929e: 22 0c           BHI   $92AC
92a0: 22 0c           BHI   $92AE
92a2: 22 0c           BHI   $92B0
92a4: 22 0c           BHI   $92B2
92a6: 28 0c           BVC   $92B4
92a8: 28 0c           BVC   $92B6
92aa: 28 0c           BVC   $92B8
92ac: 28 0c           BVC   $92BA
92ae: 28 0c           BVC   $92BC
92b0: 28 0c           BVC   $92BE
92b2: 27 0c           BEQ   $92C0
92b4: 25 18           BCS   $92CE
92b6: 25 0c           BCS   $92C4
92b8: 25 0c           BCS   $92C6
92ba: 25 0c           BCS   $92C8
92bc: 25 0c           BCS   $92CA
92be: 25 0c           BCS   $92CC
92c0: 25 0c           BCS   $92CE
92c2: 25 0c           BCS   $92D0
92c4: 20 24           BRA   $92EA
92c6: 22 30           BHI   $92F8
92c8: 23 18           BLS   $92E2
92ca: 27 0c           BEQ   $92D8
92cc: 25 0c           BCS   $92DA
92ce: 23 0c           BLS   $92DC
92d0: 1e 06           EXG   D,W
92d2: 20 06           BRA   $92DA
92d4: 25 0c           BCS   $92E2
92d6: 23 0c           BLS   $92E4
92d8: 22 0c           BHI   $92E6
92da: 20 24           BRA   $9300
92dc: 22 30           BHI   $930E
92de: 27 18           BEQ   $92F8
92e0: 1e 18           EXG   X,A
92e2: 2a 0c           BPL   $92F0
92e4: 20 0c           BRA   $92F2
92e6: 2c 0c           BGE   $92F4
92e8: 22 0c           BHI   $92F6
92ea: 2e 0c           BGT   $92F8
92ec: 20 24           BRA   $9312
92ee: 22 30           BHI   $9320
92f0: 23 18           BLS   $930A
92f2: 2f 0c           BLE   $9300
92f4: 22 0c           BHI   $9302
92f6: 2e 0c           BGT   $9304
92f8: 1e 0c           EXG   D,0
92fa: 20 0c           BRA   $9308
92fc: 23 0c           BLS   $930A
92fe: 25 18           BCS   $9318
9300: 25 0c           BCS   $930E
9302: 25 0c           BCS   $9310
9304: 25 0c           BCS   $9312
9306: 25 0c           BCS   $9314
9308: 25 0c           BCS   $9316
930a: 25 0c           BCS   $9318
930c: 25 0c           BCS   $931A
930e: 25 0c           BCS   $931C
9310: 25 0c           BCS   $931E
9312: 25 0c           BCS   $9320
9314: 25 0c           BCS   $9322
9316: 25 0c           BCS   $9324
9318: 25 0c           BCS   $9326
931a: 25 0c           BCS   $9328
931c: 25 0c           BCS   $932A
931e: 82 00           SBCA  #$00
9320: 87              FCB   $87
9321: 00 60           NEG   $60
9323: 80 00           SUBA  #$00
9325: 18              FCB   $18
9326: 84 dd           ANDA  #$DD
9328: 4f              CLRA
9329: 85 d2           BITA  #$D2
932b: 86 0c           LDA   #$0C
932d: 27 0c           BEQ   $933B
932f: 00 0c           NEG   $0C
9331: 00 18           NEG   $18
9333: 29 18           BVS   $934D
9335: 00 18           NEG   $18
9337: 2a 0c           BPL   $9345
9339: 00 0c           NEG   $0C
933b: 00 18           NEG   $18
933d: 2c 18           BGE   $9357
933f: 00 18           NEG   $18
9341: 27 0c           BEQ   $934F
9343: 00 0c           NEG   $0C
9345: 00 18           NEG   $18
9347: 29 18           BVS   $9361
9349: 00 18           NEG   $18
934b: 2a 0c           BPL   $9359
934d: 00 0c           NEG   $0C
934f: 00 18           NEG   $18
9351: 2c 18           BGE   $936B
9353: 00 18           NEG   $18
9355: 27 0c           BEQ   $9363
9357: 00 0c           NEG   $0C
9359: 00 18           NEG   $18
935b: 29 18           BVS   $9375
935d: 00 18           NEG   $18
935f: 2a 0c           BPL   $936D
9361: 00 0c           NEG   $0C
9363: 00 18           NEG   $18
9365: 2c 18           BGE   $937F
9367: 2a 48           BPL   $93B1
9369: 2a 0c           BPL   $9377
936b: 2e 3c           BGT   $93A9
936d: 86 00           LDA   #$00
936f: 84 db           ANDA  #$DB
9371: 6e 85           JMP   B,X
9373: be 00 30        LDX   >$0030
9376: 2a 06           BPL   $937E
9378: 2a 06           BPL   $9380
937a: 00 06           NEG   $06
937c: 2a 06           BPL   $9384
937e: 2a 06           BPL   $9386
9380: 00 06           NEG   $06
9382: 2a 06           BPL   $938A
9384: 2a 06           BPL   $938C
9386: 00 06           NEG   $06
9388: 2a 06           BPL   $9390
938a: 2a 06           BPL   $9392
938c: 00 06           NEG   $06
938e: 2a 0c           BPL   $939C
9390: 2a 0c           BPL   $939E
9392: 2c 06           BGE   $939A
9394: 2c 06           BGE   $939C
9396: 00 06           NEG   $06
9398: 2c 06           BGE   $93A0
939a: 2c 06           BGE   $93A2
939c: 00 06           NEG   $06
939e: 2c 06           BGE   $93A6
93a0: 2c 06           BGE   $93A8
93a2: 00 06           NEG   $06
93a4: 2c 06           BGE   $93AC
93a6: 2c 06           BGE   $93AE
93a8: 00 06           NEG   $06
93aa: 2c 0c           BGE   $93B8
93ac: 2c 0c           BGE   $93BA
93ae: 2e 06           BGT   $93B6
93b0: 2e 06           BGT   $93B8
93b2: 00 06           NEG   $06
93b4: 2e 06           BGT   $93BC
93b6: 2e 06           BGT   $93BE
93b8: 00 06           NEG   $06
93ba: 2e 06           BGT   $93C2
93bc: 2e 06           BGT   $93C4
93be: 00 06           NEG   $06
93c0: 2e 06           BGT   $93C8
93c2: 2e 06           BGT   $93CA
93c4: 00 06           NEG   $06
93c6: 2e 0c           BGT   $93D4
93c8: 2e 0c           BGT   $93D6
93ca: 30 06           LEAX  $6,X
93cc: 30 06           LEAX  $6,X
93ce: 00 06           NEG   $06
93d0: 30 06           LEAX  $6,X
93d2: 30 06           LEAX  $6,X
93d4: 00 06           NEG   $06
93d6: 30 06           LEAX  $6,X
93d8: 30 06           LEAX  $6,X
93da: 00 06           NEG   $06
93dc: 30 06           LEAX  $6,X
93de: 30 06           LEAX  $6,X
93e0: 00 06           NEG   $06
93e2: 30 0c           LEAX  $C,X
93e4: 30 0c           LEAX  $C,X
93e6: 2f 06           BLE   $93EE
93e8: 2f 06           BLE   $93F0
93ea: 00 06           NEG   $06
93ec: 2f 06           BLE   $93F4
93ee: 2f 06           BLE   $93F6
93f0: 00 06           NEG   $06
93f2: 2f 06           BLE   $93FA
93f4: 2f 06           BLE   $93FC
93f6: 00 06           NEG   $06
93f8: 2f 06           BLE   $9400
93fa: 2f 06           BLE   $9402
93fc: 00 06           NEG   $06
93fe: 2f 0c           BLE   $940C
9400: 2f 0c           BLE   $940E
9402: 2e 06           BGT   $940A
9404: 2e 06           BGT   $940C
9406: 00 06           NEG   $06
9408: 2e 06           BGT   $9410
940a: 2e 06           BGT   $9412
940c: 00 06           NEG   $06
940e: 2e 06           BGT   $9416
9410: 2e 06           BGT   $9418
9412: 00 06           NEG   $06
9414: 2e 06           BGT   $941C
9416: 2e 06           BGT   $941E
9418: 00 06           NEG   $06
941a: 2e 0c           BGT   $9428
941c: 2e 0c           BGT   $942A
941e: 2c 06           BGE   $9426
9420: 2c 06           BGE   $9428
9422: 00 06           NEG   $06
9424: 2c 06           BGE   $942C
9426: 2c 06           BGE   $942E
9428: 00 06           NEG   $06
942a: 2c 06           BGE   $9432
942c: 2c 06           BGE   $9434
942e: 00 06           NEG   $06
9430: 2c 06           BGE   $9438
9432: 2c 06           BGE   $943A
9434: 00 06           NEG   $06
9436: 2c 0c           BGE   $9444
9438: 2c 0c           BGE   $9446
943a: 00 60           NEG   $60
943c: 2a 06           BPL   $9444
943e: 2a 06           BPL   $9446
9440: 00 06           NEG   $06
9442: 2a 06           BPL   $944A
9444: 2a 06           BPL   $944C
9446: 00 06           NEG   $06
9448: 2a 06           BPL   $9450
944a: 2a 06           BPL   $9452
944c: 00 06           NEG   $06
944e: 2a 06           BPL   $9456
9450: 2a 06           BPL   $9458
9452: 00 06           NEG   $06
9454: 2a 0c           BPL   $9462
9456: 2a 0c           BPL   $9464
9458: 2c 06           BGE   $9460
945a: 2c 06           BGE   $9462
945c: 00 06           NEG   $06
945e: 2c 06           BGE   $9466
9460: 2c 06           BGE   $9468
9462: 00 06           NEG   $06
9464: 2c 06           BGE   $946C
9466: 2c 06           BGE   $946E
9468: 00 06           NEG   $06
946a: 2c 06           BGE   $9472
946c: 2c 06           BGE   $9474
946e: 00 06           NEG   $06
9470: 2c 0c           BGE   $947E
9472: 2c 0c           BGE   $9480
9474: 2e 06           BGT   $947C
9476: 2e 06           BGT   $947E
9478: 00 06           NEG   $06
947a: 2e 06           BGT   $9482
947c: 2e 06           BGT   $9484
947e: 00 06           NEG   $06
9480: 2e 06           BGT   $9488
9482: 2e 06           BGT   $948A
9484: 00 06           NEG   $06
9486: 2e 06           BGT   $948E
9488: 2e 06           BGT   $9490
948a: 00 06           NEG   $06
948c: 2e 0c           BGT   $949A
948e: 2e 0c           BGT   $949C
9490: 30 06           LEAX  $6,X
9492: 30 06           LEAX  $6,X
9494: 00 06           NEG   $06
9496: 30 06           LEAX  $6,X
9498: 30 06           LEAX  $6,X
949a: 00 06           NEG   $06
949c: 30 06           LEAX  $6,X
949e: 30 06           LEAX  $6,X
94a0: 00 06           NEG   $06
94a2: 30 06           LEAX  $6,X
94a4: 30 06           LEAX  $6,X
94a6: 00 06           NEG   $06
94a8: 30 0c           LEAX  $C,X
94aa: 30 0c           LEAX  $C,X
94ac: 2f 06           BLE   $94B4
94ae: 2f 06           BLE   $94B6
94b0: 00 06           NEG   $06
94b2: 2f 06           BLE   $94BA
94b4: 2f 06           BLE   $94BC
94b6: 00 06           NEG   $06
94b8: 2f 06           BLE   $94C0
94ba: 2f 06           BLE   $94C2
94bc: 00 06           NEG   $06
94be: 2f 06           BLE   $94C6
94c0: 2f 06           BLE   $94C8
94c2: 00 06           NEG   $06
94c4: 2f 0c           BLE   $94D2
94c6: 2f 0c           BLE   $94D4
94c8: 2e 06           BGT   $94D0
94ca: 2e 06           BGT   $94D2
94cc: 00 06           NEG   $06
94ce: 2e 06           BGT   $94D6
94d0: 2e 06           BGT   $94D8
94d2: 00 06           NEG   $06
94d4: 2e 06           BGT   $94DC
94d6: 2e 06           BGT   $94DE
94d8: 00 06           NEG   $06
94da: 2e 06           BGT   $94E2
94dc: 2e 06           BGT   $94E4
94de: 00 06           NEG   $06
94e0: 2e 0c           BGT   $94EE
94e2: 2e 0c           BGT   $94F0
94e4: 2c 06           BGE   $94EC
94e6: 2c 06           BGE   $94EE
94e8: 00 06           NEG   $06
94ea: 2c 06           BGE   $94F2
94ec: 2c 06           BGE   $94F4
94ee: 00 06           NEG   $06
94f0: 2c 06           BGE   $94F8
94f2: 2c 06           BGE   $94FA
94f4: 00 06           NEG   $06
94f6: 2c 06           BGE   $94FE
94f8: 2c 0c           BGE   $9506
94fa: 2f 0c           BLE   $9508
94fc: 31 6c           LEAY  $C,S
94fe: 84 dc           ANDA  #$DC
9500: 02 86 00        AIM   #$86;$00
9503: 85 cd           BITA  #$CD
9505: 27 24           BEQ   $952B
9507: 29 30           BVS   $9539
9509: 2a 24           BPL   $952F
950b: 86 0c           LDA   #$0C
950d: 2a 0c           BPL   $951B
950f: 00 0c           NEG   $0C
9511: 2a 06           BPL   $9519
9513: 2a 06           BPL   $951B
9515: 00 06           NEG   $06
9517: 2a 06           BPL   $951F
9519: 2a 0c           BPL   $9527
951b: 2a 0c           BPL   $9529
951d: 86 f4           LDA   #$F4
951f: 27 24           BEQ   $9545
9521: 29 30           BVS   $9553
9523: 2a 24           BPL   $9549
9525: 86 0c           LDA   #$0C
9527: 2a 0c           BPL   $9535
9529: 00 06           NEG   $06
952b: 2a 06           BPL   $9533
952d: 00 06           NEG   $06
952f: 2a 06           BPL   $9537
9531: 2a 06           BPL   $9539
9533: 2a 06           BPL   $953B
9535: 2a 06           BPL   $953D
9537: 2a 06           BPL   $953F
9539: 00 06           NEG   $06
953b: 2a 06           BPL   $9543
953d: 86 f4           LDA   #$F4
953f: 27 24           BEQ   $9565
9541: 29 30           BVS   $9573
9543: 2a 24           BPL   $9569
9545: 86 0c           LDA   #$0C
9547: 2a 0c           BPL   $9555
9549: 00 0c           NEG   $0C
954b: 2a 06           BPL   $9553
954d: 2a 06           BPL   $9555
954f: 27 0c           BEQ   $955D
9551: 2a 0c           BPL   $955F
9553: 84 dd           ANDA  #$DD
9555: 4f              CLRA
9556: 85 c8           BITA  #$C8
9558: 86 0c           LDA   #$0C
955a: 2c cc           BGE   $9528
955c: 86 f4           LDA   #$F4
955e: 82 00           SBCA  #$00
9560: 87              FCB   $87
9561: 00 60           NEG   $60
9563: 80 00           SUBA  #$00
9565: 0c 86           INC   $86
9567: 0c 84           INC   $84
9569: dd 4f           STD   $4F
956b: 85 d2           BITA  #$D2
956d: 23 18           BLS   $9587
956f: 00 0c           NEG   $0C
9571: 00 0c           NEG   $0C
9573: 25 24           BCS   $9599
9575: 00 0c           NEG   $0C
9577: 27 18           BEQ   $9591
9579: 00 0c           NEG   $0C
957b: 00 0c           NEG   $0C
957d: 29 24           BVS   $95A3
957f: 00 0c           NEG   $0C
9581: 23 18           BLS   $959B
9583: 00 0c           NEG   $0C
9585: 00 0c           NEG   $0C
9587: 25 24           BCS   $95AD
9589: 00 0c           NEG   $0C
958b: 27 18           BEQ   $95A5
958d: 00 0c           NEG   $0C
958f: 00 0c           NEG   $0C
9591: 29 24           BVS   $95B7
9593: 00 0c           NEG   $0C
9595: 23 18           BLS   $95AF
9597: 00 0c           NEG   $0C
9599: 00 0c           NEG   $0C
959b: 25 24           BCS   $95C1
959d: 00 0c           NEG   $0C
959f: 27 18           BEQ   $95B9
95a1: 00 0c           NEG   $0C
95a3: 00 0c           NEG   $0C
95a5: 29 24           BVS   $95CB
95a7: 27 54           BEQ   $95FD
95a9: 29 3c           BVS   $95E7
95ab: 84 db           ANDA  #$DB
95ad: 6e 85           JMP   B,X
95af: be 86 00        LDX   $8600
95b2: 00 30           NEG   $30
95b4: 27 06           BEQ   $95BC
95b6: 27 06           BEQ   $95BE
95b8: 00 06           NEG   $06
95ba: 27 06           BEQ   $95C2
95bc: 27 06           BEQ   $95C4
95be: 00 06           NEG   $06
95c0: 27 06           BEQ   $95C8
95c2: 27 06           BEQ   $95CA
95c4: 00 06           NEG   $06
95c6: 27 06           BEQ   $95CE
95c8: 27 06           BEQ   $95D0
95ca: 00 06           NEG   $06
95cc: 27 0c           BEQ   $95DA
95ce: 27 0c           BEQ   $95DC
95d0: 29 06           BVS   $95D8
95d2: 29 06           BVS   $95DA
95d4: 00 06           NEG   $06
95d6: 29 06           BVS   $95DE
95d8: 29 06           BVS   $95E0
95da: 00 06           NEG   $06
95dc: 29 06           BVS   $95E4
95de: 29 06           BVS   $95E6
95e0: 00 06           NEG   $06
95e2: 29 06           BVS   $95EA
95e4: 29 06           BVS   $95EC
95e6: 00 06           NEG   $06
95e8: 29 0c           BVS   $95F6
95ea: 29 0c           BVS   $95F8
95ec: 2a 06           BPL   $95F4
95ee: 2a 06           BPL   $95F6
95f0: 00 06           NEG   $06
95f2: 2a 06           BPL   $95FA
95f4: 2a 06           BPL   $95FC
95f6: 00 06           NEG   $06
95f8: 2a 06           BPL   $9600
95fa: 2a 06           BPL   $9602
95fc: 00 06           NEG   $06
95fe: 2a 06           BPL   $9606
9600: 2a 06           BPL   $9608
9602: 00 06           NEG   $06
9604: 2a 0c           BPL   $9612
9606: 2a 0c           BPL   $9614
9608: 2c 06           BGE   $9610
960a: 2c 06           BGE   $9612
960c: 00 06           NEG   $06
960e: 2c 06           BGE   $9616
9610: 2c 06           BGE   $9618
9612: 00 06           NEG   $06
9614: 2c 06           BGE   $961C
9616: 2c 06           BGE   $961E
9618: 00 06           NEG   $06
961a: 2c 06           BGE   $9622
961c: 2c 06           BGE   $9624
961e: 00 06           NEG   $06
9620: 2c 0c           BGE   $962E
9622: 2c 0c           BGE   $9630
9624: 2a 06           BPL   $962C
9626: 2a 06           BPL   $962E
9628: 00 06           NEG   $06
962a: 2a 06           BPL   $9632
962c: 2a 06           BPL   $9634
962e: 00 06           NEG   $06
9630: 2a 06           BPL   $9638
9632: 2a 06           BPL   $963A
9634: 00 06           NEG   $06
9636: 2a 06           BPL   $963E
9638: 2a 06           BPL   $9640
963a: 00 06           NEG   $06
963c: 2a 0c           BPL   $964A
963e: 2a 0c           BPL   $964C
9640: 29 06           BVS   $9648
9642: 29 06           BVS   $964A
9644: 00 06           NEG   $06
9646: 29 06           BVS   $964E
9648: 29 06           BVS   $9650
964a: 00 06           NEG   $06
964c: 29 06           BVS   $9654
964e: 29 06           BVS   $9656
9650: 00 06           NEG   $06
9652: 29 06           BVS   $965A
9654: 29 06           BVS   $965C
9656: 00 06           NEG   $06
9658: 29 0c           BVS   $9666
965a: 29 0c           BVS   $9668
965c: 27 06           BEQ   $9664
965e: 27 06           BEQ   $9666
9660: 00 06           NEG   $06
9662: 27 06           BEQ   $966A
9664: 27 06           BEQ   $966C
9666: 00 06           NEG   $06
9668: 27 06           BEQ   $9670
966a: 27 06           BEQ   $9672
966c: 00 06           NEG   $06
966e: 27 06           BEQ   $9676
9670: 27 06           BEQ   $9678
9672: 00 06           NEG   $06
9674: 27 0c           BEQ   $9682
9676: 27 0c           BEQ   $9684
9678: 00 60           NEG   $60
967a: 27 06           BEQ   $9682
967c: 27 06           BEQ   $9684
967e: 00 06           NEG   $06
9680: 27 06           BEQ   $9688
9682: 27 06           BEQ   $968A
9684: 00 06           NEG   $06
9686: 27 06           BEQ   $968E
9688: 27 06           BEQ   $9690
968a: 00 06           NEG   $06
968c: 27 06           BEQ   $9694
968e: 27 06           BEQ   $9696
9690: 00 06           NEG   $06
9692: 27 0c           BEQ   $96A0
9694: 27 0c           BEQ   $96A2
9696: 29 06           BVS   $969E
9698: 29 06           BVS   $96A0
969a: 00 06           NEG   $06
969c: 29 06           BVS   $96A4
969e: 29 06           BVS   $96A6
96a0: 00 06           NEG   $06
96a2: 29 06           BVS   $96AA
96a4: 29 06           BVS   $96AC
96a6: 00 06           NEG   $06
96a8: 29 06           BVS   $96B0
96aa: 29 06           BVS   $96B2
96ac: 00 06           NEG   $06
96ae: 29 0c           BVS   $96BC
96b0: 29 0c           BVS   $96BE
96b2: 2a 06           BPL   $96BA
96b4: 2a 06           BPL   $96BC
96b6: 00 06           NEG   $06
96b8: 2a 06           BPL   $96C0
96ba: 2a 06           BPL   $96C2
96bc: 00 06           NEG   $06
96be: 2a 06           BPL   $96C6
96c0: 2a 06           BPL   $96C8
96c2: 00 06           NEG   $06
96c4: 2a 06           BPL   $96CC
96c6: 2a 06           BPL   $96CE
96c8: 00 06           NEG   $06
96ca: 2a 0c           BPL   $96D8
96cc: 2a 0c           BPL   $96DA
96ce: 2c 06           BGE   $96D6
96d0: 2c 06           BGE   $96D8
96d2: 00 06           NEG   $06
96d4: 2c 06           BGE   $96DC
96d6: 2c 06           BGE   $96DE
96d8: 00 06           NEG   $06
96da: 2c 06           BGE   $96E2
96dc: 2c 06           BGE   $96E4
96de: 00 06           NEG   $06
96e0: 2c 06           BGE   $96E8
96e2: 2c 06           BGE   $96EA
96e4: 00 06           NEG   $06
96e6: 2c 0c           BGE   $96F4
96e8: 2c 0c           BGE   $96F6
96ea: 2a 06           BPL   $96F2
96ec: 2a 06           BPL   $96F4
96ee: 00 06           NEG   $06
96f0: 2a 06           BPL   $96F8
96f2: 2a 06           BPL   $96FA
96f4: 00 06           NEG   $06
96f6: 2a 06           BPL   $96FE
96f8: 2a 06           BPL   $9700
96fa: 00 06           NEG   $06
96fc: 2a 06           BPL   $9704
96fe: 2a 06           BPL   $9706
9700: 00 06           NEG   $06
9702: 2a 0c           BPL   $9710
9704: 2a 0c           BPL   $9712
9706: 29 06           BVS   $970E
9708: 29 06           BVS   $9710
970a: 00 06           NEG   $06
970c: 29 06           BVS   $9714
970e: 29 06           BVS   $9716
9710: 00 06           NEG   $06
9712: 29 06           BVS   $971A
9714: 29 06           BVS   $971C
9716: 00 06           NEG   $06
9718: 29 06           BVS   $9720
971a: 29 06           BVS   $9722
971c: 00 06           NEG   $06
971e: 29 0c           BVS   $972C
9720: 29 0c           BVS   $972E
9722: 27 06           BEQ   $972A
9724: 27 06           BEQ   $972C
9726: 00 06           NEG   $06
9728: 27 06           BEQ   $9730
972a: 27 06           BEQ   $9732
972c: 00 06           NEG   $06
972e: 27 06           BEQ   $9736
9730: 27 06           BEQ   $9738
9732: 00 06           NEG   $06
9734: 27 06           BEQ   $973C
9736: 27 0c           BEQ   $9744
9738: 2a 0c           BPL   $9746
973a: 2c 6c           BGE   $97A8
973c: 84 dc           ANDA  #$DC
973e: 02 85 cd        AIM   #$85;$CD
9741: 86 00           LDA   #$00
9743: 2f 24           BLE   $9769
9745: 25 30           BCS   $9777
9747: 27 24           BEQ   $976D
9749: 86 0c           LDA   #$0C
974b: 27 0c           BEQ   $9759
974d: 00 0c           NEG   $0C
974f: 27 06           BEQ   $9757
9751: 27 06           BEQ   $9759
9753: 00 06           NEG   $06
9755: 27 06           BEQ   $975D
9757: 27 0c           BEQ   $9765
9759: 27 0c           BEQ   $9767
975b: 86 f4           LDA   #$F4
975d: 2f 24           BLE   $9783
975f: 25 30           BCS   $9791
9761: 27 24           BEQ   $9787
9763: 86 0c           LDA   #$0C
9765: 27 0c           BEQ   $9773
9767: 00 06           NEG   $06
9769: 27 06           BEQ   $9771
976b: 00 06           NEG   $06
976d: 27 06           BEQ   $9775
976f: 27 06           BEQ   $9777
9771: 27 06           BEQ   $9779
9773: 27 06           BEQ   $977B
9775: 27 06           BEQ   $977D
9777: 00 06           NEG   $06
9779: 27 06           BEQ   $9781
977b: 86 f4           LDA   #$F4
977d: 2f 24           BLE   $97A3
977f: 25 30           BCS   $97B1
9781: 27 24           BEQ   $97A7
9783: 86 0c           LDA   #$0C
9785: 27 0c           BEQ   $9793
9787: 00 0c           NEG   $0C
9789: 27 06           BEQ   $9791
978b: 27 06           BEQ   $9793
978d: 2f 0c           BLE   $979B
978f: 27 0c           BEQ   $979D
9791: 84 dd           ANDA  #$DD
9793: 4f              CLRA
9794: 85 c8           BITA  #$C8
9796: 86 0c           LDA   #$0C
9798: 27 cc           BEQ   $9766
979a: 86 f4           LDA   #$F4
979c: 82 00           SBCA  #$00
979e: 87              FCB   $87
979f: 00 60           NEG   $60
97a1: 80 84           SUBA  #$84
97a3: dd 4f           STD   $4F
97a5: 85 d2           BITA  #$D2
97a7: 86 0c           LDA   #$0C
97a9: 1e 24           EXG   Y,S
97ab: 20 3c           BRA   $97E9
97ad: 23 24           BLS   $97D3
97af: 25 3c           BCS   $97ED
97b1: 1e 24           EXG   Y,S
97b3: 20 3c           BRA   $97F1
97b5: 23 24           BLS   $97DB
97b7: 25 30           BCS   $97E9
97b9: 31 0c           LEAY  $C,X
97bb: 1e 24           EXG   Y,S
97bd: 20 3c           BRA   $97FB
97bf: 23 24           BLS   $97E5
97c1: 25 3c           BCS   $97FF
97c3: 23 54           BLS   $9819
97c5: 26 3c           BNE   $9803
97c7: 84 dc           ANDA  #$DC
97c9: bb 86 f4        ADDA  $86F4
97cc: 85 d2           BITA  #$D2
97ce: 88 fa           EORA  #$FA
97d0: 00 30           NEG   $30
97d2: 33 60           LEAU  $0,S
97d4: 35 60           PULS  Y,U
97d6: 36 60           PSHU  S,Y
97d8: 38              FCB   $38
97d9: 60 3b           NEG   -$5,Y
97db: 60 3d           NEG   -$3,Y
97dd: 60 3f           NEG   -$1,Y
97df: 60 00           NEG   $0,X
97e1: 60 33           NEG   -$D,Y
97e3: 60 35           NEG   -$B,Y
97e5: 60 36           NEG   -$A,Y
97e7: 60 38           NEG   -$8,Y
97e9: 60 3b           NEG   -$5,Y
97eb: 60 3d           NEG   -$3,Y
97ed: 60 3f           NEG   -$1,Y
97ef: 54              LSRB
97f0: 42              FCB   $42
97f1: 6c 84           INC   ,X
97f3: dc 02           LDD   $02
97f5: 85 d2           BITA  #$D2
97f7: 88 c8           EORA  #$C8
97f9: 86 00           LDA   #$00
97fb: 1e 24           EXG   Y,S
97fd: 20 30           BRA   $982F
97ff: 22 24           BHI   $9825
9801: 86 0c           LDA   #$0C
9803: 22 0c           BHI   $9811
9805: 00 0c           NEG   $0C
9807: 22 06           BHI   $980F
9809: 22 06           BHI   $9811
980b: 00 06           NEG   $06
980d: 22 06           BHI   $9815
980f: 22 0c           BHI   $981D
9811: 22 0c           BHI   $981F
9813: 86 00           LDA   #$00
9815: 1e 24           EXG   Y,S
9817: 20 30           BRA   $9849
9819: 22 24           BHI   $983F
981b: 86 0c           LDA   #$0C
981d: 22 0c           BHI   $982B
981f: 00 06           NEG   $06
9821: 22 06           BHI   $9829
9823: 00 06           NEG   $06
9825: 22 06           BHI   $982D
9827: 22 06           BHI   $982F
9829: 22 06           BHI   $9831
982b: 22 06           BHI   $9833
982d: 22 06           BHI   $9835
982f: 00 06           NEG   $06
9831: 22 06           BHI   $9839
9833: 86 00           LDA   #$00
9835: 1e 24           EXG   Y,S
9837: 20 30           BRA   $9869
9839: 22 24           BHI   $985F
983b: 86 0c           LDA   #$0C
983d: 22 0c           BHI   $984B
983f: 00 0c           NEG   $0C
9841: 22 06           BHI   $9849
9843: 22 06           BHI   $984B
9845: 1e 0c           EXG   D,0
9847: 22 0c           BHI   $9855
9849: 84 dd           ANDA  #$DD
984b: 4f              CLRA
984c: 85 c8           BITA  #$C8
984e: 86 0c           LDA   #$0C
9850: 25 cc           BCS   $981E
9852: 86 00           LDA   #$00
9854: 82 00           SBCA  #$00
9856: 87              FCB   $87
9857: 86 00           LDA   #$00
9859: 85 e6           BITA  #$E6
985b: 00 30           NEG   $30
985d: 29 06           BVS   $9865
985f: 20 06           BRA   $9867
9861: 00 06           NEG   $06
9863: 29 06           BVS   $986B
9865: 24 0c           BCC   $9873
9867: 24 0c           BCC   $9875
9869: 80 84           SUBA  #$84
986b: de 2d           LDU   $2D
986d: 85 d2           BITA  #$D2
986f: 81 3d           CMPA  #$3D
9871: 0c 3d           INC   $3D
9873: 0c 84           INC   $84
9875: de 52           LDU   $52
9877: 85 e6           BITA  #$E6
9879: 31 0c           LEAY  $C,X
987b: 84 de           ANDA  #$DE
987d: 2d 85           BLT   $9804
987f: d2 3d           SBCB  $3D
9881: 0c 3d           INC   $3D
9883: 0c 3d           INC   $3D
9885: 0c 84           INC   $84
9887: de 52           LDU   $52
9889: 85 e6           BITA  #$E6
988b: 31 0c           LEAY  $C,X
988d: 84 de           ANDA  #$DE
988f: 2d 85           BLT   $9816
9891: d2 3d           SBCB  $3D
9893: 0c 83           INC   $83
9895: 03 84           COM   $84
9897: de 2d           LDU   $2D
9899: 85 d2           BITA  #$D2
989b: 3d              MUL
989c: 0c 3d           INC   $3D
989e: 0c 84           INC   $84
98a0: de 52           LDU   $52
98a2: 85 e6           BITA  #$E6
98a4: 31 0c           LEAY  $C,X
98a6: 84 de           ANDA  #$DE
98a8: 2d 85           BLT   $982F
98aa: d2 3d           SBCB  $3D
98ac: 0c 3d           INC   $3D
98ae: 0c 3d           INC   $3D
98b0: 0c 84           INC   $84
98b2: de 52           LDU   $52
98b4: 85 e6           BITA  #$E6
98b6: 31 0c           LEAY  $C,X
98b8: 31 0c           LEAY  $C,X
98ba: 84 de           ANDA  #$DE
98bc: 2d 85           BLT   $9843
98be: d2 81           SBCB  $81
98c0: 3d              MUL
98c1: 0c 3d           INC   $3D
98c3: 0c 84           INC   $84
98c5: de 52           LDU   $52
98c7: 85 e6           BITA  #$E6
98c9: 31 0c           LEAY  $C,X
98cb: 84 de           ANDA  #$DE
98cd: 2d 85           BLT   $9854
98cf: d2 3d           SBCB  $3D
98d1: 0c 3d           INC   $3D
98d3: 0c 3d           INC   $3D
98d5: 0c 84           INC   $84
98d7: de 52           LDU   $52
98d9: 85 e6           BITA  #$E6
98db: 31 0c           LEAY  $C,X
98dd: 84 de           ANDA  #$DE
98df: 2d 85           BLT   $9866
98e1: d2 3d           SBCB  $3D
98e3: 0c 83           INC   $83
98e5: 03 84           COM   $84
98e7: de 52           LDU   $52
98e9: 85 e6           BITA  #$E6
98eb: 31 0c           LEAY  $C,X
98ed: 31 0c           LEAY  $C,X
98ef: 31 0c           LEAY  $C,X
98f1: 31 0c           LEAY  $C,X
98f3: 00 18           NEG   $18
98f5: 31 06           LEAY  $6,X
98f7: 31 06           LEAY  $6,X
98f9: 00 06           NEG   $06
98fb: 31 06           LEAY  $6,X
98fd: 84 de           ANDA  #$DE
98ff: 2d 85           BLT   $9886
9901: d2 81           SBCB  $81
9903: 3d              MUL
9904: 0c 3d           INC   $3D
9906: 0c 84           INC   $84
9908: de 52           LDU   $52
990a: 85 e6           BITA  #$E6
990c: 31 0c           LEAY  $C,X
990e: 84 de           ANDA  #$DE
9910: 2d 85           BLT   $9897
9912: d2 3d           SBCB  $3D
9914: 0c 3d           INC   $3D
9916: 0c 3d           INC   $3D
9918: 0c 84           INC   $84
991a: de 52           LDU   $52
991c: 85 e6           BITA  #$E6
991e: 31 0c           LEAY  $C,X
9920: 84 de           ANDA  #$DE
9922: 2d 85           BLT   $98A9
9924: d2 3d           SBCB  $3D
9926: 0c 83           INC   $83
9928: 03 84           COM   $84
992a: de 2d           LDU   $2D
992c: 85 d2           BITA  #$D2
992e: 3d              MUL
992f: 0c 3d           INC   $3D
9931: 0c 84           INC   $84
9933: de 52           LDU   $52
9935: 85 e6           BITA  #$E6
9937: 31 0c           LEAY  $C,X
9939: 84 de           ANDA  #$DE
993b: 2d 85           BLT   $98C2
993d: d2 3d           SBCB  $3D
993f: 0c 3d           INC   $3D
9941: 0c 3d           INC   $3D
9943: 0c 84           INC   $84
9945: de 52           LDU   $52
9947: 85 e6           BITA  #$E6
9949: 31 0c           LEAY  $C,X
994b: 31 0c           LEAY  $C,X
994d: 84 de           ANDA  #$DE
994f: 2d 85           BLT   $98D6
9951: d2 81           SBCB  $81
9953: 3d              MUL
9954: 0c 3d           INC   $3D
9956: 0c 84           INC   $84
9958: de 52           LDU   $52
995a: 85 e6           BITA  #$E6
995c: 31 0c           LEAY  $C,X
995e: 84 de           ANDA  #$DE
9960: 2d 85           BLT   $98E7
9962: d2 3d           SBCB  $3D
9964: 0c 3d           INC   $3D
9966: 0c 3d           INC   $3D
9968: 0c 84           INC   $84
996a: de 52           LDU   $52
996c: 85 e6           BITA  #$E6
996e: 31 0c           LEAY  $C,X
9970: 84 de           ANDA  #$DE
9972: 2d 85           BLT   $98F9
9974: d2 3d           SBCB  $3D
9976: 0c 83           INC   $83
9978: 03 84           COM   $84
997a: dd e3           STD   $E3
997c: 85 e6           BITA  #$E6
997e: 29 06           BVS   $9986
9980: 29 06           BVS   $9988
9982: 25 0c           BCS   $9990
9984: 22 0c           BHI   $9992
9986: 1e 0c           EXG   D,0
9988: 84 de           ANDA  #$DE
998a: 52              FCB   $52
998b: 85 e6           BITA  #$E6
998d: 00 18           NEG   $18
998f: 31 06           LEAY  $6,X
9991: 31 06           LEAY  $6,X
9993: 00 06           NEG   $06
9995: 31 06           LEAY  $6,X
9997: 84 de           ANDA  #$DE
9999: 2d 85           BLT   $9920
999b: d2 81           SBCB  $81
999d: 3d              MUL
999e: 0c 3d           INC   $3D
99a0: 0c 84           INC   $84
99a2: de 52           LDU   $52
99a4: 85 e6           BITA  #$E6
99a6: 31 0c           LEAY  $C,X
99a8: 84 de           ANDA  #$DE
99aa: 2d 85           BLT   $9931
99ac: d2 3d           SBCB  $3D
99ae: 0c 3d           INC   $3D
99b0: 0c 3d           INC   $3D
99b2: 0c 84           INC   $84
99b4: de 52           LDU   $52
99b6: 85 e6           BITA  #$E6
99b8: 31 0c           LEAY  $C,X
99ba: 84 de           ANDA  #$DE
99bc: 2d 85           BLT   $9943
99be: d2 3d           SBCB  $3D
99c0: 0c 83           INC   $83
99c2: 03 84           COM   $84
99c4: de 2d           LDU   $2D
99c6: 85 d2           BITA  #$D2
99c8: 3d              MUL
99c9: 0c 3d           INC   $3D
99cb: 0c 84           INC   $84
99cd: de 52           LDU   $52
99cf: 85 e6           BITA  #$E6
99d1: 31 0c           LEAY  $C,X
99d3: 84 de           ANDA  #$DE
99d5: 2d 85           BLT   $995C
99d7: d2 3d           SBCB  $3D
99d9: 0c 3d           INC   $3D
99db: 0c 3d           INC   $3D
99dd: 0c 84           INC   $84
99df: de 52           LDU   $52
99e1: 85 e6           BITA  #$E6
99e3: 31 0c           LEAY  $C,X
99e5: 31 0c           LEAY  $C,X
99e7: 84 de           ANDA  #$DE
99e9: 2d 85           BLT   $9970
99eb: d2 3d           SBCB  $3D
99ed: 0c 3d           INC   $3D
99ef: 0c 84           INC   $84
99f1: de 52           LDU   $52
99f3: 85 e6           BITA  #$E6
99f5: 31 0c           LEAY  $C,X
99f7: 84 de           ANDA  #$DE
99f9: 2d 85           BLT   $9980
99fb: d2 3d           SBCB  $3D
99fd: 0c 3d           INC   $3D
99ff: 0c 3d           INC   $3D
9a01: 0c 84           INC   $84
9a03: de 52           LDU   $52
9a05: 85 e6           BITA  #$E6
9a07: 31 0c           LEAY  $C,X
9a09: 84 de           ANDA  #$DE
9a0b: 2d 85           BLT   $9992
9a0d: d2 3d           SBCB  $3D
9a0f: 0c 84           INC   $84
9a11: de 2d           LDU   $2D
9a13: 85 d2           BITA  #$D2
9a15: 3d              MUL
9a16: 0c 3d           INC   $3D
9a18: 0c 84           INC   $84
9a1a: de 52           LDU   $52
9a1c: 85 e6           BITA  #$E6
9a1e: 31 0c           LEAY  $C,X
9a20: 84 de           ANDA  #$DE
9a22: 2d 85           BLT   $99A9
9a24: d2 3d           SBCB  $3D
9a26: 0c 3d           INC   $3D
9a28: 0c 3d           INC   $3D
9a2a: 0c 84           INC   $84
9a2c: de 52           LDU   $52
9a2e: 85 e6           BITA  #$E6
9a30: 31 0c           LEAY  $C,X
9a32: 84 de           ANDA  #$DE
9a34: 2d 85           BLT   $99BB
9a36: d2 3d           SBCB  $3D
9a38: 0c 84           INC   $84
9a3a: de 2d           LDU   $2D
9a3c: 85 d2           BITA  #$D2
9a3e: 3d              MUL
9a3f: 0c 3d           INC   $3D
9a41: 0c 84           INC   $84
9a43: de 52           LDU   $52
9a45: 85 e6           BITA  #$E6
9a47: 31 0c           LEAY  $C,X
9a49: 84 de           ANDA  #$DE
9a4b: 2d 85           BLT   $99D2
9a4d: d2 3d           SBCB  $3D
9a4f: 0c 3d           INC   $3D
9a51: 0c 84           INC   $84
9a53: de 52           LDU   $52
9a55: 85 e6           BITA  #$E6
9a57: 31 0c           LEAY  $C,X
9a59: 31 0c           LEAY  $C,X
9a5b: 31 0c           LEAY  $C,X
9a5d: 84 de           ANDA  #$DE
9a5f: 2d 85           BLT   $99E6
9a61: d2 3d           SBCB  $3D
9a63: 0c 84           INC   $84
9a65: de 52           LDU   $52
9a67: 85 e6           BITA  #$E6
9a69: 31 0c           LEAY  $C,X
9a6b: 31 0c           LEAY  $C,X
9a6d: 84 de           ANDA  #$DE
9a6f: 2d 85           BLT   $99F6
9a71: d2 3d           SBCB  $3D
9a73: 0c 3d           INC   $3D
9a75: 0c 3d           INC   $3D
9a77: 0c 84           INC   $84
9a79: de 52           LDU   $52
9a7b: 85 e6           BITA  #$E6
9a7d: 36 06           PSHU  B,A
9a7f: 36 06           PSHU  B,A
9a81: 33 06           LEAU  $6,X
9a83: 33 06           LEAU  $6,X
9a85: 81 84           CMPA  #$84
9a87: de 2d           LDU   $2D
9a89: 85 d2           BITA  #$D2
9a8b: 3d              MUL
9a8c: 0c 3d           INC   $3D
9a8e: 0c 84           INC   $84
9a90: de 52           LDU   $52
9a92: 85 e6           BITA  #$E6
9a94: 31 0c           LEAY  $C,X
9a96: 84 de           ANDA  #$DE
9a98: 2d 85           BLT   $9A1F
9a9a: d2 3d           SBCB  $3D
9a9c: 0c 3d           INC   $3D
9a9e: 0c 3d           INC   $3D
9aa0: 0c 84           INC   $84
9aa2: de 52           LDU   $52
9aa4: 85 e6           BITA  #$E6
9aa6: 31 0c           LEAY  $C,X
9aa8: 84 de           ANDA  #$DE
9aaa: 2d 85           BLT   $9A31
9aac: d2 3d           SBCB  $3D
9aae: 0c 84           INC   $84
9ab0: de 2d           LDU   $2D
9ab2: 85 d2           BITA  #$D2
9ab4: 3d              MUL
9ab5: 0c 3d           INC   $3D
9ab7: 0c 84           INC   $84
9ab9: de 52           LDU   $52
9abb: 85 e6           BITA  #$E6
9abd: 31 0c           LEAY  $C,X
9abf: 84 de           ANDA  #$DE
9ac1: 2d 85           BLT   $9A48
9ac3: d2 3d           SBCB  $3D
9ac5: 0c 3d           INC   $3D
9ac7: 0c 3d           INC   $3D
9ac9: 0c 84           INC   $84
9acb: de 52           LDU   $52
9acd: 85 e6           BITA  #$E6
9acf: 31 0c           LEAY  $C,X
9ad1: 31 0c           LEAY  $C,X
9ad3: 83 03 84        SUBD  #$0384
9ad6: de 2d           LDU   $2D
9ad8: 85 d2           BITA  #$D2
9ada: 3d              MUL
9adb: 0c 3d           INC   $3D
9add: 0c 84           INC   $84
9adf: de 52           LDU   $52
9ae1: 85 e6           BITA  #$E6
9ae3: 31 0c           LEAY  $C,X
9ae5: 84 de           ANDA  #$DE
9ae7: 2d 85           BLT   $9A6E
9ae9: d2 3d           SBCB  $3D
9aeb: 0c 3d           INC   $3D
9aed: 0c 3d           INC   $3D
9aef: 0c 84           INC   $84
9af1: de 52           LDU   $52
9af3: 85 e6           BITA  #$E6
9af5: 31 0c           LEAY  $C,X
9af7: 84 de           ANDA  #$DE
9af9: 2d 85           BLT   $9A80
9afb: d2 3d           SBCB  $3D
9afd: 0c 84           INC   $84
9aff: de 52           LDU   $52
9b01: 85 e6           BITA  #$E6
9b03: 00 0c           NEG   $0C
9b05: 31 0c           LEAY  $C,X
9b07: 31 0c           LEAY  $C,X
9b09: 31 0c           LEAY  $C,X
9b0b: 31 0c           LEAY  $C,X
9b0d: 31 0c           LEAY  $C,X
9b0f: 31 06           LEAY  $6,X
9b11: 31 06           LEAY  $6,X
9b13: 31 06           LEAY  $6,X
9b15: 31 06           LEAY  $6,X
9b17: 82 00           SBCA  #$00
9b19: 87              FCB   $87
9b1a: 85 e6           BITA  #$E6
9b1c: 00 60           NEG   $60
9b1e: 80 22           SUBA  #$22
9b20: 18              FCB   $18
9b21: 00 18           NEG   $18
9b23: 22 18           BHI   $9B3D
9b25: 00 18           NEG   $18
9b27: 22 18           BHI   $9B41
9b29: 00 18           NEG   $18
9b2b: 22 0c           BHI   $9B39
9b2d: 22 0c           BHI   $9B3B
9b2f: 00 18           NEG   $18
9b31: 22 18           BHI   $9B4B
9b33: 00 18           NEG   $18
9b35: 22 18           BHI   $9B4F
9b37: 00 18           NEG   $18
9b39: 22 18           BHI   $9B53
9b3b: 00 18           NEG   $18
9b3d: 22 0c           BHI   $9B4B
9b3f: 22 0c           BHI   $9B4D
9b41: 00 18           NEG   $18
9b43: 22 18           BHI   $9B5D
9b45: 00 18           NEG   $18
9b47: 22 18           BHI   $9B61
9b49: 00 18           NEG   $18
9b4b: 22 18           BHI   $9B65
9b4d: 00 18           NEG   $18
9b4f: 22 0c           BHI   $9B5D
9b51: 22 0c           BHI   $9B5F
9b53: 00 18           NEG   $18
9b55: 22 18           BHI   $9B6F
9b57: 00 18           NEG   $18
9b59: 22 18           BHI   $9B73
9b5b: 00 18           NEG   $18
9b5d: 22 18           BHI   $9B77
9b5f: 00 18           NEG   $18
9b61: 00 30           NEG   $30
9b63: 22 18           BHI   $9B7D
9b65: 00 18           NEG   $18
9b67: 22 18           BHI   $9B81
9b69: 00 18           NEG   $18
9b6b: 22 18           BHI   $9B85
9b6d: 00 18           NEG   $18
9b6f: 22 0c           BHI   $9B7D
9b71: 22 0c           BHI   $9B7F
9b73: 00 18           NEG   $18
9b75: 22 18           BHI   $9B8F
9b77: 00 18           NEG   $18
9b79: 22 18           BHI   $9B93
9b7b: 00 18           NEG   $18
9b7d: 22 18           BHI   $9B97
9b7f: 00 18           NEG   $18
9b81: 22 0c           BHI   $9B8F
9b83: 22 0c           BHI   $9B91
9b85: 00 18           NEG   $18
9b87: 22 18           BHI   $9BA1
9b89: 00 18           NEG   $18
9b8b: 22 18           BHI   $9BA5
9b8d: 00 18           NEG   $18
9b8f: 22 18           BHI   $9BA9
9b91: 00 18           NEG   $18
9b93: 22 0c           BHI   $9BA1
9b95: 22 0c           BHI   $9BA3
9b97: 00 18           NEG   $18
9b99: 22 18           BHI   $9BB3
9b9b: 00 18           NEG   $18
9b9d: 22 18           BHI   $9BB7
9b9f: 00 18           NEG   $18
9ba1: 22 18           BHI   $9BBB
9ba3: 00 18           NEG   $18
9ba5: 00 30           NEG   $30
9ba7: 22 18           BHI   $9BC1
9ba9: 00 18           NEG   $18
9bab: 22 18           BHI   $9BC5
9bad: 00 18           NEG   $18
9baf: 22 18           BHI   $9BC9
9bb1: 00 18           NEG   $18
9bb3: 22 0c           BHI   $9BC1
9bb5: 22 0c           BHI   $9BC3
9bb7: 00 18           NEG   $18
9bb9: 22 18           BHI   $9BD3
9bbb: 00 18           NEG   $18
9bbd: 22 18           BHI   $9BD7
9bbf: 00 18           NEG   $18
9bc1: 22 18           BHI   $9BDB
9bc3: 00 18           NEG   $18
9bc5: 22 0c           BHI   $9BD3
9bc7: 22 0c           BHI   $9BD5
9bc9: 00 18           NEG   $18
9bcb: 22 18           BHI   $9BE5
9bcd: 00 18           NEG   $18
9bcf: 22 18           BHI   $9BE9
9bd1: 00 18           NEG   $18
9bd3: 22 18           BHI   $9BED
9bd5: 00 18           NEG   $18
9bd7: 22 0c           BHI   $9BE5
9bd9: 22 0c           BHI   $9BE7
9bdb: 00 18           NEG   $18
9bdd: 22 18           BHI   $9BF7
9bdf: 00 18           NEG   $18
9be1: 22 18           BHI   $9BFB
9be3: 00 0c           NEG   $0C
9be5: 22 0c           BHI   $9BF3
9be7: 00 0c           NEG   $0C
9be9: 22 0c           BHI   $9BF7
9beb: 00 18           NEG   $18
9bed: 22 18           BHI   $9C07
9bef: 00 18           NEG   $18
9bf1: 22 0c           BHI   $9BFF
9bf3: 00 0c           NEG   $0C
9bf5: 00 0c           NEG   $0C
9bf7: 22 0c           BHI   $9C05
9bf9: 00 24           NEG   $24
9bfb: 22 0c           BHI   $9C09
9bfd: 00 0c           NEG   $0C
9bff: 22 0c           BHI   $9C0D
9c01: 00 18           NEG   $18
9c03: 22 18           BHI   $9C1D
9c05: 00 18           NEG   $18
9c07: 22 0c           BHI   $9C15
9c09: 00 0c           NEG   $0C
9c0b: 00 0c           NEG   $0C
9c0d: 22 0c           BHI   $9C1B
9c0f: 00 24           NEG   $24
9c11: 22 0c           BHI   $9C1F
9c13: 00 0c           NEG   $0C
9c15: 22 0c           BHI   $9C23
9c17: 00 18           NEG   $18
9c19: 22 18           BHI   $9C33
9c1b: 00 18           NEG   $18
9c1d: 22 0c           BHI   $9C2B
9c1f: 00 0c           NEG   $0C
9c21: 00 0c           NEG   $0C
9c23: 22 0c           BHI   $9C31
9c25: 00 18           NEG   $18
9c27: 22 0c           BHI   $9C35
9c29: 00 0c           NEG   $0C
9c2b: 00 0c           NEG   $0C
9c2d: 22 0c           BHI   $9C3B
9c2f: 00 18           NEG   $18
9c31: 22 18           BHI   $9C4B
9c33: 00 0c           NEG   $0C
9c35: 22 0c           BHI   $9C43
9c37: 00 0c           NEG   $0C
9c39: 22 0c           BHI   $9C47
9c3b: 00 18           NEG   $18
9c3d: 22 18           BHI   $9C57
9c3f: 00 18           NEG   $18
9c41: 22 18           BHI   $9C5B
9c43: 00 18           NEG   $18
9c45: 22 18           BHI   $9C5F
9c47: 00 18           NEG   $18
9c49: 82 00           SBCA  #$00
9c4b: 87              FCB   $87
9c4c: 81 fa           CMPA  #$FA
9c4e: 9c 52           CMPX  $52
9c50: de c1           LDU   $C1
9c52: 86 fa           LDA   #$FA
9c54: 85 f0           BITA  #$F0
9c56: 3a              ABX
9c57: 06 46           ROR   $46
9c59: 06 3a           ROR   $3A
9c5b: 06 46           ROR   $46
9c5d: 06 3a           ROR   $3A
9c5f: 06 46           ROR   $46
9c61: 06 87           ROR   $87
9c63: 06 ea           ROR   $EA
9c65: 9c 7d           CMPX  $7D
9c67: db 24           ADDB  $24
9c69: 9e 2e           LDX   $2E
9c6b: dc bb           LDD   $BB
9c6d: 9f 3b           STX   $3B
9c6f: dc bb           LDD   $BB
9c71: a0 46           SUBA  $6,U
9c73: db 24           ADDB  $24
9c75: a0 79           SUBA  -$7,S
9c77: da 6b           ORB   $6B
9c79: a1 0c           CMPA  $C,X
9c7b: dd e3           STD   $E3
9c7d: 86 00           LDA   #$00
9c7f: 80 85           SUBA  #$85
9c81: dc 00           LDD   $00
9c83: 60 00           NEG   $0,X
9c85: 60 27           NEG   $7,Y
9c87: 01 28 01        OIM   #$28;$01
9c8a: 29 01           BVS   $9C8D
9c8c: 2a 01           BPL   $9C8F
9c8e: 2b 01           BMI   $9C91
9c90: 2c 01           BGE   $9C93
9c92: 2d 01           BLT   $9C95
9c94: 2e 01           BGT   $9C97
9c96: 2f 01           BLE   $9C99
9c98: 30 01           LEAX  $1,X
9c9a: 31 01           LEAY  $1,X
9c9c: 32 01           LEAS  $1,X
9c9e: 33 01           LEAU  $1,X
9ca0: 34 01           PSHS  CC
9ca2: 35 01           PULS  CC
9ca4: 36 01           PSHU  CC
9ca6: 37 01           PULU  CC
9ca8: 38              FCB   $38
9ca9: 01 39 01        OIM   #$39;$01
9cac: 3a              ABX
9cad: 01 3b 01        OIM   #$3B;$01
9cb0: 3c 01           CWAI  #$01
9cb2: 3d              MUL
9cb3: 01 3e 01        OIM   #$3E;$01
9cb6: 3f              SWI
9cb7: 01 40 01        OIM   #$40;$01
9cba: 41              FCB   $41
9cbb: 01 40 01        OIM   #$40;$01
9cbe: 3f              SWI
9cbf: 01 3e 01        OIM   #$3E;$01
9cc2: 3d              MUL
9cc3: 01 3c 01        OIM   #$3C;$01
9cc6: 3b              RTI
9cc7: 01 3a 01        OIM   #$3A;$01
9cca: 39              RTS
9ccb: 01 38 01        OIM   #$38;$01
9cce: 37 01           PULU  CC
9cd0: 36 01           PSHU  CC
9cd2: 35 01           PULS  CC
9cd4: 34 01           PSHS  CC
9cd6: 33 01           LEAU  $1,X
9cd8: 32 01           LEAS  $1,X
9cda: 33 01           LEAU  $1,X
9cdc: 34 01           PSHS  CC
9cde: 35 01           PULS  CC
9ce0: 36 01           PSHU  CC
9ce2: 37 01           PULU  CC
9ce4: 38              FCB   $38
9ce5: 01 39 01        OIM   #$39;$01
9ce8: 3a              ABX
9ce9: 01 3b 01        OIM   #$3B;$01
9cec: 3c 01           CWAI  #$01
9cee: 3d              MUL
9cef: 01 3e 01        OIM   #$3E;$01
9cf2: 3f              SWI
9cf3: 01 40 01        OIM   #$40;$01
9cf6: 41              FCB   $41
9cf7: 01 42 01        OIM   #$42;$01
9cfa: 43              COMA
9cfb: 01 44 01        OIM   #$44;$01
9cfe: 45              FCB   $45
9cff: 01 46 01        OIM   #$46;$01
9d02: 45              FCB   $45
9d03: 01 44 01        OIM   #$44;$01
9d06: 43              COMA
9d07: 01 42 01        OIM   #$42;$01
9d0a: 41              FCB   $41
9d0b: 01 40 01        OIM   #$40;$01
9d0e: 3f              SWI
9d0f: 01 3e 01        OIM   #$3E;$01
9d12: 3d              MUL
9d13: 01 3c 01        OIM   #$3C;$01
9d16: 3b              RTI
9d17: 01 3a 01        OIM   #$3A;$01
9d1a: 39              RTS
9d1b: 01 38 01        OIM   #$38;$01
9d1e: 37 01           PULU  CC
9d20: 36 01           PSHU  CC
9d22: 35 01           PULS  CC
9d24: 34 01           PSHS  CC
9d26: 33 01           LEAU  $1,X
9d28: 32 01           LEAS  $1,X
9d2a: 31 01           LEAY  $1,X
9d2c: 30 01           LEAX  $1,X
9d2e: 2f 01           BLE   $9D31
9d30: 2e 01           BGT   $9D33
9d32: 2d 01           BLT   $9D35
9d34: 2c 01           BGE   $9D37
9d36: 2b 01           BMI   $9D39
9d38: 2a 01           BPL   $9D3B
9d3a: 29 01           BVS   $9D3D
9d3c: 28 01           BVC   $9D3F
9d3e: 27 01           BEQ   $9D41
9d40: 26 01           BNE   $9D43
9d42: 25 01           BCS   $9D45
9d44: 24 01           BCC   $9D47
9d46: 23 01           BLS   $9D49
9d48: 22 01           BHI   $9D4B
9d4a: 21 01           BRN   $9D4D
9d4c: 20 01           BRA   $9D4F
9d4e: 1f 01           TFR   D,X
9d50: 1e 01           EXG   D,X
9d52: 1d              SEX
9d53: 01 1c 01        OIM   #$1C;$01
9d56: 1b              FCB   $1B
9d57: 01 1c 01        OIM   #$1C;$01
9d5a: 1d              SEX
9d5b: 01 1e 01        OIM   #$1E;$01
9d5e: 1f 01           TFR   D,X
9d60: 20 01           BRA   $9D63
9d62: 21 01           BRN   $9D65
9d64: 22 01           BHI   $9D67
9d66: 23 01           BLS   $9D69
9d68: 24 01           BCC   $9D6B
9d6a: 25 01           BCS   $9D6D
9d6c: 26 01           BNE   $9D6F
9d6e: 27 01           BEQ   $9D71
9d70: 26 01           BNE   $9D73
9d72: 25 01           BCS   $9D75
9d74: 24 01           BCC   $9D77
9d76: 23 01           BLS   $9D79
9d78: 22 01           BHI   $9D7B
9d7a: 21 01           BRN   $9D7D
9d7c: 20 01           BRA   $9D7F
9d7e: 21 01           BRN   $9D81
9d80: 22 01           BHI   $9D83
9d82: 23 01           BLS   $9D85
9d84: 24 01           BCC   $9D87
9d86: 25 01           BCS   $9D89
9d88: 26 01           BNE   $9D8B
9d8a: 27 01           BEQ   $9D8D
9d8c: 28 01           BVC   $9D8F
9d8e: 29 01           BVS   $9D91
9d90: 2a 01           BPL   $9D93
9d92: 2b 01           BMI   $9D95
9d94: 2c 01           BGE   $9D97
9d96: 2d 01           BLT   $9D99
9d98: 2e 01           BGT   $9D9B
9d9a: 2f 01           BLE   $9D9D
9d9c: 30 01           LEAX  $1,X
9d9e: 31 01           LEAY  $1,X
9da0: 32 01           LEAS  $1,X
9da2: 33 01           LEAU  $1,X
9da4: 34 01           PSHS  CC
9da6: 35 01           PULS  CC
9da8: 36 01           PSHU  CC
9daa: 37 01           PULU  CC
9dac: 38              FCB   $38
9dad: 01 39 01        OIM   #$39;$01
9db0: 3a              ABX
9db1: 01 3b 01        OIM   #$3B;$01
9db4: 3c 01           CWAI  #$01
9db6: 3d              MUL
9db7: 01 3e 01        OIM   #$3E;$01
9dba: 3f              SWI
9dbb: 01 40 01        OIM   #$40;$01
9dbe: 41              FCB   $41
9dbf: 01 42 01        OIM   #$42;$01
9dc2: 43              COMA
9dc3: 01 44 01        OIM   #$44;$01
9dc6: 45              FCB   $45
9dc7: 01 46 01        OIM   #$46;$01
9dca: 47              ASRA
9dcb: 01 48 01        OIM   #$48;$01
9dce: 49              ROLA
9dcf: 01 48 01        OIM   #$48;$01
9dd2: 47              ASRA
9dd3: 01 46 01        OIM   #$46;$01
9dd6: 45              FCB   $45
9dd7: 01 44 01        OIM   #$44;$01
9dda: 43              COMA
9ddb: 01 42 01        OIM   #$42;$01
9dde: 41              FCB   $41
9ddf: 01 40 01        OIM   #$40;$01
9de2: 3f              SWI
9de3: 01 3e 01        OIM   #$3E;$01
9de6: 3d              MUL
9de7: 01 3e 01        OIM   #$3E;$01
9dea: 3f              SWI
9deb: 01 40 01        OIM   #$40;$01
9dee: 41              FCB   $41
9def: 01 41 01        OIM   #$41;$01
9df2: 43              COMA
9df3: 01 44 01        OIM   #$44;$01
9df6: 45              FCB   $45
9df7: 01 46 01        OIM   #$46;$01
9dfa: 47              ASRA
9dfb: 01 48 01        OIM   #$48;$01
9dfe: 49              ROLA
9dff: 01 47 01        OIM   #$47;$01
9e02: 48              ASLA
9e03: 01 49 01        OIM   #$49;$01
9e06: 85 c8           BITA  #$C8
9e08: 81 20           CMPA  #$20
9e0a: 18              FCB   $18
9e0b: 26 18           BNE   $9E25
9e0d: 23 18           BLS   $9E27
9e0f: 29 18           BVS   $9E29
9e11: 20 18           BRA   $9E2B
9e13: 26 18           BNE   $9E2D
9e15: 23 18           BLS   $9E2F
9e17: 29 18           BVS   $9E31
9e19: 20 18           BRA   $9E33
9e1b: 26 18           BNE   $9E35
9e1d: 23 18           BLS   $9E37
9e1f: 29 18           BVS   $9E39
9e21: 2c 18           BGE   $9E3B
9e23: 2b 18           BMI   $9E3D
9e25: 2a 18           BPL   $9E3F
9e27: 29 18           BVS   $9E41
9e29: 83 02 82        SUBD  #$0282
9e2c: 00 87           NEG   $87
9e2e: 85 d2           BITA  #$D2
9e30: 80 86           SUBA  #$86
9e32: 0c 1b           INC   $1B
9e34: 06 1b           ROR   $1B
9e36: 06 1b           ROR   $1B
9e38: 06 1b           ROR   $1B
9e3a: 06 1b           ROR   $1B
9e3c: 06 27           ROR   $27
9e3e: 06 1b           ROR   $1B
9e40: 06 27           ROR   $27
9e42: 06 1b           ROR   $1B
9e44: 06 1b           ROR   $1B
9e46: 06 27           ROR   $27
9e48: 06 1b           ROR   $1B
9e4a: 06 1b           ROR   $1B
9e4c: 06 27           ROR   $27
9e4e: 06 1b           ROR   $1B
9e50: 06 27           ROR   $27
9e52: 06 1b           ROR   $1B
9e54: 06 1b           ROR   $1B
9e56: 06 1b           ROR   $1B
9e58: 06 27           ROR   $27
9e5a: 06 1b           ROR   $1B
9e5c: 06 1b           ROR   $1B
9e5e: 06 27           ROR   $27
9e60: 06 1b           ROR   $1B
9e62: 06 1b           ROR   $1B
9e64: 06 1b           ROR   $1B
9e66: 06 27           ROR   $27
9e68: 06 1b           ROR   $1B
9e6a: 06 27           ROR   $27
9e6c: 06 1b           ROR   $1B
9e6e: 06 27           ROR   $27
9e70: 06 27           ROR   $27
9e72: 06 1b           ROR   $1B
9e74: 06 1b           ROR   $1B
9e76: 06 1b           ROR   $1B
9e78: 06 1b           ROR   $1B
9e7a: 06 1b           ROR   $1B
9e7c: 06 27           ROR   $27
9e7e: 06 1b           ROR   $1B
9e80: 06 27           ROR   $27
9e82: 06 1b           ROR   $1B
9e84: 06 1b           ROR   $1B
9e86: 06 27           ROR   $27
9e88: 06 1b           ROR   $1B
9e8a: 06 1b           ROR   $1B
9e8c: 06 27           ROR   $27
9e8e: 06 1b           ROR   $1B
9e90: 06 27           ROR   $27
9e92: 06 1b           ROR   $1B
9e94: 06 1b           ROR   $1B
9e96: 06 1b           ROR   $1B
9e98: 06 27           ROR   $27
9e9a: 06 1b           ROR   $1B
9e9c: 06 1b           ROR   $1B
9e9e: 06 27           ROR   $27
9ea0: 06 1b           ROR   $1B
9ea2: 06 1b           ROR   $1B
9ea4: 06 1b           ROR   $1B
9ea6: 06 27           ROR   $27
9ea8: 06 1b           ROR   $1B
9eaa: 06 27           ROR   $27
9eac: 06 1b           ROR   $1B
9eae: 06 27           ROR   $27
9eb0: 06 27           ROR   $27
9eb2: 06 86           ROR   $86
9eb4: f4 81 38        ANDB  $8138
9eb7: 06 3b           ROR   $3B
9eb9: 06 3e           ROR   $3E
9ebb: 06 38           ROR   $38
9ebd: 06 3b           ROR   $3B
9ebf: 06 3f           ROR   $3F
9ec1: 06 38           ROR   $38
9ec3: 06 3b           ROR   $3B
9ec5: 06 41           ROR   $41
9ec7: 06 38           ROR   $38
9ec9: 06 3b           ROR   $3B
9ecb: 06 3f           ROR   $3F
9ecd: 06 38           ROR   $38
9ecf: 06 3b           ROR   $3B
9ed1: 06 3e           ROR   $3E
9ed3: 06 38           ROR   $38
9ed5: 06 38           ROR   $38
9ed7: 06 3b           ROR   $3B
9ed9: 06 3e           ROR   $3E
9edb: 06 38           ROR   $38
9edd: 06 3b           ROR   $3B
9edf: 06 3f           ROR   $3F
9ee1: 06 38           ROR   $38
9ee3: 06 3b           ROR   $3B
9ee5: 06 41           ROR   $41
9ee7: 06 38           ROR   $38
9ee9: 06 3b           ROR   $3B
9eeb: 06 3f           ROR   $3F
9eed: 06 38           ROR   $38
9eef: 06 3b           ROR   $3B
9ef1: 06 3e           ROR   $3E
9ef3: 06 38           ROR   $38
9ef5: 06 38           ROR   $38
9ef7: 06 3b           ROR   $3B
9ef9: 06 3e           ROR   $3E
9efb: 06 38           ROR   $38
9efd: 06 3b           ROR   $3B
9eff: 06 3f           ROR   $3F
9f01: 06 38           ROR   $38
9f03: 06 3b           ROR   $3B
9f05: 06 41           ROR   $41
9f07: 06 38           ROR   $38
9f09: 06 3b           ROR   $3B
9f0b: 06 3f           ROR   $3F
9f0d: 06 38           ROR   $38
9f0f: 06 3b           ROR   $3B
9f11: 06 3e           ROR   $3E
9f13: 06 38           ROR   $38
9f15: 06 38           ROR   $38
9f17: 06 3b           ROR   $3B
9f19: 06 3e           ROR   $3E
9f1b: 06 38           ROR   $38
9f1d: 06 3b           ROR   $3B
9f1f: 06 3f           ROR   $3F
9f21: 06 38           ROR   $38
9f23: 06 3b           ROR   $3B
9f25: 06 41           ROR   $41
9f27: 06 38           ROR   $38
9f29: 06 3b           ROR   $3B
9f2b: 06 3f           ROR   $3F
9f2d: 06 38           ROR   $38
9f2f: 06 3b           ROR   $3B
9f31: 06 3e           ROR   $3E
9f33: 06 38           ROR   $38
9f35: 06 83           ROR   $83
9f37: 02 82 00        AIM   #$82;$00
9f3a: 87              FCB   $87
9f3b: 86 00           LDA   #$00
9f3d: 85 d2           BITA  #$D2
9f3f: 80 1b           SUBA  #$1B
9f41: 06 1b           ROR   $1B
9f43: 06 1b           ROR   $1B
9f45: 06 1b           ROR   $1B
9f47: 06 1b           ROR   $1B
9f49: 06 27           ROR   $27
9f4b: 06 1b           ROR   $1B
9f4d: 06 27           ROR   $27
9f4f: 06 1b           ROR   $1B
9f51: 06 1b           ROR   $1B
9f53: 06 27           ROR   $27
9f55: 06 1b           ROR   $1B
9f57: 06 1b           ROR   $1B
9f59: 06 27           ROR   $27
9f5b: 06 1b           ROR   $1B
9f5d: 06 27           ROR   $27
9f5f: 06 1b           ROR   $1B
9f61: 06 1b           ROR   $1B
9f63: 06 1b           ROR   $1B
9f65: 06 27           ROR   $27
9f67: 06 1b           ROR   $1B
9f69: 06 1b           ROR   $1B
9f6b: 06 27           ROR   $27
9f6d: 06 1b           ROR   $1B
9f6f: 06 1b           ROR   $1B
9f71: 06 1b           ROR   $1B
9f73: 06 27           ROR   $27
9f75: 06 1b           ROR   $1B
9f77: 06 27           ROR   $27
9f79: 06 1b           ROR   $1B
9f7b: 06 27           ROR   $27
9f7d: 06 27           ROR   $27
9f7f: 06 1b           ROR   $1B
9f81: 06 1b           ROR   $1B
9f83: 06 1b           ROR   $1B
9f85: 06 1b           ROR   $1B
9f87: 06 1b           ROR   $1B
9f89: 06 27           ROR   $27
9f8b: 06 1b           ROR   $1B
9f8d: 06 27           ROR   $27
9f8f: 06 1b           ROR   $1B
9f91: 06 1b           ROR   $1B
9f93: 06 27           ROR   $27
9f95: 06 1b           ROR   $1B
9f97: 06 1b           ROR   $1B
9f99: 06 27           ROR   $27
9f9b: 06 1b           ROR   $1B
9f9d: 06 27           ROR   $27
9f9f: 06 1b           ROR   $1B
9fa1: 06 1b           ROR   $1B
9fa3: 06 1b           ROR   $1B
9fa5: 06 27           ROR   $27
9fa7: 06 1b           ROR   $1B
9fa9: 06 1b           ROR   $1B
9fab: 06 27           ROR   $27
9fad: 06 1b           ROR   $1B
9faf: 06 1b           ROR   $1B
9fb1: 06 1b           ROR   $1B
9fb3: 06 27           ROR   $27
9fb5: 06 1b           ROR   $1B
9fb7: 06 27           ROR   $27
9fb9: 06 1b           ROR   $1B
9fbb: 06 27           ROR   $27
9fbd: 06 27           ROR   $27
9fbf: 06 81           ROR   $81
9fc1: 3b              RTI
9fc2: 06 3e           ROR   $3E
9fc4: 06 41           ROR   $41
9fc6: 06 3b           ROR   $3B
9fc8: 06 3e           ROR   $3E
9fca: 06 42           ROR   $42
9fcc: 06 3b           ROR   $3B
9fce: 06 3e           ROR   $3E
9fd0: 06 44           ROR   $44
9fd2: 06 3b           ROR   $3B
9fd4: 06 3e           ROR   $3E
9fd6: 06 42           ROR   $42
9fd8: 06 3b           ROR   $3B
9fda: 06 3e           ROR   $3E
9fdc: 06 41           ROR   $41
9fde: 06 3b           ROR   $3B
9fe0: 06 3b           ROR   $3B
9fe2: 06 3e           ROR   $3E
9fe4: 06 41           ROR   $41
9fe6: 06 3b           ROR   $3B
9fe8: 06 3e           ROR   $3E
9fea: 06 42           ROR   $42
9fec: 06 3b           ROR   $3B
9fee: 06 3e           ROR   $3E
9ff0: 06 44           ROR   $44
9ff2: 06 3b           ROR   $3B
9ff4: 06 3e           ROR   $3E
9ff6: 06 42           ROR   $42
9ff8: 06 3b           ROR   $3B
9ffa: 06 3e           ROR   $3E
9ffc: 06 41           ROR   $41
9ffe: 06 3b           ROR   $3B
a000: 06 3b           ROR   $3B
a002: 06 3e           ROR   $3E
a004: 06 41           ROR   $41
a006: 06 3b           ROR   $3B
a008: 06 3e           ROR   $3E
a00a: 06 42           ROR   $42
a00c: 06 3b           ROR   $3B
a00e: 06 3e           ROR   $3E
a010: 06 44           ROR   $44
a012: 06 3b           ROR   $3B
a014: 06 3e           ROR   $3E
a016: 06 42           ROR   $42
a018: 06 3b           ROR   $3B
a01a: 06 3e           ROR   $3E
a01c: 06 41           ROR   $41
a01e: 06 3b           ROR   $3B
a020: 06 3b           ROR   $3B
a022: 06 3e           ROR   $3E
a024: 06 41           ROR   $41
a026: 06 3b           ROR   $3B
a028: 06 3e           ROR   $3E
a02a: 06 42           ROR   $42
a02c: 06 3b           ROR   $3B
a02e: 06 3e           ROR   $3E
a030: 06 44           ROR   $44
a032: 06 3b           ROR   $3B
a034: 06 3e           ROR   $3E
a036: 06 42           ROR   $42
a038: 06 3b           ROR   $3B
a03a: 06 3e           ROR   $3E
a03c: 06 41           ROR   $41
a03e: 06 3b           ROR   $3B
a040: 06 83           ROR   $83
a042: 02 82 00        AIM   #$82;$00
a045: 87              FCB   $87
a046: 86 00           LDA   #$00
a048: 85 d2           BITA  #$D2
a04a: 80 00           SUBA  #$00
a04c: 60 00           NEG   $0,X
a04e: 60 00           NEG   $0,X
a050: 60 00           NEG   $0,X
a052: 60 81           NEG   ,X++
a054: 20 18           BRA   $A06E
a056: 26 18           BNE   $A070
a058: 23 18           BLS   $A072
a05a: 29 18           BVS   $A074
a05c: 20 18           BRA   $A076
a05e: 26 18           BNE   $A078
a060: 23 18           BLS   $A07A
a062: 29 18           BVS   $A07C
a064: 20 18           BRA   $A07E
a066: 26 18           BNE   $A080
a068: 23 18           BLS   $A082
a06a: 29 18           BVS   $A084
a06c: 2f 18           BLE   $A086
a06e: 2e 18           BGT   $A088
a070: 2d 18           BLT   $A08A
a072: 2c 18           BGE   $A08C
a074: 83 02 82        SUBD  #$0282
a077: 00 87           NEG   $87
a079: 86 0c           LDA   #$0C
a07b: 85 dc           BITA  #$DC
a07d: 80 1b           SUBA  #$1B
a07f: 06 1b           ROR   $1B
a081: 06 1b           ROR   $1B
a083: 06 1b           ROR   $1B
a085: 06 1b           ROR   $1B
a087: 06 27           ROR   $27
a089: 06 1b           ROR   $1B
a08b: 06 27           ROR   $27
a08d: 06 1b           ROR   $1B
a08f: 06 1b           ROR   $1B
a091: 06 27           ROR   $27
a093: 06 1b           ROR   $1B
a095: 06 1b           ROR   $1B
a097: 06 27           ROR   $27
a099: 06 1b           ROR   $1B
a09b: 06 27           ROR   $27
a09d: 06 1b           ROR   $1B
a09f: 06 1b           ROR   $1B
a0a1: 06 1b           ROR   $1B
a0a3: 06 27           ROR   $27
a0a5: 06 1b           ROR   $1B
a0a7: 06 1b           ROR   $1B
a0a9: 06 27           ROR   $27
a0ab: 06 1b           ROR   $1B
a0ad: 06 1b           ROR   $1B
a0af: 06 1b           ROR   $1B
a0b1: 06 27           ROR   $27
a0b3: 06 1b           ROR   $1B
a0b5: 06 27           ROR   $27
a0b7: 06 1b           ROR   $1B
a0b9: 06 27           ROR   $27
a0bb: 06 27           ROR   $27
a0bd: 06 1b           ROR   $1B
a0bf: 06 1b           ROR   $1B
a0c1: 06 1b           ROR   $1B
a0c3: 06 1b           ROR   $1B
a0c5: 06 1b           ROR   $1B
a0c7: 06 27           ROR   $27
a0c9: 06 1b           ROR   $1B
a0cb: 06 27           ROR   $27
a0cd: 06 1b           ROR   $1B
a0cf: 06 1b           ROR   $1B
a0d1: 06 27           ROR   $27
a0d3: 06 1b           ROR   $1B
a0d5: 06 1b           ROR   $1B
a0d7: 06 27           ROR   $27
a0d9: 06 1b           ROR   $1B
a0db: 06 27           ROR   $27
a0dd: 06 1b           ROR   $1B
a0df: 06 1b           ROR   $1B
a0e1: 06 1b           ROR   $1B
a0e3: 06 27           ROR   $27
a0e5: 06 1b           ROR   $1B
a0e7: 06 1b           ROR   $1B
a0e9: 06 27           ROR   $27
a0eb: 06 1b           ROR   $1B
a0ed: 06 1b           ROR   $1B
a0ef: 06 1b           ROR   $1B
a0f1: 06 27           ROR   $27
a0f3: 06 1b           ROR   $1B
a0f5: 06 27           ROR   $27
a0f7: 06 1b           ROR   $1B
a0f9: 06 27           ROR   $27
a0fb: 06 27           ROR   $27
a0fd: 06 81           ROR   $81
a0ff: 00 60           NEG   $60
a101: 00 60           NEG   $60
a103: 00 60           NEG   $60
a105: 00 60           NEG   $60
a107: 83 02 82        SUBD  #$0282
a10a: 00 87           NEG   $87
a10c: 86 00           LDA   #$00
a10e: 85 d2           BITA  #$D2
a110: 80 00           SUBA  #$00
a112: 60 00           NEG   $0,X
a114: 60 00           NEG   $0,X
a116: 60 00           NEG   $0,X
a118: 30 00           LEAX  $0,X
a11a: 18              FCB   $18
a11b: 29 06           BVS   $A123
a11d: 29 06           BVS   $A125
a11f: 29 06           BVS   $A127
a121: 29 06           BVS   $A129
a123: 81 00           CMPA  #$00
a125: 60 00           NEG   $0,X
a127: 60 00           NEG   $0,X
a129: 60 00           NEG   $0,X
a12b: 60 83           NEG   ,--X
a12d: 02 82 00        AIM   #$82;$00
a130: 87              FCB   $87
a131: 81 f4           CMPA  #$F4
a133: a1 37           CMPA  -$9,Y
a135: de 9c           LDU   $9C
a137: 86 01           LDA   #$01
a139: 85 ff           BITA  #$FF
a13b: 31 06           LEAY  $6,X
a13d: 35 06           PULS  A,B
a13f: 38              FCB   $38
a140: 06 3c           ROR   $3C
a142: 06 3f           ROR   $3F
a144: 06 87           ROR   $87
a146: 87              FCB   $87
a147: 02 eb a1        AIM   #$EB;$A1
a14a: 51              FCB   $51
a14b: da 6b           ORB   $6B
a14d: a1 dd dc 27     CMPA  [$7D78,PCR]
a151: 86 00           LDA   #$00
a153: 85 f0           BITA  #$F0
a155: 80 22           SUBA  #$22
a157: 06 22           ROR   $22
a159: 06 22           ROR   $22
a15b: 06 28           ROR   $28
a15d: 06 22           ROR   $22
a15f: 06 27           ROR   $27
a161: 06 2c           ROR   $2C
a163: 06 28           ROR   $28
a165: 06 22           ROR   $22
a167: 06 22           ROR   $22
a169: 06 28           ROR   $28
a16b: 06 27           ROR   $27
a16d: 06 2c           ROR   $2C
a16f: 06 28           ROR   $28
a171: 06 22           ROR   $22
a173: 06 27           ROR   $27
a175: 06 27           ROR   $27
a177: 06 22           ROR   $22
a179: 06 2a           ROR   $2A
a17b: 06 27           ROR   $27
a17d: 06 28           ROR   $28
a17f: 06 25           ROR   $25
a181: 06 28           ROR   $28
a183: 06 2a           ROR   $2A
a185: 06 25           ROR   $25
a187: 06 28           ROR   $28
a189: 06 22           ROR   $22
a18b: 06 25           ROR   $25
a18d: 06 2a           ROR   $2A
a18f: 06 22           ROR   $22
a191: 06 22           ROR   $22
a193: 06 25           ROR   $25
a195: 06 28           ROR   $28
a197: 06 28           ROR   $28
a199: 06 22           ROR   $22
a19b: 06 25           ROR   $25
a19d: 06 28           ROR   $28
a19f: 06 2a           ROR   $2A
a1a1: 06 2a           ROR   $2A
a1a3: 06 22           ROR   $22
a1a5: 06 22           ROR   $22
a1a7: 06 22           ROR   $22
a1a9: 06 25           ROR   $25
a1ab: 06 28           ROR   $28
a1ad: 06 25           ROR   $25
a1af: 06 2a           ROR   $2A
a1b1: 06 28           ROR   $28
a1b3: 06 27           ROR   $27
a1b5: 06 31           ROR   $31
a1b7: 06 2e           ROR   $2E
a1b9: 06 2c           ROR   $2C
a1bb: 06 2e           ROR   $2E
a1bd: 06 2c           ROR   $2C
a1bf: 06 28           ROR   $28
a1c1: 06 27           ROR   $27
a1c3: 06 2c           ROR   $2C
a1c5: 06 28           ROR   $28
a1c7: 06 2c           ROR   $2C
a1c9: 06 27           ROR   $27
a1cb: 06 25           ROR   $25
a1cd: 06 28           ROR   $28
a1cf: 06 27           ROR   $27
a1d1: 06 25           ROR   $25
a1d3: 06 24           ROR   $24
a1d5: 06 82           ROR   $82
a1d7: 02 22 30        AIM   #$22;$30
a1da: 00 30           NEG   $30
a1dc: 87              FCB   $87
a1dd: 86 00           LDA   #$00
a1df: 85 dc           BITA  #$DC
a1e1: 80 22           SUBA  #$22
a1e3: 06 22           ROR   $22
a1e5: 06 22           ROR   $22
a1e7: 06 28           ROR   $28
a1e9: 06 22           ROR   $22
a1eb: 06 27           ROR   $27
a1ed: 06 2c           ROR   $2C
a1ef: 06 28           ROR   $28
a1f1: 06 22           ROR   $22
a1f3: 06 22           ROR   $22
a1f5: 06 28           ROR   $28
a1f7: 06 27           ROR   $27
a1f9: 06 2c           ROR   $2C
a1fb: 06 28           ROR   $28
a1fd: 06 22           ROR   $22
a1ff: 06 27           ROR   $27
a201: 06 27           ROR   $27
a203: 06 22           ROR   $22
a205: 06 2a           ROR   $2A
a207: 06 27           ROR   $27
a209: 06 28           ROR   $28
a20b: 06 25           ROR   $25
a20d: 06 28           ROR   $28
a20f: 06 2a           ROR   $2A
a211: 06 25           ROR   $25
a213: 06 28           ROR   $28
a215: 06 22           ROR   $22
a217: 06 25           ROR   $25
a219: 06 2a           ROR   $2A
a21b: 06 22           ROR   $22
a21d: 06 22           ROR   $22
a21f: 06 25           ROR   $25
a221: 06 28           ROR   $28
a223: 06 28           ROR   $28
a225: 06 22           ROR   $22
a227: 06 25           ROR   $25
a229: 06 28           ROR   $28
a22b: 06 2a           ROR   $2A
a22d: 06 2a           ROR   $2A
a22f: 06 22           ROR   $22
a231: 06 22           ROR   $22
a233: 06 22           ROR   $22
a235: 06 25           ROR   $25
a237: 06 28           ROR   $28
a239: 06 25           ROR   $25
a23b: 06 2a           ROR   $2A
a23d: 06 28           ROR   $28
a23f: 06 27           ROR   $27
a241: 06 31           ROR   $31
a243: 06 2e           ROR   $2E
a245: 06 2c           ROR   $2C
a247: 06 2e           ROR   $2E
a249: 06 2c           ROR   $2C
a24b: 06 28           ROR   $28
a24d: 06 27           ROR   $27
a24f: 06 2c           ROR   $2C
a251: 06 28           ROR   $28
a253: 06 2c           ROR   $2C
a255: 06 27           ROR   $27
a257: 06 25           ROR   $25
a259: 06 28           ROR   $28
a25b: 06 27           ROR   $27
a25d: 06 25           ROR   $25
a25f: 06 24           ROR   $24
a261: 06 82           ROR   $82
a263: 02 22 30        AIM   #$22;$30
a266: 00 30           NEG   $30
a268: 87              FCB   $87
a269: 05 e6 a2        EIM   #$E6;$A2
a26c: 7f da da        CLR   $DADA
a26f: a3 41           SUBD  $1,U
a271: da da           ORB   $DA
a273: a3 e7           SUBD  E,S
a275: da da           ORB   $DA
a277: a4 59           ANDA  -$7,U
a279: da da           ORB   $DA
a27b: a4 e5           ANDA  B,S
a27d: da da           ORB   $DA
a27f: 86 f4           LDA   #$F4
a281: 85 d2           BITA  #$D2
a283: 31 60           LEAY  $0,S
a285: 80 3f           SUBA  #$3F
a287: 0c 3d           INC   $3D
a289: 0c 3f           INC   $3F
a28b: 0c 44           INC   $44
a28d: 0c 3f           INC   $3F
a28f: 0c 3d           INC   $3D
a291: 0c 3f           INC   $3F
a293: 0c 3d           INC   $3D
a295: 0c 3c           INC   $3C
a297: 0c 3a           INC   $3A
a299: 0c 3c           INC   $3C
a29b: 0c 3d           INC   $3D
a29d: 0c 3f           INC   $3F
a29f: 0c 41           INC   $41
a2a1: 0c 42           INC   $42
a2a3: 0c 44           INC   $44
a2a5: 0c 46           INC   $46
a2a7: 0c 42           INC   $42
a2a9: 0c 3f           INC   $3F
a2ab: 0c 3d           INC   $3D
a2ad: 0c 3c           INC   $3C
a2af: 0c 3a           INC   $3A
a2b1: 0c 3c           INC   $3C
a2b3: 0c 3d           INC   $3D
a2b5: 0c 3f           INC   $3F
a2b7: 0c 41           INC   $41
a2b9: 0c 42           INC   $42
a2bb: 0c 3d           INC   $3D
a2bd: 0c 3f           INC   $3F
a2bf: 0c 3c           INC   $3C
a2c1: 0c 3a           INC   $3A
a2c3: 0c 38           INC   $38
a2c5: 0c 3f           INC   $3F
a2c7: 0c 3d           INC   $3D
a2c9: 0c 3f           INC   $3F
a2cb: 0c 44           INC   $44
a2cd: 0c 3f           INC   $3F
a2cf: 0c 3d           INC   $3D
a2d1: 0c 3f           INC   $3F
a2d3: 0c 3d           INC   $3D
a2d5: 0c 3c           INC   $3C
a2d7: 0c 3a           INC   $3A
a2d9: 0c 3c           INC   $3C
a2db: 0c 3d           INC   $3D
a2dd: 0c 3f           INC   $3F
a2df: 0c 41           INC   $41
a2e1: 0c 42           INC   $42
a2e3: 0c 44           INC   $44
a2e5: 0c 46           INC   $46
a2e7: 0c 42           INC   $42
a2e9: 0c 3f           INC   $3F
a2eb: 0c 3d           INC   $3D
a2ed: 0c 3c           INC   $3C
a2ef: 0c 3a           INC   $3A
a2f1: 0c 3c           INC   $3C
a2f3: 0c 3d           INC   $3D
a2f5: 0c 3f           INC   $3F
a2f7: 0c 41           INC   $41
a2f9: 0c 42           INC   $42
a2fb: 0c 3d           INC   $3D
a2fd: 0c 3f           INC   $3F
a2ff: 0c 3c           INC   $3C
a301: 0c 3a           INC   $3A
a303: 0c 38           INC   $38
a305: 0c 41           INC   $41
a307: 0c 3a           INC   $3A
a309: 0c 3d           INC   $3D
a30b: 0c 3f           INC   $3F
a30d: 0c 41           INC   $41
a30f: 0c 3f           INC   $3F
a311: 0c 44           INC   $44
a313: 0c 42           INC   $42
a315: 0c 41           INC   $41
a317: 0c 42           INC   $42
a319: 0c 44           INC   $44
a31b: 0c 41           INC   $41
a31d: 0c 3f           INC   $3F
a31f: 0c 41           INC   $41
a321: 0c 3d           INC   $3D
a323: 0c 3c           INC   $3C
a325: 0c 3a           INC   $3A
a327: 18              FCB   $18
a328: 41              FCB   $41
a329: 18              FCB   $18
a32a: 3d              MUL
a32b: 0c 44           INC   $44
a32d: 18              FCB   $18
a32e: 3d              MUL
a32f: 0c 3a           INC   $3A
a331: 18              FCB   $18
a332: 41              FCB   $41
a333: 18              FCB   $18
a334: 42              FCB   $42
a335: 0c 44           INC   $44
a337: 0c 46           INC   $46
a339: 0c 48           INC   $48
a33b: 0c 82           INC   $82
a33d: 02 49 60        AIM   #$49;$60
a340: 87              FCB   $87
a341: 86 f4           LDA   #$F4
a343: 85 be           BITA  #$BE
a345: 2e 60           BGT   $A3A7
a347: 80 38           SUBA  #$38
a349: 0c 35           INC   $35
a34b: 0c 3d           INC   $3D
a34d: 0c 35           INC   $35
a34f: 0c 38           INC   $38
a351: 0c 35           INC   $35
a353: 0c 31           INC   $31
a355: 0c 33           INC   $33
a357: 0c 38           INC   $38
a359: 0c 35           INC   $35
a35b: 0c 31           INC   $31
a35d: 0c 35           INC   $35
a35f: 0c 38           INC   $38
a361: 0c 35           INC   $35
a363: 0c 3a           INC   $3A
a365: 0c 35           INC   $35
a367: 0c 36           INC   $36
a369: 0c 31           INC   $31
a36b: 0c 36           INC   $36
a36d: 0c 31           INC   $31
a36f: 0c 36           INC   $36
a371: 0c 31           INC   $31
a373: 0c 3a           INC   $3A
a375: 0c 36           INC   $36
a377: 0c 38           INC   $38
a379: 60 38           NEG   -$8,Y
a37b: 0c 35           INC   $35
a37d: 0c 3d           INC   $3D
a37f: 0c 35           INC   $35
a381: 0c 38           INC   $38
a383: 0c 35           INC   $35
a385: 0c 31           INC   $31
a387: 0c 33           INC   $33
a389: 0c 38           INC   $38
a38b: 0c 35           INC   $35
a38d: 0c 31           INC   $31
a38f: 0c 35           INC   $35
a391: 0c 38           INC   $38
a393: 0c 35           INC   $35
a395: 0c 3a           INC   $3A
a397: 0c 35           INC   $35
a399: 0c 36           INC   $36
a39b: 0c 31           INC   $31
a39d: 0c 36           INC   $36
a39f: 0c 31           INC   $31
a3a1: 0c 36           INC   $36
a3a3: 0c 31           INC   $31
a3a5: 0c 3a           INC   $3A
a3a7: 0c 36           INC   $36
a3a9: 0c 38           INC   $38
a3ab: 60 35           NEG   -$B,Y
a3ad: 0c 3a           INC   $3A
a3af: 0c 3d           INC   $3D
a3b1: 0c 35           INC   $35
a3b3: 0c 3a           INC   $3A
a3b5: 0c 3d           INC   $3D
a3b7: 0c 35           INC   $35
a3b9: 0c 3a           INC   $3A
a3bb: 0c 33           INC   $33
a3bd: 0c 38           INC   $38
a3bf: 0c 3c           INC   $3C
a3c1: 0c 33           INC   $33
a3c3: 0c 38           INC   $38
a3c5: 0c 3c           INC   $3C
a3c7: 0c 33           INC   $33
a3c9: 0c 38           INC   $38
a3cb: 0c 36           INC   $36
a3cd: 18              FCB   $18
a3ce: 3d              MUL
a3cf: 18              FCB   $18
a3d0: 3a              ABX
a3d1: 0c 41           INC   $41
a3d3: 18              FCB   $18
a3d4: 3d              MUL
a3d5: 0c 36           INC   $36
a3d7: 18              FCB   $18
a3d8: 3d              MUL
a3d9: 18              FCB   $18
a3da: 3d              MUL
a3db: 0c 3c           INC   $3C
a3dd: 0c 3a           INC   $3A
a3df: 0c 38           INC   $38
a3e1: 0c 82           INC   $82
a3e3: 02 3a 60        AIM   #$3A;$60
a3e6: 87              FCB   $87
a3e7: 86 f4           LDA   #$F4
a3e9: 85 d2           BITA  #$D2
a3eb: 2a 48           BPL   $A435
a3ed: 30 18           LEAX  -$8,X
a3ef: 80 00           SUBA  #$00
a3f1: 60 00           NEG   $0,X
a3f3: 60 00           NEG   $0,X
a3f5: 60 86           NEG   A,X
a3f7: 0c 85           INC   $85
a3f9: be 00 30        LDX   >$0030
a3fc: 00 18           NEG   $18
a3fe: 36 06           PSHU  B,A
a400: 38              FCB   $38
a401: 06 3a           ROR   $3A
a403: 06 3c           ROR   $3C
a405: 06 3d           ROR   $3D
a407: 54              LSRB
a408: 3f              SWI
a409: 0c 3c           INC   $3C
a40b: 24 3a           BCC   $A447
a40d: 24 3d           BCC   $A44C
a40f: 0c 3f           INC   $3F
a411: 0c 41           INC   $41
a413: 30 42           LEAX  $2,U
a415: 30 46           LEAX  $6,U
a417: 24 44           BCC   $A45D
a419: 3c 41           CWAI  #$41
a41b: 0c 3a           INC   $3A
a41d: 0c 3d           INC   $3D
a41f: 0c 3f           INC   $3F
a421: 0c 41           INC   $41
a423: 0c 3f           INC   $3F
a425: 0c 44           INC   $44
a427: 0c 42           INC   $42
a429: 0c 41           INC   $41
a42b: 0c 42           INC   $42
a42d: 0c 44           INC   $44
a42f: 0c 41           INC   $41
a431: 0c 3f           INC   $3F
a433: 0c 41           INC   $41
a435: 0c 3d           INC   $3D
a437: 0c 3c           INC   $3C
a439: 0c 3a           INC   $3A
a43b: 18              FCB   $18
a43c: 41              FCB   $41
a43d: 18              FCB   $18
a43e: 3d              MUL
a43f: 0c 44           INC   $44
a441: 18              FCB   $18
a442: 3d              MUL
a443: 0c 3a           INC   $3A
a445: 18              FCB   $18
a446: 41              FCB   $41
a447: 18              FCB   $18
a448: 42              FCB   $42
a449: 0c 44           INC   $44
a44b: 0c 46           INC   $46
a44d: 0c 48           INC   $48
a44f: 0c 86           INC   $86
a451: f4 82 02        ANDB  $8202
a454: 86 0c           LDA   #$0C
a456: 41              FCB   $41
a457: 60 87           NEG   E,X
a459: 86 f4           LDA   #$F4
a45b: 85 d2           BITA  #$D2
a45d: 35 18           PULS  DP,X
a45f: 38              FCB   $38
a460: 18              FCB   $18
a461: 36 18           PSHU  X,DP
a463: 33 18           LEAU  -$8,X
a465: 80 00           SUBA  #$00
a467: 18              FCB   $18
a468: 2c 18           BGE   $A482
a46a: 31 18           LEAY  -$8,X
a46c: 2c 0c           BGE   $A47A
a46e: 2d 0c           BLT   $A47C
a470: 2e 18           BGT   $A48A
a472: 30 18           LEAX  -$8,X
a474: 31 18           LEAY  -$8,X
a476: 35 18           PULS  DP,X
a478: 36 0c           PSHU  DP,B
a47a: 35 0c           PULS  B,DP
a47c: 33 0c           LEAU  $C,X
a47e: 31 24           LEAY  $4,Y
a480: 30 0c           LEAX  $C,X
a482: 31 0c           LEAY  $C,X
a484: 2e 0c           BGT   $A492
a486: 2c 54           BGE   $A4DC
a488: 00 18           NEG   $18
a48a: 2c 18           BGE   $A4A4
a48c: 31 18           LEAY  -$8,X
a48e: 2c 0c           BGE   $A49C
a490: 2d 0c           BLT   $A49E
a492: 2e 18           BGT   $A4AC
a494: 30 18           LEAX  -$8,X
a496: 31 18           LEAY  -$8,X
a498: 35 18           PULS  DP,X
a49a: 36 0c           PSHU  DP,B
a49c: 35 0c           PULS  B,DP
a49e: 33 0c           LEAU  $C,X
a4a0: 31 24           LEAY  $4,Y
a4a2: 30 0c           LEAX  $C,X
a4a4: 31 0c           LEAY  $C,X
a4a6: 2e 0c           BGT   $A4B4
a4a8: 2c 54           BGE   $A4FE
a4aa: 31 0c           LEAY  $C,X
a4ac: 35 0c           PULS  B,DP
a4ae: 2e 0c           BGT   $A4BC
a4b0: 31 0c           LEAY  $C,X
a4b2: 35 0c           PULS  B,DP
a4b4: 31 0c           LEAY  $C,X
a4b6: 2e 0c           BGT   $A4C4
a4b8: 31 0c           LEAY  $C,X
a4ba: 33 0c           LEAU  $C,X
a4bc: 38              FCB   $38
a4bd: 0c 27           INC   $27
a4bf: 0c 3c           INC   $3C
a4c1: 0c 33           INC   $33
a4c3: 0c 3c           INC   $3C
a4c5: 0c 2c           INC   $2C
a4c7: 0c 3c           INC   $3C
a4c9: 0c 33           INC   $33
a4cb: 18              FCB   $18
a4cc: 3a              ABX
a4cd: 18              FCB   $18
a4ce: 36 0c           PSHU  DP,B
a4d0: 3d              MUL
a4d1: 18              FCB   $18
a4d2: 3a              ABX
a4d3: 0c 33           INC   $33
a4d5: 18              FCB   $18
a4d6: 3a              ABX
a4d7: 18              FCB   $18
a4d8: 33 0c           LEAU  $C,X
a4da: 35 0c           PULS  B,DP
a4dc: 36 0c           PSHU  DP,B
a4de: 38              FCB   $38
a4df: 0c 82           INC   $82
a4e1: 02 31 60        AIM   #$31;$60
a4e4: 87              FCB   $87
a4e5: 86 f4           LDA   #$F4
a4e7: 85 d2           BITA  #$D2
a4e9: 20 60           BRA   $A54B
a4eb: 80 25           SUBA  #$25
a4ed: 48              ASLA
a4ee: 19              DAA
a4ef: 0c 24           INC   $24
a4f1: 0c 22           INC   $22
a4f3: 48              ASLA
a4f4: 22 0c           BHI   $A502
a4f6: 20 0c           BRA   $A504
a4f8: 1e 48           EXG   S,A
a4fa: 1e 0c           EXG   D,0
a4fc: 22 0c           BHI   $A50A
a4fe: 20 18           BRA   $A518
a500: 22 18           BHI   $A51A
a502: 24 18           BCC   $A51C
a504: 20 18           BRA   $A51E
a506: 25 48           BCS   $A550
a508: 19              DAA
a509: 0c 24           INC   $24
a50b: 0c 22           INC   $22
a50d: 48              ASLA
a50e: 22 0c           BHI   $A51C
a510: 20 0c           BRA   $A51E
a512: 1e 48           EXG   S,A
a514: 1e 0c           EXG   D,0
a516: 22 0c           BHI   $A524
a518: 20 18           BRA   $A532
a51a: 22 18           BHI   $A534
a51c: 24 18           BCC   $A536
a51e: 25 18           BCS   $A538
a520: 1e 0c           EXG   D,0
a522: 1e 0c           EXG   D,0
a524: 1e 0c           EXG   D,0
a526: 1e 0c           EXG   D,0
a528: 1e 0c           EXG   D,0
a52a: 1e 0c           EXG   D,0
a52c: 1e 18           EXG   X,A
a52e: 1d              SEX
a52f: 0c 1d           INC   $1D
a531: 0c 1d           INC   $1D
a533: 0c 1d           INC   $1D
a535: 0c 1d           INC   $1D
a537: 0c 1d           INC   $1D
a539: 0c 1d           INC   $1D
a53b: 18              FCB   $18
a53c: 27 0c           BEQ   $A54A
a53e: 27 0c           BEQ   $A54C
a540: 25 0c           BCS   $A54E
a542: 25 0c           BCS   $A550
a544: 22 0c           BHI   $A552
a546: 20 18           BRA   $A560
a548: 22 0c           BHI   $A556
a54a: 20 0c           BRA   $A558
a54c: 20 0c           BRA   $A55A
a54e: 1e 0c           EXG   D,0
a550: 1e 0c           EXG   D,0
a552: 20 0c           BRA   $A560
a554: 22 0c           BHI   $A562
a556: 24 0c           BCC   $A564
a558: 20 0c           BRA   $A566
a55a: 82 02           SBCA  #$02
a55c: 25 60           BCS   $A5BE
a55e: 87              FCB   $87
a55f: 07 ec           ASR   $EC
a561: a5 7d           BITA  -$3,S
a563: da 90           ORB   $90
a565: a6 76           LDA   -$A,S
a567: dc 27           LDD   $27
a569: a8 ab           EORA  D,Y
a56b: dc 27           LDD   $27
a56d: aa c4           ORA   ,U
a56f: dc 27           LDD   $27
a571: ab ce           ADDA  W,U
a573: dc 27           LDD   $27
a575: ac 7c           CMPX  -$4,S
a577: de 52           LDU   $52
a579: af 2e           STX   $E,Y
a57b: de 77           LDU   $77
a57d: 86 00           LDA   #$00
a57f: 85 f0           BITA  #$F0
a581: 00 60           NEG   $60
a583: 00 60           NEG   $60
a585: 20 12           BRA   $A599
a587: 20 06           BRA   $A58F
a589: 00 30           NEG   $30
a58b: 00 12           NEG   $12
a58d: 1e 06           EXG   D,W
a58f: 20 12           BRA   $A5A3
a591: 20 06           BRA   $A599
a593: 00 48           NEG   $48
a595: 20 12           BRA   $A5A9
a597: 20 06           BRA   $A59F
a599: 00 30           NEG   $30
a59b: 2a 06           BPL   $A5A3
a59d: 2c 06           BGE   $A5A5
a59f: 00 06           NEG   $06
a5a1: 1e 06           EXG   D,W
a5a3: 20 12           BRA   $A5B7
a5a5: 20 06           BRA   $A5AD
a5a7: 00 48           NEG   $48
a5a9: 80 81           SUBA  #$81
a5ab: 20 12           BRA   $A5BF
a5ad: 20 06           BRA   $A5B5
a5af: 00 30           NEG   $30
a5b1: 00 12           NEG   $12
a5b3: 1e 06           EXG   D,W
a5b5: 20 12           BRA   $A5C9
a5b7: 20 06           BRA   $A5BF
a5b9: 00 48           NEG   $48
a5bb: 20 12           BRA   $A5CF
a5bd: 20 06           BRA   $A5C5
a5bf: 00 30           NEG   $30
a5c1: 00 12           NEG   $12
a5c3: 1e 06           EXG   D,W
a5c5: 20 12           BRA   $A5D9
a5c7: 20 06           BRA   $A5CF
a5c9: 00 48           NEG   $48
a5cb: 83 02 20        SUBD  #$0220
a5ce: 12              NOP
a5cf: 20 06           BRA   $A5D7
a5d1: 00 30           NEG   $30
a5d3: 00 12           NEG   $12
a5d5: 1e 06           EXG   D,W
a5d7: 20 12           BRA   $A5EB
a5d9: 20 06           BRA   $A5E1
a5db: 00 48           NEG   $48
a5dd: 20 12           BRA   $A5F1
a5df: 20 06           BRA   $A5E7
a5e1: 00 30           NEG   $30
a5e3: 00 12           NEG   $12
a5e5: 1e 06           EXG   D,W
a5e7: 20 12           BRA   $A5FB
a5e9: 20 06           BRA   $A5F1
a5eb: 00 48           NEG   $48
a5ed: 20 12           BRA   $A601
a5ef: 20 06           BRA   $A5F7
a5f1: 00 30           NEG   $30
a5f3: 00 12           NEG   $12
a5f5: 1e 06           EXG   D,W
a5f7: 20 12           BRA   $A60B
a5f9: 20 06           BRA   $A601
a5fb: 00 48           NEG   $48
a5fd: 20 12           BRA   $A611
a5ff: 20 06           BRA   $A607
a601: 00 30           NEG   $30
a603: 00 12           NEG   $12
a605: 1e 06           EXG   D,W
a607: 20 12           BRA   $A61B
a609: 20 06           BRA   $A611
a60b: 00 48           NEG   $48
a60d: 20 18           BRA   $A627
a60f: 22 18           BHI   $A629
a611: 23 18           BLS   $A62B
a613: 25 12           BCS   $A627
a615: 27 06           BEQ   $A61D
a617: 00 06           NEG   $06
a619: 27 06           BEQ   $A621
a61b: 27 06           BEQ   $A623
a61d: 00 06           NEG   $06
a61f: 27 06           BEQ   $A627
a621: 00 06           NEG   $06
a623: 25 06           BCS   $A62B
a625: 00 06           NEG   $06
a627: 27 12           BEQ   $A63B
a629: 27 06           BEQ   $A631
a62b: 00 18           NEG   $18
a62d: 20 18           BRA   $A647
a62f: 22 18           BHI   $A649
a631: 23 18           BLS   $A64B
a633: 25 12           BCS   $A647
a635: 27 06           BEQ   $A63D
a637: 00 06           NEG   $06
a639: 27 06           BEQ   $A641
a63b: 27 06           BEQ   $A643
a63d: 00 06           NEG   $06
a63f: 27 06           BEQ   $A647
a641: 00 06           NEG   $06
a643: 25 06           BCS   $A64B
a645: 00 06           NEG   $06
a647: 27 12           BEQ   $A65B
a649: 27 06           BEQ   $A651
a64b: 00 18           NEG   $18
a64d: 20 18           BRA   $A667
a64f: 22 18           BHI   $A669
a651: 23 18           BLS   $A66B
a653: 25 12           BCS   $A667
a655: 27 66           BEQ   $A6BD
a657: 00 06           NEG   $06
a659: 33 06           LEAU  $6,X
a65b: 31 06           LEAY  $6,X
a65d: 2e 06           BGT   $A665
a65f: 2c 06           BGE   $A667
a661: 2a 06           BPL   $A669
a663: 27 06           BEQ   $A66B
a665: 26 06           BNE   $A66D
a667: 25 06           BCS   $A66F
a669: 23 06           BLS   $A671
a66b: 22 06           BHI   $A673
a66d: 20 06           BRA   $A675
a66f: 1e 06           EXG   D,W
a671: 1f 12           TFR   X,Y
a673: 82 00           SBCA  #$00
a675: 87              FCB   $87
a676: 86 00           LDA   #$00
a678: 85 d2           BITA  #$D2
a67a: 39              RTS
a67b: 08 39           ASL   $39
a67d: 08 39           ASL   $39
a67f: 08 39           ASL   $39
a681: 08 39           ASL   $39
a683: 08 39           ASL   $39
a685: 08 39           ASL   $39
a687: 08 39           ASL   $39
a689: 08 39           ASL   $39
a68b: 08 39           ASL   $39
a68d: 08 39           ASL   $39
a68f: 08 39           ASL   $39
a691: 08 39           ASL   $39
a693: 08 39           ASL   $39
a695: 08 39           ASL   $39
a697: 08 39           ASL   $39
a699: 08 39           ASL   $39
a69b: 08 39           ASL   $39
a69d: 08 00           ASL   $00
a69f: 30 00           LEAX  $0,X
a6a1: 60 00           NEG   $0,X
a6a3: 60 00           NEG   $0,X
a6a5: 60 00           NEG   $0,X
a6a7: 60 80           NEG   ,X+
a6a9: 84 dd           ANDA  #$DD
a6ab: 74 85 be        LSR   $85BE
a6ae: 81 00           CMPA  #$00
a6b0: 06 38           ROR   $38
a6b2: 06 36           ROR   $36
a6b4: 06 00           ROR   $00
a6b6: 06 38           ROR   $38
a6b8: 06 00           ROR   $00
a6ba: 06 36           ROR   $36
a6bc: 06 00           ROR   $00
a6be: 06 38           ROR   $38
a6c0: 06 00           ROR   $00
a6c2: 06 36           ROR   $36
a6c4: 06 00           ROR   $00
a6c6: 06 38           ROR   $38
a6c8: 06 36           ROR   $36
a6ca: 06 36           ROR   $36
a6cc: 06 38           ROR   $38
a6ce: 06 00           ROR   $00
a6d0: 06 38           ROR   $38
a6d2: 06 36           ROR   $36
a6d4: 06 00           ROR   $00
a6d6: 06 38           ROR   $38
a6d8: 06 00           ROR   $00
a6da: 06 36           ROR   $36
a6dc: 06 00           ROR   $00
a6de: 06 38           ROR   $38
a6e0: 06 00           ROR   $00
a6e2: 06 36           ROR   $36
a6e4: 06 00           ROR   $00
a6e6: 06 38           ROR   $38
a6e8: 06 36           ROR   $36
a6ea: 06 3a           ROR   $3A
a6ec: 06 38           ROR   $38
a6ee: 06 00           ROR   $00
a6f0: 06 38           ROR   $38
a6f2: 06 36           ROR   $36
a6f4: 06 00           ROR   $00
a6f6: 06 38           ROR   $38
a6f8: 06 00           ROR   $00
a6fa: 06 36           ROR   $36
a6fc: 06 00           ROR   $00
a6fe: 06 38           ROR   $38
a700: 06 00           ROR   $00
a702: 06 36           ROR   $36
a704: 06 00           ROR   $00
a706: 06 38           ROR   $38
a708: 06 36           ROR   $36
a70a: 06 36           ROR   $36
a70c: 06 38           ROR   $38
a70e: 06 00           ROR   $00
a710: 06 38           ROR   $38
a712: 06 36           ROR   $36
a714: 06 00           ROR   $00
a716: 06 38           ROR   $38
a718: 06 00           ROR   $00
a71a: 06 36           ROR   $36
a71c: 06 00           ROR   $00
a71e: 06 38           ROR   $38
a720: 06 00           ROR   $00
a722: 06 36           ROR   $36
a724: 06 00           ROR   $00
a726: 06 38           ROR   $38
a728: 06 36           ROR   $36
a72a: 06 3a           ROR   $3A
a72c: 06 38           ROR   $38
a72e: 06 83           ROR   $83
a730: 02 36 06        AIM   #$36;$06
a733: 36 06           PSHU  B,A
a735: 36 06           PSHU  B,A
a737: 36 06           PSHU  B,A
a739: 36 06           PSHU  B,A
a73b: 36 06           PSHU  B,A
a73d: 36 06           PSHU  B,A
a73f: 36 06           PSHU  B,A
a741: 35 06           PULS  A,B
a743: 35 06           PULS  A,B
a745: 35 06           PULS  A,B
a747: 35 06           PULS  A,B
a749: 35 06           PULS  A,B
a74b: 35 06           PULS  A,B
a74d: 35 06           PULS  A,B
a74f: 35 06           PULS  A,B
a751: 34 06           PSHS  B,A
a753: 34 06           PSHS  B,A
a755: 34 06           PSHS  B,A
a757: 34 06           PSHS  B,A
a759: 34 06           PSHS  B,A
a75b: 34 06           PSHS  B,A
a75d: 34 06           PSHS  B,A
a75f: 34 06           PSHS  B,A
a761: 33 06           LEAU  $6,X
a763: 33 06           LEAU  $6,X
a765: 33 06           LEAU  $6,X
a767: 33 06           LEAU  $6,X
a769: 33 06           LEAU  $6,X
a76b: 33 06           LEAU  $6,X
a76d: 33 06           LEAU  $6,X
a76f: 33 06           LEAU  $6,X
a771: 38              FCB   $38
a772: 06 38           ROR   $38
a774: 06 38           ROR   $38
a776: 06 38           ROR   $38
a778: 06 38           ROR   $38
a77a: 06 38           ROR   $38
a77c: 06 38           ROR   $38
a77e: 06 38           ROR   $38
a780: 06 39           ROR   $39
a782: 06 39           ROR   $39
a784: 06 39           ROR   $39
a786: 06 39           ROR   $39
a788: 06 39           ROR   $39
a78a: 06 39           ROR   $39
a78c: 06 39           ROR   $39
a78e: 06 39           ROR   $39
a790: 06 36           ROR   $36
a792: 06 36           ROR   $36
a794: 06 36           ROR   $36
a796: 06 36           ROR   $36
a798: 06 36           ROR   $36
a79a: 06 36           ROR   $36
a79c: 06 36           ROR   $36
a79e: 06 36           ROR   $36
a7a0: 06 35           ROR   $35
a7a2: 06 35           ROR   $35
a7a4: 06 35           ROR   $35
a7a6: 06 35           ROR   $35
a7a8: 06 35           ROR   $35
a7aa: 06 35           ROR   $35
a7ac: 06 35           ROR   $35
a7ae: 06 35           ROR   $35
a7b0: 06 36           ROR   $36
a7b2: 06 36           ROR   $36
a7b4: 06 36           ROR   $36
a7b6: 06 36           ROR   $36
a7b8: 06 36           ROR   $36
a7ba: 06 36           ROR   $36
a7bc: 06 36           ROR   $36
a7be: 06 36           ROR   $36
a7c0: 06 35           ROR   $35
a7c2: 06 35           ROR   $35
a7c4: 06 35           ROR   $35
a7c6: 06 35           ROR   $35
a7c8: 06 35           ROR   $35
a7ca: 06 35           ROR   $35
a7cc: 06 35           ROR   $35
a7ce: 06 35           ROR   $35
a7d0: 06 34           ROR   $34
a7d2: 06 34           ROR   $34
a7d4: 06 34           ROR   $34
a7d6: 06 34           ROR   $34
a7d8: 06 34           ROR   $34
a7da: 06 34           ROR   $34
a7dc: 06 34           ROR   $34
a7de: 06 34           ROR   $34
a7e0: 06 33           ROR   $33
a7e2: 06 33           ROR   $33
a7e4: 06 33           ROR   $33
a7e6: 06 33           ROR   $33
a7e8: 06 33           ROR   $33
a7ea: 06 33           ROR   $33
a7ec: 06 33           ROR   $33
a7ee: 06 33           ROR   $33
a7f0: 06 31           ROR   $31
a7f2: 06 31           ROR   $31
a7f4: 06 31           ROR   $31
a7f6: 06 31           ROR   $31
a7f8: 06 31           ROR   $31
a7fa: 06 31           ROR   $31
a7fc: 06 31           ROR   $31
a7fe: 06 31           ROR   $31
a800: 06 30           ROR   $30
a802: 06 30           ROR   $30
a804: 06 30           ROR   $30
a806: 06 30           ROR   $30
a808: 06 30           ROR   $30
a80a: 06 30           ROR   $30
a80c: 06 30           ROR   $30
a80e: 06 30           ROR   $30
a810: 06 2f           ROR   $2F
a812: 06 2f           ROR   $2F
a814: 06 2f           ROR   $2F
a816: 06 2f           ROR   $2F
a818: 06 2f           ROR   $2F
a81a: 06 2f           ROR   $2F
a81c: 06 2f           ROR   $2F
a81e: 06 2f           ROR   $2F
a820: 06 2c           ROR   $2C
a822: 04 2d           LSR   $2D
a824: 04 2e           LSR   $2E
a826: 04 2f           LSR   $2F
a828: 04 30           LSR   $30
a82a: 04 31           LSR   $31
a82c: 04 32           LSR   $32
a82e: 04 33           LSR   $33
a830: 04 34           LSR   $34
a832: 04 35           LSR   $35
a834: 04 36           LSR   $36
a836: 04 37           LSR   $37
a838: 04 84           LSR   $84
a83a: d8 8a           EORB  $8A
a83c: 85 d2           BITA  #$D2
a83e: 33 18           LEAU  -$8,X
a840: 35 18           PULS  DP,X
a842: 36 18           PSHU  X,DP
a844: 38              FCB   $38
a845: 12              NOP
a846: 3a              ABX
a847: 06 00           ROR   $00
a849: 06 3a           ROR   $3A
a84b: 06 3a           ROR   $3A
a84d: 06 00           ROR   $00
a84f: 06 3a           ROR   $3A
a851: 06 00           ROR   $00
a853: 06 38           ROR   $38
a855: 06 00           ROR   $00
a857: 06 3a           ROR   $3A
a859: 12              NOP
a85a: 3a              ABX
a85b: 06 00           ROR   $00
a85d: 18              FCB   $18
a85e: 33 18           LEAU  -$8,X
a860: 35 18           PULS  DP,X
a862: 36 18           PSHU  X,DP
a864: 38              FCB   $38
a865: 12              NOP
a866: 3a              ABX
a867: 06 00           ROR   $00
a869: 06 3a           ROR   $3A
a86b: 06 3a           ROR   $3A
a86d: 06 00           ROR   $00
a86f: 06 3a           ROR   $3A
a871: 06 00           ROR   $00
a873: 06 38           ROR   $38
a875: 06 00           ROR   $00
a877: 06 3a           ROR   $3A
a879: 12              NOP
a87a: 3a              ABX
a87b: 06 00           ROR   $00
a87d: 18              FCB   $18
a87e: 33 18           LEAU  -$8,X
a880: 35 18           PULS  DP,X
a882: 36 18           PSHU  X,DP
a884: 38              FCB   $38
a885: 12              NOP
a886: 3a              ABX
a887: 66 86           ROR   A,X
a889: 0c 00           INC   $00
a88b: 06 33           ROR   $33
a88d: 06 31           ROR   $31
a88f: 06 2e           ROR   $2E
a891: 06 2c           ROR   $2C
a893: 06 2a           ROR   $2A
a895: 06 27           ROR   $27
a897: 06 26           ROR   $26
a899: 06 25           ROR   $25
a89b: 06 2f           ROR   $2F
a89d: 06 22           ROR   $22
a89f: 06 20           ROR   $20
a8a1: 06 1e           ROR   $1E
a8a3: 06 1f           ROR   $1F
a8a5: 12              NOP
a8a6: 86 00           LDA   #$00
a8a8: 82 00           SBCA  #$00
a8aa: 87              FCB   $87
a8ab: 86 00           LDA   #$00
a8ad: 85 c8           BITA  #$C8
a8af: 88 c8           EORA  #$C8
a8b1: 3d              MUL
a8b2: 08 3d           ASL   $3D
a8b4: 08 3d           ASL   $3D
a8b6: 08 3d           ASL   $3D
a8b8: 08 3d           ASL   $3D
a8ba: 08 3d           ASL   $3D
a8bc: 08 3d           ASL   $3D
a8be: 08 3d           ASL   $3D
a8c0: 08 3d           ASL   $3D
a8c2: 08 3d           ASL   $3D
a8c4: 08 3d           ASL   $3D
a8c6: 08 3d           ASL   $3D
a8c8: 08 3d           ASL   $3D
a8ca: 08 3d           ASL   $3D
a8cc: 08 3d           ASL   $3D
a8ce: 08 3d           ASL   $3D
a8d0: 08 3d           ASL   $3D
a8d2: 08 3d           ASL   $3D
a8d4: 08 00           ASL   $00
a8d6: 30 00           LEAX  $0,X
a8d8: 60 00           NEG   $0,X
a8da: 60 00           NEG   $0,X
a8dc: 60 84           NEG   ,X
a8de: d8 8a           EORB  $8A
a8e0: 85 c8           BITA  #$C8
a8e2: 86 00           LDA   #$00
a8e4: 00 48           NEG   $48
a8e6: 38              FCB   $38
a8e7: 01 37 01        OIM   #$37;$01
a8ea: 36 01           PSHU  CC
a8ec: 35 01           PULS  CC
a8ee: 34 01           PSHS  CC
a8f0: 33 01           LEAU  $1,X
a8f2: 32 01           LEAS  $1,X
a8f4: 31 01           LEAY  $1,X
a8f6: 30 01           LEAX  $1,X
a8f8: 2f 01           BLE   $A8FB
a8fa: 2e 01           BGT   $A8FD
a8fc: 2d 01           BLT   $A8FF
a8fe: 2c 01           BGE   $A901
a900: 2b 01           BMI   $A903
a902: 2a 01           BPL   $A905
a904: 29 01           BVS   $A907
a906: 28 01           BVC   $A909
a908: 27 01           BEQ   $A90B
a90a: 26 01           BNE   $A90D
a90c: 25 01           BCS   $A90F
a90e: 24 01           BCC   $A911
a910: 23 01           BLS   $A913
a912: 22 01           BHI   $A915
a914: 21 01           BRN   $A917
a916: 80 84           SUBA  #$84
a918: d8 8a           EORB  $8A
a91a: 85 c8           BITA  #$C8
a91c: 81 00           CMPA  #$00
a91e: 18              FCB   $18
a91f: 00 0c           NEG   $0C
a921: 33 06           LEAU  $6,X
a923: 33 06           LEAU  $6,X
a925: 36 06           PSHU  B,A
a927: 38              FCB   $38
a928: 06 36           ROR   $36
a92a: 06 00           ROR   $00
a92c: 06 3b           ROR   $3B
a92e: 18              FCB   $18
a92f: 00 60           NEG   $60
a931: 00 18           NEG   $18
a933: 00 0c           NEG   $0C
a935: 33 06           LEAU  $6,X
a937: 33 06           LEAU  $6,X
a939: 36 06           PSHU  B,A
a93b: 38              FCB   $38
a93c: 06 36           ROR   $36
a93e: 06 00           ROR   $00
a940: 06 3b           ROR   $3B
a942: 18              FCB   $18
a943: 00 60           NEG   $60
a945: 83 02 84        SUBD  #$0284
a948: dd 99           STD   $99
a94a: 85 c8           BITA  #$C8
a94c: 36 06           PSHU  B,A
a94e: 36 06           PSHU  B,A
a950: 36 06           PSHU  B,A
a952: 36 06           PSHU  B,A
a954: 36 06           PSHU  B,A
a956: 36 06           PSHU  B,A
a958: 36 06           PSHU  B,A
a95a: 36 06           PSHU  B,A
a95c: 35 06           PULS  A,B
a95e: 35 06           PULS  A,B
a960: 35 06           PULS  A,B
a962: 35 06           PULS  A,B
a964: 35 06           PULS  A,B
a966: 35 06           PULS  A,B
a968: 35 06           PULS  A,B
a96a: 35 06           PULS  A,B
a96c: 34 06           PSHS  B,A
a96e: 34 06           PSHS  B,A
a970: 34 06           PSHS  B,A
a972: 34 06           PSHS  B,A
a974: 34 06           PSHS  B,A
a976: 34 06           PSHS  B,A
a978: 34 06           PSHS  B,A
a97a: 34 06           PSHS  B,A
a97c: 33 06           LEAU  $6,X
a97e: 33 06           LEAU  $6,X
a980: 33 06           LEAU  $6,X
a982: 33 06           LEAU  $6,X
a984: 33 06           LEAU  $6,X
a986: 33 06           LEAU  $6,X
a988: 33 06           LEAU  $6,X
a98a: 33 06           LEAU  $6,X
a98c: 38              FCB   $38
a98d: 06 38           ROR   $38
a98f: 06 38           ROR   $38
a991: 06 38           ROR   $38
a993: 06 38           ROR   $38
a995: 06 38           ROR   $38
a997: 06 38           ROR   $38
a999: 06 38           ROR   $38
a99b: 06 37           ROR   $37
a99d: 06 37           ROR   $37
a99f: 06 37           ROR   $37
a9a1: 06 37           ROR   $37
a9a3: 06 37           ROR   $37
a9a5: 06 37           ROR   $37
a9a7: 06 37           ROR   $37
a9a9: 06 37           ROR   $37
a9ab: 06 36           ROR   $36
a9ad: 06 36           ROR   $36
a9af: 06 36           ROR   $36
a9b1: 06 36           ROR   $36
a9b3: 06 36           ROR   $36
a9b5: 06 36           ROR   $36
a9b7: 06 36           ROR   $36
a9b9: 06 36           ROR   $36
a9bb: 06 35           ROR   $35
a9bd: 06 35           ROR   $35
a9bf: 06 35           ROR   $35
a9c1: 06 35           ROR   $35
a9c3: 06 35           ROR   $35
a9c5: 06 35           ROR   $35
a9c7: 06 35           ROR   $35
a9c9: 06 35           ROR   $35
a9cb: 06 36           ROR   $36
a9cd: 06 36           ROR   $36
a9cf: 06 36           ROR   $36
a9d1: 06 36           ROR   $36
a9d3: 06 36           ROR   $36
a9d5: 06 36           ROR   $36
a9d7: 06 36           ROR   $36
a9d9: 06 36           ROR   $36
a9db: 06 35           ROR   $35
a9dd: 06 35           ROR   $35
a9df: 06 35           ROR   $35
a9e1: 06 35           ROR   $35
a9e3: 06 35           ROR   $35
a9e5: 06 35           ROR   $35
a9e7: 06 35           ROR   $35
a9e9: 06 35           ROR   $35
a9eb: 06 34           ROR   $34
a9ed: 06 34           ROR   $34
a9ef: 06 34           ROR   $34
a9f1: 06 34           ROR   $34
a9f3: 06 34           ROR   $34
a9f5: 06 34           ROR   $34
a9f7: 06 34           ROR   $34
a9f9: 06 34           ROR   $34
a9fb: 06 33           ROR   $33
a9fd: 06 33           ROR   $33
a9ff: 06 33           ROR   $33
aa01: 06 33           ROR   $33
aa03: 06 33           ROR   $33
aa05: 06 33           ROR   $33
aa07: 06 33           ROR   $33
aa09: 06 33           ROR   $33
aa0b: 06 31           ROR   $31
aa0d: 06 31           ROR   $31
aa0f: 06 31           ROR   $31
aa11: 06 31           ROR   $31
aa13: 06 31           ROR   $31
aa15: 06 31           ROR   $31
aa17: 06 31           ROR   $31
aa19: 06 31           ROR   $31
aa1b: 06 30           ROR   $30
aa1d: 06 30           ROR   $30
aa1f: 06 30           ROR   $30
aa21: 06 30           ROR   $30
aa23: 06 30           ROR   $30
aa25: 06 30           ROR   $30
aa27: 06 30           ROR   $30
aa29: 06 30           ROR   $30
aa2b: 06 2f           ROR   $2F
aa2d: 06 2f           ROR   $2F
aa2f: 06 2f           ROR   $2F
aa31: 06 2f           ROR   $2F
aa33: 06 2f           ROR   $2F
aa35: 06 2f           ROR   $2F
aa37: 06 2f           ROR   $2F
aa39: 06 2f           ROR   $2F
aa3b: 06 2c           ROR   $2C
aa3d: 04 2d           LSR   $2D
aa3f: 04 2e           LSR   $2E
aa41: 04 2f           LSR   $2F
aa43: 04 30           LSR   $30
aa45: 04 31           LSR   $31
aa47: 04 32           LSR   $32
aa49: 04 33           LSR   $33
aa4b: 04 34           LSR   $34
aa4d: 04 35           LSR   $35
aa4f: 04 36           LSR   $36
aa51: 04 37           LSR   $37
aa53: 04 84           LSR   $84
aa55: d8 8a           EORB  $8A
aa57: 85 d2           BITA  #$D2
aa59: 2f 18           BLE   $AA73
aa5b: 31 18           LEAY  -$8,X
aa5d: 33 18           LEAU  -$8,X
aa5f: 35 12           PULS  A,X
aa61: 36 06           PSHU  B,A
aa63: 00 06           NEG   $06
aa65: 36 06           PSHU  B,A
aa67: 36 06           PSHU  B,A
aa69: 00 06           NEG   $06
aa6b: 36 06           PSHU  B,A
aa6d: 00 06           NEG   $06
aa6f: 36 06           PSHU  B,A
aa71: 00 06           NEG   $06
aa73: 36 12           PSHU  X,A
aa75: 36 06           PSHU  B,A
aa77: 00 18           NEG   $18
aa79: 2f 18           BLE   $AA93
aa7b: 31 18           LEAY  -$8,X
aa7d: 33 18           LEAU  -$8,X
aa7f: 35 12           PULS  A,X
aa81: 36 06           PSHU  B,A
aa83: 00 06           NEG   $06
aa85: 36 06           PSHU  B,A
aa87: 36 06           PSHU  B,A
aa89: 00 06           NEG   $06
aa8b: 36 06           PSHU  B,A
aa8d: 00 06           NEG   $06
aa8f: 36 06           PSHU  B,A
aa91: 00 06           NEG   $06
aa93: 36 12           PSHU  X,A
aa95: 36 06           PSHU  B,A
aa97: 00 18           NEG   $18
aa99: 2f 18           BLE   $AAB3
aa9b: 31 18           LEAY  -$8,X
aa9d: 33 18           LEAU  -$8,X
aa9f: 35 12           PULS  A,X
aaa1: 36 66           PSHU  S,Y,B,A
aaa3: 00 06           NEG   $06
aaa5: 33 06           LEAU  $6,X
aaa7: 31 06           LEAY  $6,X
aaa9: 2e 06           BGT   $AAB1
aaab: 2c 06           BGE   $AAB3
aaad: 2a 06           BPL   $AAB5
aaaf: 27 06           BEQ   $AAB7
aab1: 26 06           BNE   $AAB9
aab3: 25 06           BCS   $AABB
aab5: 2f 06           BLE   $AABD
aab7: 22 06           BHI   $AABF
aab9: 20 06           BRA   $AAC1
aabb: 1e 06           EXG   D,W
aabd: 1f 12           TFR   X,Y
aabf: 86 00           LDA   #$00
aac1: 82 00           SBCA  #$00
aac3: 87              FCB   $87
aac4: 86 00           LDA   #$00
aac6: 85 c8           BITA  #$C8
aac8: 42              FCB   $42
aac9: 08 42           ASL   $42
aacb: 08 42           ASL   $42
aacd: 08 42           ASL   $42
aacf: 08 42           ASL   $42
aad1: 08 42           ASL   $42
aad3: 08 42           ASL   $42
aad5: 08 42           ASL   $42
aad7: 08 42           ASL   $42
aad9: 08 42           ASL   $42
aadb: 08 42           ASL   $42
aadd: 08 42           ASL   $42
aadf: 08 42           ASL   $42
aae1: 08 42           ASL   $42
aae3: 08 42           ASL   $42
aae5: 08 42           ASL   $42
aae7: 08 42           ASL   $42
aae9: 08 42           ASL   $42
aaeb: 08 00           ASL   $00
aaed: 30 00           LEAX  $0,X
aaef: 60 00           NEG   $0,X
aaf1: 60 00           NEG   $0,X
aaf3: 60 00           NEG   $0,X
aaf5: 60 80           NEG   ,X+
aaf7: 81 00           CMPA  #$00
aaf9: 30 84           LEAX  ,X
aafb: dc 27           LDD   $27
aafd: 85 c8           BITA  #$C8
aaff: 00 18           NEG   $18
ab01: 3f              SWI
ab02: 12              NOP
ab03: 3f              SWI
ab04: 06 00           ROR   $00
ab06: 18              FCB   $18
ab07: 00 06           NEG   $06
ab09: 3b              RTI
ab0a: 06 3d           ROR   $3D
ab0c: 06 3b           ROR   $3B
ab0e: 06 3f           ROR   $3F
ab10: 06 3d           ROR   $3D
ab12: 06 3b           ROR   $3B
ab14: 06 38           ROR   $38
ab16: 06 3a           ROR   $3A
ab18: 06 36           ROR   $36
ab1a: 12              NOP
ab1b: 00 48           NEG   $48
ab1d: 3f              SWI
ab1e: 12              NOP
ab1f: 3f              SWI
ab20: 06 00           ROR   $00
ab22: 18              FCB   $18
ab23: 00 06           NEG   $06
ab25: 3b              RTI
ab26: 06 3d           ROR   $3D
ab28: 06 3b           ROR   $3B
ab2a: 06 3f           ROR   $3F
ab2c: 06 3d           ROR   $3D
ab2e: 06 3b           ROR   $3B
ab30: 06 38           ROR   $38
ab32: 06 3a           ROR   $3A
ab34: 06 36           ROR   $36
ab36: 12              NOP
ab37: 83 02 84        SUBD  #$0284
ab3a: da ff           ORB   $FF
ab3c: 85 aa           BITA  #$AA
ab3e: 36 30           PSHU  Y,X
ab40: 35 30           PULS  X,Y
ab42: 34 30           PSHS  Y,X
ab44: 33 30           LEAU  -$10,Y
ab46: 38              FCB   $38
ab47: 30 37           LEAX  -$9,Y
ab49: 30 36           LEAX  -$A,Y
ab4b: 30 37           LEAX  -$9,Y
ab4d: 30 38           LEAX  -$8,Y
ab4f: 30 39           LEAX  -$7,Y
ab51: 30 3a           LEAX  -$6,Y
ab53: 30 3b           LEAX  -$5,Y
ab55: 30 3c           LEAX  -$4,Y
ab57: 30 3d           LEAX  -$3,Y
ab59: 30 32           LEAX  -$E,Y
ab5b: 30 00           LEAX  $0,X
ab5d: 30 84           LEAX  ,X
ab5f: d8 8a           EORB  $8A
ab61: 85 d2           BITA  #$D2
ab63: 2a 18           BPL   $AB7D
ab65: 2c 18           BGE   $AB7F
ab67: 2e 18           BGT   $AB81
ab69: 31 12           LEAY  -$E,X
ab6b: 33 06           LEAU  $6,X
ab6d: 00 06           NEG   $06
ab6f: 33 06           LEAU  $6,X
ab71: 33 06           LEAU  $6,X
ab73: 00 06           NEG   $06
ab75: 33 06           LEAU  $6,X
ab77: 00 06           NEG   $06
ab79: 31 06           LEAY  $6,X
ab7b: 00 06           NEG   $06
ab7d: 33 12           LEAU  -$E,X
ab7f: 33 06           LEAU  $6,X
ab81: 00 18           NEG   $18
ab83: 2a 18           BPL   $AB9D
ab85: 2c 18           BGE   $AB9F
ab87: 2e 18           BGT   $ABA1
ab89: 31 12           LEAY  -$E,X
ab8b: 33 06           LEAU  $6,X
ab8d: 00 06           NEG   $06
ab8f: 33 06           LEAU  $6,X
ab91: 33 06           LEAU  $6,X
ab93: 00 06           NEG   $06
ab95: 33 06           LEAU  $6,X
ab97: 00 06           NEG   $06
ab99: 31 06           LEAY  $6,X
ab9b: 00 06           NEG   $06
ab9d: 33 12           LEAU  -$E,X
ab9f: 33 06           LEAU  $6,X
aba1: 00 18           NEG   $18
aba3: 2a 18           BPL   $ABBD
aba5: 2c 18           BGE   $ABBF
aba7: 2e 18           BGT   $ABC1
aba9: 31 12           LEAY  -$E,X
abab: 33 66           LEAU  $6,S
abad: 00 06           NEG   $06
abaf: 33 06           LEAU  $6,X
abb1: 31 06           LEAY  $6,X
abb3: 2e 06           BGT   $ABBB
abb5: 2c 06           BGE   $ABBD
abb7: 2a 06           BPL   $ABBF
abb9: 27 06           BEQ   $ABC1
abbb: 26 06           BNE   $ABC3
abbd: 25 06           BCS   $ABC5
abbf: 2f 06           BLE   $ABC7
abc1: 22 06           BHI   $ABC9
abc3: 20 06           BRA   $ABCB
abc5: 1e 06           EXG   D,W
abc7: 1f 12           TFR   X,Y
abc9: 86 00           LDA   #$00
abcb: 82 00           SBCA  #$00
abcd: 87              FCB   $87
abce: 86 00           LDA   #$00
abd0: 85 d2           BITA  #$D2
abd2: 42              FCB   $42
abd3: 08 42           ASL   $42
abd5: 08 42           ASL   $42
abd7: 08 3d           ASL   $3D
abd9: 08 3d           ASL   $3D
abdb: 08 3d           ASL   $3D
abdd: 08 37           ASL   $37
abdf: 08 37           ASL   $37
abe1: 08 37           ASL   $37
abe3: 08 36           ASL   $36
abe5: 08 36           ASL   $36
abe7: 08 36           ASL   $36
abe9: 08 31           ASL   $31
abeb: 08 31           ASL   $31
abed: 08 31           ASL   $31
abef: 08 2b           ASL   $2B
abf1: 08 2b           ASL   $2B
abf3: 08 27           ASL   $27
abf5: 08 00           ASL   $00
abf7: 30 00           LEAX  $0,X
abf9: 60 00           NEG   $0,X
abfb: 60 00           NEG   $0,X
abfd: 60 00           NEG   $0,X
abff: 60 80           NEG   ,X+
ac01: 81 00           CMPA  #$00
ac03: 30 84           LEAX  ,X
ac05: dd 4f           STD   $4F
ac07: 85 be           BITA  #$BE
ac09: 00 18           NEG   $18
ac0b: 44              LSRA
ac0c: 12              NOP
ac0d: 44              LSRA
ac0e: 06 00           ROR   $00
ac10: 18              FCB   $18
ac11: 00 06           NEG   $06
ac13: 3b              RTI
ac14: 06 3d           ROR   $3D
ac16: 06 3b           ROR   $3B
ac18: 06 3f           ROR   $3F
ac1a: 06 3d           ROR   $3D
ac1c: 06 3b           ROR   $3B
ac1e: 06 38           ROR   $38
ac20: 06 3a           ROR   $3A
ac22: 06 36           ROR   $36
ac24: 12              NOP
ac25: 00 48           NEG   $48
ac27: 44              LSRA
ac28: 12              NOP
ac29: 44              LSRA
ac2a: 06 00           ROR   $00
ac2c: 18              FCB   $18
ac2d: 00 06           NEG   $06
ac2f: 3b              RTI
ac30: 06 3d           ROR   $3D
ac32: 06 3b           ROR   $3B
ac34: 06 3f           ROR   $3F
ac36: 06 3d           ROR   $3D
ac38: 06 3b           ROR   $3B
ac3a: 06 38           ROR   $38
ac3c: 06 3a           ROR   $3A
ac3e: 06 36           ROR   $36
ac40: 12              NOP
ac41: 83 02 84        SUBD  #$0284
ac44: da ff           ORB   $FF
ac46: 85 aa           BITA  #$AA
ac48: 31 30           LEAY  -$10,Y
ac4a: 30 30           LEAX  -$10,Y
ac4c: 2f 30           BLE   $AC7E
ac4e: 2e 30           BGT   $AC80
ac50: 33 30           LEAU  -$10,Y
ac52: 32 30           LEAS  -$10,Y
ac54: 31 30           LEAY  -$10,Y
ac56: 30 30           LEAX  -$10,Y
ac58: 31 30           LEAY  -$10,Y
ac5a: 32 30           LEAS  -$10,Y
ac5c: 33 30           LEAU  -$10,Y
ac5e: 34 30           PSHS  Y,X
ac60: 35 30           PULS  X,Y
ac62: 36 30           PSHU  Y,X
ac64: 37 30           PULU  X,Y
ac66: 00 30           NEG   $30
ac68: 00 60           NEG   $60
ac6a: 00 60           NEG   $60
ac6c: 00 60           NEG   $60
ac6e: 00 60           NEG   $60
ac70: 84 dc           ANDA  #$DC
ac72: bb 85 aa        ADDA  $85AA
ac75: 3a              ABX
ac76: c0 00           SUBB  #$00
ac78: 60 82           NEG   ,-X
ac7a: 00 87           NEG   $87
ac7c: 86 00           LDA   #$00
ac7e: 85 dc           BITA  #$DC
ac80: 00 60           NEG   $60
ac82: 00 48           NEG   $48
ac84: 3a              ABX
ac85: 06 3a           ROR   $3A
ac87: 06 3a           ROR   $3A
ac89: 06 3c           ROR   $3C
ac8b: 06 84           ROR   $84
ac8d: de 2d           LDU   $2D
ac8f: 85 c8           BITA  #$C8
ac91: 3d              MUL
ac92: 06 3d           ROR   $3D
ac94: 06 3d           ROR   $3D
ac96: 06 3d           ROR   $3D
ac98: 06 84           ROR   $84
ac9a: de 52           LDU   $52
ac9c: 85 dc           BITA  #$DC
ac9e: 31 06           LEAY  $6,X
aca0: 84 de           ANDA  #$DE
aca2: 2d 85           BLT   $AC29
aca4: c8 3d           EORB  #$3D
aca6: 06 3d           ROR   $3D
aca8: 06 3d           ROR   $3D
acaa: 06 3d           ROR   $3D
acac: 06 3d           ROR   $3D
acae: 06 3d           ROR   $3D
acb0: 06 3d           ROR   $3D
acb2: 06 84           ROR   $84
acb4: de 52           LDU   $52
acb6: 85 dc           BITA  #$DC
acb8: 31 06           LEAY  $6,X
acba: 84 de           ANDA  #$DE
acbc: 2d 85           BLT   $AC43
acbe: c8 3d           EORB  #$3D
acc0: 06 3d           ROR   $3D
acc2: 06 3d           ROR   $3D
acc4: 06 84           ROR   $84
acc6: de 2d           LDU   $2D
acc8: 85 c8           BITA  #$C8
acca: 3d              MUL
accb: 06 3d           ROR   $3D
accd: 06 3d           ROR   $3D
accf: 06 3d           ROR   $3D
acd1: 06 84           ROR   $84
acd3: de 52           LDU   $52
acd5: 85 dc           BITA  #$DC
acd7: 31 06           LEAY  $6,X
acd9: 84 de           ANDA  #$DE
acdb: 2d 85           BLT   $AC62
acdd: c8 3d           EORB  #$3D
acdf: 06 3d           ROR   $3D
ace1: 06 3d           ROR   $3D
ace3: 06 3d           ROR   $3D
ace5: 06 3d           ROR   $3D
ace7: 06 3d           ROR   $3D
ace9: 06 3d           ROR   $3D
aceb: 06 84           ROR   $84
aced: de 52           LDU   $52
acef: 85 dc           BITA  #$DC
acf1: 31 06           LEAY  $6,X
acf3: 84 de           ANDA  #$DE
acf5: 2d 85           BLT   $AC7C
acf7: c8 3d           EORB  #$3D
acf9: 06 3d           ROR   $3D
acfb: 06 3d           ROR   $3D
acfd: 06 84           ROR   $84
acff: de 2d           LDU   $2D
ad01: 85 c8           BITA  #$C8
ad03: 3d              MUL
ad04: 06 3d           ROR   $3D
ad06: 06 3d           ROR   $3D
ad08: 06 3d           ROR   $3D
ad0a: 06 84           ROR   $84
ad0c: de 52           LDU   $52
ad0e: 85 dc           BITA  #$DC
ad10: 31 06           LEAY  $6,X
ad12: 84 de           ANDA  #$DE
ad14: 2d 85           BLT   $AC9B
ad16: c8 3d           EORB  #$3D
ad18: 06 3d           ROR   $3D
ad1a: 06 3d           ROR   $3D
ad1c: 06 3d           ROR   $3D
ad1e: 06 3d           ROR   $3D
ad20: 06 3d           ROR   $3D
ad22: 06 3d           ROR   $3D
ad24: 06 84           ROR   $84
ad26: de 52           LDU   $52
ad28: 85 dc           BITA  #$DC
ad2a: 31 06           LEAY  $6,X
ad2c: 84 de           ANDA  #$DE
ad2e: 2d 85           BLT   $ACB5
ad30: c8 3d           EORB  #$3D
ad32: 06 3d           ROR   $3D
ad34: 06 3d           ROR   $3D
ad36: 06 84           ROR   $84
ad38: de 2d           LDU   $2D
ad3a: 85 c8           BITA  #$C8
ad3c: 3d              MUL
ad3d: 06 3d           ROR   $3D
ad3f: 06 3d           ROR   $3D
ad41: 06 3d           ROR   $3D
ad43: 06 84           ROR   $84
ad45: de 52           LDU   $52
ad47: 85 dc           BITA  #$DC
ad49: 31 06           LEAY  $6,X
ad4b: 84 de           ANDA  #$DE
ad4d: 2d 85           BLT   $ACD4
ad4f: c8 3d           EORB  #$3D
ad51: 06 3d           ROR   $3D
ad53: 06 3d           ROR   $3D
ad55: 06 3d           ROR   $3D
ad57: 06 3d           ROR   $3D
ad59: 06 3d           ROR   $3D
ad5b: 06 3d           ROR   $3D
ad5d: 06 84           ROR   $84
ad5f: de 52           LDU   $52
ad61: 85 dc           BITA  #$DC
ad63: 31 0c           LEAY  $C,X
ad65: 31 06           LEAY  $6,X
ad67: 31 06           LEAY  $6,X
ad69: 80 84           SUBA  #$84
ad6b: de 2d           LDU   $2D
ad6d: 85 c8           BITA  #$C8
ad6f: 81 3d           CMPA  #$3D
ad71: 06 3d           ROR   $3D
ad73: 06 3d           ROR   $3D
ad75: 06 3d           ROR   $3D
ad77: 06 84           ROR   $84
ad79: de 52           LDU   $52
ad7b: 85 dc           BITA  #$DC
ad7d: 31 06           LEAY  $6,X
ad7f: 84 de           ANDA  #$DE
ad81: 2d 85           BLT   $AD08
ad83: c8 3d           EORB  #$3D
ad85: 06 3d           ROR   $3D
ad87: 06 3d           ROR   $3D
ad89: 06 3d           ROR   $3D
ad8b: 06 3d           ROR   $3D
ad8d: 06 3d           ROR   $3D
ad8f: 06 3d           ROR   $3D
ad91: 06 84           ROR   $84
ad93: de 52           LDU   $52
ad95: 85 dc           BITA  #$DC
ad97: 31 06           LEAY  $6,X
ad99: 84 de           ANDA  #$DE
ad9b: 2d 85           BLT   $AD22
ad9d: c8 3d           EORB  #$3D
ad9f: 06 3d           ROR   $3D
ada1: 06 3d           ROR   $3D
ada3: 06 83           ROR   $83
ada5: 0f 84           CLR   $84
ada7: de 2d           LDU   $2D
ada9: 85 c8           BITA  #$C8
adab: 3d              MUL
adac: 06 3d           ROR   $3D
adae: 06 3d           ROR   $3D
adb0: 06 3d           ROR   $3D
adb2: 06 84           ROR   $84
adb4: de 52           LDU   $52
adb6: 85 dc           BITA  #$DC
adb8: 31 06           LEAY  $6,X
adba: 84 de           ANDA  #$DE
adbc: 2d 85           BLT   $AD43
adbe: c8 3d           EORB  #$3D
adc0: 06 3d           ROR   $3D
adc2: 06 3d           ROR   $3D
adc4: 06 3d           ROR   $3D
adc6: 06 3d           ROR   $3D
adc8: 06 3d           ROR   $3D
adca: 06 3d           ROR   $3D
adcc: 06 84           ROR   $84
adce: de 52           LDU   $52
add0: 85 dc           BITA  #$DC
add2: 31 06           LEAY  $6,X
add4: 31 06           LEAY  $6,X
add6: 2c 06           BGE   $ADDE
add8: 2c 06           BGE   $ADE0
adda: 84 dd           ANDA  #$DD
addc: 2a 85           BPL   $AD63
adde: e6 38           LDB   -$8,Y
ade0: 18              FCB   $18
ade1: 84 de           ANDA  #$DE
ade3: 52              FCB   $52
ade4: 85 dc           BITA  #$DC
ade6: 31 06           LEAY  $6,X
ade8: 84 de           ANDA  #$DE
adea: 2d 85           BLT   $AD71
adec: c8 3d           EORB  #$3D
adee: 06 3d           ROR   $3D
adf0: 06 3d           ROR   $3D
adf2: 06 3d           ROR   $3D
adf4: 06 3d           ROR   $3D
adf6: 06 3d           ROR   $3D
adf8: 06 3d           ROR   $3D
adfa: 06 84           ROR   $84
adfc: de 52           LDU   $52
adfe: 85 dc           BITA  #$DC
ae00: 31 06           LEAY  $6,X
ae02: 84 de           ANDA  #$DE
ae04: 2d 85           BLT   $AD8B
ae06: c8 3d           EORB  #$3D
ae08: 06 3d           ROR   $3D
ae0a: 06 3d           ROR   $3D
ae0c: 06 84           ROR   $84
ae0e: de 2d           LDU   $2D
ae10: 85 c8           BITA  #$C8
ae12: 3d              MUL
ae13: 06 3d           ROR   $3D
ae15: 06 3d           ROR   $3D
ae17: 06 3d           ROR   $3D
ae19: 06 84           ROR   $84
ae1b: de 52           LDU   $52
ae1d: 85 dc           BITA  #$DC
ae1f: 31 06           LEAY  $6,X
ae21: 84 de           ANDA  #$DE
ae23: 2d 85           BLT   $ADAA
ae25: c8 3d           EORB  #$3D
ae27: 06 3d           ROR   $3D
ae29: 06 3d           ROR   $3D
ae2b: 06 3d           ROR   $3D
ae2d: 06 3d           ROR   $3D
ae2f: 06 3d           ROR   $3D
ae31: 06 3d           ROR   $3D
ae33: 06 84           ROR   $84
ae35: de 52           LDU   $52
ae37: 85 dc           BITA  #$DC
ae39: 35 06           PULS  A,B
ae3b: 33 06           LEAU  $6,X
ae3d: 31 0c           LEAY  $C,X
ae3f: 84 de           ANDA  #$DE
ae41: 2d 85           BLT   $ADC8
ae43: c8 3d           EORB  #$3D
ae45: 06 3d           ROR   $3D
ae47: 06 3d           ROR   $3D
ae49: 06 3d           ROR   $3D
ae4b: 06 84           ROR   $84
ae4d: de 52           LDU   $52
ae4f: 85 dc           BITA  #$DC
ae51: 31 06           LEAY  $6,X
ae53: 84 de           ANDA  #$DE
ae55: 2d 85           BLT   $ADDC
ae57: c8 3d           EORB  #$3D
ae59: 06 3d           ROR   $3D
ae5b: 06 3d           ROR   $3D
ae5d: 06 3d           ROR   $3D
ae5f: 06 3d           ROR   $3D
ae61: 06 3d           ROR   $3D
ae63: 06 3d           ROR   $3D
ae65: 06 84           ROR   $84
ae67: de 52           LDU   $52
ae69: 85 dc           BITA  #$DC
ae6b: 31 06           LEAY  $6,X
ae6d: 84 de           ANDA  #$DE
ae6f: 2d 85           BLT   $ADF6
ae71: c8 3d           EORB  #$3D
ae73: 06 3d           ROR   $3D
ae75: 06 3d           ROR   $3D
ae77: 06 84           ROR   $84
ae79: de 2d           LDU   $2D
ae7b: 85 c8           BITA  #$C8
ae7d: 3d              MUL
ae7e: 06 3d           ROR   $3D
ae80: 06 3d           ROR   $3D
ae82: 06 3d           ROR   $3D
ae84: 06 84           ROR   $84
ae86: de 52           LDU   $52
ae88: 85 dc           BITA  #$DC
ae8a: 31 06           LEAY  $6,X
ae8c: 84 de           ANDA  #$DE
ae8e: 2d 85           BLT   $AE15
ae90: c8 3d           EORB  #$3D
ae92: 06 3d           ROR   $3D
ae94: 06 3d           ROR   $3D
ae96: 06 3d           ROR   $3D
ae98: 06 3d           ROR   $3D
ae9a: 06 3d           ROR   $3D
ae9c: 06 3d           ROR   $3D
ae9e: 06 84           ROR   $84
aea0: de 52           LDU   $52
aea2: 85 dc           BITA  #$DC
aea4: 35 06           PULS  A,B
aea6: 33 06           LEAU  $6,X
aea8: 31 0c           LEAY  $C,X
aeaa: 84 de           ANDA  #$DE
aeac: 2d 85           BLT   $AE33
aeae: c8 3d           EORB  #$3D
aeb0: 06 3d           ROR   $3D
aeb2: 06 3d           ROR   $3D
aeb4: 06 3d           ROR   $3D
aeb6: 06 84           ROR   $84
aeb8: de 52           LDU   $52
aeba: 85 dc           BITA  #$DC
aebc: 31 06           LEAY  $6,X
aebe: 84 de           ANDA  #$DE
aec0: 2d 85           BLT   $AE47
aec2: c8 3d           EORB  #$3D
aec4: 06 3d           ROR   $3D
aec6: 06 3d           ROR   $3D
aec8: 06 3d           ROR   $3D
aeca: 06 3d           ROR   $3D
aecc: 06 3d           ROR   $3D
aece: 06 3d           ROR   $3D
aed0: 06 84           ROR   $84
aed2: de 52           LDU   $52
aed4: 85 dc           BITA  #$DC
aed6: 31 06           LEAY  $6,X
aed8: 84 de           ANDA  #$DE
aeda: 2d 85           BLT   $AE61
aedc: c8 3d           EORB  #$3D
aede: 06 3d           ROR   $3D
aee0: 06 3d           ROR   $3D
aee2: 06 84           ROR   $84
aee4: de 2d           LDU   $2D
aee6: 85 c8           BITA  #$C8
aee8: 00 0c           NEG   $0C
aeea: 3d              MUL
aeeb: 0c 84           INC   $84
aeed: de 52           LDU   $52
aeef: 85 dc           BITA  #$DC
aef1: 31 0c           LEAY  $C,X
aef3: 84 de           ANDA  #$DE
aef5: 2d 85           BLT   $AE7C
aef7: c8 3d           EORB  #$3D
aef9: 0c 3d           INC   $3D
aefb: 0c 3d           INC   $3D
aefd: 0c 84           INC   $84
aeff: de 52           LDU   $52
af01: 85 dc           BITA  #$DC
af03: 35 06           PULS  A,B
af05: 33 06           LEAU  $6,X
af07: 31 06           LEAY  $6,X
af09: 31 06           LEAY  $6,X
af0b: 00 06           NEG   $06
af0d: 31 06           LEAY  $6,X
af0f: 31 06           LEAY  $6,X
af11: 31 06           LEAY  $6,X
af13: 31 06           LEAY  $6,X
af15: 31 06           LEAY  $6,X
af17: 31 06           LEAY  $6,X
af19: 31 06           LEAY  $6,X
af1b: 31 06           LEAY  $6,X
af1d: 31 06           LEAY  $6,X
af1f: 31 06           LEAY  $6,X
af21: 31 06           LEAY  $6,X
af23: 31 06           LEAY  $6,X
af25: 31 06           LEAY  $6,X
af27: 31 06           LEAY  $6,X
af29: 31 06           LEAY  $6,X
af2b: 82 00           SBCA  #$00
af2d: 87              FCB   $87
af2e: 86 00           LDA   #$00
af30: 85 e6           BITA  #$E6
af32: 00 60           NEG   $60
af34: 00 60           NEG   $60
af36: 20 12           BRA   $AF4A
af38: 20 06           BRA   $AF40
af3a: 00 30           NEG   $30
af3c: 00 12           NEG   $12
af3e: 1e 06           EXG   D,W
af40: 20 12           BRA   $AF54
af42: 20 06           BRA   $AF4A
af44: 84 dc           ANDA  #$DC
af46: 71 85 c8 00     OIM   #$85,$C800
af4a: 0c 3d           INC   $3D
af4c: 06 3d           ROR   $3D
af4e: 06 3d           ROR   $3D
af50: 06 3d           ROR   $3D
af52: 06 3d           ROR   $3D
af54: 06 3d           ROR   $3D
af56: 06 00           ROR   $00
af58: 06 3d           ROR   $3D
af5a: 06 84           ROR   $84
af5c: de 77           LDU   $77
af5e: 85 e6           BITA  #$E6
af60: 00 0c           NEG   $0C
af62: 20 12           BRA   $AF76
af64: 20 06           BRA   $AF6C
af66: 00 30           NEG   $30
af68: 00 12           NEG   $12
af6a: 1e 06           EXG   D,W
af6c: 20 12           BRA   $AF80
af6e: 20 06           BRA   $AF76
af70: 00 0c           NEG   $0C
af72: 84 dc           ANDA  #$DC
af74: 71 85 c8 3d     OIM   #$85,$C83D
af78: 0c 3d           INC   $3D
af7a: 06 3d           ROR   $3D
af7c: 06 00           ROR   $00
af7e: 06 3d           ROR   $3D
af80: 06 3d           ROR   $3D
af82: 06 00           ROR   $00
af84: 06 3d           ROR   $3D
af86: 06 3d           ROR   $3D
af88: 06 84           ROR   $84
af8a: de 77           LDU   $77
af8c: 85 e6           BITA  #$E6
af8e: 80 81           SUBA  #$81
af90: 20 12           BRA   $AFA4
af92: 20 06           BRA   $AF9A
af94: 00 30           NEG   $30
af96: 00 12           NEG   $12
af98: 1e 06           EXG   D,W
af9a: 20 12           BRA   $AFAE
af9c: 20 06           BRA   $AFA4
af9e: 00 48           NEG   $48
afa0: 20 12           BRA   $AFB4
afa2: 20 06           BRA   $AFAA
afa4: 00 30           NEG   $30
afa6: 00 12           NEG   $12
afa8: 1e 06           EXG   D,W
afaa: 20 12           BRA   $AFBE
afac: 20 06           BRA   $AFB4
afae: 00 48           NEG   $48
afb0: 83 02 20        SUBD  #$0220
afb3: 12              NOP
afb4: 20 06           BRA   $AFBC
afb6: 00 30           NEG   $30
afb8: 00 12           NEG   $12
afba: 1e 06           EXG   D,W
afbc: 20 12           BRA   $AFD0
afbe: 20 06           BRA   $AFC6
afc0: 00 48           NEG   $48
afc2: 20 12           BRA   $AFD6
afc4: 20 06           BRA   $AFCC
afc6: 00 30           NEG   $30
afc8: 00 12           NEG   $12
afca: 1e 06           EXG   D,W
afcc: 20 12           BRA   $AFE0
afce: 20 06           BRA   $AFD6
afd0: 00 48           NEG   $48
afd2: 20 12           BRA   $AFE6
afd4: 20 06           BRA   $AFDC
afd6: 00 30           NEG   $30
afd8: 00 12           NEG   $12
afda: 1e 06           EXG   D,W
afdc: 20 12           BRA   $AFF0
afde: 20 06           BRA   $AFE6
afe0: 00 48           NEG   $48
afe2: 20 12           BRA   $AFF6
afe4: 20 06           BRA   $AFEC
afe6: 00 30           NEG   $30
afe8: 00 12           NEG   $12
afea: 1e 06           EXG   D,W
afec: 20 12           BRA   $B000
afee: 20 06           BRA   $AFF6
aff0: 00 48           NEG   $48
aff2: 20 18           BRA   $B00C
aff4: 20 18           BRA   $B00E
aff6: 20 18           BRA   $B010
aff8: 20 12           BRA   $B00C
affa: 20 06           BRA   $B002
affc: 00 06           NEG   $06
affe: 20 06           BRA   $B006
b000: 20 06           BRA   $B008
b002: 00 06           NEG   $06
b004: 20 06           BRA   $B00C
b006: 00 06           NEG   $06
b008: 20 06           BRA   $B010
b00a: 00 06           NEG   $06
b00c: 20 12           BRA   $B020
b00e: 20 06           BRA   $B016
b010: 00 18           NEG   $18
b012: 20 18           BRA   $B02C
b014: 20 18           BRA   $B02E
b016: 20 18           BRA   $B030
b018: 20 12           BRA   $B02C
b01a: 20 06           BRA   $B022
b01c: 00 06           NEG   $06
b01e: 20 06           BRA   $B026
b020: 20 06           BRA   $B028
b022: 00 06           NEG   $06
b024: 20 06           BRA   $B02C
b026: 00 06           NEG   $06
b028: 20 06           BRA   $B030
b02a: 00 06           NEG   $06
b02c: 20 12           BRA   $B040
b02e: 20 06           BRA   $B036
b030: 00 18           NEG   $18
b032: 20 18           BRA   $B04C
b034: 20 18           BRA   $B04E
b036: 20 18           BRA   $B050
b038: 20 12           BRA   $B04C
b03a: 20 06           BRA   $B042
b03c: 00 18           NEG   $18
b03e: 00 18           NEG   $18
b040: 00 18           NEG   $18
b042: 00 18           NEG   $18
b044: 00 06           NEG   $06
b046: 20 06           BRA   $B04E
b048: 20 06           BRA   $B050
b04a: 20 06           BRA   $B052
b04c: 20 06           BRA   $B054
b04e: 20 06           BRA   $B056
b050: 20 06           BRA   $B058
b052: 20 06           BRA   $B05A
b054: 20 06           BRA   $B05C
b056: 20 06           BRA   $B05E
b058: 20 06           BRA   $B060
b05a: 20 06           BRA   $B062
b05c: 20 06           BRA   $B064
b05e: 20 06           BRA   $B066
b060: 00 0c           NEG   $0C
b062: 82 00           SBCA  #$00
b064: 87              FCB   $87
b065: 05 e9 b0        EIM   #$E9;$B0
b068: 7b de e6 b0     TIM   #$DE,$E6B0
b06c: a2 d8 d4        SBCA  [-$2C,U]
b06f: b0 c9 df        SUBA  $C9DF
b072: 0b b0 d8        TIM   #$B0;$D8
b075: de e6           LDU   $E6
b077: b0 f5 d8        SUBA  $F5D8
b07a: d4 86           ANDB  $86
b07c: 00 85           NEG   $85
b07e: d2 38           SBCB  $38
b080: 0c 31           INC   $31
b082: 0c 33           INC   $33
b084: 0c 38           INC   $38
b086: 0c 33           INC   $33
b088: 0c 31           INC   $31
b08a: 0c 2e           INC   $2E
b08c: 0c 31           INC   $31
b08e: 0c 38           INC   $38
b090: 0c 31           INC   $31
b092: 0c 33           INC   $33
b094: 0c 38           INC   $38
b096: 0c 36           INC   $36
b098: 0c 35           INC   $35
b09a: 0c 33           INC   $33
b09c: 0c 31           INC   $31
b09e: 0c 33           INC   $33
b0a0: 60 87           NEG   E,X
b0a2: 86 00           LDA   #$00
b0a4: 85 be           BITA  #$BE
b0a6: 38              FCB   $38
b0a7: 0c 31           INC   $31
b0a9: 0c 33           INC   $33
b0ab: 0c 38           INC   $38
b0ad: 0c 33           INC   $33
b0af: 0c 31           INC   $31
b0b1: 0c 2e           INC   $2E
b0b3: 0c 31           INC   $31
b0b5: 0c 38           INC   $38
b0b7: 0c 31           INC   $31
b0b9: 0c 33           INC   $33
b0bb: 0c 38           INC   $38
b0bd: 0c 36           INC   $36
b0bf: 0c 35           INC   $35
b0c1: 0c 33           INC   $33
b0c3: 0c 31           INC   $31
b0c5: 0c 33           INC   $33
b0c7: 60 87           NEG   E,X
b0c9: 86 f4           LDA   #$F4
b0cb: 85 c8           BITA  #$C8
b0cd: 88 ff           EORA  #$FF
b0cf: 89 dc           ADCA  #$DC
b0d1: 27 c0           BEQ   $B093
b0d3: 85 be           BITA  #$BE
b0d5: 27 60           BEQ   $B137
b0d7: 87              FCB   $87
b0d8: 86 0c           LDA   #$0C
b0da: 85 be           BITA  #$BE
b0dc: 00 60           NEG   $60
b0de: 38              FCB   $38
b0df: 0c 31           INC   $31
b0e1: 0c 33           INC   $33
b0e3: 0c 38           INC   $38
b0e5: 0c 36           INC   $36
b0e7: 0c 35           INC   $35
b0e9: 0c 33           INC   $33
b0eb: 0c 31           INC   $31
b0ed: 0c 33           INC   $33
b0ef: 0c 2a           INC   $2A
b0f1: 0c 2e           INC   $2E
b0f3: 48              ASLA
b0f4: 87              FCB   $87
b0f5: 86 0c           LDA   #$0C
b0f7: 85 be           BITA  #$BE
b0f9: 00 60           NEG   $60
b0fb: 38              FCB   $38
b0fc: 0c 31           INC   $31
b0fe: 0c 33           INC   $33
b100: 0c 38           INC   $38
b102: 0c 36           INC   $36
b104: 0c 35           INC   $35
b106: 0c 33           INC   $33
b108: 0c 31           INC   $31
b10a: 0c 86           INC   $86
b10c: f4 27 0c        ANDB  $270C
b10f: 2a 0c           BPL   $B11D
b111: 2e 48           BGT   $B15B
b113: 87              FCB   $87
b114: 07 f0           ASR   $F0
b116: b1 32 dd        CMPA  $32DD
b119: 99 b3           ADCA  $B3
b11b: 4f              CLRA
b11c: db 24           ADDB  $24
b11e: b4 d1 d8        ANDA  $D1D8
b121: 8a b7           ORA   #$B7
b123: 60 d8 8a        NEG   [-$76,U]
b126: b8 a1 da        EORA  $A1DA
b129: 6b bb a4        TIM   #$BB;,Y
b12c: de 2d           LDU   $2D
b12e: bb be de        ADDA  $BEDE
b131: 52              FCB   $52
b132: 00 60           NEG   $60
b134: 86 00           LDA   #$00
b136: 80 84           SUBA  #$84
b138: dd 99           STD   $99
b13a: 85 be           BITA  #$BE
b13c: 89 fa           ADCA  #$FA
b13e: 81 2e           CMPA  #$2E
b140: 0c 2e           INC   $2E
b142: 0c 2e           INC   $2E
b144: 0c 2e           INC   $2E
b146: 0c 2e           INC   $2E
b148: 0c 2e           INC   $2E
b14a: 0c 2e           INC   $2E
b14c: 0c 2e           INC   $2E
b14e: 0c 2e           INC   $2E
b150: 0c 2e           INC   $2E
b152: 0c 2e           INC   $2E
b154: 0c 31           INC   $31
b156: 24 30           BCC   $B188
b158: 18              FCB   $18
b159: 2e 0c           BGT   $B167
b15b: 2e 0c           BGT   $B169
b15d: 2e 0c           BGT   $B16B
b15f: 2e 0c           BGT   $B16D
b161: 2e 0c           BGT   $B16F
b163: 2e 0c           BGT   $B171
b165: 2e 0c           BGT   $B173
b167: 2e 0c           BGT   $B175
b169: 2e 0c           BGT   $B177
b16b: 2e 0c           BGT   $B179
b16d: 2e 0c           BGT   $B17B
b16f: 33 24           LEAU  $4,Y
b171: 35 18           PULS  DP,X
b173: 2e 0c           BGT   $B181
b175: 2e 0c           BGT   $B183
b177: 2e 0c           BGT   $B185
b179: 2e 0c           BGT   $B187
b17b: 2e 0c           BGT   $B189
b17d: 2e 0c           BGT   $B18B
b17f: 2e 0c           BGT   $B18D
b181: 2e 0c           BGT   $B18F
b183: 2e 0c           BGT   $B191
b185: 2e 0c           BGT   $B193
b187: 2e 0c           BGT   $B195
b189: 31 24           LEAY  $4,Y
b18b: 30 18           LEAX  -$8,X
b18d: 2e 0c           BGT   $B19B
b18f: 2e 0c           BGT   $B19D
b191: 2e 0c           BGT   $B19F
b193: 2e 0c           BGT   $B1A1
b195: 2e 0c           BGT   $B1A3
b197: 2e 0c           BGT   $B1A5
b199: 2e 0c           BGT   $B1A7
b19b: 2e 0c           BGT   $B1A9
b19d: 2e 0c           BGT   $B1AB
b19f: 2e 0c           BGT   $B1AD
b1a1: 2e 0c           BGT   $B1AF
b1a3: 31 0c           LEAY  $C,X
b1a5: 33 0c           LEAU  $C,X
b1a7: 35 0c           PULS  B,DP
b1a9: 38              FCB   $38
b1aa: 0c 3a           INC   $3A
b1ac: 0c 83           INC   $83
b1ae: 02 2a 0c        AIM   #$2A;$0C
b1b1: 2a 0c           BPL   $B1BF
b1b3: 2a 0c           BPL   $B1C1
b1b5: 2a 0c           BPL   $B1C3
b1b7: 2a 0c           BPL   $B1C5
b1b9: 2a 0c           BPL   $B1C7
b1bb: 2a 0c           BPL   $B1C9
b1bd: 2a 0c           BPL   $B1CB
b1bf: 2a 0c           BPL   $B1CD
b1c1: 2a 0c           BPL   $B1CF
b1c3: 2a 0c           BPL   $B1D1
b1c5: 2a 0c           BPL   $B1D3
b1c7: 2a 0c           BPL   $B1D5
b1c9: 2a 0c           BPL   $B1D7
b1cb: 2a 0c           BPL   $B1D9
b1cd: 2a 0c           BPL   $B1DB
b1cf: 2a 0c           BPL   $B1DD
b1d1: 2a 0c           BPL   $B1DF
b1d3: 2a 0c           BPL   $B1E1
b1d5: 2a 0c           BPL   $B1E3
b1d7: 2a 0c           BPL   $B1E5
b1d9: 2a 0c           BPL   $B1E7
b1db: 2a 0c           BPL   $B1E9
b1dd: 2a 0c           BPL   $B1EB
b1df: 2a 0c           BPL   $B1ED
b1e1: 2a 0c           BPL   $B1EF
b1e3: 2a 0c           BPL   $B1F1
b1e5: 2a 0c           BPL   $B1F3
b1e7: 2a 0c           BPL   $B1F5
b1e9: 2a 0c           BPL   $B1F7
b1eb: 2a 0c           BPL   $B1F9
b1ed: 2a 0c           BPL   $B1FB
b1ef: 2a 0c           BPL   $B1FD
b1f1: 2a 0c           BPL   $B1FF
b1f3: 2a 0c           BPL   $B201
b1f5: 2a 0c           BPL   $B203
b1f7: 2a 0c           BPL   $B205
b1f9: 2a 0c           BPL   $B207
b1fb: 2a 0c           BPL   $B209
b1fd: 2a 0c           BPL   $B20B
b1ff: 2a 0c           BPL   $B20D
b201: 2a 0c           BPL   $B20F
b203: 2a 0c           BPL   $B211
b205: 2a 0c           BPL   $B213
b207: 2a 0c           BPL   $B215
b209: 2a 0c           BPL   $B217
b20b: 2a 0c           BPL   $B219
b20d: 2a 0c           BPL   $B21B
b20f: 2a 0c           BPL   $B21D
b211: 2a 0c           BPL   $B21F
b213: 2a 0c           BPL   $B221
b215: 2a 0c           BPL   $B223
b217: 2a 0c           BPL   $B225
b219: 2a 0c           BPL   $B227
b21b: 2a 0c           BPL   $B229
b21d: 2a 0c           BPL   $B22B
b21f: 2a 0c           BPL   $B22D
b221: 31 0c           LEAY  $C,X
b223: 30 0c           LEAX  $C,X
b225: 31 0c           LEAY  $C,X
b227: 32 0c           LEAS  $C,X
b229: 33 0c           LEAU  $C,X
b22b: 34 0c           PSHS  DP,B
b22d: 35 0c           PULS  B,DP
b22f: 2e 0c           BGT   $B23D
b231: 2e 0c           BGT   $B23F
b233: 2e 0c           BGT   $B241
b235: 2e 0c           BGT   $B243
b237: 2e 0c           BGT   $B245
b239: 2e 0c           BGT   $B247
b23b: 2e 0c           BGT   $B249
b23d: 2e 0c           BGT   $B24B
b23f: 2e 0c           BGT   $B24D
b241: 2e 0c           BGT   $B24F
b243: 2e 0c           BGT   $B251
b245: 31 24           LEAY  $4,Y
b247: 30 18           LEAX  -$8,X
b249: 2e 0c           BGT   $B257
b24b: 2e 0c           BGT   $B259
b24d: 2e 0c           BGT   $B25B
b24f: 2e 0c           BGT   $B25D
b251: 2e 0c           BGT   $B25F
b253: 2e 0c           BGT   $B261
b255: 2e 0c           BGT   $B263
b257: 2e 0c           BGT   $B265
b259: 2e 0c           BGT   $B267
b25b: 2e 0c           BGT   $B269
b25d: 2e 0c           BGT   $B26B
b25f: 33 24           LEAU  $4,Y
b261: 35 18           PULS  DP,X
b263: 2e 0c           BGT   $B271
b265: 2e 0c           BGT   $B273
b267: 2e 0c           BGT   $B275
b269: 2e 0c           BGT   $B277
b26b: 2e 0c           BGT   $B279
b26d: 2e 0c           BGT   $B27B
b26f: 2e 0c           BGT   $B27D
b271: 2e 0c           BGT   $B27F
b273: 2e 0c           BGT   $B281
b275: 2e 0c           BGT   $B283
b277: 2e 0c           BGT   $B285
b279: 31 24           LEAY  $4,Y
b27b: 30 18           LEAX  -$8,X
b27d: 2e 0c           BGT   $B28B
b27f: 2e 0c           BGT   $B28D
b281: 2e 0c           BGT   $B28F
b283: 2e 0c           BGT   $B291
b285: 2e 0c           BGT   $B293
b287: 2e 0c           BGT   $B295
b289: 2e 0c           BGT   $B297
b28b: 2e 0c           BGT   $B299
b28d: 2e 0c           BGT   $B29B
b28f: 2e 0c           BGT   $B29D
b291: 2e 0c           BGT   $B29F
b293: 31 0c           LEAY  $C,X
b295: 33 0c           LEAU  $C,X
b297: 35 0c           PULS  B,DP
b299: 38              FCB   $38
b29a: 0c 3a           INC   $3A
b29c: 0c 2a           INC   $2A
b29e: 0c 2a           INC   $2A
b2a0: 0c 2a           INC   $2A
b2a2: 0c 2a           INC   $2A
b2a4: 0c 2a           INC   $2A
b2a6: 0c 2a           INC   $2A
b2a8: 0c 2a           INC   $2A
b2aa: 0c 2a           INC   $2A
b2ac: 0c 2a           INC   $2A
b2ae: 0c 2a           INC   $2A
b2b0: 0c 2a           INC   $2A
b2b2: 0c 2a           INC   $2A
b2b4: 0c 2a           INC   $2A
b2b6: 0c 2a           INC   $2A
b2b8: 0c 2a           INC   $2A
b2ba: 0c 2a           INC   $2A
b2bc: 0c 2a           INC   $2A
b2be: 0c 2a           INC   $2A
b2c0: 0c 2a           INC   $2A
b2c2: 0c 2a           INC   $2A
b2c4: 0c 2a           INC   $2A
b2c6: 0c 2a           INC   $2A
b2c8: 0c 2a           INC   $2A
b2ca: 0c 2a           INC   $2A
b2cc: 0c 2a           INC   $2A
b2ce: 0c 2a           INC   $2A
b2d0: 0c 2a           INC   $2A
b2d2: 0c 2a           INC   $2A
b2d4: 0c 2a           INC   $2A
b2d6: 0c 2a           INC   $2A
b2d8: 0c 2a           INC   $2A
b2da: 0c 2a           INC   $2A
b2dc: 0c 2a           INC   $2A
b2de: 0c 2a           INC   $2A
b2e0: 0c 2a           INC   $2A
b2e2: 0c 2a           INC   $2A
b2e4: 0c 2a           INC   $2A
b2e6: 0c 2a           INC   $2A
b2e8: 0c 2a           INC   $2A
b2ea: 0c 2a           INC   $2A
b2ec: 0c 2a           INC   $2A
b2ee: 0c 2a           INC   $2A
b2f0: 0c 2a           INC   $2A
b2f2: 0c 2a           INC   $2A
b2f4: 0c 2a           INC   $2A
b2f6: 0c 2a           INC   $2A
b2f8: 0c 2a           INC   $2A
b2fa: 0c 2a           INC   $2A
b2fc: 0c 2a           INC   $2A
b2fe: 0c 2a           INC   $2A
b300: 0c 2a           INC   $2A
b302: 0c 2a           INC   $2A
b304: 0c 2a           INC   $2A
b306: 0c 2a           INC   $2A
b308: 0c 2a           INC   $2A
b30a: 0c 2a           INC   $2A
b30c: 0c 2c           INC   $2C
b30e: 0c 2c           INC   $2C
b310: 0c 2c           INC   $2C
b312: 0c 2e           INC   $2E
b314: 0c 2e           INC   $2E
b316: 0c 2f           INC   $2F
b318: 0c 2f           INC   $2F
b31a: 0c 30           INC   $30
b31c: 0c 89           INC   $89
b31e: 78 84 dc        ASL   $84DC
b321: bb 85 c8        ADDA  $85C8
b324: 88 ff           EORA  #$FF
b326: 38              FCB   $38
b327: c0 3b           SUBB  #$3B
b329: c0 39           SUBB  #$39
b32b: c0 38           SUBB  #$38
b32d: 60 00           NEG   $0,X
b32f: 0c 38           INC   $38
b331: 0c 00           INC   $00
b333: 18              FCB   $18
b334: 38              FCB   $38
b335: 30 3a           LEAX  -$6,Y
b337: c0 3c           SUBB  #$3C
b339: c0 3a           SUBB  #$3A
b33b: c0 00           SUBB  #$00
b33d: 0c 3c           INC   $3C
b33f: 0c 00           INC   $00
b341: 18              FCB   $18
b342: 3c 30           CWAI  #$30
b344: 00 0c           NEG   $0C
b346: 3c 0c           CWAI  #$0C
b348: 00 0c           NEG   $0C
b34a: 3f              SWI
b34b: 3c 82           CWAI  #$82
b34d: 00 87           NEG   $87
b34f: 86 00           LDA   #$00
b351: 00 60           NEG   $60
b353: 80 84           SUBA  #$84
b355: db 24           ADDB  $24
b357: 85 c8           BITA  #$C8
b359: 88 e6           EORA  #$E6
b35b: 81 00           CMPA  #$00
b35d: 60 83           NEG   ,--X
b35f: 08 38           ASL   $38
b361: 06 39           ROR   $39
b363: 06 38           ROR   $38
b365: b4 38 c0        ANDA  $38C0
b368: 38              FCB   $38
b369: 06 39           ROR   $39
b36b: 06 38           ROR   $38
b36d: b4 38 84        ANDA  $3884
b370: 00 0c           NEG   $0C
b372: 84 dc           ANDA  #$DC
b374: 02 89 b4        AIM   #$89;$B4
b377: 85 c8           BITA  #$C8
b379: 88 c8           EORA  #$C8
b37b: 00 30           NEG   $30
b37d: 36 0c           PSHU  DP,B
b37f: 3d              MUL
b380: 0c 38           INC   $38
b382: 0c 36           INC   $36
b384: 0c 3d           INC   $3D
b386: 0c 36           INC   $36
b388: 0c 38           INC   $38
b38a: 0c 36           INC   $36
b38c: 0c 38           INC   $38
b38e: 0c 3f           INC   $3F
b390: 0c 3a           INC   $3A
b392: 0c 38           INC   $38
b394: 0c 3f           INC   $3F
b396: 0c 38           INC   $38
b398: 0c 3a           INC   $3A
b39a: 0c 38           INC   $38
b39c: 0c 3a           INC   $3A
b39e: 0c 41           INC   $41
b3a0: 0c 3d           INC   $3D
b3a2: 0c 46           INC   $46
b3a4: 0c 41           INC   $41
b3a6: 0c 3a           INC   $3A
b3a8: 0c 3d           INC   $3D
b3aa: 0c 41           INC   $41
b3ac: 0c 46           INC   $46
b3ae: 0c 42           INC   $42
b3b0: 0c 44           INC   $44
b3b2: 0c 41           INC   $41
b3b4: 0c 42           INC   $42
b3b6: 0c 3f           INC   $3F
b3b8: 0c 41           INC   $41
b3ba: 0c 3d           INC   $3D
b3bc: 0c 36           INC   $36
b3be: 0c 3d           INC   $3D
b3c0: 0c 38           INC   $38
b3c2: 0c 36           INC   $36
b3c4: 0c 3d           INC   $3D
b3c6: 0c 36           INC   $36
b3c8: 0c 38           INC   $38
b3ca: 0c 36           INC   $36
b3cc: 0c 38           INC   $38
b3ce: 0c 3f           INC   $3F
b3d0: 0c 3a           INC   $3A
b3d2: 0c 38           INC   $38
b3d4: 0c 3f           INC   $3F
b3d6: 0c 38           INC   $38
b3d8: 0c 3a           INC   $3A
b3da: 0c 38           INC   $38
b3dc: 0c 3a           INC   $3A
b3de: 0c 41           INC   $41
b3e0: 0c 3d           INC   $3D
b3e2: 0c 46           INC   $46
b3e4: 0c 41           INC   $41
b3e6: 0c 3a           INC   $3A
b3e8: 0c 3d           INC   $3D
b3ea: 0c 41           INC   $41
b3ec: 0c 84           INC   $84
b3ee: db 24           ADDB  $24
b3f0: 85 cd           BITA  #$CD
b3f2: 88 e6           EORA  #$E6
b3f4: 00 60           NEG   $60
b3f6: 3a              ABX
b3f7: c0 3a           SUBB  #$3A
b3f9: c0 38           SUBB  #$38
b3fb: 06 39           ROR   $39
b3fd: 06 3a           ROR   $3A
b3ff: b4 3a 84        ANDA  $3A84
b402: 00 0c           NEG   $0C
b404: 84 dc           ANDA  #$DC
b406: 02 85 c8        AIM   #$85;$C8
b409: 88 c8           EORA  #$C8
b40b: 89 b4           ADCA  #$B4
b40d: 00 30           NEG   $30
b40f: 36 0c           PSHU  DP,B
b411: 36 0c           PSHU  DP,B
b413: 3d              MUL
b414: 0c 38           INC   $38
b416: 0c 36           INC   $36
b418: 0c 3d           INC   $3D
b41a: 0c 36           INC   $36
b41c: 0c 38           INC   $38
b41e: 0c 36           INC   $36
b420: 0c 38           INC   $38
b422: 0c 3f           INC   $3F
b424: 0c 3a           INC   $3A
b426: 0c 38           INC   $38
b428: 0c 3f           INC   $3F
b42a: 0c 38           INC   $38
b42c: 0c 3a           INC   $3A
b42e: 0c 38           INC   $38
b430: 0c 3a           INC   $3A
b432: 0c 41           INC   $41
b434: 0c 3d           INC   $3D
b436: 0c 3a           INC   $3A
b438: 0c 41           INC   $41
b43a: 0c 3a           INC   $3A
b43c: 0c 3d           INC   $3D
b43e: 0c 41           INC   $41
b440: 0c 46           INC   $46
b442: 0c 42           INC   $42
b444: 0c 44           INC   $44
b446: 0c 41           INC   $41
b448: 0c 42           INC   $42
b44a: 0c 3f           INC   $3F
b44c: 0c 41           INC   $41
b44e: 0c 3d           INC   $3D
b450: 0c 36           INC   $36
b452: 0c 3d           INC   $3D
b454: 0c 38           INC   $38
b456: 0c 36           INC   $36
b458: 0c 3d           INC   $3D
b45a: 0c 36           INC   $36
b45c: 0c 38           INC   $38
b45e: 0c 36           INC   $36
b460: 0c 38           INC   $38
b462: 0c 3f           INC   $3F
b464: 0c 3a           INC   $3A
b466: 0c 38           INC   $38
b468: 0c 3f           INC   $3F
b46a: 0c 38           INC   $38
b46c: 0c 3a           INC   $3A
b46e: 0c 38           INC   $38
b470: 0c 3a           INC   $3A
b472: 0c 41           INC   $41
b474: 0c 3d           INC   $3D
b476: 0c 3a           INC   $3A
b478: 0c 41           INC   $41
b47a: 0c 3a           INC   $3A
b47c: 0c 3d           INC   $3D
b47e: 0c 38           INC   $38
b480: 06 3f           ROR   $3F
b482: 06 42           ROR   $42
b484: 06 38           ROR   $38
b486: 06 3f           ROR   $3F
b488: 06 42           ROR   $42
b48a: 06 38           ROR   $38
b48c: 06 3f           ROR   $3F
b48e: 06 42           ROR   $42
b490: 06 38           ROR   $38
b492: 06 3f           ROR   $3F
b494: 06 42           ROR   $42
b496: 06 38           ROR   $38
b498: 06 3f           ROR   $3F
b49a: 06 42           ROR   $42
b49c: 06 38           ROR   $38
b49e: 06 84           ROR   $84
b4a0: dc bb           LDD   $BB
b4a2: 89 78           ADCA  #$78
b4a4: 85 d2           BITA  #$D2
b4a6: 88 ff           EORA  #$FF
b4a8: 34 c0           PSHS  PC,U
b4aa: 36 c0           PSHU  PC,S
b4ac: 34 c0           PSHS  PC,U
b4ae: 33 60           LEAU  $0,S
b4b0: 00 0c           NEG   $0C
b4b2: 33 0c           LEAU  $C,X
b4b4: 00 18           NEG   $18
b4b6: 33 30           LEAU  -$10,Y
b4b8: 35 c0           PULS  U,PC
b4ba: 38              FCB   $38
b4bb: c0 36           SUBB  #$36
b4bd: c0 00           SUBB  #$00
b4bf: 0c 39           INC   $39
b4c1: 0c 00           INC   $00
b4c3: 18              FCB   $18
b4c4: 39              RTS
b4c5: 30 00           LEAX  $0,X
b4c7: 0c 39           INC   $39
b4c9: 0c 00           INC   $00
b4cb: 0c 3c           INC   $3C
b4cd: 3c 82           CWAI  #$82
b4cf: 00 87           NEG   $87
b4d1: 85 c3           BITA  #$C3
b4d3: 00 60           NEG   $60
b4d5: 80 84           SUBA  #$84
b4d7: d8 8a           EORB  $8A
b4d9: 85 cd           BITA  #$CD
b4db: 89 c8           ADCA  #$C8
b4dd: 81 00           CMPA  #$00
b4df: 0c 31           INC   $31
b4e1: 0c 30           INC   $30
b4e3: 0c 00           INC   $00
b4e5: 0c 31           INC   $31
b4e7: 0c 30           INC   $30
b4e9: 0c 00           INC   $00
b4eb: 0c 31           INC   $31
b4ed: 0c 00           INC   $00
b4ef: 0c 31           INC   $31
b4f1: 0c 30           INC   $30
b4f3: 0c 33           INC   $33
b4f5: 24 33           BCC   $B52A
b4f7: 18              FCB   $18
b4f8: 00 0c           NEG   $0C
b4fa: 31 0c           LEAY  $C,X
b4fc: 30 0c           LEAX  $C,X
b4fe: 00 0c           NEG   $0C
b500: 31 0c           LEAY  $C,X
b502: 30 0c           LEAX  $C,X
b504: 00 0c           NEG   $0C
b506: 31 0c           LEAY  $C,X
b508: 00 0c           NEG   $0C
b50a: 31 0c           LEAY  $C,X
b50c: 30 0c           LEAX  $C,X
b50e: 33 24           LEAU  $4,Y
b510: 33 18           LEAU  -$8,X
b512: 00 0c           NEG   $0C
b514: 31 0c           LEAY  $C,X
b516: 30 0c           LEAX  $C,X
b518: 00 0c           NEG   $0C
b51a: 31 0c           LEAY  $C,X
b51c: 30 0c           LEAX  $C,X
b51e: 00 0c           NEG   $0C
b520: 31 0c           LEAY  $C,X
b522: 00 0c           NEG   $0C
b524: 31 0c           LEAY  $C,X
b526: 30 0c           LEAX  $C,X
b528: 33 24           LEAU  $4,Y
b52a: 33 18           LEAU  -$8,X
b52c: 00 0c           NEG   $0C
b52e: 31 0c           LEAY  $C,X
b530: 30 0c           LEAX  $C,X
b532: 00 0c           NEG   $0C
b534: 31 0c           LEAY  $C,X
b536: 30 0c           LEAX  $C,X
b538: 00 0c           NEG   $0C
b53a: 35 0c           PULS  B,DP
b53c: 00 0c           NEG   $0C
b53e: 36 0c           PSHU  DP,B
b540: 00 0c           NEG   $0C
b542: 31 0c           LEAY  $C,X
b544: 33 0c           LEAU  $C,X
b546: 35 0c           PULS  B,DP
b548: 38              FCB   $38
b549: 0c 3a           INC   $3A
b54b: 0c 83           INC   $83
b54d: 02 84 d8        AIM   #$84;$D8
b550: d4 88           ANDB  $88
b552: ff 85 be        STU   $85BE
b555: 2a 60           BPL   $B5B7
b557: 2c 60           BGE   $B5B9
b559: 2e 60           BGT   $B5BB
b55b: 30 60           LEAX  $0,S
b55d: 31 60           LEAY  $0,S
b55f: 33 60           LEAU  $0,S
b561: 35 60           PULS  Y,U
b563: 84 d8           ANDA  #$D8
b565: 8a 85           ORA   #$85
b567: cd 31 0c 3d 0c  LDQ   #$310C3D0C
b56c: 3c 0c           CWAI  #$0C
b56e: 3d              MUL
b56f: 0c 3e           INC   $3E
b571: 0c 3f           INC   $3F
b573: 0c 40           INC   $40
b575: 0c 41           INC   $41
b577: 0c 00           INC   $00
b579: 0c 31           INC   $31
b57b: 0c 30           INC   $30
b57d: 0c 00           INC   $00
b57f: 0c 31           INC   $31
b581: 0c 30           INC   $30
b583: 0c 00           INC   $00
b585: 0c 31           INC   $31
b587: 0c 00           INC   $00
b589: 0c 31           INC   $31
b58b: 0c 30           INC   $30
b58d: 0c 33           INC   $33
b58f: 24 33           BCC   $B5C4
b591: 18              FCB   $18
b592: 00 0c           NEG   $0C
b594: 31 0c           LEAY  $C,X
b596: 30 0c           LEAX  $C,X
b598: 00 0c           NEG   $0C
b59a: 31 0c           LEAY  $C,X
b59c: 30 0c           LEAX  $C,X
b59e: 00 0c           NEG   $0C
b5a0: 31 0c           LEAY  $C,X
b5a2: 00 0c           NEG   $0C
b5a4: 31 0c           LEAY  $C,X
b5a6: 30 0c           LEAX  $C,X
b5a8: 33 24           LEAU  $4,Y
b5aa: 33 18           LEAU  -$8,X
b5ac: 00 0c           NEG   $0C
b5ae: 31 0c           LEAY  $C,X
b5b0: 30 0c           LEAX  $C,X
b5b2: 00 0c           NEG   $0C
b5b4: 31 0c           LEAY  $C,X
b5b6: 30 0c           LEAX  $C,X
b5b8: 00 0c           NEG   $0C
b5ba: 31 0c           LEAY  $C,X
b5bc: 00 0c           NEG   $0C
b5be: 31 0c           LEAY  $C,X
b5c0: 30 0c           LEAX  $C,X
b5c2: 33 24           LEAU  $4,Y
b5c4: 33 18           LEAU  -$8,X
b5c6: 00 0c           NEG   $0C
b5c8: 31 0c           LEAY  $C,X
b5ca: 30 0c           LEAX  $C,X
b5cc: 00 0c           NEG   $0C
b5ce: 31 0c           LEAY  $C,X
b5d0: 30 0c           LEAX  $C,X
b5d2: 00 0c           NEG   $0C
b5d4: 35 0c           PULS  B,DP
b5d6: 00 0c           NEG   $0C
b5d8: 36 0c           PSHU  DP,B
b5da: 00 0c           NEG   $0C
b5dc: 31 0c           LEAY  $C,X
b5de: 33 0c           LEAU  $C,X
b5e0: 35 0c           PULS  B,DP
b5e2: 38              FCB   $38
b5e3: 0c 3a           INC   $3A
b5e5: 0c 84           INC   $84
b5e7: d8 d4           EORB  $D4
b5e9: 88 ff           EORA  #$FF
b5eb: 85 be           BITA  #$BE
b5ed: 2a 60           BPL   $B64F
b5ef: 2c 60           BGE   $B651
b5f1: 2e 60           BGT   $B653
b5f3: 30 60           LEAX  $0,S
b5f5: 31 60           LEAY  $0,S
b5f7: 33 60           LEAU  $0,S
b5f9: 35 60           PULS  Y,U
b5fb: 84 d8           ANDA  #$D8
b5fd: 8a 85           ORA   #$85
b5ff: 00 00           NEG   $00
b601: 48              ASLA
b602: 84 dd           ANDA  #$DD
b604: 99 89           ADCA  $89
b606: be 85 dc        LDX   $85DC
b609: 86 00           LDA   #$00
b60b: 2c 06           BGE   $B613
b60d: 2f 06           BLE   $B615
b60f: 31 06           LEAY  $6,X
b611: 34 06           PSHS  B,A
b613: 36 03           PSHU  A,CC
b615: 38              FCB   $38
b616: 5d              TSTB
b617: 00 0c           NEG   $0C
b619: 34 03           PSHS  A,CC
b61b: 35 03           PULS  CC,A
b61d: 36 06           PSHU  B,A
b61f: 38              FCB   $38
b620: 0c 3d           INC   $3D
b622: 0c 3b           INC   $3B
b624: 0c 38           INC   $38
b626: 0c 36           INC   $36
b628: 0c 38           INC   $38
b62a: 0c 40           INC   $40
b62c: 03 41           COM   $41
b62e: 03 42           COM   $42
b630: 12              NOP
b631: 40              NEGA
b632: 18              FCB   $18
b633: 3f              SWI
b634: 06 40           ROR   $40
b636: 06 3f           ROR   $3F
b638: 06 3b           ROR   $3B
b63a: 06 38           ROR   $38
b63c: 0c 36           INC   $36
b63e: 0c 34           INC   $34
b640: 0c 31           INC   $31
b642: 0c 36           INC   $36
b644: 03 37           COM   $37
b646: 03 38           COM   $38
b648: 2a 31           BPL   $B67B
b64a: 0c 34           INC   $34
b64c: 0c 36           INC   $36
b64e: 0c 34           INC   $34
b650: 06 36           ROR   $36
b652: 06 38           ROR   $38
b654: 0c 36           INC   $36
b656: 06 38           ROR   $38
b658: 06 39           ROR   $39
b65a: 06 38           ROR   $38
b65c: 06 39           ROR   $39
b65e: 06 3b           ROR   $3B
b660: 06 3d           ROR   $3D
b662: 06 3f           ROR   $3F
b664: 06 40           ROR   $40
b666: 06 42           ROR   $42
b668: 06 45           ROR   $45
b66a: 04 40           LSR   $40
b66c: 04 3d           LSR   $3D
b66e: 04 44           LSR   $44
b670: 04 40           LSR   $40
b672: 04 3d           LSR   $3D
b674: 04 45           LSR   $45
b676: 04 40           LSR   $40
b678: 04 3d           LSR   $3D
b67a: 04 44           LSR   $44
b67c: 04 40           LSR   $40
b67e: 04 3d           LSR   $3D
b680: 04 45           LSR   $45
b682: 04 40           LSR   $40
b684: 04 3d           LSR   $3D
b686: 04 44           LSR   $44
b688: 04 40           LSR   $40
b68a: 04 3d           LSR   $3D
b68c: 04 45           LSR   $45
b68e: 04 40           LSR   $40
b690: 04 3d           LSR   $3D
b692: 04 44           LSR   $44
b694: 04 40           LSR   $40
b696: 04 3d           LSR   $3D
b698: 04 44           LSR   $44
b69a: 04 42           LSR   $42
b69c: 04 3f           LSR   $3F
b69e: 04 44           LSR   $44
b6a0: 04 42           LSR   $42
b6a2: 04 3f           LSR   $3F
b6a4: 04 44           LSR   $44
b6a6: 04 42           LSR   $42
b6a8: 04 3f           LSR   $3F
b6aa: 04 44           LSR   $44
b6ac: 04 42           LSR   $42
b6ae: 04 3f           LSR   $3F
b6b0: 04 44           LSR   $44
b6b2: 04 42           LSR   $42
b6b4: 04 3f           LSR   $3F
b6b6: 04 44           LSR   $44
b6b8: 04 42           LSR   $42
b6ba: 04 3f           LSR   $3F
b6bc: 04 44           LSR   $44
b6be: 04 42           LSR   $42
b6c0: 04 3f           LSR   $3F
b6c2: 04 44           LSR   $44
b6c4: 04 42           LSR   $42
b6c6: 04 3f           LSR   $3F
b6c8: 04 46           LSR   $46
b6ca: 03 47           COM   $47
b6cc: 03 48           COM   $48
b6ce: 03 49           COM   $49
b6d0: 3f              SWI
b6d1: 49              ROLA
b6d2: 0c 47           INC   $47
b6d4: 0c 46           INC   $46
b6d6: 18              FCB   $18
b6d7: 86 0c           LDA   #$0C
b6d9: 00 0c           NEG   $0C
b6db: 3c 0c           CWAI  #$0C
b6dd: 38              FCB   $38
b6de: 0c 35           INC   $35
b6e0: 0c 31           INC   $31
b6e2: 0c 30           INC   $30
b6e4: 0c 2e           INC   $2E
b6e6: 0c 2c           INC   $2C
b6e8: 0c 31           INC   $31
b6ea: 0c 35           INC   $35
b6ec: 0c 38           INC   $38
b6ee: 0c 3c           INC   $3C
b6f0: 0c 3d           INC   $3D
b6f2: 0c 3f           INC   $3F
b6f4: 0c 3c           INC   $3C
b6f6: 06 3d           ROR   $3D
b6f8: 06 3c           ROR   $3C
b6fa: 48              ASLA
b6fb: 38              FCB   $38
b6fc: 04 39           LSR   $39
b6fe: 04 3a           LSR   $3A
b700: 04 38           LSR   $38
b702: 60 00           NEG   $0,X
b704: 0c 35           INC   $35
b706: 0c 3a           INC   $3A
b708: 0c 41           INC   $41
b70a: 18              FCB   $18
b70b: 35 0c           PULS  B,DP
b70d: 3a              ABX
b70e: 0c 41           INC   $41
b710: 18              FCB   $18
b711: 35 0c           PULS  B,DP
b713: 3a              ABX
b714: 0c 41           INC   $41
b716: 18              FCB   $18
b717: 35 0c           PULS  B,DP
b719: 3a              ABX
b71a: 0c 41           INC   $41
b71c: 0c 46           INC   $46
b71e: 06 44           ROR   $44
b720: 06 42           ROR   $42
b722: 06 44           ROR   $44
b724: 06 42           ROR   $42
b726: 06 41           ROR   $41
b728: 06 42           ROR   $42
b72a: 06 41           ROR   $41
b72c: 06 3f           ROR   $3F
b72e: 06 41           ROR   $41
b730: 06 3f           ROR   $3F
b732: 06 3d           ROR   $3D
b734: 06 3f           ROR   $3F
b736: 06 3d           ROR   $3D
b738: 06 3c           ROR   $3C
b73a: 06 3a           ROR   $3A
b73c: 06 39           ROR   $39
b73e: 06 38           ROR   $38
b740: 06 36           ROR   $36
b742: 06 35           ROR   $35
b744: 06 33           ROR   $33
b746: 06 31           ROR   $31
b748: 06 30           ROR   $30
b74a: 06 2e           ROR   $2E
b74c: 06 2c           ROR   $2C
b74e: 06 2e           ROR   $2E
b750: 06 2a           ROR   $2A
b752: 06 2c           ROR   $2C
b754: 06 29           ROR   $29
b756: 06 2a           ROR   $2A
b758: 06 27           ROR   $27
b75a: 06 25           ROR   $25
b75c: 06 82           ROR   $82
b75e: 00 87           NEG   $87
b760: 85 c3           BITA  #$C3
b762: 00 60           NEG   $60
b764: 80 84           SUBA  #$84
b766: d8 8a           EORB  $8A
b768: 85 c3           BITA  #$C3
b76a: 89 c8           ADCA  #$C8
b76c: 81 00           CMPA  #$00
b76e: 0c 35           INC   $35
b770: 0c 33           INC   $33
b772: 0c 00           INC   $00
b774: 0c 35           INC   $35
b776: 0c 27           INC   $27
b778: 0c 00           INC   $00
b77a: 0c 35           INC   $35
b77c: 0c 00           INC   $00
b77e: 0c 35           INC   $35
b780: 0c 27           INC   $27
b782: 0c 38           INC   $38
b784: 24 36           BCC   $B7BC
b786: 18              FCB   $18
b787: 00 0c           NEG   $0C
b789: 35 0c           PULS  B,DP
b78b: 33 0c           LEAU  $C,X
b78d: 00 0c           NEG   $0C
b78f: 35 0c           PULS  B,DP
b791: 27 0c           BEQ   $B79F
b793: 00 0c           NEG   $0C
b795: 35 0c           PULS  B,DP
b797: 00 0c           NEG   $0C
b799: 35 0c           PULS  B,DP
b79b: 27 0c           BEQ   $B7A9
b79d: 36 24           PSHU  Y,B
b79f: 38              FCB   $38
b7a0: 18              FCB   $18
b7a1: 00 0c           NEG   $0C
b7a3: 35 0c           PULS  B,DP
b7a5: 33 0c           LEAU  $C,X
b7a7: 00 0c           NEG   $0C
b7a9: 35 0c           PULS  B,DP
b7ab: 27 0c           BEQ   $B7B9
b7ad: 00 0c           NEG   $0C
b7af: 35 0c           PULS  B,DP
b7b1: 00 0c           NEG   $0C
b7b3: 35 0c           PULS  B,DP
b7b5: 33 0c           LEAU  $C,X
b7b7: 38              FCB   $38
b7b8: 24 36           BCC   $B7F0
b7ba: 18              FCB   $18
b7bb: 00 0c           NEG   $0C
b7bd: 35 0c           PULS  B,DP
b7bf: 33 0c           LEAU  $C,X
b7c1: 00 0c           NEG   $0C
b7c3: 35 0c           PULS  B,DP
b7c5: 27 0c           BEQ   $B7D3
b7c7: 00 0c           NEG   $0C
b7c9: 38              FCB   $38
b7ca: 0c 00           INC   $00
b7cc: 0c 3a           INC   $3A
b7ce: 0c 00           INC   $00
b7d0: 0c 3d           INC   $3D
b7d2: 0c 3f           INC   $3F
b7d4: 0c 41           INC   $41
b7d6: 0c 44           INC   $44
b7d8: 0c 46           INC   $46
b7da: 0c 83           INC   $83
b7dc: 02 84 d8        AIM   #$84;$D8
b7df: d4 88           ANDB  $88
b7e1: ff 85 be        STU   $85BE
b7e4: 2e 60           BGT   $B846
b7e6: 30 60           LEAX  $0,S
b7e8: 31 60           LEAY  $0,S
b7ea: 33 60           LEAU  $0,S
b7ec: 35 60           PULS  Y,U
b7ee: 36 60           PSHU  S,Y
b7f0: 38              FCB   $38
b7f1: 60 84           NEG   ,X
b7f3: d8 8a           EORB  $8A
b7f5: 85 c3           BITA  #$C3
b7f7: 00 60           NEG   $60
b7f9: 00 0c           NEG   $0C
b7fb: 35 0c           PULS  B,DP
b7fd: 33 0c           LEAU  $C,X
b7ff: 00 0c           NEG   $0C
b801: 35 0c           PULS  B,DP
b803: 27 0c           BEQ   $B811
b805: 00 0c           NEG   $0C
b807: 35 0c           PULS  B,DP
b809: 00 0c           NEG   $0C
b80b: 35 0c           PULS  B,DP
b80d: 27 0c           BEQ   $B81B
b80f: 38              FCB   $38
b810: 24 36           BCC   $B848
b812: 18              FCB   $18
b813: 00 0c           NEG   $0C
b815: 35 0c           PULS  B,DP
b817: 33 0c           LEAU  $C,X
b819: 00 0c           NEG   $0C
b81b: 35 0c           PULS  B,DP
b81d: 27 0c           BEQ   $B82B
b81f: 00 0c           NEG   $0C
b821: 35 0c           PULS  B,DP
b823: 00 0c           NEG   $0C
b825: 35 0c           PULS  B,DP
b827: 27 0c           BEQ   $B835
b829: 36 24           PSHU  Y,B
b82b: 38              FCB   $38
b82c: 18              FCB   $18
b82d: 00 0c           NEG   $0C
b82f: 35 0c           PULS  B,DP
b831: 33 0c           LEAU  $C,X
b833: 00 0c           NEG   $0C
b835: 35 0c           PULS  B,DP
b837: 27 0c           BEQ   $B845
b839: 00 0c           NEG   $0C
b83b: 35 0c           PULS  B,DP
b83d: 00 0c           NEG   $0C
b83f: 35 0c           PULS  B,DP
b841: 33 0c           LEAU  $C,X
b843: 38              FCB   $38
b844: 24 36           BCC   $B87C
b846: 18              FCB   $18
b847: 00 0c           NEG   $0C
b849: 35 0c           PULS  B,DP
b84b: 33 0c           LEAU  $C,X
b84d: 00 0c           NEG   $0C
b84f: 35 0c           PULS  B,DP
b851: 27 0c           BEQ   $B85F
b853: 00 0c           NEG   $0C
b855: 38              FCB   $38
b856: 0c 00           INC   $00
b858: 0c 3a           INC   $3A
b85a: 0c 00           INC   $00
b85c: 0c 3d           INC   $3D
b85e: 0c 3f           INC   $3F
b860: 0c 41           INC   $41
b862: 0c 44           INC   $44
b864: 0c 46           INC   $46
b866: 0c 84           INC   $84
b868: d8 d4           EORB  $D4
b86a: 88 ff           EORA  #$FF
b86c: 85 be           BITA  #$BE
b86e: 2e 60           BGT   $B8D0
b870: 30 60           LEAX  $0,S
b872: 31 60           LEAY  $0,S
b874: 33 60           LEAU  $0,S
b876: 35 60           PULS  Y,U
b878: 36 60           PSHU  S,Y
b87a: 38              FCB   $38
b87b: 60 00           NEG   $0,X
b87d: 60 00           NEG   $0,X
b87f: 60 00           NEG   $0,X
b881: 60 00           NEG   $0,X
b883: 60 00           NEG   $0,X
b885: 60 00           NEG   $0,X
b887: 60 00           NEG   $0,X
b889: 60 00           NEG   $0,X
b88b: 60 00           NEG   $0,X
b88d: 60 00           NEG   $0,X
b88f: 60 00           NEG   $0,X
b891: 60 00           NEG   $0,X
b893: 60 00           NEG   $0,X
b895: 60 00           NEG   $0,X
b897: 60 00           NEG   $0,X
b899: 60 00           NEG   $0,X
b89b: 60 00           NEG   $0,X
b89d: 60 82           NEG   ,-X
b89f: 00 87           NEG   $87
b8a1: 86 00           LDA   #$00
b8a3: 85 e6           BITA  #$E6
b8a5: 00 60           NEG   $60
b8a7: 80 81           SUBA  #$81
b8a9: 22 0c           BHI   $B8B7
b8ab: 22 0c           BHI   $B8B9
b8ad: 22 0c           BHI   $B8BB
b8af: 22 0c           BHI   $B8BD
b8b1: 22 0c           BHI   $B8BF
b8b3: 22 0c           BHI   $B8C1
b8b5: 22 0c           BHI   $B8C3
b8b7: 22 0c           BHI   $B8C5
b8b9: 22 0c           BHI   $B8C7
b8bb: 22 0c           BHI   $B8C9
b8bd: 22 0c           BHI   $B8CB
b8bf: 25 0c           BCS   $B8CD
b8c1: 25 0c           BCS   $B8CF
b8c3: 25 0c           BCS   $B8D1
b8c5: 24 0c           BCC   $B8D3
b8c7: 24 0c           BCC   $B8D5
b8c9: 22 0c           BHI   $B8D7
b8cb: 22 0c           BHI   $B8D9
b8cd: 22 0c           BHI   $B8DB
b8cf: 22 0c           BHI   $B8DD
b8d1: 22 0c           BHI   $B8DF
b8d3: 22 0c           BHI   $B8E1
b8d5: 22 0c           BHI   $B8E3
b8d7: 22 0c           BHI   $B8E5
b8d9: 22 0c           BHI   $B8E7
b8db: 22 0c           BHI   $B8E9
b8dd: 22 0c           BHI   $B8EB
b8df: 27 0c           BEQ   $B8ED
b8e1: 27 0c           BEQ   $B8EF
b8e3: 27 0c           BEQ   $B8F1
b8e5: 29 0c           BVS   $B8F3
b8e7: 29 0c           BVS   $B8F5
b8e9: 22 0c           BHI   $B8F7
b8eb: 22 0c           BHI   $B8F9
b8ed: 22 0c           BHI   $B8FB
b8ef: 22 0c           BHI   $B8FD
b8f1: 22 0c           BHI   $B8FF
b8f3: 22 0c           BHI   $B901
b8f5: 22 0c           BHI   $B903
b8f7: 22 0c           BHI   $B905
b8f9: 22 0c           BHI   $B907
b8fb: 22 0c           BHI   $B909
b8fd: 22 0c           BHI   $B90B
b8ff: 25 0c           BCS   $B90D
b901: 25 0c           BCS   $B90F
b903: 25 0c           BCS   $B911
b905: 24 0c           BCC   $B913
b907: 24 0c           BCC   $B915
b909: 22 0c           BHI   $B917
b90b: 22 0c           BHI   $B919
b90d: 22 0c           BHI   $B91B
b90f: 22 0c           BHI   $B91D
b911: 22 0c           BHI   $B91F
b913: 22 0c           BHI   $B921
b915: 22 0c           BHI   $B923
b917: 22 0c           BHI   $B925
b919: 22 0c           BHI   $B927
b91b: 22 0c           BHI   $B929
b91d: 22 0c           BHI   $B92B
b91f: 25 0c           BCS   $B92D
b921: 27 0c           BEQ   $B92F
b923: 29 0c           BVS   $B931
b925: 2c 0c           BGE   $B933
b927: 2e 0c           BGT   $B935
b929: 83 02 1e        SUBD  #$021E
b92c: 0c 1e           INC   $1E
b92e: 0c 1e           INC   $1E
b930: 0c 1e           INC   $1E
b932: 0c 1e           INC   $1E
b934: 0c 1e           INC   $1E
b936: 0c 1e           INC   $1E
b938: 0c 1e           INC   $1E
b93a: 0c 1e           INC   $1E
b93c: 0c 1e           INC   $1E
b93e: 0c 1e           INC   $1E
b940: 0c 1e           INC   $1E
b942: 0c 1e           INC   $1E
b944: 0c 1e           INC   $1E
b946: 0c 1e           INC   $1E
b948: 0c 1e           INC   $1E
b94a: 0c 1e           INC   $1E
b94c: 0c 1e           INC   $1E
b94e: 0c 1e           INC   $1E
b950: 0c 1e           INC   $1E
b952: 0c 1e           INC   $1E
b954: 0c 1e           INC   $1E
b956: 0c 1e           INC   $1E
b958: 0c 1e           INC   $1E
b95a: 0c 1e           INC   $1E
b95c: 0c 1e           INC   $1E
b95e: 0c 1e           INC   $1E
b960: 0c 1e           INC   $1E
b962: 0c 1e           INC   $1E
b964: 0c 1e           INC   $1E
b966: 0c 1e           INC   $1E
b968: 0c 1e           INC   $1E
b96a: 0c 1e           INC   $1E
b96c: 0c 1e           INC   $1E
b96e: 0c 1e           INC   $1E
b970: 0c 1e           INC   $1E
b972: 0c 1e           INC   $1E
b974: 0c 1e           INC   $1E
b976: 0c 1e           INC   $1E
b978: 0c 1e           INC   $1E
b97a: 0c 1e           INC   $1E
b97c: 0c 1e           INC   $1E
b97e: 0c 1e           INC   $1E
b980: 0c 1e           INC   $1E
b982: 0c 1e           INC   $1E
b984: 0c 1e           INC   $1E
b986: 0c 1e           INC   $1E
b988: 0c 1e           INC   $1E
b98a: 0c 1e           INC   $1E
b98c: 0c 1e           INC   $1E
b98e: 0c 1e           INC   $1E
b990: 0c 1e           INC   $1E
b992: 0c 1e           INC   $1E
b994: 0c 1e           INC   $1E
b996: 0c 1e           INC   $1E
b998: 0c 1e           INC   $1E
b99a: 0c 25           INC   $25
b99c: 0c 25           INC   $25
b99e: 0c 24           INC   $24
b9a0: 0c 25           INC   $25
b9a2: 0c 26           INC   $26
b9a4: 0c 27           INC   $27
b9a6: 0c 28           INC   $28
b9a8: 0c 29           INC   $29
b9aa: 0c 22           INC   $22
b9ac: 0c 22           INC   $22
b9ae: 0c 22           INC   $22
b9b0: 0c 22           INC   $22
b9b2: 0c 22           INC   $22
b9b4: 0c 22           INC   $22
b9b6: 0c 22           INC   $22
b9b8: 0c 22           INC   $22
b9ba: 0c 22           INC   $22
b9bc: 0c 22           INC   $22
b9be: 0c 22           INC   $22
b9c0: 0c 25           INC   $25
b9c2: 0c 25           INC   $25
b9c4: 0c 25           INC   $25
b9c6: 0c 24           INC   $24
b9c8: 0c 24           INC   $24
b9ca: 0c 22           INC   $22
b9cc: 0c 22           INC   $22
b9ce: 0c 22           INC   $22
b9d0: 0c 22           INC   $22
b9d2: 0c 22           INC   $22
b9d4: 0c 22           INC   $22
b9d6: 0c 22           INC   $22
b9d8: 0c 22           INC   $22
b9da: 0c 22           INC   $22
b9dc: 0c 22           INC   $22
b9de: 0c 22           INC   $22
b9e0: 0c 27           INC   $27
b9e2: 0c 27           INC   $27
b9e4: 0c 27           INC   $27
b9e6: 0c 29           INC   $29
b9e8: 0c 29           INC   $29
b9ea: 0c 22           INC   $22
b9ec: 0c 22           INC   $22
b9ee: 0c 22           INC   $22
b9f0: 0c 22           INC   $22
b9f2: 0c 22           INC   $22
b9f4: 0c 22           INC   $22
b9f6: 0c 22           INC   $22
b9f8: 0c 22           INC   $22
b9fa: 0c 22           INC   $22
b9fc: 0c 22           INC   $22
b9fe: 0c 22           INC   $22
ba00: 0c 25           INC   $25
ba02: 0c 25           INC   $25
ba04: 0c 25           INC   $25
ba06: 0c 24           INC   $24
ba08: 0c 24           INC   $24
ba0a: 0c 22           INC   $22
ba0c: 0c 22           INC   $22
ba0e: 0c 22           INC   $22
ba10: 0c 22           INC   $22
ba12: 0c 22           INC   $22
ba14: 0c 22           INC   $22
ba16: 0c 22           INC   $22
ba18: 0c 22           INC   $22
ba1a: 0c 22           INC   $22
ba1c: 0c 22           INC   $22
ba1e: 0c 22           INC   $22
ba20: 0c 25           INC   $25
ba22: 0c 27           INC   $27
ba24: 0c 29           INC   $29
ba26: 0c 2c           INC   $2C
ba28: 0c 2e           INC   $2E
ba2a: 0c 1e           INC   $1E
ba2c: 0c 1e           INC   $1E
ba2e: 0c 1e           INC   $1E
ba30: 0c 1e           INC   $1E
ba32: 0c 1e           INC   $1E
ba34: 0c 1e           INC   $1E
ba36: 0c 1e           INC   $1E
ba38: 0c 1e           INC   $1E
ba3a: 0c 1e           INC   $1E
ba3c: 0c 1e           INC   $1E
ba3e: 0c 1e           INC   $1E
ba40: 0c 1e           INC   $1E
ba42: 0c 1e           INC   $1E
ba44: 0c 1e           INC   $1E
ba46: 0c 1e           INC   $1E
ba48: 0c 1e           INC   $1E
ba4a: 0c 1e           INC   $1E
ba4c: 0c 1e           INC   $1E
ba4e: 0c 1e           INC   $1E
ba50: 0c 1e           INC   $1E
ba52: 0c 1e           INC   $1E
ba54: 0c 1e           INC   $1E
ba56: 0c 1e           INC   $1E
ba58: 0c 1e           INC   $1E
ba5a: 0c 1e           INC   $1E
ba5c: 0c 1e           INC   $1E
ba5e: 0c 1e           INC   $1E
ba60: 0c 1e           INC   $1E
ba62: 0c 1e           INC   $1E
ba64: 0c 1e           INC   $1E
ba66: 0c 1e           INC   $1E
ba68: 0c 1e           INC   $1E
ba6a: 0c 1e           INC   $1E
ba6c: 0c 1e           INC   $1E
ba6e: 0c 1e           INC   $1E
ba70: 0c 1e           INC   $1E
ba72: 0c 1e           INC   $1E
ba74: 0c 1e           INC   $1E
ba76: 0c 1e           INC   $1E
ba78: 0c 1e           INC   $1E
ba7a: 0c 1e           INC   $1E
ba7c: 0c 1e           INC   $1E
ba7e: 0c 1e           INC   $1E
ba80: 0c 1e           INC   $1E
ba82: 0c 1e           INC   $1E
ba84: 0c 1e           INC   $1E
ba86: 0c 1e           INC   $1E
ba88: 0c 1e           INC   $1E
ba8a: 0c 1e           INC   $1E
ba8c: 0c 1e           INC   $1E
ba8e: 0c 1e           INC   $1E
ba90: 0c 1e           INC   $1E
ba92: 0c 1e           INC   $1E
ba94: 0c 1e           INC   $1E
ba96: 0c 1e           INC   $1E
ba98: 0c 1e           INC   $1E
ba9a: 0c 25           INC   $25
ba9c: 0c 25           INC   $25
ba9e: 0c 24           INC   $24
baa0: 0c 25           INC   $25
baa2: 0c 26           INC   $26
baa4: 0c 27           INC   $27
baa6: 0c 28           INC   $28
baa8: 0c 29           INC   $29
baaa: 0c 85           INC   $85
baac: dc 25           LDD   $25
baae: 0c 25           INC   $25
bab0: 0c 25           INC   $25
bab2: 0c 25           INC   $25
bab4: 0c 25           INC   $25
bab6: 0c 25           INC   $25
bab8: 0c 25           INC   $25
baba: 0c 25           INC   $25
babc: 0c 25           INC   $25
babe: 0c 25           INC   $25
bac0: 0c 25           INC   $25
bac2: 0c 25           INC   $25
bac4: 0c 25           INC   $25
bac6: 0c 25           INC   $25
bac8: 0c 25           INC   $25
baca: 0c 25           INC   $25
bacc: 0c 23           INC   $23
bace: 0c 23           INC   $23
bad0: 0c 23           INC   $23
bad2: 0c 23           INC   $23
bad4: 0c 23           INC   $23
bad6: 0c 23           INC   $23
bad8: 0c 23           INC   $23
bada: 0c 23           INC   $23
badc: 0c 23           INC   $23
bade: 0c 23           INC   $23
bae0: 0c 23           INC   $23
bae2: 0c 23           INC   $23
bae4: 0c 23           INC   $23
bae6: 0c 23           INC   $23
bae8: 0c 23           INC   $23
baea: 0c 23           INC   $23
baec: 0c 21           INC   $21
baee: 0c 21           INC   $21
baf0: 0c 21           INC   $21
baf2: 0c 21           INC   $21
baf4: 0c 21           INC   $21
baf6: 0c 21           INC   $21
baf8: 0c 21           INC   $21
bafa: 0c 21           INC   $21
bafc: 0c 21           INC   $21
bafe: 0c 21           INC   $21
bb00: 0c 21           INC   $21
bb02: 0c 21           INC   $21
bb04: 0c 21           INC   $21
bb06: 0c 21           INC   $21
bb08: 0c 21           INC   $21
bb0a: 0c 21           INC   $21
bb0c: 0c 20           INC   $20
bb0e: 0c 20           INC   $20
bb10: 0c 20           INC   $20
bb12: 0c 20           INC   $20
bb14: 0c 20           INC   $20
bb16: 0c 20           INC   $20
bb18: 0c 20           INC   $20
bb1a: 0c 20           INC   $20
bb1c: 0c 00           INC   $00
bb1e: 0c 20           INC   $20
bb20: 0c 00           INC   $00
bb22: 18              FCB   $18
bb23: 20 18           BRA   $BB3D
bb25: 20 0c           BRA   $BB33
bb27: 21 0c           BRN   $BB35
bb29: 22 0c           BHI   $BB37
bb2b: 22 0c           BHI   $BB39
bb2d: 22 0c           BHI   $BB3B
bb2f: 22 0c           BHI   $BB3D
bb31: 22 0c           BHI   $BB3F
bb33: 22 0c           BHI   $BB41
bb35: 22 0c           BHI   $BB43
bb37: 22 0c           BHI   $BB45
bb39: 22 0c           BHI   $BB47
bb3b: 22 0c           BHI   $BB49
bb3d: 22 0c           BHI   $BB4B
bb3f: 22 0c           BHI   $BB4D
bb41: 22 0c           BHI   $BB4F
bb43: 22 0c           BHI   $BB51
bb45: 22 0c           BHI   $BB53
bb47: 22 0c           BHI   $BB55
bb49: 20 0c           BRA   $BB57
bb4b: 20 0c           BRA   $BB59
bb4d: 20 0c           BRA   $BB5B
bb4f: 20 0c           BRA   $BB5D
bb51: 20 0c           BRA   $BB5F
bb53: 20 0c           BRA   $BB61
bb55: 20 0c           BRA   $BB63
bb57: 20 0c           BRA   $BB65
bb59: 20 0c           BRA   $BB67
bb5b: 20 0c           BRA   $BB69
bb5d: 20 0c           BRA   $BB6B
bb5f: 20 0c           BRA   $BB6D
bb61: 20 0c           BRA   $BB6F
bb63: 20 0c           BRA   $BB71
bb65: 20 0c           BRA   $BB73
bb67: 20 0c           BRA   $BB75
bb69: 1e 0c           EXG   D,0
bb6b: 1e 0c           EXG   D,0
bb6d: 1e 0c           EXG   D,0
bb6f: 1e 0c           EXG   D,0
bb71: 1e 0c           EXG   D,0
bb73: 1e 0c           EXG   D,0
bb75: 1e 0c           EXG   D,0
bb77: 1e 0c           EXG   D,0
bb79: 1e 0c           EXG   D,0
bb7b: 1e 0c           EXG   D,0
bb7d: 1e 0c           EXG   D,0
bb7f: 1e 0c           EXG   D,0
bb81: 1e 0c           EXG   D,0
bb83: 1e 0c           EXG   D,0
bb85: 1e 0c           EXG   D,0
bb87: 1e 0c           EXG   D,0
bb89: 00 0c           NEG   $0C
bb8b: 1d              SEX
bb8c: 0c 00           INC   $00
bb8e: 18              FCB   $18
bb8f: 1d              SEX
bb90: 30 00           LEAX  $0,X
bb92: 0c 1d           INC   $1D
bb94: 0c 00           INC   $00
bb96: 0c 1d           INC   $1D
bb98: 0c 1d           INC   $1D
bb9a: 0c 20           INC   $20
bb9c: 0c 21           INC   $21
bb9e: 0c 22           INC   $22
bba0: 0c 82           INC   $82
bba2: 00 87           NEG   $87
bba4: 86 00           LDA   #$00
bba6: 85 d2           BITA  #$D2
bba8: 00 60           NEG   $60
bbaa: 80 31           SUBA  #$31
bbac: 0c 31           INC   $31
bbae: 0c 31           INC   $31
bbb0: 0c 31           INC   $31
bbb2: 0c 31           INC   $31
bbb4: 0c 31           INC   $31
bbb6: 0c 31           INC   $31
bbb8: 0c 31           INC   $31
bbba: 0c 82           INC   $82
bbbc: 00 87           NEG   $87
bbbe: 86 00           LDA   #$00
bbc0: 85 e6           BITA  #$E6
bbc2: 00 30           NEG   $30
bbc4: 2a 06           BPL   $BBCC
bbc6: 22 06           BHI   $BBCE
bbc8: 1d              SEX
bbc9: 0c 25           INC   $25
bbcb: 0c 29           INC   $29
bbcd: 06 29           ROR   $29
bbcf: 06 85           ROR   $85
bbd1: d2 80           SBCB  $80
bbd3: 84 de           ANDA  #$DE
bbd5: 77 85 e6        ASR   $85E6
bbd8: 22 18           BHI   $BBF2
bbda: 84 de           ANDA  #$DE
bbdc: 52              FCB   $52
bbdd: 85 d2           BITA  #$D2
bbdf: 31 0c           LEAY  $C,X
bbe1: 00 0c           NEG   $0C
bbe3: 84 de           ANDA  #$DE
bbe5: 77 85 e6        ASR   $85E6
bbe8: 22 18           BHI   $BC02
bbea: 84 de           ANDA  #$DE
bbec: 52              FCB   $52
bbed: 85 d2           BITA  #$D2
bbef: 31 0c           LEAY  $C,X
bbf1: 00 0c           NEG   $0C
bbf3: 84 de           ANDA  #$DE
bbf5: 77 85 e6        ASR   $85E6
bbf8: 22 18           BHI   $BC12
bbfa: 84 de           ANDA  #$DE
bbfc: 52              FCB   $52
bbfd: 85 d2           BITA  #$D2
bbff: 31 0c           LEAY  $C,X
bc01: 84 de           ANDA  #$DE
bc03: 77 85 e6        ASR   $85E6
bc06: 22 0c           BHI   $BC14
bc08: 00 0c           NEG   $0C
bc0a: 22 0c           BHI   $BC18
bc0c: 84 de           ANDA  #$DE
bc0e: 52              FCB   $52
bc0f: 85 d2           BITA  #$D2
bc11: 31 0c           LEAY  $C,X
bc13: 84 de           ANDA  #$DE
bc15: 77 85 e6        ASR   $85E6
bc18: 22 0c           BHI   $BC26
bc1a: 82 00           SBCA  #$00
bc1c: 87              FCB   $87
bc1d: 07 ea           ASR   $EA
bc1f: bc 3b d8        CMPX  $3BD8
bc22: af bd c0 d8     STX   [$7CFE,PCR]
bc26: af be           STX   [W,Y]
bc28: f4 d8 af        ANDB  $D8AF
bc2b: c0 28           SUBB  #$28
bc2d: d8 af           EORB  $AF
bc2f: c0 98           SUBB  #$98
bc31: d8 af           EORB  $AF
bc33: c2 ad           SBCB  #$AD
bc35: de 2d           LDU   $2D
bc37: c2 d1           SBCB  #$D1
bc39: de 52           LDU   $52
bc3b: 86 00           LDA   #$00
bc3d: 85 d2           BITA  #$D2
bc3f: 88 e6           EORA  #$E6
bc41: 1d              SEX
bc42: c0 00           SUBB  #$00
bc44: c0 85           SUBB  #$85
bc46: dc 80           LDD   $80
bc48: 2e 48           BGT   $BC92
bc4a: 2c 0c           BGE   $BC58
bc4c: 29 60           BVS   $BCAE
bc4e: 25 0c           BCS   $BC5C
bc50: 29 0c           BVS   $BC5E
bc52: 27 3c           BEQ   $BC90
bc54: 25 0c           BCS   $BC62
bc56: 22 6c           BHI   $BCC4
bc58: 2e 48           BGT   $BCA2
bc5a: 31 0c           LEAY  $C,X
bc5c: 2e 60           BGT   $BCBE
bc5e: 2e 0c           BGT   $BC6C
bc60: 31 0c           LEAY  $C,X
bc62: 32 0c           LEAS  $C,X
bc64: 33 30           LEAU  -$10,Y
bc66: 35 0c           PULS  B,DP
bc68: 2e 6c           BGT   $BCD6
bc6a: 00 60           NEG   $60
bc6c: 00 60           NEG   $60
bc6e: 00 18           NEG   $18
bc70: 46              RORA
bc71: 18              FCB   $18
bc72: 00 30           NEG   $30
bc74: 00 0c           NEG   $0C
bc76: 46              RORA
bc77: 0c 00           INC   $00
bc79: 18              FCB   $18
bc7a: 00 30           NEG   $30
bc7c: 00 18           NEG   $18
bc7e: 46              RORA
bc7f: 18              FCB   $18
bc80: 00 0c           NEG   $0C
bc82: 49              ROLA
bc83: 0c 46           INC   $46
bc85: 0c 00           INC   $00
bc87: 0c 00           INC   $00
bc89: 0c 46           INC   $46
bc8b: 0c 00           INC   $00
bc8d: 18              FCB   $18
bc8e: 00 30           NEG   $30
bc90: 00 18           NEG   $18
bc92: 46              RORA
bc93: 18              FCB   $18
bc94: 00 0c           NEG   $0C
bc96: 49              ROLA
bc97: 0c 46           INC   $46
bc99: 0c 00           INC   $00
bc9b: 0c 00           INC   $00
bc9d: 0c 46           INC   $46
bc9f: 0c 00           INC   $00
bca1: 18              FCB   $18
bca2: 84 dd           ANDA  #$DD
bca4: 99 85           ADCA  $85
bca6: d2 86           SBCB  $86
bca8: f4 00 30        ANDB  >$0030
bcab: 81 38           CMPA  #$38
bcad: 06 3a           ROR   $3A
bcaf: 06 3a           ROR   $3A
bcb1: 06 3a           ROR   $3A
bcb3: 06 3a           ROR   $3A
bcb5: 06 3a           ROR   $3A
bcb7: 06 3a           ROR   $3A
bcb9: 06 3a           ROR   $3A
bcbb: 06 3a           ROR   $3A
bcbd: 06 3a           ROR   $3A
bcbf: 06 3a           ROR   $3A
bcc1: 06 3a           ROR   $3A
bcc3: 06 3d           ROR   $3D
bcc5: 18              FCB   $18
bcc6: 38              FCB   $38
bcc7: 06 3a           ROR   $3A
bcc9: 06 3a           ROR   $3A
bccb: 06 3a           ROR   $3A
bccd: 06 3a           ROR   $3A
bccf: 06 3a           ROR   $3A
bcd1: 06 3a           ROR   $3A
bcd3: 06 3a           ROR   $3A
bcd5: 06 3a           ROR   $3A
bcd7: 06 3a           ROR   $3A
bcd9: 06 3a           ROR   $3A
bcdb: 06 3a           ROR   $3A
bcdd: 06 3f           ROR   $3F
bcdf: 0c 3d           INC   $3D
bce1: 0c 38           INC   $38
bce3: 06 3a           ROR   $3A
bce5: 06 3a           ROR   $3A
bce7: 06 3a           ROR   $3A
bce9: 06 3a           ROR   $3A
bceb: 06 3a           ROR   $3A
bced: 06 3a           ROR   $3A
bcef: 06 3a           ROR   $3A
bcf1: 06 3a           ROR   $3A
bcf3: 06 3a           ROR   $3A
bcf5: 06 3a           ROR   $3A
bcf7: 06 3a           ROR   $3A
bcf9: 06 3a           ROR   $3A
bcfb: 06 3d           ROR   $3D
bcfd: 12              NOP
bcfe: 38              FCB   $38
bcff: 06 3a           ROR   $3A
bd01: 06 3a           ROR   $3A
bd03: 06 3a           ROR   $3A
bd05: 06 3a           ROR   $3A
bd07: 06 41           ROR   $41
bd09: 06 3a           ROR   $3A
bd0b: 06 3a           ROR   $3A
bd0d: 06 3f           ROR   $3F
bd0f: 06 3a           ROR   $3A
bd11: 06 3a           ROR   $3A
bd13: 06 3d           ROR   $3D
bd15: 06 3a           ROR   $3A
bd17: 06 3a           ROR   $3A
bd19: 06 38           ROR   $38
bd1b: 06 3a           ROR   $3A
bd1d: 06 83           ROR   $83
bd1f: 02 84 dc        AIM   #$84;$DC
bd22: 96 85           LDA   $85
bd24: d2 86           SBCB  $86
bd26: f4 00 60        ANDB  >$0060
bd29: 00 60           NEG   $60
bd2b: 81 33           CMPA  #$33
bd2d: 06 38           ROR   $38
bd2f: 06 3d           ROR   $3D
bd31: 06 33           ROR   $33
bd33: 06 38           ROR   $38
bd35: 06 3d           ROR   $3D
bd37: 06 33           ROR   $33
bd39: 06 38           ROR   $38
bd3b: 06 3d           ROR   $3D
bd3d: 06 33           ROR   $33
bd3f: 06 38           ROR   $38
bd41: 06 3d           ROR   $3D
bd43: 06 33           ROR   $33
bd45: 06 38           ROR   $38
bd47: 06 3d           ROR   $3D
bd49: 06 33           ROR   $33
bd4b: 06 35           ROR   $35
bd4d: 06 3a           ROR   $3A
bd4f: 06 3f           ROR   $3F
bd51: 06 35           ROR   $35
bd53: 06 3a           ROR   $3A
bd55: 06 3f           ROR   $3F
bd57: 06 35           ROR   $35
bd59: 06 3a           ROR   $3A
bd5b: 06 3f           ROR   $3F
bd5d: 06 35           ROR   $35
bd5f: 06 3a           ROR   $3A
bd61: 06 3f           ROR   $3F
bd63: 06 35           ROR   $35
bd65: 06 3a           ROR   $3A
bd67: 06 3f           ROR   $3F
bd69: 06 35           ROR   $35
bd6b: 06 36           ROR   $36
bd6d: 06 3c           ROR   $3C
bd6f: 06 41           ROR   $41
bd71: 06 36           ROR   $36
bd73: 06 3c           ROR   $3C
bd75: 06 41           ROR   $41
bd77: 06 36           ROR   $36
bd79: 06 3c           ROR   $3C
bd7b: 06 41           ROR   $41
bd7d: 06 36           ROR   $36
bd7f: 06 3c           ROR   $3C
bd81: 06 41           ROR   $41
bd83: 06 36           ROR   $36
bd85: 06 3c           ROR   $3C
bd87: 06 41           ROR   $41
bd89: 06 36           ROR   $36
bd8b: 06 35           ROR   $35
bd8d: 06 3a           ROR   $3A
bd8f: 06 3f           ROR   $3F
bd91: 06 35           ROR   $35
bd93: 06 3a           ROR   $3A
bd95: 06 3f           ROR   $3F
bd97: 06 35           ROR   $35
bd99: 06 3a           ROR   $3A
bd9b: 06 3f           ROR   $3F
bd9d: 06 35           ROR   $35
bd9f: 06 3a           ROR   $3A
bda1: 06 3f           ROR   $3F
bda3: 06 35           ROR   $35
bda5: 06 3a           ROR   $3A
bda7: 06 3f           ROR   $3F
bda9: 06 35           ROR   $35
bdab: 06 83           ROR   $83
bdad: 02 84 d8        AIM   #$84;$D8
bdb0: af 85           STX   B,X
bdb2: dc 86           LDD   $86
bdb4: 00 00           NEG   $00
bdb6: 60 00           NEG   $0,X
bdb8: 60 00           NEG   $0,X
bdba: 60 00           NEG   $0,X
bdbc: 60 82           NEG   ,-X
bdbe: 00 87           NEG   $87
bdc0: 86 00           LDA   #$00
bdc2: 85 d2           BITA  #$D2
bdc4: 88 e6           EORA  #$E6
bdc6: 00 30           NEG   $30
bdc8: 21 c0           BRN   $BD8A
bdca: 30 90           LEAX  [,W]
bdcc: 85 dc           BITA  #$DC
bdce: 80 3a           SUBA  #$3A
bdd0: 48              ASLA
bdd1: 38              FCB   $38
bdd2: 0c 35           INC   $35
bdd4: 60 31           NEG   -$F,Y
bdd6: 0c 35           INC   $35
bdd8: 0c 33           INC   $33
bdda: 3c 31           CWAI  #$31
bddc: 0c 3a           INC   $3A
bdde: 6c 3a           INC   -$6,Y
bde0: 48              ASLA
bde1: 3d              MUL
bde2: 0c 3a           INC   $3A
bde4: 60 3a           NEG   -$6,Y
bde6: 0c 3d           INC   $3D
bde8: 0c 3e           INC   $3E
bdea: 0c 3f           INC   $3F
bdec: 30 41           LEAX  $1,U
bdee: 0c 3a           INC   $3A
bdf0: 6c 00           INC   $0,X
bdf2: 60 00           NEG   $0,X
bdf4: 60 00           NEG   $0,X
bdf6: 18              FCB   $18
bdf7: 41              FCB   $41
bdf8: 18              FCB   $18
bdf9: 00 30           NEG   $30
bdfb: 00 0c           NEG   $0C
bdfd: 41              FCB   $41
bdfe: 0c 00           INC   $00
be00: 18              FCB   $18
be01: 00 30           NEG   $30
be03: 00 18           NEG   $18
be05: 41              FCB   $41
be06: 18              FCB   $18
be07: 00 0c           NEG   $0C
be09: 50              NEGB
be0a: 0c 41           INC   $41
be0c: 0c 00           INC   $00
be0e: 0c 00           INC   $00
be10: 0c 41           INC   $41
be12: 0c 00           INC   $00
be14: 18              FCB   $18
be15: 00 30           NEG   $30
be17: 00 18           NEG   $18
be19: 41              FCB   $41
be1a: 18              FCB   $18
be1b: 00 0c           NEG   $0C
be1d: 50              NEGB
be1e: 0c 41           INC   $41
be20: 0c 00           INC   $00
be22: 0c 00           INC   $00
be24: 0c 41           INC   $41
be26: 0c 00           INC   $00
be28: 18              FCB   $18
be29: 85 be           BITA  #$BE
be2b: 00 30           NEG   $30
be2d: 81 41           CMPA  #$41
be2f: 48              ASLA
be30: 44              LSRA
be31: 18              FCB   $18
be32: 41              FCB   $41
be33: 48              ASLA
be34: 46              RORA
be35: 0c 44           INC   $44
be37: 0c 41           INC   $41
be39: 48              ASLA
be3a: 00 06           NEG   $06
be3c: 44              LSRA
be3d: 12              NOP
be3e: 41              FCB   $41
be3f: 18              FCB   $18
be40: 00 06           NEG   $06
be42: 48              ASLA
be43: 06 00           ROR   $00
be45: 0c 46           INC   $46
be47: 06 00           ROR   $00
be49: 0c 44           INC   $44
be4b: 06 00           ROR   $00
be4d: 0c 3f           INC   $3F
be4f: 06 41           ROR   $41
be51: 06 83           ROR   $83
be53: 02 00 60        AIM   #$00;$60
be56: 84 dc           ANDA  #$DC
be58: 96 85           LDA   $85
be5a: d2 86           SBCB  $86
be5c: 00 00           NEG   $00
be5e: 60 81           NEG   ,X++
be60: 33 06           LEAU  $6,X
be62: 2c 06           BGE   $BE6A
be64: 31 06           LEAY  $6,X
be66: 33 06           LEAU  $6,X
be68: 31 06           LEAY  $6,X
be6a: 33 06           LEAU  $6,X
be6c: 2c 06           BGE   $BE74
be6e: 31 06           LEAY  $6,X
be70: 33 06           LEAU  $6,X
be72: 2c 06           BGE   $BE7A
be74: 31 06           LEAY  $6,X
be76: 33 06           LEAU  $6,X
be78: 31 06           LEAY  $6,X
be7a: 33 06           LEAU  $6,X
be7c: 2c 06           BGE   $BE84
be7e: 31 06           LEAY  $6,X
be80: 36 06           PSHU  B,A
be82: 2e 06           BGT   $BE8A
be84: 33 06           LEAU  $6,X
be86: 35 06           PULS  A,B
be88: 33 06           LEAU  $6,X
be8a: 35 06           PULS  A,B
be8c: 2e 06           BGT   $BE94
be8e: 33 06           LEAU  $6,X
be90: 35 06           PULS  A,B
be92: 2e 06           BGT   $BE9A
be94: 33 06           LEAU  $6,X
be96: 35 06           PULS  A,B
be98: 2e 06           BGT   $BEA0
be9a: 33 06           LEAU  $6,X
be9c: 35 06           PULS  A,B
be9e: 33 06           LEAU  $6,X
bea0: 36 06           PSHU  B,A
bea2: 30 06           LEAX  $6,X
bea4: 35 06           PULS  A,B
bea6: 36 06           PSHU  B,A
bea8: 35 06           PULS  A,B
beaa: 36 06           PSHU  B,A
beac: 30 06           LEAX  $6,X
beae: 35 06           PULS  A,B
beb0: 36 06           PSHU  B,A
beb2: 30 06           LEAX  $6,X
beb4: 35 06           PULS  A,B
beb6: 36 06           PSHU  B,A
beb8: 30 06           LEAX  $6,X
beba: 35 06           PULS  A,B
bebc: 36 06           PSHU  B,A
bebe: 35 06           PULS  A,B
bec0: 36 06           PSHU  B,A
bec2: 2e 06           BGT   $BECA
bec4: 33 06           LEAU  $6,X
bec6: 35 06           PULS  A,B
bec8: 33 06           LEAU  $6,X
beca: 35 06           PULS  A,B
becc: 2e 06           BGT   $BED4
bece: 33 06           LEAU  $6,X
bed0: 35 06           PULS  A,B
bed2: 2e 06           BGT   $BEDA
bed4: 33 06           LEAU  $6,X
bed6: 35 06           PULS  A,B
bed8: 33 06           LEAU  $6,X
beda: 35 06           PULS  A,B
bedc: 2e 06           BGT   $BEE4
bede: 33 06           LEAU  $6,X
bee0: 83 02 00        SUBD  #$0200
bee3: 60 84           NEG   ,X
bee5: d8 af           EORB  $AF
bee7: 85 dc           BITA  #$DC
bee9: 86 00           LDA   #$00
beeb: 00 60           NEG   $60
beed: 00 60           NEG   $60
beef: 00 60           NEG   $60
bef1: 82 00           SBCA  #$00
bef3: 87              FCB   $87
bef4: 86 00           LDA   #$00
bef6: 85 d2           BITA  #$D2
bef8: 88 e6           EORA  #$E6
befa: 00 60           NEG   $60
befc: 27 c0           BEQ   $BEBE
befe: 33 60           LEAU  $0,S
bf00: 85 dc           BITA  #$DC
bf02: 80 35           SUBA  #$35
bf04: 48              ASLA
bf05: 33 0c           LEAU  $C,X
bf07: 30 60           LEAX  $0,S
bf09: 2c 0c           BGE   $BF17
bf0b: 30 0c           LEAX  $C,X
bf0d: 2e 3c           BGT   $BF4B
bf0f: 2c 0c           BGE   $BF1D
bf11: 29 6c           BVS   $BF7F
bf13: 35 48           PULS  DP,U
bf15: 38              FCB   $38
bf16: 0c 35           INC   $35
bf18: 60 35           NEG   -$B,Y
bf1a: 0c 38           INC   $38
bf1c: 0c 37           INC   $37
bf1e: 0c 36           INC   $36
bf20: 30 3a           LEAX  -$6,Y
bf22: 0c 35           INC   $35
bf24: 6c 00           INC   $0,X
bf26: 60 00           NEG   $0,X
bf28: 60 00           NEG   $0,X
bf2a: 18              FCB   $18
bf2b: 3a              ABX
bf2c: 18              FCB   $18
bf2d: 00 30           NEG   $30
bf2f: 00 0c           NEG   $0C
bf31: 3a              ABX
bf32: 0c 00           INC   $00
bf34: 18              FCB   $18
bf35: 00 30           NEG   $30
bf37: 00 18           NEG   $18
bf39: 3a              ABX
bf3a: 18              FCB   $18
bf3b: 00 0c           NEG   $0C
bf3d: 3d              MUL
bf3e: 0c 3a           INC   $3A
bf40: 0c 00           INC   $00
bf42: 0c 00           INC   $00
bf44: 0c 3a           INC   $3A
bf46: 0c 00           INC   $00
bf48: 18              FCB   $18
bf49: 00 30           NEG   $30
bf4b: 00 18           NEG   $18
bf4d: 3a              ABX
bf4e: 18              FCB   $18
bf4f: 00 0c           NEG   $0C
bf51: 3d              MUL
bf52: 0c 3a           INC   $3A
bf54: 0c 00           INC   $00
bf56: 0c 00           INC   $00
bf58: 0c 3a           INC   $3A
bf5a: 0c 00           INC   $00
bf5c: 18              FCB   $18
bf5d: 85 be           BITA  #$BE
bf5f: 00 30           NEG   $30
bf61: 81 3a           CMPA  #$3A
bf63: 48              ASLA
bf64: 3d              MUL
bf65: 18              FCB   $18
bf66: 3a              ABX
bf67: 48              ASLA
bf68: 3f              SWI
bf69: 0c 3d           INC   $3D
bf6b: 0c 3a           INC   $3A
bf6d: 48              ASLA
bf6e: 00 06           NEG   $06
bf70: 3d              MUL
bf71: 12              NOP
bf72: 3a              ABX
bf73: 18              FCB   $18
bf74: 00 06           NEG   $06
bf76: 41              FCB   $41
bf77: 06 00           ROR   $00
bf79: 0c 3f           INC   $3F
bf7b: 06 00           ROR   $00
bf7d: 0c 3d           INC   $3D
bf7f: 06 00           ROR   $00
bf81: 0c 38           INC   $38
bf83: 06 3a           ROR   $3A
bf85: 06 83           ROR   $83
bf87: 02 00 60        AIM   #$00;$60
bf8a: 00 60           NEG   $60
bf8c: 84 dc           ANDA  #$DC
bf8e: 96 85           LDA   $85
bf90: c8 86           EORB  #$86
bf92: 00 81           NEG   $81
bf94: 3d              MUL
bf95: 06 3f           ROR   $3F
bf97: 06 44           ROR   $44
bf99: 06 3f           ROR   $3F
bf9b: 06 3d           ROR   $3D
bf9d: 06 3f           ROR   $3F
bf9f: 06 3d           ROR   $3D
bfa1: 06 3f           ROR   $3F
bfa3: 06 44           ROR   $44
bfa5: 06 3f           ROR   $3F
bfa7: 06 3d           ROR   $3D
bfa9: 06 3f           ROR   $3F
bfab: 06 3d           ROR   $3D
bfad: 06 3f           ROR   $3F
bfaf: 06 44           ROR   $44
bfb1: 06 3f           ROR   $3F
bfb3: 06 3f           ROR   $3F
bfb5: 06 41           ROR   $41
bfb7: 06 46           ROR   $46
bfb9: 06 41           ROR   $41
bfbb: 06 3f           ROR   $3F
bfbd: 06 41           ROR   $41
bfbf: 06 3f           ROR   $3F
bfc1: 06 41           ROR   $41
bfc3: 06 46           ROR   $46
bfc5: 06 41           ROR   $41
bfc7: 06 3f           ROR   $3F
bfc9: 06 41           ROR   $41
bfcb: 06 3f           ROR   $3F
bfcd: 06 41           ROR   $41
bfcf: 06 46           ROR   $46
bfd1: 06 41           ROR   $41
bfd3: 06 41           ROR   $41
bfd5: 06 42           ROR   $42
bfd7: 06 48           ROR   $48
bfd9: 06 42           ROR   $42
bfdb: 06 41           ROR   $41
bfdd: 06 42           ROR   $42
bfdf: 06 41           ROR   $41
bfe1: 06 42           ROR   $42
bfe3: 06 48           ROR   $48
bfe5: 06 42           ROR   $42
bfe7: 06 41           ROR   $41
bfe9: 06 42           ROR   $42
bfeb: 06 41           ROR   $41
bfed: 06 42           ROR   $42
bfef: 06 48           ROR   $48
bff1: 06 42           ROR   $42
bff3: 06 3f           ROR   $3F
bff5: 06 41           ROR   $41
bff7: 06 46           ROR   $46
bff9: 06 41           ROR   $41
bffb: 06 3f           ROR   $3F
bffd: 06 41           ROR   $41
bfff: 06 3f           ROR   $3F
c001: 06 41           ROR   $41
c003: 06 46           ROR   $46
c005: 06 41           ROR   $41
c007: 06 3f           ROR   $3F
c009: 06 41           ROR   $41
c00b: 06 3f           ROR   $3F
c00d: 06 41           ROR   $41
c00f: 06 46           ROR   $46
c011: 06 41           ROR   $41
c013: 06 83           ROR   $83
c015: 02 00 60        AIM   #$00;$60
c018: 00 60           NEG   $60
c01a: 84 d8           ANDA  #$D8
c01c: af 85           STX   B,X
c01e: dc 86           LDD   $86
c020: 00 00           NEG   $00
c022: 60 00           NEG   $0,X
c024: 60 82           NEG   ,-X
c026: 00 87           NEG   $87
c028: 86 00           LDA   #$00
c02a: 85 d2           BITA  #$D2
c02c: 88 e6           EORA  #$E6
c02e: 00 60           NEG   $60
c030: 00 30           NEG   $30
c032: 2a e4           BPL   $C018
c034: 84 dc           ANDA  #$DC
c036: 02 85 d2        AIM   #$85;$D2
c039: 00 0c           NEG   $0C
c03b: 80 00           SUBA  #$00
c03d: 48              ASLA
c03e: 00 0c           NEG   $0C
c040: 46              RORA
c041: 54              LSRB
c042: 44              LSRA
c043: 0c 41           INC   $41
c045: 60 46           NEG   $6,U
c047: 54              LSRB
c048: 44              LSRA
c049: 0c 41           INC   $41
c04b: 60 46           NEG   $6,U
c04d: 54              LSRB
c04e: 44              LSRA
c04f: 0c 41           INC   $41
c051: 24 42           BCC   $C095
c053: 30 44           LEAX  $4,U
c055: 0c 46           INC   $46
c057: 6c 00           INC   $0,X
c059: 60 00           NEG   $0,X
c05b: 60 00           NEG   $0,X
c05d: 60 00           NEG   $0,X
c05f: 60 00           NEG   $0,X
c061: 60 00           NEG   $0,X
c063: 60 00           NEG   $0,X
c065: 60 00           NEG   $0,X
c067: 60 81           NEG   ,X++
c069: 00 60           NEG   $60
c06b: 83 04 46        SUBD  #$0446
c06e: c0 46           SUBB  #$46
c070: c0 81           SUBB  #$81
c072: 00 60           NEG   $60
c074: 83 02 81        SUBD  #$0281
c077: 00 60           NEG   $60
c079: 00 60           NEG   $60
c07b: 00 60           NEG   $60
c07d: 00 60           NEG   $60
c07f: 83 02 84        SUBD  #$0284
c082: da 46           ORB   $46
c084: 85 e6           BITA  #$E6
c086: 86 f4           LDA   #$F4
c088: 36 90           PSHU  PC,X
c08a: 3d              MUL
c08b: 90 41           SUBA  $41
c08d: 60 84           NEG   ,X
c08f: dc 02           LDD   $02
c091: 85 d2           BITA  #$D2
c093: 86 00           LDA   #$00
c095: 82 00           SBCA  #$00
c097: 87              FCB   $87
c098: 86 00           LDA   #$00
c09a: 85 d2           BITA  #$D2
c09c: 00 60           NEG   $60
c09e: 00 60           NEG   $60
c0a0: 2d c0           BLT   $C062
c0a2: 84 da           ANDA  #$DA
c0a4: 90 85           SUBA  $85
c0a6: f0 86 00        SUBB  $8600
c0a9: 80 22           SUBA  #$22
c0ab: 0c 22           INC   $22
c0ad: 0c 22           INC   $22
c0af: 0c 1d           INC   $1D
c0b1: 0c 20           INC   $20
c0b3: 0c 20           INC   $20
c0b5: 0c 00           INC   $00
c0b7: 0c 1d           INC   $1D
c0b9: 0c 22           INC   $22
c0bb: 0c 22           INC   $22
c0bd: 0c 22           INC   $22
c0bf: 0c 1d           INC   $1D
c0c1: 0c 20           INC   $20
c0c3: 0c 20           INC   $20
c0c5: 0c 1d           INC   $1D
c0c7: 0c 20           INC   $20
c0c9: 0c 22           INC   $22
c0cb: 0c 22           INC   $22
c0cd: 0c 22           INC   $22
c0cf: 0c 2e           INC   $2E
c0d1: 0c 25           INC   $25
c0d3: 0c 20           INC   $20
c0d5: 0c 20           INC   $20
c0d7: 0c 22           INC   $22
c0d9: 18              FCB   $18
c0da: 22 0c           BHI   $C0E8
c0dc: 22 0c           BHI   $C0EA
c0de: 1d              SEX
c0df: 0c 20           INC   $20
c0e1: 0c 20           INC   $20
c0e3: 0c 00           INC   $00
c0e5: 0c 21           INC   $21
c0e7: 0c 22           INC   $22
c0e9: 0c 22           INC   $22
c0eb: 0c 22           INC   $22
c0ed: 0c 1d           INC   $1D
c0ef: 0c 20           INC   $20
c0f1: 0c 20           INC   $20
c0f3: 0c 00           INC   $00
c0f5: 0c 1d           INC   $1D
c0f7: 0c 22           INC   $22
c0f9: 0c 22           INC   $22
c0fb: 0c 22           INC   $22
c0fd: 0c 1d           INC   $1D
c0ff: 0c 20           INC   $20
c101: 0c 20           INC   $20
c103: 0c 1d           INC   $1D
c105: 0c 20           INC   $20
c107: 0c 22           INC   $22
c109: 0c 22           INC   $22
c10b: 0c 22           INC   $22
c10d: 0c 2e           INC   $2E
c10f: 0c 25           INC   $25
c111: 0c 20           INC   $20
c113: 0c 20           INC   $20
c115: 0c 22           INC   $22
c117: 18              FCB   $18
c118: 22 0c           BHI   $C126
c11a: 22 0c           BHI   $C128
c11c: 1d              SEX
c11d: 0c 20           INC   $20
c11f: 0c 20           INC   $20
c121: 0c 00           INC   $00
c123: 0c 21           INC   $21
c125: 0c 22           INC   $22
c127: 0c 22           INC   $22
c129: 0c 22           INC   $22
c12b: 0c 1d           INC   $1D
c12d: 0c 20           INC   $20
c12f: 0c 20           INC   $20
c131: 0c 00           INC   $00
c133: 0c 1d           INC   $1D
c135: 0c 22           INC   $22
c137: 0c 22           INC   $22
c139: 0c 22           INC   $22
c13b: 0c 1d           INC   $1D
c13d: 0c 20           INC   $20
c13f: 0c 20           INC   $20
c141: 0c 1d           INC   $1D
c143: 0c 20           INC   $20
c145: 0c 22           INC   $22
c147: 0c 22           INC   $22
c149: 0c 22           INC   $22
c14b: 0c 2e           INC   $2E
c14d: 0c 25           INC   $25
c14f: 0c 20           INC   $20
c151: 0c 20           INC   $20
c153: 0c 22           INC   $22
c155: 18              FCB   $18
c156: 22 0c           BHI   $C164
c158: 22 0c           BHI   $C166
c15a: 1d              SEX
c15b: 0c 20           INC   $20
c15d: 0c 20           INC   $20
c15f: 0c 00           INC   $00
c161: 0c 21           INC   $21
c163: 0c 22           INC   $22
c165: 0c 22           INC   $22
c167: 0c 22           INC   $22
c169: 0c 1d           INC   $1D
c16b: 0c 20           INC   $20
c16d: 0c 20           INC   $20
c16f: 0c 00           INC   $00
c171: 0c 1d           INC   $1D
c173: 0c 22           INC   $22
c175: 0c 22           INC   $22
c177: 0c 22           INC   $22
c179: 0c 1d           INC   $1D
c17b: 0c 20           INC   $20
c17d: 0c 20           INC   $20
c17f: 0c 1d           INC   $1D
c181: 0c 20           INC   $20
c183: 0c 22           INC   $22
c185: 0c 22           INC   $22
c187: 0c 22           INC   $22
c189: 0c 2e           INC   $2E
c18b: 0c 25           INC   $25
c18d: 0c 20           INC   $20
c18f: 0c 20           INC   $20
c191: 0c 22           INC   $22
c193: 18              FCB   $18
c194: 22 0c           BHI   $C1A2
c196: 22 0c           BHI   $C1A4
c198: 1d              SEX
c199: 0c 20           INC   $20
c19b: 0c 20           INC   $20
c19d: 0c 00           INC   $00
c19f: 0c 21           INC   $21
c1a1: 0c 81           INC   $81
c1a3: 20 06           BRA   $C1AB
c1a5: 22 06           BHI   $C1AD
c1a7: 22 06           BHI   $C1AF
c1a9: 22 06           BHI   $C1B1
c1ab: 22 06           BHI   $C1B3
c1ad: 22 06           BHI   $C1B5
c1af: 22 06           BHI   $C1B7
c1b1: 22 06           BHI   $C1B9
c1b3: 22 06           BHI   $C1BB
c1b5: 22 06           BHI   $C1BD
c1b7: 22 06           BHI   $C1BF
c1b9: 22 06           BHI   $C1C1
c1bb: 25 18           BCS   $C1D5
c1bd: 20 06           BRA   $C1C5
c1bf: 22 06           BHI   $C1C7
c1c1: 22 06           BHI   $C1C9
c1c3: 22 06           BHI   $C1CB
c1c5: 22 06           BHI   $C1CD
c1c7: 22 06           BHI   $C1CF
c1c9: 22 06           BHI   $C1D1
c1cb: 22 06           BHI   $C1D3
c1cd: 22 06           BHI   $C1D5
c1cf: 22 06           BHI   $C1D7
c1d1: 22 06           BHI   $C1D9
c1d3: 22 06           BHI   $C1DB
c1d5: 27 0c           BEQ   $C1E3
c1d7: 25 0c           BCS   $C1E5
c1d9: 20 06           BRA   $C1E1
c1db: 22 06           BHI   $C1E3
c1dd: 22 06           BHI   $C1E5
c1df: 22 06           BHI   $C1E7
c1e1: 22 06           BHI   $C1E9
c1e3: 22 06           BHI   $C1EB
c1e5: 22 06           BHI   $C1ED
c1e7: 22 06           BHI   $C1EF
c1e9: 22 06           BHI   $C1F1
c1eb: 22 06           BHI   $C1F3
c1ed: 22 06           BHI   $C1F5
c1ef: 22 06           BHI   $C1F7
c1f1: 22 06           BHI   $C1F9
c1f3: 25 12           BCS   $C207
c1f5: 20 06           BRA   $C1FD
c1f7: 22 06           BHI   $C1FF
c1f9: 22 06           BHI   $C201
c1fb: 22 06           BHI   $C203
c1fd: 22 06           BHI   $C205
c1ff: 29 06           BVS   $C207
c201: 22 06           BHI   $C209
c203: 22 06           BHI   $C20B
c205: 27 06           BEQ   $C20D
c207: 22 06           BHI   $C20F
c209: 22 06           BHI   $C211
c20b: 25 06           BCS   $C213
c20d: 22 06           BHI   $C215
c20f: 22 06           BHI   $C217
c211: 20 06           BRA   $C219
c213: 22 06           BHI   $C21B
c215: 83 02 00        SUBD  #$0200
c218: 60 00           NEG   $0,X
c21a: 48              ASLA
c21b: 27 06           BEQ   $C223
c21d: 25 06           BCS   $C225
c21f: 24 06           BCC   $C227
c221: 3b              RTI
c222: 06 81           ROR   $81
c224: 22 06           BHI   $C22C
c226: 22 06           BHI   $C22E
c228: 22 06           BHI   $C230
c22a: 22 06           BHI   $C232
c22c: 00 06           NEG   $06
c22e: 20 06           BRA   $C236
c230: 20 06           BRA   $C238
c232: 20 06           BRA   $C23A
c234: 22 12           BHI   $C248
c236: 22 06           BHI   $C23E
c238: 00 06           NEG   $06
c23a: 20 06           BRA   $C242
c23c: 00 06           NEG   $06
c23e: 20 06           BRA   $C246
c240: 22 06           BHI   $C248
c242: 22 06           BHI   $C24A
c244: 22 06           BHI   $C24C
c246: 22 06           BHI   $C24E
c248: 00 06           NEG   $06
c24a: 20 06           BRA   $C252
c24c: 20 06           BRA   $C254
c24e: 00 06           NEG   $06
c250: 22 06           BHI   $C258
c252: 00 06           NEG   $06
c254: 22 06           BHI   $C25C
c256: 22 06           BHI   $C25E
c258: 00 06           NEG   $06
c25a: 20 06           BRA   $C262
c25c: 20 06           BRA   $C264
c25e: 20 06           BRA   $C266
c260: 24 06           BCC   $C268
c262: 24 06           BCC   $C26A
c264: 00 06           NEG   $06
c266: 24 06           BCC   $C26E
c268: 24 06           BCC   $C270
c26a: 00 06           NEG   $06
c26c: 24 06           BCC   $C274
c26e: 24 06           BCC   $C276
c270: 00 06           NEG   $06
c272: 24 06           BCC   $C27A
c274: 24 06           BCC   $C27C
c276: 00 06           NEG   $06
c278: 24 06           BCC   $C280
c27a: 24 06           BCC   $C282
c27c: 00 06           NEG   $06
c27e: 24 06           BCC   $C286
c280: 00 06           NEG   $06
c282: 22 06           BHI   $C28A
c284: 22 06           BHI   $C28C
c286: 22 06           BHI   $C28E
c288: 22 06           BHI   $C290
c28a: 22 06           BHI   $C292
c28c: 00 06           NEG   $06
c28e: 00 06           NEG   $06
c290: 00 06           NEG   $06
c292: 00 06           NEG   $06
c294: 22 06           BHI   $C29C
c296: 22 06           BHI   $C29E
c298: 20 06           BRA   $C2A0
c29a: 20 06           BRA   $C2A2
c29c: 20 06           BRA   $C2A4
c29e: 20 06           BRA   $C2A6
c2a0: 83 02 00        SUBD  #$0200
c2a3: 60 00           NEG   $0,X
c2a5: 60 00           NEG   $0,X
c2a7: 60 00           NEG   $0,X
c2a9: 60 82           NEG   ,-X
c2ab: 00 87           NEG   $87
c2ad: 86 00           LDA   #$00
c2af: 85 c8           BITA  #$C8
c2b1: 80 3d           SUBA  #$3D
c2b3: 06 3d           ROR   $3D
c2b5: 06 3d           ROR   $3D
c2b7: 06 3d           ROR   $3D
c2b9: 06 3d           ROR   $3D
c2bb: 0c 3d           INC   $3D
c2bd: 06 3d           ROR   $3D
c2bf: 06 3d           ROR   $3D
c2c1: 06 3d           ROR   $3D
c2c3: 06 3d           ROR   $3D
c2c5: 06 3d           ROR   $3D
c2c7: 06 3d           ROR   $3D
c2c9: 0c 3d           INC   $3D
c2cb: 06 3d           ROR   $3D
c2cd: 06 82           ROR   $82
c2cf: 00 87           NEG   $87
c2d1: 86 00           LDA   #$00
c2d3: 85 96           BITA  #$96
c2d5: 00 60           NEG   $60
c2d7: 00 60           NEG   $60
c2d9: 00 60           NEG   $60
c2db: 00 60           NEG   $60
c2dd: 80 81           SUBA  #$81
c2df: 31 18           LEAY  -$8,X
c2e1: 31 18           LEAY  -$8,X
c2e3: 31 18           LEAY  -$8,X
c2e5: 31 18           LEAY  -$8,X
c2e7: 83 0f 31        SUBD  #$0F31
c2ea: 18              FCB   $18
c2eb: 31 18           LEAY  -$8,X
c2ed: 31 18           LEAY  -$8,X
c2ef: 85 dc           BITA  #$DC
c2f1: 31 06           LEAY  $6,X
c2f3: 31 06           LEAY  $6,X
c2f5: 00 06           NEG   $06
c2f7: 31 06           LEAY  $6,X
c2f9: 81 31           CMPA  #$31
c2fb: 18              FCB   $18
c2fc: 31 18           LEAY  -$8,X
c2fe: 31 18           LEAY  -$8,X
c300: 31 18           LEAY  -$8,X
c302: 83 08 00        SUBD  #$0800
c305: 60 00           NEG   $0,X
c307: 60 84           NEG   ,X
c309: de 08           LDU   $08
c30b: 85 e6           BITA  #$E6
c30d: 81 3d           CMPA  #$3D
c30f: 18              FCB   $18
c310: 3d              MUL
c311: 18              FCB   $18
c312: 3d              MUL
c313: 18              FCB   $18
c314: 3d              MUL
c315: 18              FCB   $18
c316: 83 08 84        SUBD  #$0884
c319: de 52           LDU   $52
c31b: 85 a0           BITA  #$A0
c31d: 31 18           LEAY  -$8,X
c31f: 31 18           LEAY  -$8,X
c321: 31 18           LEAY  -$8,X
c323: 31 18           LEAY  -$8,X
c325: 31 18           LEAY  -$8,X
c327: 31 18           LEAY  -$8,X
c329: 31 18           LEAY  -$8,X
c32b: 31 18           LEAY  -$8,X
c32d: 31 18           LEAY  -$8,X
c32f: 31 18           LEAY  -$8,X
c331: 31 18           LEAY  -$8,X
c333: 31 18           LEAY  -$8,X
c335: 31 18           LEAY  -$8,X
c337: 31 18           LEAY  -$8,X
c339: 31 18           LEAY  -$8,X
c33b: 85 c8           BITA  #$C8
c33d: 31 06           LEAY  $6,X
c33f: 31 06           LEAY  $6,X
c341: 31 06           LEAY  $6,X
c343: 31 06           LEAY  $6,X
c345: 85 96           BITA  #$96
c347: 82 00           SBCA  #$00
c349: 87              FCB   $87
c34a: 07 eb           ASR   $EB
c34c: c3 68 db        ADDD  #$68DB
c34f: b8 c4 d2        EORA  $C4D2
c352: da 6b           ORB   $6B
c354: c6 1c           LDB   #$1C
c356: dc 4c           LDD   $4C
c358: c6 a2           LDB   #$A2
c35a: dc 4c           LDD   $4C
c35c: c7              FCB   $C7
c35d: 28 dc           BVC   $C33B
c35f: 4c              INCA
c360: c7              FCB   $C7
c361: ae de           LDX   [W,U]
c363: 2d c9           BLT   $C32E
c365: fc de 77        LDD   $DE77
c368: 86 00           LDA   #$00
c36a: 85 d2           BITA  #$D2
c36c: 80 25           SUBA  #$25
c36e: 06 2a           ROR   $2A
c370: 06 2f           ROR   $2F
c372: 06 33           ROR   $33
c374: 06 27           ROR   $27
c376: 06 2c           ROR   $2C
c378: 06 31           ROR   $31
c37a: 06 35           ROR   $35
c37c: 06 32           ROR   $32
c37e: 0c 33           INC   $33
c380: 0c 34           INC   $34
c382: 0c 36           INC   $36
c384: 0c 84           INC   $84
c386: dc e0           LDD   $E0
c388: 85 d2           BITA  #$D2
c38a: 00 48           NEG   $48
c38c: 2c 06           BGE   $C394
c38e: 2e 06           BGT   $C396
c390: 31 06           LEAY  $6,X
c392: 33 06           LEAU  $6,X
c394: 35 12           PULS  A,X
c396: 38              FCB   $38
c397: 42              FCB   $42
c398: 3f              SWI
c399: 0c 3d           INC   $3D
c39b: 12              NOP
c39c: 38              FCB   $38
c39d: 30 3a           LEAX  -$6,Y
c39f: 06 3b           ROR   $3B
c3a1: 06 3a           ROR   $3A
c3a3: 06 38           ROR   $38
c3a5: 06 36           ROR   $36
c3a7: 06 35           ROR   $35
c3a9: 12              NOP
c3aa: 31 36           LEAY  -$A,Y
c3ac: 2e 06           BGT   $C3B4
c3ae: 31 06           LEAY  $6,X
c3b0: 00 06           NEG   $06
c3b2: 35 06           PULS  A,B
c3b4: 33 24           LEAU  $4,Y
c3b6: 34 0c           PSHS  DP,B
c3b8: 35 0c           PULS  B,DP
c3ba: 00 0c           NEG   $0C
c3bc: 2c 06           BGE   $C3C4
c3be: 2e 06           BGT   $C3C6
c3c0: 31 06           LEAY  $6,X
c3c2: 33 06           LEAU  $6,X
c3c4: 35 12           PULS  A,X
c3c6: 38              FCB   $38
c3c7: 42              FCB   $42
c3c8: 3f              SWI
c3c9: 0c 3d           INC   $3D
c3cb: 12              NOP
c3cc: 38              FCB   $38
c3cd: 36 3d           PSHU  Y,X,DP,B,CC
c3cf: 06 3f           ROR   $3F
c3d1: 06 00           ROR   $00
c3d3: 06 3d           ROR   $3D
c3d5: 06 41           ROR   $41
c3d7: 12              NOP
c3d8: 42              FCB   $42
c3d9: 06 41           ROR   $41
c3db: 06 3f           ROR   $3F
c3dd: 06 3d           ROR   $3D
c3df: 06 3c           ROR   $3C
c3e1: 06 3a           ROR   $3A
c3e3: 06 39           ROR   $39
c3e5: 06 38           ROR   $38
c3e7: 06 36           ROR   $36
c3e9: 06 35           ROR   $35
c3eb: 06 33           ROR   $33
c3ed: 06 31           ROR   $31
c3ef: 06 30           ROR   $30
c3f1: 06 2c           ROR   $2C
c3f3: 0c 2e           INC   $2E
c3f5: 06 30           ROR   $30
c3f7: 06 31           ROR   $31
c3f9: 06 33           ROR   $33
c3fb: 06 35           ROR   $35
c3fd: 06 36           ROR   $36
c3ff: 06 38           ROR   $38
c401: 18              FCB   $18
c402: 3a              ABX
c403: 18              FCB   $18
c404: 3c 0c           CWAI  #$0C
c406: 3a              ABX
c407: 06 3c           ROR   $3C
c409: 0c 3a           INC   $3A
c40b: 06 00           ROR   $00
c40d: 06 3c           ROR   $3C
c40f: 06 00           ROR   $00
c411: 06 3a           ROR   $3A
c413: 06 00           ROR   $00
c415: 06 3c           ROR   $3C
c417: 06 3c           ROR   $3C
c419: 0c 3a           INC   $3A
c41b: 0c 3d           INC   $3D
c41d: 0c 3c           INC   $3C
c41f: 06 3d           ROR   $3D
c421: 0c 3c           INC   $3C
c423: 06 00           ROR   $00
c425: 06 3d           ROR   $3D
c427: 06 00           ROR   $00
c429: 06 3c           ROR   $3C
c42b: 06 00           ROR   $00
c42d: 06 3f           ROR   $3F
c42f: 06 3f           ROR   $3F
c431: 06 3d           ROR   $3D
c433: 06 3c           ROR   $3C
c435: 06 3a           ROR   $3A
c437: 06 3c           ROR   $3C
c439: 0c 3a           INC   $3A
c43b: 06 3c           ROR   $3C
c43d: 0c 3a           INC   $3A
c43f: 06 00           ROR   $00
c441: 06 3c           ROR   $3C
c443: 06 00           ROR   $00
c445: 06 3a           ROR   $3A
c447: 06 00           ROR   $00
c449: 06 3c           ROR   $3C
c44b: 06 3c           ROR   $3C
c44d: 0c 3a           INC   $3A
c44f: 0c 3d           INC   $3D
c451: 0c 3c           INC   $3C
c453: 06 3d           ROR   $3D
c455: 0c 3c           INC   $3C
c457: 06 00           ROR   $00
c459: 06 3d           ROR   $3D
c45b: 06 00           ROR   $00
c45d: 06 3c           ROR   $3C
c45f: 06 00           ROR   $00
c461: 06 41           ROR   $41
c463: 06 41           ROR   $41
c465: 06 3f           ROR   $3F
c467: 06 3d           ROR   $3D
c469: 06 3f           ROR   $3F
c46b: 06 41           ROR   $41
c46d: 12              NOP
c46e: 3f              SWI
c46f: 06 00           ROR   $00
c471: 18              FCB   $18
c472: 3d              MUL
c473: 12              NOP
c474: 3c 06           CWAI  #$06
c476: 00 0c           NEG   $0C
c478: 38              FCB   $38
c479: 54              LSRB
c47a: 38              FCB   $38
c47b: 06 3a           ROR   $3A
c47d: 06 3c           ROR   $3C
c47f: 06 3d           ROR   $3D
c481: 06 41           ROR   $41
c483: 12              NOP
c484: 3f              SWI
c485: 06 00           ROR   $00
c487: 18              FCB   $18
c488: 3d              MUL
c489: 12              NOP
c48a: 3c 06           CWAI  #$06
c48c: 00 18           NEG   $18
c48e: 41              FCB   $41
c48f: 12              NOP
c490: 3f              SWI
c491: 06 00           ROR   $00
c493: 18              FCB   $18
c494: 3d              MUL
c495: 12              NOP
c496: 3c 06           CWAI  #$06
c498: 00 18           NEG   $18
c49a: 00 0c           NEG   $0C
c49c: 41              FCB   $41
c49d: 06 00           ROR   $00
c49f: 06 00           ROR   $00
c4a1: 06 3f           ROR   $3F
c4a3: 06 00           ROR   $00
c4a5: 06 00           ROR   $00
c4a7: 06 3d           ROR   $3D
c4a9: 06 00           ROR   $00
c4ab: 06 00           ROR   $00
c4ad: 06 3c           ROR   $3C
c4af: 06 00           ROR   $00
c4b1: 06 00           ROR   $00
c4b3: 06 3d           ROR   $3D
c4b5: 06 00           ROR   $00
c4b7: 06 00           ROR   $00
c4b9: 06 3a           ROR   $3A
c4bb: 06 3c           ROR   $3C
c4bd: 06 3d           ROR   $3D
c4bf: 06 3e           ROR   $3E
c4c1: 06 3f           ROR   $3F
c4c3: 06 41           ROR   $41
c4c5: 06 42           ROR   $42
c4c7: 06 44           ROR   $44
c4c9: 30 84           LEAX  ,X
c4cb: db b8           ADDB  $B8
c4cd: 85 d2           BITA  #$D2
c4cf: 82 00           SBCA  #$00
c4d1: 87              FCB   $87
c4d2: 86 00           LDA   #$00
c4d4: 85 eb           BITA  #$EB
c4d6: 80 25           SUBA  #$25
c4d8: 18              FCB   $18
c4d9: 27 18           BEQ   $C4F3
c4db: 24 0c           BCC   $C4E9
c4dd: 25 0c           BCS   $C4EB
c4df: 26 0c           BNE   $C4ED
c4e1: 28 0c           BVC   $C4EF
c4e3: 00 60           NEG   $60
c4e5: 25 0c           BCS   $C4F3
c4e7: 31 0c           LEAY  $C,X
c4e9: 25 0c           BCS   $C4F7
c4eb: 31 0c           LEAY  $C,X
c4ed: 25 06           BCS   $C4F5
c4ef: 25 06           BCS   $C4F7
c4f1: 25 0c           BCS   $C4FF
c4f3: 23 0c           BLS   $C501
c4f5: 22 0c           BHI   $C503
c4f7: 20 0c           BRA   $C505
c4f9: 2c 0c           BGE   $C507
c4fb: 20 0c           BRA   $C509
c4fd: 2c 0c           BGE   $C50B
c4ff: 20 06           BRA   $C507
c501: 20 0c           BRA   $C50F
c503: 20 06           BRA   $C50B
c505: 20 0c           BRA   $C513
c507: 1f 0c           TFR   D,0
c509: 1e 0c           EXG   D,0
c50b: 2a 0c           BPL   $C519
c50d: 1e 0c           EXG   D,0
c50f: 2a 0c           BPL   $C51D
c511: 1e 06           EXG   D,W
c513: 1e 06           EXG   D,W
c515: 00 06           NEG   $06
c517: 1e 06           EXG   D,W
c519: 22 0c           BHI   $C527
c51b: 2e 0c           BGT   $C529
c51d: 27 12           BEQ   $C531
c51f: 27 06           BEQ   $C527
c521: 27 0c           BEQ   $C52F
c523: 22 0c           BHI   $C531
c525: 20 0c           BRA   $C533
c527: 00 0c           NEG   $0C
c529: 00 0c           NEG   $0C
c52b: 00 0c           NEG   $0C
c52d: 25 0c           BCS   $C53B
c52f: 31 0c           LEAY  $C,X
c531: 25 0c           BCS   $C53F
c533: 31 0c           LEAY  $C,X
c535: 25 06           BCS   $C53D
c537: 25 06           BCS   $C53F
c539: 25 0c           BCS   $C547
c53b: 23 0c           BLS   $C549
c53d: 22 0c           BHI   $C54B
c53f: 20 0c           BRA   $C54D
c541: 2c 0c           BGE   $C54F
c543: 20 0c           BRA   $C551
c545: 2c 0c           BGE   $C553
c547: 20 06           BRA   $C54F
c549: 20 0c           BRA   $C557
c54b: 20 06           BRA   $C553
c54d: 20 0c           BRA   $C55B
c54f: 1f 0c           TFR   D,0
c551: 1e 0c           EXG   D,0
c553: 2a 0c           BPL   $C561
c555: 1e 0c           EXG   D,0
c557: 2a 0c           BPL   $C565
c559: 1e 06           EXG   D,W
c55b: 1e 06           EXG   D,W
c55d: 00 06           NEG   $06
c55f: 1e 06           EXG   D,W
c561: 1e 0c           EXG   D,0
c563: 1f 0c           TFR   D,0
c565: 20 12           BRA   $C579
c567: 2c 06           BGE   $C56F
c569: 20 0c           BRA   $C577
c56b: 2c 0c           BGE   $C579
c56d: 20 0c           BRA   $C57B
c56f: 2c 0c           BGE   $C57D
c571: 20 0c           BRA   $C57F
c573: 2c 0c           BGE   $C581
c575: 19              DAA
c576: 0c 25           INC   $25
c578: 0c 19           INC   $19
c57a: 0c 25           INC   $25
c57c: 0c 19           INC   $19
c57e: 0c 25           INC   $25
c580: 0c 19           INC   $19
c582: 0c 25           INC   $25
c584: 0c 1b           INC   $1B
c586: 0c 27           INC   $27
c588: 0c 1b           INC   $1B
c58a: 0c 27           INC   $27
c58c: 0c 1b           INC   $1B
c58e: 0c 27           INC   $27
c590: 0c 1b           INC   $1B
c592: 0c 27           INC   $27
c594: 0c 1d           INC   $1D
c596: 0c 29           INC   $29
c598: 0c 1d           INC   $1D
c59a: 0c 29           INC   $29
c59c: 0c 1d           INC   $1D
c59e: 0c 29           INC   $29
c5a0: 0c 1d           INC   $1D
c5a2: 0c 29           INC   $29
c5a4: 0c 1e           INC   $1E
c5a6: 0c 2a           INC   $2A
c5a8: 0c 1e           INC   $1E
c5aa: 0c 2a           INC   $2A
c5ac: 0c 1e           INC   $1E
c5ae: 0c 2a           INC   $2A
c5b0: 0c 1e           INC   $1E
c5b2: 0c 2a           INC   $2A
c5b4: 0c 1e           INC   $1E
c5b6: 12              NOP
c5b7: 1d              SEX
c5b8: 06 00           ROR   $00
c5ba: 18              FCB   $18
c5bb: 27 12           BEQ   $C5CF
c5bd: 29 06           BVS   $C5C5
c5bf: 00 0c           NEG   $0C
c5c1: 25 18           BCS   $C5DB
c5c3: 31 0c           LEAY  $C,X
c5c5: 27 0c           BEQ   $C5D3
c5c7: 33 0c           LEAU  $C,X
c5c9: 28 0c           BVC   $C5D7
c5cb: 34 0c           PSHS  DP,B
c5cd: 29 0c           BVS   $C5DB
c5cf: 35 0c           PULS  B,DP
c5d1: 1e 12           EXG   X,Y
c5d3: 1d              SEX
c5d4: 06 00           ROR   $00
c5d6: 18              FCB   $18
c5d7: 27 12           BEQ   $C5EB
c5d9: 29 06           BVS   $C5E1
c5db: 00 18           NEG   $18
c5dd: 1e 12           EXG   X,Y
c5df: 1d              SEX
c5e0: 06 00           ROR   $00
c5e2: 18              FCB   $18
c5e3: 27 12           BEQ   $C5F7
c5e5: 29 06           BVS   $C5ED
c5e7: 00 18           NEG   $18
c5e9: 00 0c           NEG   $0C
c5eb: 2a 06           BPL   $C5F3
c5ed: 00 06           NEG   $06
c5ef: 00 06           NEG   $06
c5f1: 29 06           BVS   $C5F9
c5f3: 00 06           NEG   $06
c5f5: 00 06           NEG   $06
c5f7: 27 06           BEQ   $C5FF
c5f9: 00 06           NEG   $06
c5fb: 00 06           NEG   $06
c5fd: 22 06           BHI   $C605
c5ff: 00 06           NEG   $06
c601: 00 06           NEG   $06
c603: 27 06           BEQ   $C60B
c605: 00 06           NEG   $06
c607: 00 06           NEG   $06
c609: 20 06           BRA   $C611
c60b: 00 06           NEG   $06
c60d: 20 06           BRA   $C615
c60f: 20 06           BRA   $C617
c611: 20 06           BRA   $C619
c613: 00 06           NEG   $06
c615: 20 06           BRA   $C61D
c617: 20 30           BRA   $C649
c619: 82 00           SBCA  #$00
c61b: 87              FCB   $87
c61c: 86 f4           LDA   #$F4
c61e: 85 d2           BITA  #$D2
c620: 88 fa           EORA  #$FA
c622: 80 33           SUBA  #$33
c624: 18              FCB   $18
c625: 35 18           PULS  DP,X
c627: 36 0c           PSHU  DP,B
c629: 37 0c           PULU  B,DP
c62b: 38              FCB   $38
c62c: 0c 3a           INC   $3A
c62e: 0c 00           INC   $00
c630: 60 38           NEG   -$8,Y
c632: 60 36           NEG   -$A,Y
c634: 60 35           NEG   -$B,Y
c636: 60 36           NEG   -$A,Y
c638: 24 36           BCC   $C670
c63a: 0c 35           INC   $35
c63c: 0c 00           INC   $00
c63e: 0c 00           INC   $00
c640: 18              FCB   $18
c641: 38              FCB   $38
c642: 60 36           NEG   -$A,Y
c644: 60 35           NEG   -$B,Y
c646: 60 35           NEG   -$B,Y
c648: 30 36           LEAX  -$A,Y
c64a: 18              FCB   $18
c64b: 38              FCB   $38
c64c: 18              FCB   $18
c64d: 3c 60           CWAI  #$60
c64f: 3d              MUL
c650: 60 3c           NEG   -$4,Y
c652: 60 3d           NEG   -$3,Y
c654: 60 3d           NEG   -$3,Y
c656: 12              NOP
c657: 3c 06           CWAI  #$06
c659: 00 18           NEG   $18
c65b: 3a              ABX
c65c: 12              NOP
c65d: 3c 06           CWAI  #$06
c65f: 00 0c           NEG   $0C
c661: 3c 6c           CWAI  #$6C
c663: 3d              MUL
c664: 12              NOP
c665: 3c 06           CWAI  #$06
c667: 00 18           NEG   $18
c669: 3a              ABX
c66a: 12              NOP
c66b: 3c 06           CWAI  #$06
c66d: 00 18           NEG   $18
c66f: 3d              MUL
c670: 12              NOP
c671: 3c 06           CWAI  #$06
c673: 00 18           NEG   $18
c675: 3a              ABX
c676: 12              NOP
c677: 3c 06           CWAI  #$06
c679: 00 18           NEG   $18
c67b: 00 0c           NEG   $0C
c67d: 3d              MUL
c67e: 06 00           ROR   $00
c680: 06 00           ROR   $00
c682: 06 3c           ROR   $3C
c684: 06 00           ROR   $00
c686: 06 00           ROR   $00
c688: 06 3a           ROR   $3A
c68a: 06 00           ROR   $00
c68c: 06 00           ROR   $00
c68e: 06 38           ROR   $38
c690: 06 00           ROR   $00
c692: 06 00           ROR   $00
c694: 06 3a           ROR   $3A
c696: 06 00           ROR   $00
c698: 06 00           ROR   $00
c69a: 06 38           ROR   $38
c69c: 2a 3d           BPL   $C6DB
c69e: 30 82           LEAX  ,-X
c6a0: 00 87           NEG   $87
c6a2: 86 f4           LDA   #$F4
c6a4: 85 d2           BITA  #$D2
c6a6: 88 fa           EORA  #$FA
c6a8: 80 2f           SUBA  #$2F
c6aa: 18              FCB   $18
c6ab: 31 18           LEAY  -$8,X
c6ad: 32 0c           LEAS  $C,X
c6af: 33 0c           LEAU  $C,X
c6b1: 34 0c           PSHS  DP,B
c6b3: 36 0c           PSHU  DP,B
c6b5: 00 60           NEG   $60
c6b7: 35 60           PULS  Y,U
c6b9: 33 60           LEAU  $0,S
c6bb: 31 60           LEAY  $0,S
c6bd: 31 24           LEAY  $4,Y
c6bf: 31 0c           LEAY  $C,X
c6c1: 30 0c           LEAX  $C,X
c6c3: 00 0c           NEG   $0C
c6c5: 00 18           NEG   $18
c6c7: 35 60           PULS  Y,U
c6c9: 33 60           LEAU  $0,S
c6cb: 31 60           LEAY  $0,S
c6cd: 31 30           LEAY  -$10,Y
c6cf: 33 18           LEAU  -$8,X
c6d1: 35 18           PULS  DP,X
c6d3: 38              FCB   $38
c6d4: 60 3a           NEG   -$6,Y
c6d6: 60 38           NEG   -$8,Y
c6d8: 60 3a           NEG   -$6,Y
c6da: 60 3a           NEG   -$6,Y
c6dc: 12              NOP
c6dd: 38              FCB   $38
c6de: 06 00           ROR   $00
c6e0: 18              FCB   $18
c6e1: 36 12           PSHU  X,A
c6e3: 38              FCB   $38
c6e4: 06 00           ROR   $00
c6e6: 0c 38           INC   $38
c6e8: 6c 3a           INC   -$6,Y
c6ea: 12              NOP
c6eb: 38              FCB   $38
c6ec: 06 00           ROR   $00
c6ee: 18              FCB   $18
c6ef: 36 12           PSHU  X,A
c6f1: 38              FCB   $38
c6f2: 06 00           ROR   $00
c6f4: 18              FCB   $18
c6f5: 3a              ABX
c6f6: 12              NOP
c6f7: 38              FCB   $38
c6f8: 06 00           ROR   $00
c6fa: 18              FCB   $18
c6fb: 36 12           PSHU  X,A
c6fd: 38              FCB   $38
c6fe: 06 00           ROR   $00
c700: 18              FCB   $18
c701: 00 0c           NEG   $0C
c703: 3a              ABX
c704: 06 00           ROR   $00
c706: 06 00           ROR   $00
c708: 06 38           ROR   $38
c70a: 06 00           ROR   $00
c70c: 06 00           ROR   $00
c70e: 06 36           ROR   $36
c710: 06 00           ROR   $00
c712: 06 00           ROR   $00
c714: 06 35           ROR   $35
c716: 06 00           ROR   $00
c718: 06 00           ROR   $00
c71a: 06 36           ROR   $36
c71c: 06 00           ROR   $00
c71e: 06 00           ROR   $00
c720: 06 36           ROR   $36
c722: 2a 3a           BPL   $C75E
c724: 30 82           LEAX  ,-X
c726: 00 87           NEG   $87
c728: 86 f4           LDA   #$F4
c72a: 85 d2           BITA  #$D2
c72c: 88 fa           EORA  #$FA
c72e: 80 2a           SUBA  #$2A
c730: 18              FCB   $18
c731: 2c 18           BGE   $C74B
c733: 2d 0c           BLT   $C741
c735: 2e 0c           BGT   $C743
c737: 2f 0c           BLE   $C745
c739: 31 0c           LEAY  $C,X
c73b: 00 60           NEG   $60
c73d: 3c 60           CWAI  #$60
c73f: 3b              RTI
c740: 60 3a           NEG   -$6,Y
c742: 60 2d           NEG   $D,Y
c744: 24 2d           BCC   $C773
c746: 0c 2c           INC   $2C
c748: 0c 00           INC   $00
c74a: 0c 00           INC   $00
c74c: 18              FCB   $18
c74d: 30 60           LEAX  $0,S
c74f: 2f 60           BLE   $C7B1
c751: 2e 60           BGT   $C7B3
c753: 2e 30           BGT   $C785
c755: 30 18           LEAX  -$8,X
c757: 31 18           LEAY  -$8,X
c759: 35 60           PULS  Y,U
c75b: 36 60           PSHU  S,Y
c75d: 35 60           PULS  Y,U
c75f: 36 60           PSHU  S,Y
c761: 35 12           PULS  A,X
c763: 33 06           LEAU  $6,X
c765: 00 18           NEG   $18
c767: 31 12           LEAY  -$E,X
c769: 33 06           LEAU  $6,X
c76b: 00 0c           NEG   $0C
c76d: 38              FCB   $38
c76e: 6c 35           INC   -$B,Y
c770: 12              NOP
c771: 33 06           LEAU  $6,X
c773: 00 18           NEG   $18
c775: 31 12           LEAY  -$E,X
c777: 33 06           LEAU  $6,X
c779: 00 18           NEG   $18
c77b: 35 12           PULS  A,X
c77d: 33 06           LEAU  $6,X
c77f: 00 18           NEG   $18
c781: 31 12           LEAY  -$E,X
c783: 33 06           LEAU  $6,X
c785: 00 18           NEG   $18
c787: 00 0c           NEG   $0C
c789: 35 06           PULS  A,B
c78b: 00 06           NEG   $06
c78d: 00 06           NEG   $06
c78f: 33 06           LEAU  $6,X
c791: 00 06           NEG   $06
c793: 00 06           NEG   $06
c795: 31 06           LEAY  $6,X
c797: 00 06           NEG   $06
c799: 00 06           NEG   $06
c79b: 31 06           LEAY  $6,X
c79d: 00 06           NEG   $06
c79f: 00 06           NEG   $06
c7a1: 31 06           LEAY  $6,X
c7a3: 00 06           NEG   $06
c7a5: 00 06           NEG   $06
c7a7: 31 2a           LEAY  $A,Y
c7a9: 38              FCB   $38
c7aa: 30 82           LEAX  ,-X
c7ac: 00 87           NEG   $87
c7ae: 86 00           LDA   #$00
c7b0: 85 c8           BITA  #$C8
c7b2: 80 3d           SUBA  #$3D
c7b4: 06 3d           ROR   $3D
c7b6: 06 3d           ROR   $3D
c7b8: 06 3d           ROR   $3D
c7ba: 06 3d           ROR   $3D
c7bc: 06 3d           ROR   $3D
c7be: 06 3d           ROR   $3D
c7c0: 06 3d           ROR   $3D
c7c2: 06 3d           ROR   $3D
c7c4: 06 3d           ROR   $3D
c7c6: 06 3d           ROR   $3D
c7c8: 06 3d           ROR   $3D
c7ca: 06 3d           ROR   $3D
c7cc: 06 3d           ROR   $3D
c7ce: 06 3d           ROR   $3D
c7d0: 06 00           ROR   $00
c7d2: 06 00           ROR   $00
c7d4: 60 3d           NEG   -$3,Y
c7d6: 06 3d           ROR   $3D
c7d8: 06 3d           ROR   $3D
c7da: 06 3d           ROR   $3D
c7dc: 06 3d           ROR   $3D
c7de: 06 3d           ROR   $3D
c7e0: 06 3d           ROR   $3D
c7e2: 06 3d           ROR   $3D
c7e4: 06 3d           ROR   $3D
c7e6: 06 3d           ROR   $3D
c7e8: 06 3d           ROR   $3D
c7ea: 06 3d           ROR   $3D
c7ec: 06 3d           ROR   $3D
c7ee: 06 3d           ROR   $3D
c7f0: 06 3d           ROR   $3D
c7f2: 06 3d           ROR   $3D
c7f4: 06 3d           ROR   $3D
c7f6: 06 3d           ROR   $3D
c7f8: 06 3d           ROR   $3D
c7fa: 06 3d           ROR   $3D
c7fc: 06 3d           ROR   $3D
c7fe: 06 3d           ROR   $3D
c800: 06 3d           ROR   $3D
c802: 06 3d           ROR   $3D
c804: 06 3d           ROR   $3D
c806: 06 3d           ROR   $3D
c808: 06 3d           ROR   $3D
c80a: 06 3d           ROR   $3D
c80c: 06 3d           ROR   $3D
c80e: 06 3d           ROR   $3D
c810: 06 3d           ROR   $3D
c812: 06 3d           ROR   $3D
c814: 06 3d           ROR   $3D
c816: 06 3d           ROR   $3D
c818: 06 3d           ROR   $3D
c81a: 06 3d           ROR   $3D
c81c: 06 3d           ROR   $3D
c81e: 06 3d           ROR   $3D
c820: 06 3d           ROR   $3D
c822: 06 3d           ROR   $3D
c824: 06 3d           ROR   $3D
c826: 06 3d           ROR   $3D
c828: 06 3d           ROR   $3D
c82a: 06 3d           ROR   $3D
c82c: 06 3d           ROR   $3D
c82e: 06 3d           ROR   $3D
c830: 06 3d           ROR   $3D
c832: 06 3d           ROR   $3D
c834: 06 3d           ROR   $3D
c836: 06 3d           ROR   $3D
c838: 06 3d           ROR   $3D
c83a: 06 3d           ROR   $3D
c83c: 06 3d           ROR   $3D
c83e: 06 3d           ROR   $3D
c840: 06 3d           ROR   $3D
c842: 06 00           ROR   $00
c844: 06 00           ROR   $00
c846: 30 3d           LEAX  -$3,Y
c848: 06 3d           ROR   $3D
c84a: 06 3d           ROR   $3D
c84c: 06 3d           ROR   $3D
c84e: 06 3d           ROR   $3D
c850: 06 3d           ROR   $3D
c852: 06 3d           ROR   $3D
c854: 06 3d           ROR   $3D
c856: 06 3d           ROR   $3D
c858: 06 3d           ROR   $3D
c85a: 06 3d           ROR   $3D
c85c: 06 3d           ROR   $3D
c85e: 06 3d           ROR   $3D
c860: 06 3d           ROR   $3D
c862: 06 3d           ROR   $3D
c864: 06 3d           ROR   $3D
c866: 06 3d           ROR   $3D
c868: 06 3d           ROR   $3D
c86a: 06 3d           ROR   $3D
c86c: 06 3d           ROR   $3D
c86e: 06 3d           ROR   $3D
c870: 06 3d           ROR   $3D
c872: 06 3d           ROR   $3D
c874: 06 3d           ROR   $3D
c876: 06 3d           ROR   $3D
c878: 06 3d           ROR   $3D
c87a: 06 3d           ROR   $3D
c87c: 06 3d           ROR   $3D
c87e: 06 3d           ROR   $3D
c880: 06 3d           ROR   $3D
c882: 06 3d           ROR   $3D
c884: 06 3d           ROR   $3D
c886: 06 3d           ROR   $3D
c888: 06 3d           ROR   $3D
c88a: 06 3d           ROR   $3D
c88c: 06 3d           ROR   $3D
c88e: 06 3d           ROR   $3D
c890: 06 3d           ROR   $3D
c892: 06 3d           ROR   $3D
c894: 06 3d           ROR   $3D
c896: 06 3d           ROR   $3D
c898: 06 3d           ROR   $3D
c89a: 06 3d           ROR   $3D
c89c: 06 3d           ROR   $3D
c89e: 06 3d           ROR   $3D
c8a0: 06 3d           ROR   $3D
c8a2: 06 3d           ROR   $3D
c8a4: 06 3d           ROR   $3D
c8a6: 06 3d           ROR   $3D
c8a8: 06 3d           ROR   $3D
c8aa: 06 3d           ROR   $3D
c8ac: 06 3d           ROR   $3D
c8ae: 06 3d           ROR   $3D
c8b0: 06 3d           ROR   $3D
c8b2: 06 3d           ROR   $3D
c8b4: 06 00           ROR   $00
c8b6: 06 00           ROR   $00
c8b8: 30 3d           LEAX  -$3,Y
c8ba: 06 3d           ROR   $3D
c8bc: 06 3d           ROR   $3D
c8be: 06 3d           ROR   $3D
c8c0: 06 3d           ROR   $3D
c8c2: 06 3d           ROR   $3D
c8c4: 06 3d           ROR   $3D
c8c6: 06 3d           ROR   $3D
c8c8: 06 3d           ROR   $3D
c8ca: 06 3d           ROR   $3D
c8cc: 06 3d           ROR   $3D
c8ce: 06 3d           ROR   $3D
c8d0: 06 3d           ROR   $3D
c8d2: 06 3d           ROR   $3D
c8d4: 06 3d           ROR   $3D
c8d6: 06 3d           ROR   $3D
c8d8: 06 3d           ROR   $3D
c8da: 06 3d           ROR   $3D
c8dc: 06 3d           ROR   $3D
c8de: 06 3d           ROR   $3D
c8e0: 06 3d           ROR   $3D
c8e2: 06 3d           ROR   $3D
c8e4: 06 3d           ROR   $3D
c8e6: 06 3d           ROR   $3D
c8e8: 06 3d           ROR   $3D
c8ea: 06 3d           ROR   $3D
c8ec: 06 3d           ROR   $3D
c8ee: 06 3d           ROR   $3D
c8f0: 06 3d           ROR   $3D
c8f2: 06 3d           ROR   $3D
c8f4: 06 3d           ROR   $3D
c8f6: 06 3d           ROR   $3D
c8f8: 06 3d           ROR   $3D
c8fa: 06 3d           ROR   $3D
c8fc: 06 3d           ROR   $3D
c8fe: 06 3d           ROR   $3D
c900: 06 3d           ROR   $3D
c902: 06 3d           ROR   $3D
c904: 06 3d           ROR   $3D
c906: 06 3d           ROR   $3D
c908: 06 3d           ROR   $3D
c90a: 06 3d           ROR   $3D
c90c: 06 3d           ROR   $3D
c90e: 06 3d           ROR   $3D
c910: 06 3d           ROR   $3D
c912: 06 3d           ROR   $3D
c914: 06 3d           ROR   $3D
c916: 06 3d           ROR   $3D
c918: 06 3d           ROR   $3D
c91a: 06 3d           ROR   $3D
c91c: 06 3d           ROR   $3D
c91e: 06 3d           ROR   $3D
c920: 06 3d           ROR   $3D
c922: 06 3d           ROR   $3D
c924: 06 3d           ROR   $3D
c926: 06 3d           ROR   $3D
c928: 06 3d           ROR   $3D
c92a: 06 3d           ROR   $3D
c92c: 06 3d           ROR   $3D
c92e: 06 3d           ROR   $3D
c930: 06 3d           ROR   $3D
c932: 06 3d           ROR   $3D
c934: 06 3d           ROR   $3D
c936: 06 3d           ROR   $3D
c938: 06 3d           ROR   $3D
c93a: 06 3d           ROR   $3D
c93c: 06 3d           ROR   $3D
c93e: 06 3d           ROR   $3D
c940: 06 3d           ROR   $3D
c942: 06 3d           ROR   $3D
c944: 06 3d           ROR   $3D
c946: 06 3d           ROR   $3D
c948: 06 3d           ROR   $3D
c94a: 06 3d           ROR   $3D
c94c: 06 3d           ROR   $3D
c94e: 06 3d           ROR   $3D
c950: 06 3d           ROR   $3D
c952: 06 3d           ROR   $3D
c954: 06 3d           ROR   $3D
c956: 06 3d           ROR   $3D
c958: 06 3d           ROR   $3D
c95a: 06 3d           ROR   $3D
c95c: 06 3d           ROR   $3D
c95e: 06 3d           ROR   $3D
c960: 06 3d           ROR   $3D
c962: 06 3d           ROR   $3D
c964: 06 3d           ROR   $3D
c966: 06 3d           ROR   $3D
c968: 06 3d           ROR   $3D
c96a: 06 3d           ROR   $3D
c96c: 06 3d           ROR   $3D
c96e: 06 3d           ROR   $3D
c970: 06 3d           ROR   $3D
c972: 06 3d           ROR   $3D
c974: 06 3d           ROR   $3D
c976: 06 3d           ROR   $3D
c978: 06 3d           ROR   $3D
c97a: 06 3d           ROR   $3D
c97c: 06 3d           ROR   $3D
c97e: 06 3d           ROR   $3D
c980: 06 3d           ROR   $3D
c982: 06 3d           ROR   $3D
c984: 06 3d           ROR   $3D
c986: 06 3d           ROR   $3D
c988: 06 3d           ROR   $3D
c98a: 06 3d           ROR   $3D
c98c: 06 3d           ROR   $3D
c98e: 06 3d           ROR   $3D
c990: 06 3d           ROR   $3D
c992: 06 3d           ROR   $3D
c994: 06 3d           ROR   $3D
c996: 06 3d           ROR   $3D
c998: 06 3d           ROR   $3D
c99a: 06 3d           ROR   $3D
c99c: 06 3d           ROR   $3D
c99e: 06 3d           ROR   $3D
c9a0: 06 3d           ROR   $3D
c9a2: 06 3d           ROR   $3D
c9a4: 06 3d           ROR   $3D
c9a6: 06 3d           ROR   $3D
c9a8: 06 3d           ROR   $3D
c9aa: 06 3d           ROR   $3D
c9ac: 06 3d           ROR   $3D
c9ae: 06 3d           ROR   $3D
c9b0: 06 3d           ROR   $3D
c9b2: 06 3d           ROR   $3D
c9b4: 06 3d           ROR   $3D
c9b6: 06 3d           ROR   $3D
c9b8: 06 3d           ROR   $3D
c9ba: 06 3d           ROR   $3D
c9bc: 06 3d           ROR   $3D
c9be: 06 3d           ROR   $3D
c9c0: 06 3d           ROR   $3D
c9c2: 06 3d           ROR   $3D
c9c4: 06 3d           ROR   $3D
c9c6: 06 3d           ROR   $3D
c9c8: 06 3d           ROR   $3D
c9ca: 06 3d           ROR   $3D
c9cc: 06 3d           ROR   $3D
c9ce: 06 3d           ROR   $3D
c9d0: 06 3d           ROR   $3D
c9d2: 06 3d           ROR   $3D
c9d4: 06 3d           ROR   $3D
c9d6: 06 3d           ROR   $3D
c9d8: 06 3d           ROR   $3D
c9da: 06 3d           ROR   $3D
c9dc: 06 3d           ROR   $3D
c9de: 06 3d           ROR   $3D
c9e0: 06 3d           ROR   $3D
c9e2: 06 3d           ROR   $3D
c9e4: 06 3d           ROR   $3D
c9e6: 06 3d           ROR   $3D
c9e8: 06 3d           ROR   $3D
c9ea: 06 3d           ROR   $3D
c9ec: 06 3d           ROR   $3D
c9ee: 06 3d           ROR   $3D
c9f0: 06 3d           ROR   $3D
c9f2: 06 3d           ROR   $3D
c9f4: 06 3d           ROR   $3D
c9f6: 06 3d           ROR   $3D
c9f8: 06 82           ROR   $82
c9fa: 00 87           NEG   $87
c9fc: 86 00           LDA   #$00
c9fe: 85 e6           BITA  #$E6
ca00: 80 22           SUBA  #$22
ca02: 18              FCB   $18
ca03: 84 de           ANDA  #$DE
ca05: 52              FCB   $52
ca06: 85 d2           BITA  #$D2
ca08: 31 18           LEAY  -$8,X
ca0a: 84 de           ANDA  #$DE
ca0c: 77 85 e6        ASR   $85E6
ca0f: 22 18           BHI   $CA29
ca11: 84 de           ANDA  #$DE
ca13: 52              FCB   $52
ca14: 85 d2           BITA  #$D2
ca16: 31 0c           LEAY  $C,X
ca18: 31 0c           LEAY  $C,X
ca1a: 85 e6           BITA  #$E6
ca1c: 00 0c           NEG   $0C
ca1e: 31 0c           LEAY  $C,X
ca20: 31 0c           LEAY  $C,X
ca22: 00 0c           NEG   $0C
ca24: 31 06           LEAY  $6,X
ca26: 31 06           LEAY  $6,X
ca28: 00 06           NEG   $06
ca2a: 31 06           LEAY  $6,X
ca2c: 31 0c           LEAY  $C,X
ca2e: 31 0c           LEAY  $C,X
ca30: 81 84           CMPA  #$84
ca32: de 77           LDU   $77
ca34: 85 e6           BITA  #$E6
ca36: 22 18           BHI   $CA50
ca38: 84 de           ANDA  #$DE
ca3a: 52              FCB   $52
ca3b: 85 dc           BITA  #$DC
ca3d: 31 18           LEAY  -$8,X
ca3f: 84 de           ANDA  #$DE
ca41: 77 85 e6        ASR   $85E6
ca44: 22 18           BHI   $CA5E
ca46: 84 de           ANDA  #$DE
ca48: 52              FCB   $52
ca49: 85 dc           BITA  #$DC
ca4b: 31 18           LEAY  -$8,X
ca4d: 83 03 84        SUBD  #$0384
ca50: de 77           LDU   $77
ca52: 85 e6           BITA  #$E6
ca54: 22 18           BHI   $CA6E
ca56: 84 de           ANDA  #$DE
ca58: 52              FCB   $52
ca59: 85 dc           BITA  #$DC
ca5b: 31 0c           LEAY  $C,X
ca5d: 31 0c           LEAY  $C,X
ca5f: 31 0c           LEAY  $C,X
ca61: 00 0c           NEG   $0C
ca63: 31 06           LEAY  $6,X
ca65: 31 06           LEAY  $6,X
ca67: 00 06           NEG   $06
ca69: 31 06           LEAY  $6,X
ca6b: 81 84           CMPA  #$84
ca6d: de 77           LDU   $77
ca6f: 85 e6           BITA  #$E6
ca71: 22 18           BHI   $CA8B
ca73: 84 de           ANDA  #$DE
ca75: 52              FCB   $52
ca76: 85 dc           BITA  #$DC
ca78: 31 18           LEAY  -$8,X
ca7a: 84 de           ANDA  #$DE
ca7c: 77 85 e6        ASR   $85E6
ca7f: 22 18           BHI   $CA99
ca81: 84 de           ANDA  #$DE
ca83: 52              FCB   $52
ca84: 85 dc           BITA  #$DC
ca86: 31 18           LEAY  -$8,X
ca88: 83 03 84        SUBD  #$0384
ca8b: de 77           LDU   $77
ca8d: 85 e6           BITA  #$E6
ca8f: 22 18           BHI   $CAA9
ca91: 84 de           ANDA  #$DE
ca93: 52              FCB   $52
ca94: 85 dc           BITA  #$DC
ca96: 31 18           LEAY  -$8,X
ca98: 31 06           LEAY  $6,X
ca9a: 31 06           LEAY  $6,X
ca9c: 00 06           NEG   $06
ca9e: 31 06           LEAY  $6,X
caa0: 31 06           LEAY  $6,X
caa2: 31 06           LEAY  $6,X
caa4: 31 06           LEAY  $6,X
caa6: 31 06           LEAY  $6,X
caa8: 81 84           CMPA  #$84
caaa: de 77           LDU   $77
caac: 85 e6           BITA  #$E6
caae: 22 18           BHI   $CAC8
cab0: 84 de           ANDA  #$DE
cab2: 52              FCB   $52
cab3: 85 dc           BITA  #$DC
cab5: 31 18           LEAY  -$8,X
cab7: 84 de           ANDA  #$DE
cab9: 77 85 e6        ASR   $85E6
cabc: 22 18           BHI   $CAD6
cabe: 84 de           ANDA  #$DE
cac0: 52              FCB   $52
cac1: 85 dc           BITA  #$DC
cac3: 31 18           LEAY  -$8,X
cac5: 83 04 84        SUBD  #$0484
cac8: de 77           LDU   $77
caca: 85 e6           BITA  #$E6
cacc: 22 12           BHI   $CAE0
cace: 22 06           BHI   $CAD6
cad0: 84 de           ANDA  #$DE
cad2: 52              FCB   $52
cad3: 85 dc           BITA  #$DC
cad5: 31 18           LEAY  -$8,X
cad7: 84 de           ANDA  #$DE
cad9: 77 85 e6        ASR   $85E6
cadc: 22 12           BHI   $CAF0
cade: 22 06           BHI   $CAE6
cae0: 84 de           ANDA  #$DE
cae2: 52              FCB   $52
cae3: 85 dc           BITA  #$DC
cae5: 31 0c           LEAY  $C,X
cae7: 84 de           ANDA  #$DE
cae9: 77 85 e6        ASR   $85E6
caec: 22 0c           BHI   $CAFA
caee: 00 0c           NEG   $0C
caf0: 31 0c           LEAY  $C,X
caf2: 31 0c           LEAY  $C,X
caf4: 00 0c           NEG   $0C
caf6: 31 06           LEAY  $6,X
caf8: 31 06           LEAY  $6,X
cafa: 00 06           NEG   $06
cafc: 31 06           LEAY  $6,X
cafe: 31 0c           LEAY  $C,X
cb00: 31 0c           LEAY  $C,X
cb02: 84 de           ANDA  #$DE
cb04: 77 85 e6        ASR   $85E6
cb07: 22 12           BHI   $CB1B
cb09: 22 06           BHI   $CB11
cb0b: 84 de           ANDA  #$DE
cb0d: 52              FCB   $52
cb0e: 85 dc           BITA  #$DC
cb10: 31 18           LEAY  -$8,X
cb12: 84 de           ANDA  #$DE
cb14: 77 85 e6        ASR   $85E6
cb17: 22 12           BHI   $CB2B
cb19: 22 06           BHI   $CB21
cb1b: 84 de           ANDA  #$DE
cb1d: 52              FCB   $52
cb1e: 85 dc           BITA  #$DC
cb20: 31 18           LEAY  -$8,X
cb22: 84 de           ANDA  #$DE
cb24: 77 85 e6        ASR   $85E6
cb27: 22 12           BHI   $CB3B
cb29: 22 06           BHI   $CB31
cb2b: 84 de           ANDA  #$DE
cb2d: 52              FCB   $52
cb2e: 85 dc           BITA  #$DC
cb30: 31 18           LEAY  -$8,X
cb32: 84 de           ANDA  #$DE
cb34: 77 85 e6        ASR   $85E6
cb37: 22 18           BHI   $CB51
cb39: 84 de           ANDA  #$DE
cb3b: 52              FCB   $52
cb3c: 85 dc           BITA  #$DC
cb3e: 31 06           LEAY  $6,X
cb40: 31 06           LEAY  $6,X
cb42: 31 06           LEAY  $6,X
cb44: 31 06           LEAY  $6,X
cb46: 00 0c           NEG   $0C
cb48: 31 06           LEAY  $6,X
cb4a: 00 06           NEG   $06
cb4c: 31 06           LEAY  $6,X
cb4e: 31 06           LEAY  $6,X
cb50: 00 06           NEG   $06
cb52: 31 06           LEAY  $6,X
cb54: 31 06           LEAY  $6,X
cb56: 00 06           NEG   $06
cb58: 18              FCB   $18
cb59: 06 31           ROR   $31
cb5b: 06 00           ROR   $00
cb5d: 06 31           ROR   $31
cb5f: 06 31           ROR   $31
cb61: 06 00           ROR   $00
cb63: 06 31           ROR   $31
cb65: 06 31           ROR   $31
cb67: 06 00           ROR   $00
cb69: 06 31           ROR   $31
cb6b: 06 31           ROR   $31
cb6d: 06 31           ROR   $31
cb6f: 06 00           ROR   $00
cb71: 06 31           ROR   $31
cb73: 06 31           ROR   $31
cb75: 0c 31           INC   $31
cb77: 0c 85           INC   $85
cb79: dc 31           LDD   $31
cb7b: 06 31           ROR   $31
cb7d: 06 00           ROR   $00
cb7f: 06 31           ROR   $31
cb81: 06 84           ROR   $84
cb83: de 77           LDU   $77
cb85: 85 e6           BITA  #$E6
cb87: 82 00           SBCA  #$00
cb89: 87              FCB   $87
cb8a: 05 ed cb        EIM   #$ED;$CB
cb8d: a0 d8 af        SUBA  [-$51,U]
cb90: cb bf           ADDB  #$BF
cb92: d8 af           EORB  $AF
cb94: cb da           ADDB  #$DA
cb96: d8 af           EORB  $AF
cb98: cb ef           ADDB  #$EF
cb9a: d8 af           EORB  $AF
cb9c: cb f8           ADDB  #$F8
cb9e: d8 af           EORB  $AF
cba0: 86 00           LDA   #$00
cba2: 85 d2           BITA  #$D2
cba4: 31 08           LEAY  $8,X
cba6: 31 08           LEAY  $8,X
cba8: 31 08           LEAY  $8,X
cbaa: 31 08           LEAY  $8,X
cbac: 31 08           LEAY  $8,X
cbae: 31 08           LEAY  $8,X
cbb0: 31 08           LEAY  $8,X
cbb2: 31 08           LEAY  $8,X
cbb4: 31 08           LEAY  $8,X
cbb6: 31 08           LEAY  $8,X
cbb8: 31 08           LEAY  $8,X
cbba: 31 08           LEAY  $8,X
cbbc: 31 60           LEAY  $0,S
cbbe: 87              FCB   $87
cbbf: 86 00           LDA   #$00
cbc1: 85 d2           BITA  #$D2
cbc3: 00 18           NEG   $18
cbc5: 36 08           PSHU  DP
cbc7: 36 08           PSHU  DP
cbc9: 36 08           PSHU  DP
cbcb: 36 08           PSHU  DP
cbcd: 36 08           PSHU  DP
cbcf: 36 08           PSHU  DP
cbd1: 36 08           PSHU  DP
cbd3: 36 08           PSHU  DP
cbd5: 36 08           PSHU  DP
cbd7: 36 60           PSHU  S,Y
cbd9: 87              FCB   $87
cbda: 86 00           LDA   #$00
cbdc: 85 d2           BITA  #$D2
cbde: 00 30           NEG   $30
cbe0: 3b              RTI
cbe1: 08 3b           ASL   $3B
cbe3: 08 3b           ASL   $3B
cbe5: 08 3a           ASL   $3A
cbe7: 08 3a           ASL   $3A
cbe9: 08 3a           ASL   $3A
cbeb: 08 3a           ASL   $3A
cbed: 60 87           NEG   E,X
cbef: 86 00           LDA   #$00
cbf1: 85 dc           BITA  #$DC
cbf3: 00 60           NEG   $60
cbf5: 3d              MUL
cbf6: 60 87           NEG   E,X
cbf8: 86 00           LDA   #$00
cbfa: 85 b4           BITA  #$B4
cbfc: 88 ff           EORA  #$FF
cbfe: 25 60           BCS   $CC60
cc00: 88 c8           EORA  #$C8
cc02: 1e 60           EXG   W,D
cc04: 87              FCB   $87
cc05: 07 f0           ASR   $F0
cc07: cc 23 db        LDD   #$23DB
cc0a: 49              ROLA
cc0b: cd b3 db 6e cf  LDQ   #$B3DB6ECF
cc10: 0e dd           JMP   $DD
cc12: 05 cf 96        EIM   #$CF;$96
cc15: dd 05           STD   $05
cc17: d0 4d           SUBB  $4D
cc19: da 90           ORB   $90
cc1b: d1 d9           CMPB  $D9
cc1d: de 2d           LDU   $2D
cc1f: d3 1b           ADDD  $1B
cc21: de 52           LDU   $52
cc23: 86 0c           LDA   #$0C
cc25: 85 c8           BITA  #$C8
cc27: 00 0c           NEG   $0C
cc29: 35 0c           PULS  B,DP
cc2b: 38              FCB   $38
cc2c: 0c 39           INC   $39
cc2e: 0c 3a           INC   $3A
cc30: 0c 38           INC   $38
cc32: 0c 35           INC   $35
cc34: 0c 3c           INC   $3C
cc36: 0c 80           INC   $80
cc38: 3a              ABX
cc39: 0c 39           INC   $39
cc3b: 0c 3a           INC   $3A
cc3d: 0c 3d           INC   $3D
cc3f: 0c 3c           INC   $3C
cc41: 0c 3a           INC   $3A
cc43: 0c 38           INC   $38
cc45: 0c 35           INC   $35
cc47: 0c 3a           INC   $3A
cc49: 0c 39           INC   $39
cc4b: 0c 3a           INC   $3A
cc4d: 0c 3c           INC   $3C
cc4f: 0c 3d           INC   $3D
cc51: 0c 3f           INC   $3F
cc53: 0c 3d           INC   $3D
cc55: 0c 3c           INC   $3C
cc57: 0c 39           INC   $39
cc59: 0c 3a           INC   $3A
cc5b: 0c 34           INC   $34
cc5d: 0c 35           INC   $35
cc5f: 0c 30           INC   $30
cc61: 0c 31           INC   $31
cc63: 0c 2d           INC   $2D
cc65: 0c 2e           INC   $2E
cc67: 0c 28           INC   $28
cc69: 0c 29           INC   $29
cc6b: 0c 2d           INC   $2D
cc6d: 0c 2e           INC   $2E
cc6f: 0c 30           INC   $30
cc71: 0c 31           INC   $31
cc73: 0c 34           INC   $34
cc75: 0c 35           INC   $35
cc77: 0c 3a           INC   $3A
cc79: 0c 39           INC   $39
cc7b: 0c 3a           INC   $3A
cc7d: 0c 3d           INC   $3D
cc7f: 0c 3c           INC   $3C
cc81: 0c 3a           INC   $3A
cc83: 0c 38           INC   $38
cc85: 0c 35           INC   $35
cc87: 0c 3a           INC   $3A
cc89: 0c 39           INC   $39
cc8b: 0c 3a           INC   $3A
cc8d: 0c 3c           INC   $3C
cc8f: 0c 3d           INC   $3D
cc91: 0c 3f           INC   $3F
cc93: 0c 3d           INC   $3D
cc95: 0c 3c           INC   $3C
cc97: 0c 39           INC   $39
cc99: 0c 3a           INC   $3A
cc9b: 0c 34           INC   $34
cc9d: 0c 35           INC   $35
cc9f: 0c 30           INC   $30
cca1: 0c 31           INC   $31
cca3: 0c 2d           INC   $2D
cca5: 0c 2e           INC   $2E
cca7: 0c 28           INC   $28
cca9: 0c 29           INC   $29
ccab: 0c 2d           INC   $2D
ccad: 0c 2e           INC   $2E
ccaf: 0c 30           INC   $30
ccb1: 0c 31           INC   $31
ccb3: 0c 34           INC   $34
ccb5: 0c 35           INC   $35
ccb7: 0c 3a           INC   $3A
ccb9: 0c 36           INC   $36
ccbb: 0c 33           INC   $33
ccbd: 0c 3d           INC   $3D
ccbf: 0c 3c           INC   $3C
ccc1: 0c 3a           INC   $3A
ccc3: 0c 36           INC   $36
ccc5: 0c 33           INC   $33
ccc7: 0c 3a           INC   $3A
ccc9: 0c 36           INC   $36
cccb: 0c 33           INC   $33
cccd: 0c 3d           INC   $3D
cccf: 0c 3c           INC   $3C
ccd1: 0c 3a           INC   $3A
ccd3: 0c 3c           INC   $3C
ccd5: 0c 3d           INC   $3D
ccd7: 0c 3a           INC   $3A
ccd9: 0c 35           INC   $35
ccdb: 0c 31           INC   $31
ccdd: 0c 3c           INC   $3C
ccdf: 0c 3d           INC   $3D
cce1: 0c 3c           INC   $3C
cce3: 0c 3a           INC   $3A
cce5: 0c 35           INC   $35
cce7: 0c 3c           INC   $3C
cce9: 0c 3d           INC   $3D
cceb: 0c 3f           INC   $3F
cced: 0c 3d           INC   $3D
ccef: 0c 3c           INC   $3C
ccf1: 0c 3a           INC   $3A
ccf3: 0c 39           INC   $39
ccf5: 0c 3a           INC   $3A
ccf7: 0c 3a           INC   $3A
ccf9: 0c 36           INC   $36
ccfb: 0c 33           INC   $33
ccfd: 0c 3d           INC   $3D
ccff: 0c 3c           INC   $3C
cd01: 0c 3a           INC   $3A
cd03: 0c 36           INC   $36
cd05: 0c 33           INC   $33
cd07: 0c 3a           INC   $3A
cd09: 0c 36           INC   $36
cd0b: 0c 33           INC   $33
cd0d: 0c 3d           INC   $3D
cd0f: 0c 3c           INC   $3C
cd11: 0c 3a           INC   $3A
cd13: 0c 3c           INC   $3C
cd15: 0c 3d           INC   $3D
cd17: 0c 3d           INC   $3D
cd19: 0c 00           INC   $00
cd1b: 0c 3d           INC   $3D
cd1d: 0c 3d           INC   $3D
cd1f: 0c 3d           INC   $3D
cd21: 0c 3f           INC   $3F
cd23: 18              FCB   $18
cd24: 3d              MUL
cd25: 0c 3c           INC   $3C
cd27: 3c 84           CWAI  #$84
cd29: dd 99           STD   $99
cd2b: 85 b4           BITA  #$B4
cd2d: 86 00           LDA   #$00
cd2f: 29 0c           BVS   $CD3D
cd31: 2c 0c           BGE   $CD3F
cd33: 2d 0c           BLT   $CD41
cd35: 2e 0c           BGT   $CD43
cd37: 29 18           BVS   $CD51
cd39: 22 18           BHI   $CD53
cd3b: 25 0c           BCS   $CD49
cd3d: 27 0c           BEQ   $CD4B
cd3f: 25 0c           BCS   $CD4D
cd41: 2a 0c           BPL   $CD4F
cd43: 2a 0c           BPL   $CD51
cd45: 00 0c           NEG   $0C
cd47: 29 18           BVS   $CD61
cd49: 29 0c           BVS   $CD57
cd4b: 2c 0c           BGE   $CD59
cd4d: 2d 0c           BLT   $CD5B
cd4f: 2e 0c           BGT   $CD5D
cd51: 29 18           BVS   $CD6B
cd53: 22 18           BHI   $CD6D
cd55: 25 0c           BCS   $CD63
cd57: 27 0c           BEQ   $CD65
cd59: 25 0c           BCS   $CD67
cd5b: 2a 0c           BPL   $CD69
cd5d: 2a 0c           BPL   $CD6B
cd5f: 00 0c           NEG   $0C
cd61: 29 18           BVS   $CD7B
cd63: 29 0c           BVS   $CD71
cd65: 2c 0c           BGE   $CD73
cd67: 2d 0c           BLT   $CD75
cd69: 2e 0c           BGT   $CD77
cd6b: 30 0c           LEAX  $C,X
cd6d: 31 0c           LEAY  $C,X
cd6f: 34 0c           PSHS  DP,B
cd71: 35 0c           PULS  B,DP
cd73: 39              RTS
cd74: 0c 3a           INC   $3A
cd76: 0c 3c           INC   $3C
cd78: 0c 3d           INC   $3D
cd7a: 0c 3f           INC   $3F
cd7c: 0c 3c           INC   $3C
cd7e: 0c 3a           INC   $3A
cd80: 0c 39           INC   $39
cd82: 0c 29           INC   $29
cd84: 0c 39           INC   $39
cd86: 0c 3c           INC   $3C
cd88: 0c 00           INC   $00
cd8a: 0c 2e           INC   $2E
cd8c: 0c 00           INC   $00
cd8e: 0c 3c           INC   $3C
cd90: 0c 00           INC   $00
cd92: 0c 31           INC   $31
cd94: 0c 00           INC   $00
cd96: 0c 33           INC   $33
cd98: 0c 34           INC   $34
cd9a: 0c 35           INC   $35
cd9c: 0c 38           INC   $38
cd9e: 0c 39           INC   $39
cda0: 0c 3a           INC   $3A
cda2: 0c 38           INC   $38
cda4: 0c 35           INC   $35
cda6: 0c 3c           INC   $3C
cda8: 0c 84           INC   $84
cdaa: db 49           ADDB  $49
cdac: 85 c8           BITA  #$C8
cdae: 86 0c           LDA   #$0C
cdb0: 82 00           SBCA  #$00
cdb2: 87              FCB   $87
cdb3: 86 00           LDA   #$00
cdb5: 85 be           BITA  #$BE
cdb7: 00 60           NEG   $60
cdb9: 80 22           SUBA  #$22
cdbb: 0c 29           INC   $29
cdbd: 0c 22           INC   $22
cdbf: 0c 29           INC   $29
cdc1: 0c 22           INC   $22
cdc3: 0c 29           INC   $29
cdc5: 0c 22           INC   $22
cdc7: 0c 29           INC   $29
cdc9: 0c 22           INC   $22
cdcb: 0c 29           INC   $29
cdcd: 0c 22           INC   $22
cdcf: 0c 29           INC   $29
cdd1: 0c 22           INC   $22
cdd3: 0c 29           INC   $29
cdd5: 0c 22           INC   $22
cdd7: 0c 29           INC   $29
cdd9: 0c 22           INC   $22
cddb: 0c 29           INC   $29
cddd: 0c 22           INC   $22
cddf: 0c 29           INC   $29
cde1: 0c 22           INC   $22
cde3: 0c 29           INC   $29
cde5: 0c 22           INC   $22
cde7: 0c 29           INC   $29
cde9: 0c 22           INC   $22
cdeb: 0c 29           INC   $29
cded: 0c 22           INC   $22
cdef: 0c 29           INC   $29
cdf1: 0c 22           INC   $22
cdf3: 0c 29           INC   $29
cdf5: 0c 22           INC   $22
cdf7: 0c 29           INC   $29
cdf9: 0c 22           INC   $22
cdfb: 0c 29           INC   $29
cdfd: 0c 22           INC   $22
cdff: 0c 29           INC   $29
ce01: 0c 22           INC   $22
ce03: 0c 29           INC   $29
ce05: 0c 22           INC   $22
ce07: 0c 29           INC   $29
ce09: 0c 22           INC   $22
ce0b: 0c 29           INC   $29
ce0d: 0c 22           INC   $22
ce0f: 0c 29           INC   $29
ce11: 0c 22           INC   $22
ce13: 0c 29           INC   $29
ce15: 0c 22           INC   $22
ce17: 0c 29           INC   $29
ce19: 0c 22           INC   $22
ce1b: 0c 22           INC   $22
ce1d: 0c 85           INC   $85
ce1f: c8 39           EORB  #$39
ce21: 0c 3a           INC   $3A
ce23: 0c 34           INC   $34
ce25: 0c 35           INC   $35
ce27: 0c 30           INC   $30
ce29: 0c 31           INC   $31
ce2b: 0c 2d           INC   $2D
ce2d: 0c 2e           INC   $2E
ce2f: 0c 30           INC   $30
ce31: 0c 31           INC   $31
ce33: 0c 34           INC   $34
ce35: 0c 35           INC   $35
ce37: 0c 39           INC   $39
ce39: 0c 3a           INC   $3A
ce3b: 0c 84           INC   $84
ce3d: db 93           ADDB  $93
ce3f: 85 d2           BITA  #$D2
ce41: 86 00           LDA   #$00
ce43: 36 18           PSHU  X,DP
ce45: 33 0c           LEAU  $C,X
ce47: 3a              ABX
ce48: 18              FCB   $18
ce49: 3a              ABX
ce4a: 0c 36           INC   $36
ce4c: 0c 33           INC   $33
ce4e: 0c 36           INC   $36
ce50: 18              FCB   $18
ce51: 33 0c           LEAU  $C,X
ce53: 3a              ABX
ce54: 18              FCB   $18
ce55: 3a              ABX
ce56: 0c 3c           INC   $3C
ce58: 0c 3d           INC   $3D
ce5a: 0c 41           INC   $41
ce5c: 0c 3d           INC   $3D
ce5e: 0c 00           INC   $00
ce60: 0c 3a           INC   $3A
ce62: 24 41           BCC   $CEA5
ce64: 18              FCB   $18
ce65: 44              LSRA
ce66: 0c 3d           INC   $3D
ce68: 0c 00           INC   $00
ce6a: 0c 3a           INC   $3A
ce6c: 24 35           BCC   $CEA3
ce6e: 18              FCB   $18
ce6f: 36 18           PSHU  X,DP
ce71: 33 0c           LEAU  $C,X
ce73: 3a              ABX
ce74: 18              FCB   $18
ce75: 3a              ABX
ce76: 0c 36           INC   $36
ce78: 0c 33           INC   $33
ce7a: 0c 36           INC   $36
ce7c: 18              FCB   $18
ce7d: 33 0c           LEAU  $C,X
ce7f: 3a              ABX
ce80: 18              FCB   $18
ce81: 3a              ABX
ce82: 0c 3c           INC   $3C
ce84: 0c 3d           INC   $3D
ce86: 0c 84           INC   $84
ce88: db dd           ADDB  $DD
ce8a: 85 d2           BITA  #$D2
ce8c: 86 00           LDA   #$00
ce8e: 00 60           NEG   $60
ce90: 00 30           NEG   $30
ce92: 00 0c           NEG   $0C
ce94: 29 0c           BVS   $CEA2
ce96: 2c 0c           BGE   $CEA4
ce98: 2d 0c           BLT   $CEA6
ce9a: 2e 0c           BGT   $CEA8
ce9c: 29 18           BVS   $CEB6
ce9e: 22 18           BHI   $CEB8
cea0: 25 0c           BCS   $CEAE
cea2: 27 0c           BEQ   $CEB0
cea4: 25 0c           BCS   $CEB2
cea6: 2a 0c           BPL   $CEB4
cea8: 2a 0c           BPL   $CEB6
ceaa: 00 0c           NEG   $0C
ceac: 29 18           BVS   $CEC6
ceae: 29 0c           BVS   $CEBC
ceb0: 2c 0c           BGE   $CEBE
ceb2: 2d 0c           BLT   $CEC0
ceb4: 2e 0c           BGT   $CEC2
ceb6: 29 18           BVS   $CED0
ceb8: 22 18           BHI   $CED2
ceba: 25 0c           BCS   $CEC8
cebc: 27 0c           BEQ   $CECA
cebe: 25 0c           BCS   $CECC
cec0: 2a 0c           BPL   $CECE
cec2: 2a 0c           BPL   $CED0
cec4: 00 0c           NEG   $0C
cec6: 29 18           BVS   $CEE0
cec8: 29 0c           BVS   $CED6
ceca: 2c 0c           BGE   $CED8
cecc: 2d 0c           BLT   $CEDA
cece: 2e 0c           BGT   $CEDC
ced0: 30 0c           LEAX  $C,X
ced2: 31 0c           LEAY  $C,X
ced4: 34 0c           PSHS  DP,B
ced6: 35 0c           PULS  B,DP
ced8: 39              RTS
ced9: 0c 3a           INC   $3A
cedb: 0c 3c           INC   $3C
cedd: 0c 3d           INC   $3D
cedf: 0c 3f           INC   $3F
cee1: 0c 3c           INC   $3C
cee3: 0c 3a           INC   $3A
cee5: 0c 39           INC   $39
cee7: 0c 29           INC   $29
cee9: 0c 39           INC   $39
ceeb: 0c 3c           INC   $3C
ceed: 0c 00           INC   $00
ceef: 0c 2e           INC   $2E
cef1: 0c 00           INC   $00
cef3: 0c 3c           INC   $3C
cef5: 0c 00           INC   $00
cef7: 0c 31           INC   $31
cef9: 0c 00           INC   $00
cefb: 0c 33           INC   $33
cefd: 0c 34           INC   $34
ceff: 0c 00           INC   $00
cf01: 0c 00           INC   $00
cf03: 18              FCB   $18
cf04: 84 db           ANDA  #$DB
cf06: 6e 85           JMP   B,X
cf08: be 00 30        LDX   >$0030
cf0b: 82 00           SBCA  #$00
cf0d: 87              FCB   $87
cf0e: 86 00           LDA   #$00
cf10: 85 c8           BITA  #$C8
cf12: 00 60           NEG   $60
cf14: 80 3a           SUBA  #$3A
cf16: 24 3a           BCC   $CF52
cf18: 0c 00           INC   $00
cf1a: 0c 3a           INC   $3A
cf1c: 0c 00           INC   $00
cf1e: 18              FCB   $18
cf1f: 3a              ABX
cf20: 24 3a           BCC   $CF5C
cf22: 0c 00           INC   $00
cf24: 0c 3a           INC   $3A
cf26: 0c 00           INC   $00
cf28: 0c 3a           INC   $3A
cf2a: 0c 3a           INC   $3A
cf2c: 60 35           NEG   -$B,Y
cf2e: 60 3a           NEG   -$6,Y
cf30: 24 3a           BCC   $CF6C
cf32: 0c 00           INC   $00
cf34: 0c 3a           INC   $3A
cf36: 0c 00           INC   $00
cf38: 18              FCB   $18
cf39: 3a              ABX
cf3a: 24 3a           BCC   $CF76
cf3c: 0c 00           INC   $00
cf3e: 0c 3a           INC   $3A
cf40: 0c 00           INC   $00
cf42: 0c 3a           INC   $3A
cf44: 0c 3a           INC   $3A
cf46: 60 41           NEG   $1,U
cf48: 60 00           NEG   $0,X
cf4a: 60 00           NEG   $0,X
cf4c: 60 84           NEG   ,X
cf4e: dc bb           LDD   $BB
cf50: 85 be           BITA  #$BE
cf52: 86 00           LDA   #$00
cf54: 00 60           NEG   $60
cf56: 00 60           NEG   $60
cf58: 00 60           NEG   $60
cf5a: 00 60           NEG   $60
cf5c: 85 d2           BITA  #$D2
cf5e: 3a              ABX
cf5f: 60 39           NEG   -$7,Y
cf61: 24 39           BCC   $CF9C
cf63: 0c 00           INC   $00
cf65: 30 35           LEAX  -$B,Y
cf67: 60 3a           NEG   -$6,Y
cf69: 24 39           BCC   $CFA4
cf6b: 0c 00           INC   $00
cf6d: 30 35           LEAX  -$B,Y
cf6f: 60 3a           NEG   -$6,Y
cf71: 24 39           BCC   $CFAC
cf73: 0c 00           INC   $00
cf75: 30 00           LEAX  $0,X
cf77: 60 00           NEG   $0,X
cf79: 60 84           NEG   ,X
cf7b: dd 05           STD   $05
cf7d: 85 c8           BITA  #$C8
cf7f: 2e 0c           BGT   $CF8D
cf81: 3a              ABX
cf82: 0c 2e           INC   $2E
cf84: 0c 3c           INC   $3C
cf86: 0c 2e           INC   $2E
cf88: 0c 3d           INC   $3D
cf8a: 0c 2e           INC   $2E
cf8c: 0c 3f           INC   $3F
cf8e: 0c 40           INC   $40
cf90: 0c 41           INC   $41
cf92: 54              LSRB
cf93: 82 00           SBCA  #$00
cf95: 87              FCB   $87
cf96: 85 c8           BITA  #$C8
cf98: 86 00           LDA   #$00
cf9a: 00 60           NEG   $60
cf9c: 80 35           SUBA  #$35
cf9e: 24 35           BCC   $CFD5
cfa0: 0c 00           INC   $00
cfa2: 0c 35           INC   $35
cfa4: 0c 00           INC   $00
cfa6: 18              FCB   $18
cfa7: 35 24           PULS  B,Y
cfa9: 35 0c           PULS  B,DP
cfab: 00 0c           NEG   $0C
cfad: 35 0c           PULS  B,DP
cfaf: 00 0c           NEG   $0C
cfb1: 35 0c           PULS  B,DP
cfb3: 35 60           PULS  Y,U
cfb5: 2e 60           BGT   $D017
cfb7: 35 24           PULS  B,Y
cfb9: 35 0c           PULS  B,DP
cfbb: 00 0c           NEG   $0C
cfbd: 35 0c           PULS  B,DP
cfbf: 00 18           NEG   $18
cfc1: 35 24           PULS  B,Y
cfc3: 35 0c           PULS  B,DP
cfc5: 00 0c           NEG   $0C
cfc7: 35 0c           PULS  B,DP
cfc9: 00 0c           NEG   $0C
cfcb: 35 0c           PULS  B,DP
cfcd: 35 60           PULS  Y,U
cfcf: 2e 60           BGT   $D031
cfd1: 84 db           ANDA  #$DB
cfd3: 93 85           SUBD  $85
cfd5: c8 86           EORB  #$86
cfd7: 00 2a           NEG   $2A
cfd9: 0c 00           INC   $00
cfdb: 0c 2a           INC   $2A
cfdd: 0c 2a           INC   $2A
cfdf: 0c 00           INC   $00
cfe1: 30 2a           LEAX  $A,Y
cfe3: 0c 00           INC   $00
cfe5: 0c 2a           INC   $2A
cfe7: 0c 2a           INC   $2A
cfe9: 0c 00           INC   $00
cfeb: 30 29           LEAX  $9,Y
cfed: 0c 29           INC   $29
cfef: 0c 00           INC   $00
cff1: 0c 29           INC   $29
cff3: 0c 00           INC   $00
cff5: 30 29           LEAX  $9,Y
cff7: 0c 00           INC   $00
cff9: 0c 29           INC   $29
cffb: 0c 29           INC   $29
cffd: 0c 00           INC   $00
cfff: 30 2a           LEAX  $A,Y
d001: 0c 00           INC   $00
d003: 0c 2a           INC   $2A
d005: 0c 2a           INC   $2A
d007: 0c 00           INC   $00
d009: 30 2a           LEAX  $A,Y
d00b: 0c 00           INC   $00
d00d: 0c 2a           INC   $2A
d00f: 0c 2a           INC   $2A
d011: 0c 00           INC   $00
d013: 0c 84           INC   $84
d015: dc bb           LDD   $BB
d017: 85 c8           BITA  #$C8
d019: 86 00           LDA   #$00
d01b: 00 0c           NEG   $0C
d01d: 00 0c           NEG   $0C
d01f: 00 0c           NEG   $0C
d021: 85 c8           BITA  #$C8
d023: 34 60           PSHS  U,Y
d025: 33 24           LEAU  $4,Y
d027: 33 0c           LEAU  $C,X
d029: 00 30           NEG   $30
d02b: 2e 60           BGT   $D08D
d02d: 34 24           PSHS  Y,B
d02f: 33 0c           LEAU  $C,X
d031: 00 30           NEG   $30
d033: 2e 60           BGT   $D095
d035: 34 24           PSHS  Y,B
d037: 33 0c           LEAU  $C,X
d039: 00 30           NEG   $30
d03b: 00 60           NEG   $60
d03d: 84 dd           ANDA  #$DD
d03f: 05 85 c8        EIM   #$85;$C8
d042: 86 00           LDA   #$00
d044: 00 60           NEG   $60
d046: 00 60           NEG   $60
d048: 00 60           NEG   $60
d04a: 82 00           SBCA  #$00
d04c: 87              FCB   $87
d04d: 86 00           LDA   #$00
d04f: 85 dc           BITA  #$DC
d051: 00 0c           NEG   $0C
d053: 29 0c           BVS   $D061
d055: 2c 0c           BGE   $D063
d057: 2d 0c           BLT   $D065
d059: 2e 0c           BGT   $D067
d05b: 2c 0c           BGE   $D069
d05d: 29 0c           BVS   $D06B
d05f: 25 0c           BCS   $D06D
d061: 80 22           SUBA  #$22
d063: 0c 22           INC   $22
d065: 0c 25           INC   $25
d067: 0c 24           INC   $24
d069: 0c 25           INC   $25
d06b: 0c 29           INC   $29
d06d: 0c 22           INC   $22
d06f: 0c 21           INC   $21
d071: 0c 22           INC   $22
d073: 0c 22           INC   $22
d075: 0c 25           INC   $25
d077: 0c 24           INC   $24
d079: 0c 25           INC   $25
d07b: 0c 29           INC   $29
d07d: 0c 1d           INC   $1D
d07f: 0c 21           INC   $21
d081: 0c 22           INC   $22
d083: 0c 22           INC   $22
d085: 0c 21           INC   $21
d087: 0c 21           INC   $21
d089: 0c 20           INC   $20
d08b: 0c 20           INC   $20
d08d: 0c 21           INC   $21
d08f: 0c 21           INC   $21
d091: 0c 22           INC   $22
d093: 0c 22           INC   $22
d095: 0c 25           INC   $25
d097: 0c 24           INC   $24
d099: 0c 22           INC   $22
d09b: 0c 1d           INC   $1D
d09d: 0c 20           INC   $20
d09f: 0c 21           INC   $21
d0a1: 0c 22           INC   $22
d0a3: 0c 22           INC   $22
d0a5: 0c 25           INC   $25
d0a7: 0c 24           INC   $24
d0a9: 0c 25           INC   $25
d0ab: 0c 29           INC   $29
d0ad: 0c 22           INC   $22
d0af: 0c 21           INC   $21
d0b1: 0c 22           INC   $22
d0b3: 0c 22           INC   $22
d0b5: 0c 25           INC   $25
d0b7: 0c 24           INC   $24
d0b9: 0c 25           INC   $25
d0bb: 0c 29           INC   $29
d0bd: 0c 1d           INC   $1D
d0bf: 0c 21           INC   $21
d0c1: 0c 22           INC   $22
d0c3: 0c 22           INC   $22
d0c5: 0c 21           INC   $21
d0c7: 0c 21           INC   $21
d0c9: 0c 20           INC   $20
d0cb: 0c 20           INC   $20
d0cd: 0c 21           INC   $21
d0cf: 0c 21           INC   $21
d0d1: 0c 22           INC   $22
d0d3: 0c 22           INC   $22
d0d5: 0c 25           INC   $25
d0d7: 0c 24           INC   $24
d0d9: 0c 22           INC   $22
d0db: 0c 1d           INC   $1D
d0dd: 0c 20           INC   $20
d0df: 0c 21           INC   $21
d0e1: 0c 27           INC   $27
d0e3: 0c 00           INC   $00
d0e5: 0c 27           INC   $27
d0e7: 0c 27           INC   $27
d0e9: 0c 00           INC   $00
d0eb: 0c 2a           INC   $2A
d0ed: 0c 2c           INC   $2C
d0ef: 0c 2e           INC   $2E
d0f1: 0c 27           INC   $27
d0f3: 0c 00           INC   $00
d0f5: 0c 27           INC   $27
d0f7: 0c 27           INC   $27
d0f9: 0c 27           INC   $27
d0fb: 0c 27           INC   $27
d0fd: 0c 25           INC   $25
d0ff: 0c 24           INC   $24
d101: 0c 22           INC   $22
d103: 0c 22           INC   $22
d105: 0c 00           INC   $00
d107: 0c 22           INC   $22
d109: 0c 22           INC   $22
d10b: 0c 22           INC   $22
d10d: 0c 25           INC   $25
d10f: 0c 29           INC   $29
d111: 0c 22           INC   $22
d113: 0c 00           INC   $00
d115: 0c 22           INC   $22
d117: 0c 22           INC   $22
d119: 0c 00           INC   $00
d11b: 0c 25           INC   $25
d11d: 0c 29           INC   $29
d11f: 0c 28           INC   $28
d121: 0c 27           INC   $27
d123: 0c 00           INC   $00
d125: 0c 27           INC   $27
d127: 0c 27           INC   $27
d129: 0c 00           INC   $00
d12b: 0c 2a           INC   $2A
d12d: 0c 2c           INC   $2C
d12f: 0c 2e           INC   $2E
d131: 0c 27           INC   $27
d133: 0c 00           INC   $00
d135: 0c 27           INC   $27
d137: 0c 27           INC   $27
d139: 0c 27           INC   $27
d13b: 0c 27           INC   $27
d13d: 0c 25           INC   $25
d13f: 0c 24           INC   $24
d141: 0c 22           INC   $22
d143: 0c 22           INC   $22
d145: 0c 00           INC   $00
d147: 0c 22           INC   $22
d149: 0c 00           INC   $00
d14b: 0c 27           INC   $27
d14d: 0c 27           INC   $27
d14f: 0c 27           INC   $27
d151: 0c 29           INC   $29
d153: 0c 29           INC   $29
d155: 0c 29           INC   $29
d157: 0c 29           INC   $29
d159: 0c 00           INC   $00
d15b: 0c 29           INC   $29
d15d: 0c 2c           INC   $2C
d15f: 0c 2d           INC   $2D
d161: 0c 2e           INC   $2E
d163: 0c 29           INC   $29
d165: 18              FCB   $18
d166: 22 18           BHI   $D180
d168: 25 0c           BCS   $D176
d16a: 27 0c           BEQ   $D178
d16c: 25 0c           BCS   $D17A
d16e: 2a 0c           BPL   $D17C
d170: 2a 0c           BPL   $D17E
d172: 00 0c           NEG   $0C
d174: 29 18           BVS   $D18E
d176: 29 0c           BVS   $D184
d178: 2c 0c           BGE   $D186
d17a: 2d 0c           BLT   $D188
d17c: 2e 0c           BGT   $D18A
d17e: 29 18           BVS   $D198
d180: 22 18           BHI   $D19A
d182: 25 0c           BCS   $D190
d184: 27 0c           BEQ   $D192
d186: 25 0c           BCS   $D194
d188: 2a 0c           BPL   $D196
d18a: 2a 0c           BPL   $D198
d18c: 00 0c           NEG   $0C
d18e: 29 18           BVS   $D1A8
d190: 29 0c           BVS   $D19E
d192: 2c 0c           BGE   $D1A0
d194: 2d 0c           BLT   $D1A2
d196: 2e 0c           BGT   $D1A4
d198: 30 0c           LEAX  $C,X
d19a: 31 0c           LEAY  $C,X
d19c: 34 0c           PSHS  DP,B
d19e: 35 0c           PULS  B,DP
d1a0: 39              RTS
d1a1: 0c 3a           INC   $3A
d1a3: 0c 3c           INC   $3C
d1a5: 0c 3d           INC   $3D
d1a7: 0c 3f           INC   $3F
d1a9: 0c 3c           INC   $3C
d1ab: 0c 3a           INC   $3A
d1ad: 0c 39           INC   $39
d1af: 0c 29           INC   $29
d1b1: 0c 39           INC   $39
d1b3: 0c 3c           INC   $3C
d1b5: 0c 22           INC   $22
d1b7: 0c 00           INC   $00
d1b9: 0c 22           INC   $22
d1bb: 0c 00           INC   $00
d1bd: 0c 22           INC   $22
d1bf: 0c 00           INC   $00
d1c1: 0c 22           INC   $22
d1c3: 0c 00           INC   $00
d1c5: 0c 1d           INC   $1D
d1c7: 0c 29           INC   $29
d1c9: 0c 2c           INC   $2C
d1cb: 0c 2d           INC   $2D
d1cd: 0c 2e           INC   $2E
d1cf: 0c 2c           INC   $2C
d1d1: 0c 29           INC   $29
d1d3: 0c 25           INC   $25
d1d5: 0c 82           INC   $82
d1d7: 00 87           NEG   $87
d1d9: 86 00           LDA   #$00
d1db: 85 d2           BITA  #$D2
d1dd: 00 60           NEG   $60
d1df: 80 3d           SUBA  #$3D
d1e1: 0c 3d           INC   $3D
d1e3: 0c 3d           INC   $3D
d1e5: 0c 3d           INC   $3D
d1e7: 0c 3d           INC   $3D
d1e9: 0c 3d           INC   $3D
d1eb: 0c 3d           INC   $3D
d1ed: 0c 3d           INC   $3D
d1ef: 0c 3d           INC   $3D
d1f1: 0c 3d           INC   $3D
d1f3: 0c 3d           INC   $3D
d1f5: 0c 3d           INC   $3D
d1f7: 0c 3d           INC   $3D
d1f9: 0c 3d           INC   $3D
d1fb: 0c 3d           INC   $3D
d1fd: 0c 3d           INC   $3D
d1ff: 0c 3d           INC   $3D
d201: 0c 3d           INC   $3D
d203: 0c 3d           INC   $3D
d205: 0c 3d           INC   $3D
d207: 0c 3d           INC   $3D
d209: 0c 3d           INC   $3D
d20b: 0c 3d           INC   $3D
d20d: 0c 3d           INC   $3D
d20f: 0c 3d           INC   $3D
d211: 0c 3d           INC   $3D
d213: 0c 3d           INC   $3D
d215: 0c 3d           INC   $3D
d217: 0c 3d           INC   $3D
d219: 0c 3d           INC   $3D
d21b: 0c 3d           INC   $3D
d21d: 0c 3d           INC   $3D
d21f: 0c 3d           INC   $3D
d221: 0c 3d           INC   $3D
d223: 0c 3d           INC   $3D
d225: 0c 3d           INC   $3D
d227: 0c 3d           INC   $3D
d229: 0c 3d           INC   $3D
d22b: 0c 3d           INC   $3D
d22d: 0c 3d           INC   $3D
d22f: 0c 3d           INC   $3D
d231: 0c 3d           INC   $3D
d233: 0c 3d           INC   $3D
d235: 0c 3d           INC   $3D
d237: 0c 3d           INC   $3D
d239: 0c 3d           INC   $3D
d23b: 0c 3d           INC   $3D
d23d: 0c 3d           INC   $3D
d23f: 0c 3d           INC   $3D
d241: 0c 3d           INC   $3D
d243: 0c 3d           INC   $3D
d245: 0c 3d           INC   $3D
d247: 0c 3d           INC   $3D
d249: 0c 3d           INC   $3D
d24b: 0c 3d           INC   $3D
d24d: 0c 3d           INC   $3D
d24f: 0c 3d           INC   $3D
d251: 0c 3d           INC   $3D
d253: 0c 3d           INC   $3D
d255: 0c 3d           INC   $3D
d257: 0c 3d           INC   $3D
d259: 0c 3d           INC   $3D
d25b: 0c 3d           INC   $3D
d25d: 0c 3d           INC   $3D
d25f: 0c 3d           INC   $3D
d261: 0c 3d           INC   $3D
d263: 0c 3d           INC   $3D
d265: 0c 3d           INC   $3D
d267: 0c 3d           INC   $3D
d269: 0c 3d           INC   $3D
d26b: 0c 3d           INC   $3D
d26d: 0c 3d           INC   $3D
d26f: 0c 3d           INC   $3D
d271: 0c 3d           INC   $3D
d273: 0c 3d           INC   $3D
d275: 0c 3d           INC   $3D
d277: 0c 3d           INC   $3D
d279: 0c 3d           INC   $3D
d27b: 0c 3d           INC   $3D
d27d: 0c 3d           INC   $3D
d27f: 0c 3d           INC   $3D
d281: 0c 3d           INC   $3D
d283: 0c 3d           INC   $3D
d285: 0c 3d           INC   $3D
d287: 0c 3d           INC   $3D
d289: 0c 3d           INC   $3D
d28b: 0c 3d           INC   $3D
d28d: 0c 3d           INC   $3D
d28f: 0c 3d           INC   $3D
d291: 0c 3d           INC   $3D
d293: 0c 3d           INC   $3D
d295: 0c 3d           INC   $3D
d297: 0c 3d           INC   $3D
d299: 0c 3d           INC   $3D
d29b: 0c 3d           INC   $3D
d29d: 0c 3d           INC   $3D
d29f: 0c 3d           INC   $3D
d2a1: 0c 3d           INC   $3D
d2a3: 0c 3d           INC   $3D
d2a5: 0c 3d           INC   $3D
d2a7: 0c 3d           INC   $3D
d2a9: 0c 3d           INC   $3D
d2ab: 0c 3d           INC   $3D
d2ad: 0c 3d           INC   $3D
d2af: 0c 3d           INC   $3D
d2b1: 0c 3d           INC   $3D
d2b3: 0c 3d           INC   $3D
d2b5: 0c 3d           INC   $3D
d2b7: 0c 3d           INC   $3D
d2b9: 0c 3d           INC   $3D
d2bb: 0c 3d           INC   $3D
d2bd: 0c 3d           INC   $3D
d2bf: 0c 00           INC   $00
d2c1: 60 00           NEG   $0,X
d2c3: 60 3d           NEG   -$3,Y
d2c5: 0c 3d           INC   $3D
d2c7: 0c 3d           INC   $3D
d2c9: 0c 3d           INC   $3D
d2cb: 0c 3d           INC   $3D
d2cd: 0c 3d           INC   $3D
d2cf: 0c 3d           INC   $3D
d2d1: 0c 3d           INC   $3D
d2d3: 0c 3d           INC   $3D
d2d5: 0c 3d           INC   $3D
d2d7: 0c 3d           INC   $3D
d2d9: 0c 3d           INC   $3D
d2db: 0c 3d           INC   $3D
d2dd: 0c 3d           INC   $3D
d2df: 0c 3d           INC   $3D
d2e1: 0c 3d           INC   $3D
d2e3: 0c 3d           INC   $3D
d2e5: 0c 3d           INC   $3D
d2e7: 0c 3d           INC   $3D
d2e9: 0c 3d           INC   $3D
d2eb: 0c 3d           INC   $3D
d2ed: 0c 3d           INC   $3D
d2ef: 0c 3d           INC   $3D
d2f1: 0c 3d           INC   $3D
d2f3: 0c 3d           INC   $3D
d2f5: 0c 3d           INC   $3D
d2f7: 0c 3d           INC   $3D
d2f9: 0c 3d           INC   $3D
d2fb: 0c 3d           INC   $3D
d2fd: 0c 3d           INC   $3D
d2ff: 0c 3d           INC   $3D
d301: 0c 3d           INC   $3D
d303: 0c 00           INC   $00
d305: 60 00           NEG   $0,X
d307: 0c 3d           INC   $3D
d309: 0c 00           INC   $00
d30b: 0c 3d           INC   $3D
d30d: 0c 00           INC   $00
d30f: 0c 3d           INC   $3D
d311: 0c 00           INC   $00
d313: 0c 3d           INC   $3D
d315: 0c 00           INC   $00
d317: 60 82           NEG   ,-X
d319: 00 87           NEG   $87
d31b: 86 00           LDA   #$00
d31d: 85 e6           BITA  #$E6
d31f: 00 30           NEG   $30
d321: 00 18           NEG   $18
d323: 31 18           LEAY  -$8,X
d325: 80 81           SUBA  #$81
d327: 84 de           ANDA  #$DE
d329: 77 85 e6        ASR   $85E6
d32c: 22 18           BHI   $D346
d32e: 84 de           ANDA  #$DE
d330: 52              FCB   $52
d331: 85 c8           BITA  #$C8
d333: 31 18           LEAY  -$8,X
d335: 84 de           ANDA  #$DE
d337: 77 85 e6        ASR   $85E6
d33a: 22 18           BHI   $D354
d33c: 84 de           ANDA  #$DE
d33e: 52              FCB   $52
d33f: 85 c8           BITA  #$C8
d341: 31 18           LEAY  -$8,X
d343: 83 07 84        SUBD  #$0784
d346: de 77           LDU   $77
d348: 85 e6           BITA  #$E6
d34a: 22 18           BHI   $D364
d34c: 84 de           ANDA  #$DE
d34e: 52              FCB   $52
d34f: 85 c8           BITA  #$C8
d351: 31 18           LEAY  -$8,X
d353: 84 de           ANDA  #$DE
d355: 77 85 e6        ASR   $85E6
d358: 22 0c           BHI   $D366
d35a: 84 de           ANDA  #$DE
d35c: 52              FCB   $52
d35d: 85 c8           BITA  #$C8
d35f: 31 0c           LEAY  $C,X
d361: 31 0c           LEAY  $C,X
d363: 31 0c           LEAY  $C,X
d365: 81 84           CMPA  #$84
d367: de 77           LDU   $77
d369: 85 e6           BITA  #$E6
d36b: 22 18           BHI   $D385
d36d: 84 de           ANDA  #$DE
d36f: 52              FCB   $52
d370: 85 c8           BITA  #$C8
d372: 31 0c           LEAY  $C,X
d374: 84 de           ANDA  #$DE
d376: 77 85 e6        ASR   $85E6
d379: 22 0c           BHI   $D387
d37b: 84 de           ANDA  #$DE
d37d: 52              FCB   $52
d37e: 85 c8           BITA  #$C8
d380: 00 18           NEG   $18
d382: 31 18           LEAY  -$8,X
d384: 83 02 84        SUBD  #$0284
d387: de 77           LDU   $77
d389: 85 e6           BITA  #$E6
d38b: 22 0c           BHI   $D399
d38d: 22 0c           BHI   $D39B
d38f: 84 de           ANDA  #$DE
d391: 52              FCB   $52
d392: 85 c8           BITA  #$C8
d394: 31 0c           LEAY  $C,X
d396: 84 de           ANDA  #$DE
d398: 77 85 e6        ASR   $85E6
d39b: 22 0c           BHI   $D3A9
d39d: 84 de           ANDA  #$DE
d39f: 52              FCB   $52
d3a0: 85 c8           BITA  #$C8
d3a2: 00 18           NEG   $18
d3a4: 31 18           LEAY  -$8,X
d3a6: 81 84           CMPA  #$84
d3a8: de 77           LDU   $77
d3aa: 85 e6           BITA  #$E6
d3ac: 22 18           BHI   $D3C6
d3ae: 84 de           ANDA  #$DE
d3b0: 52              FCB   $52
d3b1: 85 c8           BITA  #$C8
d3b3: 31 0c           LEAY  $C,X
d3b5: 84 de           ANDA  #$DE
d3b7: 77 85 e6        ASR   $85E6
d3ba: 22 0c           BHI   $D3C8
d3bc: 84 de           ANDA  #$DE
d3be: 52              FCB   $52
d3bf: 85 c8           BITA  #$C8
d3c1: 00 18           NEG   $18
d3c3: 31 18           LEAY  -$8,X
d3c5: 83 02 84        SUBD  #$0284
d3c8: de 77           LDU   $77
d3ca: 85 e6           BITA  #$E6
d3cc: 22 18           BHI   $D3E6
d3ce: 84 de           ANDA  #$DE
d3d0: 52              FCB   $52
d3d1: 85 c8           BITA  #$C8
d3d3: 31 0c           LEAY  $C,X
d3d5: 84 de           ANDA  #$DE
d3d7: 77 85 e6        ASR   $85E6
d3da: 22 0c           BHI   $D3E8
d3dc: 84 de           ANDA  #$DE
d3de: 52              FCB   $52
d3df: 85 c8           BITA  #$C8
d3e1: 00 18           NEG   $18
d3e3: 31 0c           LEAY  $C,X
d3e5: 31 0c           LEAY  $C,X
d3e7: 31 0c           LEAY  $C,X
d3e9: 00 0c           NEG   $0C
d3eb: 31 0c           LEAY  $C,X
d3ed: 31 0c           LEAY  $C,X
d3ef: 00 0c           NEG   $0C
d3f1: 31 0c           LEAY  $C,X
d3f3: 31 0c           LEAY  $C,X
d3f5: 31 0c           LEAY  $C,X
d3f7: 31 0c           LEAY  $C,X
d3f9: 31 0c           LEAY  $C,X
d3fb: 00 0c           NEG   $0C
d3fd: 31 0c           LEAY  $C,X
d3ff: 31 0c           LEAY  $C,X
d401: 00 0c           NEG   $0C
d403: 31 0c           LEAY  $C,X
d405: 31 0c           LEAY  $C,X
d407: 84 de           ANDA  #$DE
d409: 77 85 e6        ASR   $85E6
d40c: 22 0c           BHI   $D41A
d40e: 22 0c           BHI   $D41C
d410: 84 de           ANDA  #$DE
d412: 52              FCB   $52
d413: 85 c8           BITA  #$C8
d415: 31 0c           LEAY  $C,X
d417: 84 de           ANDA  #$DE
d419: 77 85 e6        ASR   $85E6
d41c: 22 0c           BHI   $D42A
d41e: 84 de           ANDA  #$DE
d420: 52              FCB   $52
d421: 85 c8           BITA  #$C8
d423: 00 0c           NEG   $0C
d425: 31 0c           LEAY  $C,X
d427: 31 18           LEAY  -$8,X
d429: 84 de           ANDA  #$DE
d42b: 77 85 e6        ASR   $85E6
d42e: 22 0c           BHI   $D43C
d430: 22 0c           BHI   $D43E
d432: 84 de           ANDA  #$DE
d434: 52              FCB   $52
d435: 85 c8           BITA  #$C8
d437: 31 0c           LEAY  $C,X
d439: 84 de           ANDA  #$DE
d43b: 77 85 e6        ASR   $85E6
d43e: 22 0c           BHI   $D44C
d440: 84 de           ANDA  #$DE
d442: 52              FCB   $52
d443: 85 c8           BITA  #$C8
d445: 00 0c           NEG   $0C
d447: 31 0c           LEAY  $C,X
d449: 31 0c           LEAY  $C,X
d44b: 31 0c           LEAY  $C,X
d44d: 84 de           ANDA  #$DE
d44f: 77 85 e6        ASR   $85E6
d452: 22 0c           BHI   $D460
d454: 22 0c           BHI   $D462
d456: 84 de           ANDA  #$DE
d458: 52              FCB   $52
d459: 85 c8           BITA  #$C8
d45b: 31 0c           LEAY  $C,X
d45d: 84 de           ANDA  #$DE
d45f: 77 85 e6        ASR   $85E6
d462: 22 0c           BHI   $D470
d464: 84 de           ANDA  #$DE
d466: 52              FCB   $52
d467: 85 c8           BITA  #$C8
d469: 00 0c           NEG   $0C
d46b: 31 0c           LEAY  $C,X
d46d: 00 0c           NEG   $0C
d46f: 31 0c           LEAY  $C,X
d471: 84 de           ANDA  #$DE
d473: 77 85 e6        ASR   $85E6
d476: 22 0c           BHI   $D484
d478: 22 0c           BHI   $D486
d47a: 84 de           ANDA  #$DE
d47c: 52              FCB   $52
d47d: 85 c8           BITA  #$C8
d47f: 31 0c           LEAY  $C,X
d481: 84 de           ANDA  #$DE
d483: 77 85 e6        ASR   $85E6
d486: 22 0c           BHI   $D494
d488: 84 de           ANDA  #$DE
d48a: 52              FCB   $52
d48b: 85 c8           BITA  #$C8
d48d: 00 0c           NEG   $0C
d48f: 31 06           LEAY  $6,X
d491: 31 06           LEAY  $6,X
d493: 31 0c           LEAY  $C,X
d495: 31 0c           LEAY  $C,X
d497: 81 31           CMPA  #$31
d499: 18              FCB   $18
d49a: 00 18           NEG   $18
d49c: 00 30           NEG   $30
d49e: 83 02 84        SUBD  #$0284
d4a1: de 77           LDU   $77
d4a3: 85 e6           BITA  #$E6
d4a5: 22 0c           BHI   $D4B3
d4a7: 84 de           ANDA  #$DE
d4a9: 52              FCB   $52
d4aa: 85 c8           BITA  #$C8
d4ac: 31 0c           LEAY  $C,X
d4ae: 84 de           ANDA  #$DE
d4b0: 77 85 e6        ASR   $85E6
d4b3: 22 0c           BHI   $D4C1
d4b5: 84 de           ANDA  #$DE
d4b7: 52              FCB   $52
d4b8: 85 c8           BITA  #$C8
d4ba: 31 0c           LEAY  $C,X
d4bc: 84 de           ANDA  #$DE
d4be: 77 85 e6        ASR   $85E6
d4c1: 22 0c           BHI   $D4CF
d4c3: 84 de           ANDA  #$DE
d4c5: 52              FCB   $52
d4c6: 85 c8           BITA  #$C8
d4c8: 31 0c           LEAY  $C,X
d4ca: 84 de           ANDA  #$DE
d4cc: 77 85 e6        ASR   $85E6
d4cf: 22 0c           BHI   $D4DD
d4d1: 84 de           ANDA  #$DE
d4d3: 52              FCB   $52
d4d4: 85 c8           BITA  #$C8
d4d6: 31 0c           LEAY  $C,X
d4d8: 31 18           LEAY  -$8,X
d4da: 00 18           NEG   $18
d4dc: 85 e6           BITA  #$E6
d4de: 00 18           NEG   $18
d4e0: 31 18           LEAY  -$8,X
d4e2: 82 00           SBCA  #$00
d4e4: 87              FCB   $87
d4e5: 06 e4           ROR   $E4
d4e7: d4 ff           ANDB  $FF
d4e9: dc 27           LDD   $27
d4eb: d5 6b           BITB  $6B
d4ed: dc 27           LDD   $27
d4ef: d5 c3           BITB  $C3
d4f1: dc 27           LDD   $27
d4f3: d6 1b           LDB   $1B
d4f5: da b5           ORB   $B5
d4f7: d6 4e           LDB   $4E
d4f9: da 6b           ORB   $6B
d4fb: d7 d6           STB   $D6
d4fd: de 77           LDU   $77
d4ff: 86 00           LDA   #$00
d501: 85 d2           BITA  #$D2
d503: 89 b4           ADCA  #$B4
d505: 88 ff           EORA  #$FF
d507: 80 00           SUBA  #$00
d509: 48              ASLA
d50a: 00 06           NEG   $06
d50c: 36 12           PSHU  X,A
d50e: 00 48           NEG   $48
d510: 00 06           NEG   $06
d512: 38              FCB   $38
d513: 12              NOP
d514: 00 48           NEG   $48
d516: 00 06           NEG   $06
d518: 36 12           PSHU  X,A
d51a: 00 48           NEG   $48
d51c: 00 06           NEG   $06
d51e: 38              FCB   $38
d51f: 12              NOP
d520: 00 48           NEG   $48
d522: 00 06           NEG   $06
d524: 36 12           PSHU  X,A
d526: 00 48           NEG   $48
d528: 00 06           NEG   $06
d52a: 38              FCB   $38
d52b: 12              NOP
d52c: 00 48           NEG   $48
d52e: 00 06           NEG   $06
d530: 36 12           PSHU  X,A
d532: 00 48           NEG   $48
d534: 00 06           NEG   $06
d536: 38              FCB   $38
d537: 12              NOP
d538: 36 48           PSHU  S,DP
d53a: 00 06           NEG   $06
d53c: 38              FCB   $38
d53d: 12              NOP
d53e: 3a              ABX
d53f: 60 38           NEG   -$8,Y
d541: 48              ASLA
d542: 00 06           NEG   $06
d544: 35 12           PULS  A,X
d546: 36 48           PSHU  S,DP
d548: 36 18           PSHU  X,DP
d54a: 36 48           PSHU  S,DP
d54c: 38              FCB   $38
d54d: 18              FCB   $18
d54e: 3a              ABX
d54f: 48              ASLA
d550: 36 0c           PSHU  DP,B
d552: 3a              ABX
d553: 0c 3a           INC   $3A
d555: 60 3a           NEG   -$6,Y
d557: 30 3a           LEAX  -$6,Y
d559: 06 3f           ROR   $3F
d55b: 06 3e           ROR   $3E
d55d: 06 3f           ROR   $3F
d55f: 06 40           ROR   $40
d561: 06 41           ROR   $41
d563: 06 42           ROR   $42
d565: 06 43           ROR   $43
d567: 06 82           ROR   $82
d569: 00 87           NEG   $87
d56b: 86 00           LDA   #$00
d56d: 85 d2           BITA  #$D2
d56f: 89 b4           ADCA  #$B4
d571: 88 ff           EORA  #$FF
d573: 80 00           SUBA  #$00
d575: 48              ASLA
d576: 00 06           NEG   $06
d578: 33 12           LEAU  -$E,X
d57a: 00 48           NEG   $48
d57c: 00 06           NEG   $06
d57e: 35 12           PULS  A,X
d580: 00 48           NEG   $48
d582: 00 06           NEG   $06
d584: 33 12           LEAU  -$E,X
d586: 00 48           NEG   $48
d588: 00 06           NEG   $06
d58a: 35 12           PULS  A,X
d58c: 00 48           NEG   $48
d58e: 00 06           NEG   $06
d590: 33 12           LEAU  -$E,X
d592: 00 48           NEG   $48
d594: 00 06           NEG   $06
d596: 35 12           PULS  A,X
d598: 00 48           NEG   $48
d59a: 00 06           NEG   $06
d59c: 33 12           LEAU  -$E,X
d59e: 00 48           NEG   $48
d5a0: 00 06           NEG   $06
d5a2: 35 12           PULS  A,X
d5a4: 33 48           LEAU  $8,U
d5a6: 00 06           NEG   $06
d5a8: 35 12           PULS  A,X
d5aa: 36 60           PSHU  S,Y
d5ac: 35 48           PULS  DP,U
d5ae: 00 06           NEG   $06
d5b0: 31 12           LEAY  -$E,X
d5b2: 33 48           LEAU  $8,U
d5b4: 31 18           LEAY  -$8,X
d5b6: 33 48           LEAU  $8,U
d5b8: 35 18           PULS  DP,X
d5ba: 36 60           PSHU  S,Y
d5bc: 38              FCB   $38
d5bd: 60 37           NEG   -$9,Y
d5bf: 60 82           NEG   ,-X
d5c1: 00 87           NEG   $87
d5c3: 86 00           LDA   #$00
d5c5: 85 d2           BITA  #$D2
d5c7: 89 b4           ADCA  #$B4
d5c9: 88 ff           EORA  #$FF
d5cb: 80 00           SUBA  #$00
d5cd: 48              ASLA
d5ce: 00 06           NEG   $06
d5d0: 2f 12           BLE   $D5E4
d5d2: 00 48           NEG   $48
d5d4: 00 06           NEG   $06
d5d6: 31 12           LEAY  -$E,X
d5d8: 00 48           NEG   $48
d5da: 00 06           NEG   $06
d5dc: 2f 12           BLE   $D5F0
d5de: 00 48           NEG   $48
d5e0: 00 06           NEG   $06
d5e2: 31 12           LEAY  -$E,X
d5e4: 00 48           NEG   $48
d5e6: 00 06           NEG   $06
d5e8: 2f 12           BLE   $D5FC
d5ea: 00 48           NEG   $48
d5ec: 00 06           NEG   $06
d5ee: 31 12           LEAY  -$E,X
d5f0: 00 48           NEG   $48
d5f2: 00 06           NEG   $06
d5f4: 2f 12           BLE   $D608
d5f6: 00 48           NEG   $48
d5f8: 00 06           NEG   $06
d5fa: 31 12           LEAY  -$E,X
d5fc: 2f 48           BLE   $D646
d5fe: 00 06           NEG   $06
d600: 31 12           LEAY  -$E,X
d602: 33 60           LEAU  $0,S
d604: 31 48           LEAY  $8,U
d606: 00 06           NEG   $06
d608: 2c 12           BGE   $D61C
d60a: 2e 48           BGT   $D654
d60c: 2e 18           BGT   $D626
d60e: 3b              RTI
d60f: 48              ASLA
d610: 31 18           LEAY  -$8,X
d612: 33 60           LEAU  $0,S
d614: 33 60           LEAU  $0,S
d616: 33 60           LEAU  $0,S
d618: 82 00           SBCA  #$00
d61a: 87              FCB   $87
d61b: 86 00           LDA   #$00
d61d: 85 c8           BITA  #$C8
d61f: 80 00           SUBA  #$00
d621: 60 00           NEG   $0,X
d623: 60 00           NEG   $0,X
d625: 60 00           NEG   $0,X
d627: 60 81           NEG   ,X++
d629: 3d              MUL
d62a: 06 3b           ROR   $3B
d62c: 06 3d           ROR   $3D
d62e: 06 3f           ROR   $3F
d630: 06 38           ROR   $38
d632: 06 3b           ROR   $3B
d634: 06 38           ROR   $38
d636: 06 3d           ROR   $3D
d638: 06 3d           ROR   $3D
d63a: 06 3c           ROR   $3C
d63c: 06 38           ROR   $38
d63e: 06 36           ROR   $36
d640: 06 3d           ROR   $3D
d642: 06 3b           ROR   $3B
d644: 06 3a           ROR   $3A
d646: 06 3f           ROR   $3F
d648: 06 83           ROR   $83
d64a: 0c 82           INC   $82
d64c: 00 87           NEG   $87
d64e: 86 00           LDA   #$00
d650: 85 f0           BITA  #$F0
d652: 80 20           SUBA  #$20
d654: 06 00           ROR   $00
d656: 06 20           ROR   $20
d658: 0c 20           INC   $20
d65a: 06 00           ROR   $00
d65c: 06 20           ROR   $20
d65e: 0c 20           INC   $20
d660: 06 00           ROR   $00
d662: 06 20           ROR   $20
d664: 0c 20           INC   $20
d666: 06 23           ROR   $23
d668: 0c 22           INC   $22
d66a: 06 20           ROR   $20
d66c: 06 00           ROR   $00
d66e: 06 20           ROR   $20
d670: 0c 20           INC   $20
d672: 06 00           ROR   $00
d674: 06 20           ROR   $20
d676: 0c 20           INC   $20
d678: 06 00           ROR   $00
d67a: 06 20           ROR   $20
d67c: 0c 20           INC   $20
d67e: 06 25           ROR   $25
d680: 0c 23           INC   $23
d682: 06 20           ROR   $20
d684: 06 00           ROR   $00
d686: 06 20           ROR   $20
d688: 0c 20           INC   $20
d68a: 06 00           ROR   $00
d68c: 06 20           ROR   $20
d68e: 0c 20           INC   $20
d690: 06 00           ROR   $00
d692: 06 20           ROR   $20
d694: 0c 20           INC   $20
d696: 06 23           ROR   $23
d698: 0c 22           INC   $22
d69a: 06 20           ROR   $20
d69c: 06 00           ROR   $00
d69e: 06 20           ROR   $20
d6a0: 0c 20           INC   $20
d6a2: 06 00           ROR   $00
d6a4: 06 20           ROR   $20
d6a6: 0c 20           INC   $20
d6a8: 06 00           ROR   $00
d6aa: 06 20           ROR   $20
d6ac: 0c 20           INC   $20
d6ae: 06 25           ROR   $25
d6b0: 0c 23           INC   $23
d6b2: 06 20           ROR   $20
d6b4: 06 00           ROR   $00
d6b6: 06 20           ROR   $20
d6b8: 0c 20           INC   $20
d6ba: 06 00           ROR   $00
d6bc: 06 20           ROR   $20
d6be: 0c 20           INC   $20
d6c0: 06 00           ROR   $00
d6c2: 06 20           ROR   $20
d6c4: 0c 20           INC   $20
d6c6: 06 23           ROR   $23
d6c8: 0c 22           INC   $22
d6ca: 06 20           ROR   $20
d6cc: 06 00           ROR   $00
d6ce: 06 20           ROR   $20
d6d0: 0c 20           INC   $20
d6d2: 06 00           ROR   $00
d6d4: 06 20           ROR   $20
d6d6: 0c 20           INC   $20
d6d8: 06 00           ROR   $00
d6da: 06 20           ROR   $20
d6dc: 0c 20           INC   $20
d6de: 06 25           ROR   $25
d6e0: 0c 23           INC   $23
d6e2: 06 20           ROR   $20
d6e4: 06 00           ROR   $00
d6e6: 06 20           ROR   $20
d6e8: 0c 20           INC   $20
d6ea: 06 00           ROR   $00
d6ec: 06 20           ROR   $20
d6ee: 0c 20           INC   $20
d6f0: 06 00           ROR   $00
d6f2: 06 20           ROR   $20
d6f4: 0c 20           INC   $20
d6f6: 06 23           ROR   $23
d6f8: 0c 22           INC   $22
d6fa: 06 20           ROR   $20
d6fc: 06 00           ROR   $00
d6fe: 06 20           ROR   $20
d700: 0c 20           INC   $20
d702: 06 00           ROR   $00
d704: 06 20           ROR   $20
d706: 0c 20           INC   $20
d708: 06 00           ROR   $00
d70a: 06 20           ROR   $20
d70c: 0c 20           INC   $20
d70e: 06 25           ROR   $25
d710: 0c 24           INC   $24
d712: 06 23           ROR   $23
d714: 06 00           ROR   $00
d716: 06 23           ROR   $23
d718: 0c 23           INC   $23
d71a: 06 00           ROR   $00
d71c: 06 23           ROR   $23
d71e: 0c 23           INC   $23
d720: 06 00           ROR   $00
d722: 06 23           ROR   $23
d724: 0c 23           INC   $23
d726: 06 00           ROR   $00
d728: 06 23           ROR   $23
d72a: 0c 23           INC   $23
d72c: 06 00           ROR   $00
d72e: 06 23           ROR   $23
d730: 0c 23           INC   $23
d732: 06 00           ROR   $00
d734: 06 23           ROR   $23
d736: 0c 23           INC   $23
d738: 06 00           ROR   $00
d73a: 06 23           ROR   $23
d73c: 0c 23           INC   $23
d73e: 06 00           ROR   $00
d740: 06 23           ROR   $23
d742: 0c 25           INC   $25
d744: 06 00           ROR   $00
d746: 06 25           ROR   $25
d748: 0c 25           INC   $25
d74a: 06 00           ROR   $00
d74c: 06 25           ROR   $25
d74e: 0c 25           INC   $25
d750: 06 00           ROR   $00
d752: 06 25           ROR   $25
d754: 0c 25           INC   $25
d756: 06 00           ROR   $00
d758: 06 25           ROR   $25
d75a: 0c 27           INC   $27
d75c: 06 00           ROR   $00
d75e: 06 27           ROR   $27
d760: 0c 27           INC   $27
d762: 06 00           ROR   $00
d764: 06 27           ROR   $27
d766: 0c 27           INC   $27
d768: 06 00           ROR   $00
d76a: 06 27           ROR   $27
d76c: 0c 25           INC   $25
d76e: 06 00           ROR   $00
d770: 06 25           ROR   $25
d772: 0c 23           INC   $23
d774: 06 00           ROR   $00
d776: 06 23           ROR   $23
d778: 0c 23           INC   $23
d77a: 06 00           ROR   $00
d77c: 06 23           ROR   $23
d77e: 0c 23           INC   $23
d780: 06 00           ROR   $00
d782: 06 23           ROR   $23
d784: 0c 22           INC   $22
d786: 06 00           ROR   $00
d788: 06 22           ROR   $22
d78a: 0c 20           INC   $20
d78c: 06 00           ROR   $00
d78e: 06 20           ROR   $20
d790: 0c 20           INC   $20
d792: 06 00           ROR   $00
d794: 06 20           ROR   $20
d796: 0c 20           INC   $20
d798: 06 00           ROR   $00
d79a: 06 20           ROR   $20
d79c: 0c 20           INC   $20
d79e: 06 00           ROR   $00
d7a0: 06 20           ROR   $20
d7a2: 0c 27           INC   $27
d7a4: 06 00           ROR   $00
d7a6: 06 27           ROR   $27
d7a8: 0c 27           INC   $27
d7aa: 06 00           ROR   $00
d7ac: 06 27           ROR   $27
d7ae: 0c 27           INC   $27
d7b0: 06 00           ROR   $00
d7b2: 06 27           ROR   $27
d7b4: 0c 27           INC   $27
d7b6: 06 00           ROR   $00
d7b8: 06 27           ROR   $27
d7ba: 0c 27           INC   $27
d7bc: 06 00           ROR   $00
d7be: 06 27           ROR   $27
d7c0: 0c 27           INC   $27
d7c2: 06 00           ROR   $00
d7c4: 06 27           ROR   $27
d7c6: 0c 2e           INC   $2E
d7c8: 06 00           ROR   $00
d7ca: 06 2e           ROR   $2E
d7cc: 0c 21           INC   $21
d7ce: 06 00           ROR   $00
d7d0: 06 21           ROR   $21
d7d2: 0c 82           INC   $82
d7d4: 00 87           NEG   $87
d7d6: 86 00           LDA   #$00
d7d8: 85 dc           BITA  #$DC
d7da: 80 20           SUBA  #$20
d7dc: 18              FCB   $18
d7dd: 20 18           BRA   $D7F7
d7df: 20 18           BRA   $D7F9
d7e1: 20 18           BRA   $D7FB
d7e3: 20 18           BRA   $D7FD
d7e5: 20 18           BRA   $D7FF
d7e7: 20 18           BRA   $D801
d7e9: 20 18           BRA   $D803
d7eb: 20 18           BRA   $D805
d7ed: 20 18           BRA   $D807
d7ef: 20 18           BRA   $D809
d7f1: 20 18           BRA   $D80B
d7f3: 20 18           BRA   $D80D
d7f5: 20 18           BRA   $D80F
d7f7: 20 18           BRA   $D811
d7f9: 20 18           BRA   $D813
d7fb: 20 18           BRA   $D815
d7fd: 20 18           BRA   $D817
d7ff: 20 18           BRA   $D819
d801: 20 18           BRA   $D81B
d803: 20 18           BRA   $D81D
d805: 20 18           BRA   $D81F
d807: 20 18           BRA   $D821
d809: 20 18           BRA   $D823
d80b: 20 18           BRA   $D825
d80d: 20 18           BRA   $D827
d80f: 20 18           BRA   $D829
d811: 20 18           BRA   $D82B
d813: 20 18           BRA   $D82D
d815: 20 18           BRA   $D82F
d817: 20 18           BRA   $D831
d819: 20 18           BRA   $D833
d81b: 20 18           BRA   $D835
d81d: 20 18           BRA   $D837
d81f: 20 18           BRA   $D839
d821: 20 18           BRA   $D83B
d823: 20 18           BRA   $D83D
d825: 20 18           BRA   $D83F
d827: 20 18           BRA   $D841
d829: 20 18           BRA   $D843
d82b: 20 18           BRA   $D845
d82d: 20 18           BRA   $D847
d82f: 20 18           BRA   $D849
d831: 20 18           BRA   $D84B
d833: 20 18           BRA   $D84D
d835: 20 18           BRA   $D84F
d837: 20 18           BRA   $D851
d839: 20 18           BRA   $D853
d83b: 20 18           BRA   $D855
d83d: 20 18           BRA   $D857
d83f: 20 18           BRA   $D859
d841: 20 18           BRA   $D85B
d843: 20 18           BRA   $D85D
d845: 20 18           BRA   $D85F
d847: 20 18           BRA   $D861
d849: 20 18           BRA   $D863
d84b: 20 18           BRA   $D865
d84d: 20 18           BRA   $D867
d84f: 20 18           BRA   $D869
d851: 20 18           BRA   $D86B
d853: 82 00           SBCA  #$00
d855: 87              FCB   $87
d856: 81 e9           CMPA  #$E9
d858: d8 5c           EORB  $5C
d85a: d8 f9           EORB  $F9
d85c: 86 da           LDA   #$DA
d85e: 85 fa           BITA  #$FA
d860: 46              RORA
d861: 00 87           NEG   $87
d863: 81 e9           CMPA  #$E9
d865: d8 69           EORB  $69
d867: d9 1e           ADCB  $1E
d869: 86 00           LDA   #$00
d86b: 85 fa           BITA  #$FA
d86d: 46              RORA
d86e: 00 87           NEG   $87
d870: 81 ea           CMPA  #$EA
d872: d8 76           EORB  $76
d874: d9 43           ADCB  $43
d876: 86 d0           LDA   #$D0
d878: 85 fa           BITA  #$FA
d87a: 46              RORA
d87b: 30 87           LEAX  E,X
d87d: 81 ea           CMPA  #$EA
d87f: d8 83           EORB  $83
d881: d9 68           ADCB  $68
d883: 86 00           LDA   #$00
d885: 85 fa           BITA  #$FA
d887: 46              RORA
d888: 0c 87           INC   $87
d88a: 01 c8 03        OIM   #$C8;$03
d88d: 9e 02           LDX   $02
d88f: 00 3a           NEG   $3A
d891: 00 21           NEG   $21
d893: 41              FCB   $41
d894: 63 41           COM   $1,U
d896: 51              FCB   $51
d897: 01 01 01        OIM   #$01;$01
d89a: 01 73 66        OIM   #$73;$66
d89d: 6e 7f           JMP   -$1,S
d89f: 0d 0f           TST   $0F
d8a1: 15              FCB   $15
d8a2: 52              FCB   $52
d8a3: 06 08           ROR   $08
d8a5: 0e 03           JMP   $03
d8a7: 02 00 00        AIM   #$00;$00
d8aa: 00 e8           NEG   $E8
d8ac: e8 d8 d8        EORB  [-$28,U]
d8af: 01 c8 00        OIM   #$C8;$00
d8b2: a3 02           SUBD  $2,X
d8b4: 00 3a           NEG   $3A
d8b6: 28 33           BVC   $D8EB
d8b8: 71 17 41 41     OIM   #$17,$4141
d8bc: 01 01 01        OIM   #$01;$01
d8bf: 01 72 60        OIM   #$72;$60
d8c2: 62 7f 10        AIM   #$7F;-$10,X
d8c5: 10 0f           FCB   $10,$0F
d8c7: 15              FCB   $15
d8c8: 0e 0e           JMP   $0E
d8ca: 0e 08           JMP   $08
d8cc: 0a 4a           DEC   $4A
d8ce: 0a 06           DEC   $06
d8d0: e3 0a           ADDD  $A,X
d8d2: e3 fa           ADDD  [F,S]
d8d4: 01 ca 03        OIM   #$CA;$03
d8d7: bc 02 00        CMPX  $0200
d8da: 3a              ABX
d8db: 00 30           NEG   $30
d8dd: 51              FCB   $51
d8de: 55              FCB   $55
d8df: 41              FCB   $41
d8e0: 51              FCB   $51
d8e1: 03 01           COM   $01
d8e3: 01 05 6d        OIM   #$05;$6D
d8e6: 71 55 7f 1c     OIM   #$55,$7F1C
d8ea: 13              SYNC
d8eb: 1c 0d           ANDCC #$0D
d8ed: 07 09           ASR   $09
d8ef: 07 04           ASR   $04
d8f1: 00 00           NEG   $00
d8f3: 00 00           NEG   $00
d8f5: e3 c2           ADDD  ,-U
d8f7: e3 f7           ADDD  [E,S]
d8f9: 00 00           NEG   $00
d8fb: 00 80           NEG   $80
d8fd: 00 00           NEG   $00
d8ff: 3a              ABX
d900: 00 00           NEG   $00
d902: 60 11           NEG   -$F,X
d904: 22 72           BHI   $D978
d906: 00 00           NEG   $00
d908: 00 00           NEG   $00
d90a: 6e 6f           JMP   $F,S
d90c: 64 7f           LSR   -$1,S
d90e: 1f 1f           TFR   X,F
d910: 1f 1f           TFR   X,F
d912: 00 00           NEG   $00
d914: 00 00           NEG   $00
d916: 80 40           SUBA  #$40
d918: 00 00           NEG   $00
d91a: fe fe fe        LDU   $FEFE
d91d: fe 00 00        LDU   >$0000
d920: 00 80           NEG   $80
d922: 00 00           NEG   $00
d924: 3a              ABX
d925: 00 00           NEG   $00
d927: 60 11           NEG   -$F,X
d929: 2f 72           BLE   $D99D
d92b: 00 00           NEG   $00
d92d: 00 00           NEG   $00
d92f: 6e 6f           JMP   $F,S
d931: 64 7f           LSR   -$1,S
d933: 1f 1f           TFR   X,F
d935: 1f 1f           TFR   X,F
d937: 00 00           NEG   $00
d939: 00 00           NEG   $00
d93b: 80 40           SUBA  #$40
d93d: 00 00           NEG   $00
d93f: f9 f9 f9        ADCB  $F9F9
d942: f9 00 00        ADCB  >$0000
d945: 00 80           NEG   $80
d947: 00 00           NEG   $00
d949: 3a              ABX
d94a: 50              NEGB
d94b: 00 60           NEG   $60
d94d: 15              FCB   $15
d94e: 20 70           BRA   $D9C0
d950: 00 00           NEG   $00
d952: 00 00           NEG   $00
d954: 6a 6a           DEC   $A,S
d956: 6a 7f           DEC   -$1,S
d958: 1f 1f           TFR   X,F
d95a: 1f 1f           TFR   X,F
d95c: 09 09           ROL   $09
d95e: 05 0b 80        EIM   #$0B;$80
d961: 40              NEGA
d962: 00 00           NEG   $00
d964: 07 07           ASR   $07
d966: 07 07           ASR   $07
d968: 00 00           NEG   $00
d96a: 00 80           NEG   $80
d96c: 00 00           NEG   $00
d96e: 1a 00           ORCC  #$00
d970: 00 4f           NEG   $4F
d972: 6a 45           DEC   $5,U
d974: 51              FCB   $51
d975: 00 00           NEG   $00
d977: 00 00           NEG   $00
d979: 70 5f 68        NEG   $5F68
d97c: 7f 1f 1f        CLR   $1F1F
d97f: 1f 1f           TFR   X,F
d981: 06 06           ROR   $06
d983: 06 06           ROR   $06
d985: 00 00           NEG   $00
d987: 00 00           NEG   $00
d989: 08 08           ASL   $08
d98b: 08 08           ASL   $08
d98d: 01 c8 03        OIM   #$C8;$03
d990: 9e 02           LDX   $02
d992: 00 1a           NEG   $1A
d994: 00 21           NEG   $21
d996: 41              FCB   $41
d997: 63 41           COM   $1,U
d999: 51              FCB   $51
d99a: 05 05 05        EIM   #$05;$05
d99d: 04 70           LSR   $70
d99f: 5f              CLRB
d9a0: 68 7f           ASL   -$1,S
d9a2: 0d 0f           TST   $0F
d9a4: 15              FCB   $15
d9a5: 52              FCB   $52
d9a6: 06 08           ROR   $08
d9a8: 0e 03           JMP   $03
d9aa: 02 00 00        AIM   #$00;$00
d9ad: 00 e8           NEG   $E8
d9af: e8 d8 d8        EORB  [-$28,U]
d9b2: 01 c8 03        OIM   #$C8;$03
d9b5: 9e 02           LDX   $02
d9b7: 00 1a           NEG   $1A
d9b9: 00 21           NEG   $21
d9bb: 41              FCB   $41
d9bc: 63 41           COM   $1,U
d9be: 51              FCB   $51
d9bf: 05 05 05        EIM   #$05;$05
d9c2: 04 70           LSR   $70
d9c4: 5f              CLRB
d9c5: 68 7f           ASL   -$1,S
d9c7: 0d 0f           TST   $0F
d9c9: 15              FCB   $15
d9ca: 52              FCB   $52
d9cb: 06 08           ROR   $08
d9cd: 0e 03           JMP   $03
d9cf: 02 00 00        AIM   #$00;$00
d9d2: 00 e8           NEG   $E8
d9d4: e8 d8 d8        EORB  [-$28,U]
d9d7: 01 c8 03        OIM   #$C8;$03
d9da: 9e 02           LDX   $02
d9dc: 00 1a           NEG   $1A
d9de: 00 21           NEG   $21
d9e0: 41              FCB   $41
d9e1: 63 41           COM   $1,U
d9e3: 51              FCB   $51
d9e4: 05 05 05        EIM   #$05;$05
d9e7: 04 70           LSR   $70
d9e9: 5f              CLRB
d9ea: 68 7f           ASL   -$1,S
d9ec: 0d 0f           TST   $0F
d9ee: 15              FCB   $15
d9ef: 52              FCB   $52
d9f0: 06 08           ROR   $08
d9f2: 0e 03           JMP   $03
d9f4: 02 00 00        AIM   #$00;$00
d9f7: 00 e8           NEG   $E8
d9f9: e8 d8 d8        EORB  [-$28,U]
d9fc: 01 c8 03        OIM   #$C8;$03
d9ff: 9e 02           LDX   $02
da01: 00 1a           NEG   $1A
da03: 00 21           NEG   $21
da05: 41              FCB   $41
da06: 63 41           COM   $1,U
da08: 51              FCB   $51
da09: 05 05 05        EIM   #$05;$05
da0c: 04 70           LSR   $70
da0e: 5f              CLRB
da0f: 68 7f           ASL   -$1,S
da11: 0d 0f           TST   $0F
da13: 15              FCB   $15
da14: 52              FCB   $52
da15: 06 08           ROR   $08
da17: 0e 03           JMP   $03
da19: 02 00 00        AIM   #$00;$00
da1c: 00 e8           NEG   $E8
da1e: e8 d8 d8        EORB  [-$28,U]
da21: 01 c8 00        OIM   #$C8;$00
da24: 9e 00           LDX   $00
da26: 00 3c           NEG   $3C
da28: 00 33           NEG   $33
da2a: 41              FCB   $41
da2b: 41              FCB   $41
da2c: 4b              FCB   $4B
da2d: 41              FCB   $41
da2e: 04 06           LSR   $06
da30: 04 06           LSR   $06
da32: 6f 7f           CLR   -$1,S
da34: 65 78 10        EIM   #$78;-$10,X
da37: 12              NOP
da38: 1f 5f           TFR   PC,F
da3a: 06 03           ROR   $03
da3c: 0f 0f           CLR   $0F
da3e: 01 06 06        OIM   #$06;$06
da41: 04 f3           LSR   $F3
da43: fc 02 02        LDD   $0202
da46: 02 a2 00        AIM   #$A2;$00
da49: ff 01 00        STU   $0100
da4c: 3e              FCB   $3E
da4d: 00 70           NEG   $70
da4f: 42              FCB   $42
da50: 42              FCB   $42
da51: 42              FCB   $42
da52: 41              FCB   $41
da53: 00 00           NEG   $00
da55: 07 07           ASR   $07
da57: 59              ROLB
da58: 78 7a 78        ASL   $7A78
da5b: 04 04           LSR   $04
da5d: 04 00           LSR   $00
da5f: 00 00           NEG   $00
da61: 00 00           NEG   $00
da63: 02 02 02        AIM   #$02;$02
da66: 02 f2 f2        AIM   #$F2;$F2
da69: f2 f0 00        SBCB  $F000
da6c: 00 00           NEG   $00
da6e: 80 00           SUBA  #$00
da70: 00 20           NEG   $20
da72: 00 00           NEG   $00
da74: 76 75 70        ROR   $7570
da77: 71 02 02 02     OIM   #$02,$0202
da7b: 02 6d 4f        AIM   #$6D;$4F
da7e: 73 7f 1f        COM   $7F1F
da81: 1f 1f           TFR   X,F
da83: 1f 07           TFR   D,V
da85: 06 09           ROR   $09
da87: 07 07           ASR   $07
da89: 06 06           ROR   $06
da8b: 0d d9           TST   $D9
da8d: e9 e9 09 00     ADCB  $0900,S
da91: 00 00           NEG   $00
da93: 80 00           SUBA  #$00
da95: 00 28           NEG   $28
da97: 00 00           NEG   $00
da99: 72 71 70 71     AIM   #$71,$7071
da9d: 01 01 01        OIM   #$01;$01
daa0: 01 79 5a        OIM   #$79;$5A
daa3: 70 7f 1e        NEG   $7F1E
daa6: 18              FCB   $18
daa7: 1c 1c           ANDCC #$1C
daa9: 0e 0a           JMP   $0A
daab: 04 05           LSR   $05
daad: 09 08           ROL   $08
daaf: 06 07           ROR   $07
dab1: 46              RORA
dab2: 46              RORA
dab3: 46              RORA
dab4: 47              ASRA
dab5: 00 00           NEG   $00
dab7: 00 80           NEG   $80
dab9: 00 40           NEG   $40
dabb: 34 00           PSHS  
dabd: 00 40           NEG   $40
dabf: 4e              FCB   $4E
dac0: 40              NEGA
dac1: 10 00           FCB   $10,$00
dac3: 01 00 01        OIM   #$00;$01
dac6: 7f 71 6c        CLR   $716C
dac9: 7f 1f 1f        CLR   $1F1F
dacc: 1f 1f           TFR   X,F
dace: 01 0d 16        OIM   #$0D;$16
dad1: 14              SEXW
dad2: 00 0f           NEG   $0F
dad4: 07 14           ASR   $14
dad6: d5 0a           BITB  $0A
dad8: 98 08           EORA  $08
dada: 02 cb 00        AIM   #$CB;$00
dadd: e4 02           ANDB  $2,X
dadf: 00 2c           NEG   $2C
dae1: 00 30           NEG   $30
dae3: 41              FCB   $41
dae4: 52              FCB   $52
dae5: 52              FCB   $52
dae6: 56              RORB
dae7: 00 05           NEG   $05
dae9: 05 05 75        EIM   #$05;$75
daec: 67 67           ASR   $7,S
daee: 7f 1f 4e        CLR   $1F4E
daf1: 0e 4e           JMP   $4E
daf3: 00 08           NEG   $08
daf5: 08 08           ASL   $08
daf7: 00 00           NEG   $00
daf9: 00 00           NEG   $00
dafb: f2 d7 e6        SBCB  $D7E6
dafe: e7 02           STB   $2,X
db00: cb 00           ADDB  #$00
db02: e4 02           ANDB  $2,X
db04: 0c 3d           INC   $3D
db06: 00 30           NEG   $30
db08: 41              FCB   $41
db09: 52              FCB   $52
db0a: 52              FCB   $52
db0b: 52              FCB   $52
db0c: 00 07           NEG   $07
db0e: 07 07           ASR   $07
db10: 69 7f           ROL   -$1,S
db12: 7f 7f 0f        CLR   $7F0F
db15: 4a              DECA
db16: 4b              FCB   $4B
db17: 4c              INCA
db18: 00 08           NEG   $08
db1a: 08 08           ASL   $08
db1c: 00 01           NEG   $01
db1e: 00 01           NEG   $01
db20: f0 d6 e6        SUBB  $D6E6
db23: e7 02           STB   $2,X
db25: cb 00           ADDB  #$00
db27: e4 02           ANDB  $2,X
db29: f4 3c 00        ANDB  $3C00
db2c: 30 72           LEAX  -$E,S
db2e: 14              SEXW
db2f: 44              LSRA
db30: 44              LSRA
db31: 00 01           NEG   $01
db33: 01 02 73        OIM   #$02;$73
db36: 7f 7f 7f        CLR   $7F7F
db39: 0a 4a           DEC   $4A
db3b: 4a              DECA
db3c: 4a              DECA
db3d: 00 05           NEG   $05
db3f: 08 05           ASL   $05
db41: 00 01           NEG   $01
db43: 01 01 f2        OIM   #$01;$F2
db46: d6 d7           LDB   $D7
db48: d7 02           STB   $02
db4a: cb 03           ADDB  #$03
db4c: da 02           ORB   $02
db4e: 00 34           NEG   $34
db50: 00 31           NEG   $31
db52: 41              FCB   $41
db53: 41              FCB   $41
db54: 41              FCB   $41
db55: 41              FCB   $41
db56: 00 07           NEG   $07
db58: 00 07           NEG   $07
db5a: 73 7f 6e        COM   $7F6E
db5d: 7f 14 0f        CLR   $140F
db60: 14              SEXW
db61: 0f 0d           CLR   $0D
db63: 0a 0d           DEC   $0D
db65: 0a 00           DEC   $00
db67: 00 00           NEG   $00
db69: 00 e3           NEG   $E3
db6b: c8 e3           EORB  #$E3
db6d: b7 02 c9        STA   $02C9
db70: 03 da           COM   $DA
db72: 02 00 34        AIM   #$00;$34
db75: 00 31           NEG   $31
db77: 41              FCB   $41
db78: 41              FCB   $41
db79: 41              FCB   $41
db7a: 41              FCB   $41
db7b: 00 04           NEG   $04
db7d: 00 04           NEG   $04
db7f: 73 7f 6e        COM   $7F6E
db82: 7f 14 12        CLR   $1412
db85: 14              SEXW
db86: 14              SEXW
db87: 0d 0a           TST   $0A
db89: 0d 0a           TST   $0A
db8b: 00 00           NEG   $00
db8d: 00 00           NEG   $00
db8f: e3 c8 e3        ADDD  -$1D,U
db92: d8 02           EORB  $02
db94: cb 05           ADDB  #$05
db96: 5a              DECB
db97: 02 00 3d        AIM   #$00;$3D
db9a: 00 22           NEG   $22
db9c: 41              FCB   $41
db9d: 41              FCB   $41
db9e: 41              FCB   $41
db9f: 41              FCB   $41
dba0: 03 07           COM   $07
dba2: 07 07           ASR   $07
dba4: 6b 7f 7f        TIM   #$7F;-$1,S
dba7: 78 4d 12        ASL   $4D12
dbaa: 14              SEXW
dbab: 55              FCB   $55
dbac: 07 08           ASR   $08
dbae: 0e 03           JMP   $03
dbb0: 00 00           NEG   $00
dbb2: 00 00           NEG   $00
dbb4: e4 e8 e8        ANDB  -$18,S
dbb7: ea 02           ORB   $2,X
dbb9: cb 08           ADDB  #$08
dbbb: 78 02 18        ASL   $0218
dbbe: 3e              FCB   $3E
dbbf: 00 41           NEG   $41
dbc1: 41              FCB   $41
dbc2: 41              FCB   $41
dbc3: 41              FCB   $41
dbc4: 41              FCB   $41
dbc5: 03 07           COM   $07
dbc7: 07 07           ASR   $07
dbc9: 64 50           LSR   -$10,U
dbcb: 7f 7f 1f        CLR   $7F1F
dbce: 10 4c           INCD
dbd0: 4c              INCA
dbd1: 07 07           ASR   $07
dbd3: 02 02 01        AIM   #$02;$01
dbd6: 01 01 01        OIM   #$01;$01
dbd9: a8 a8 d8        EORA  -$28,Y
dbdc: d8 02           EORB  $02
dbde: cb 0a           ADDB  #$0A
dbe0: ff 02 00        STU   $0200
dbe3: 04 00           LSR   $00
dbe5: 31 43           LEAY  $3,U
dbe7: 42              FCB   $42
dbe8: 43              COMA
dbe9: 41              FCB   $41
dbea: 00 07           NEG   $07
dbec: 00 07           NEG   $07
dbee: 66 7f           ROR   -$1,S
dbf0: 64 7f           LSR   -$1,S
dbf2: 1f 0c           TFR   D,0
dbf4: 1f 0c           TFR   D,0
dbf6: 08 00           ASL   $00
dbf8: 08 00           ASL   $00
dbfa: 01 01 01        OIM   #$01;$01
dbfd: 01 e3 f7        OIM   #$E3;$F7
dc00: e3 f7           ADDD  [E,S]
dc02: 02 c8 03        AIM   #$C8;$03
dc05: d0 02           SUBB  $02
dc07: 00 3a           NEG   $3A
dc09: 00 21           NEG   $21
dc0b: 41              FCB   $41
dc0c: 41              FCB   $41
dc0d: 41              FCB   $41
dc0e: 42              FCB   $42
dc0f: 00 00           NEG   $00
dc11: 00 04           NEG   $04
dc13: 76 64 6e        ROR   $646E
dc16: 7f 0d 07        CLR   $0D07
dc19: 07 52           ASR   $52
dc1b: 09 00           ROL   $00
dc1d: 00 03           NEG   $03
dc1f: 01 02 02        OIM   #$02;$02
dc22: 00 a2           NEG   $A2
dc24: f2 f2 d8        SBCB  $F2D8
dc27: 00 00           NEG   $00
dc29: 00 80           NEG   $80
dc2b: 00 00           NEG   $00
dc2d: 3c 28           CWAI  #$28
dc2f: 00 11           NEG   $11
dc31: 72 5f 44 01     AIM   #$5F,$4401
dc35: 01 00 01        OIM   #$00;$01
dc38: 76 75 5d        ROR   $755D
dc3b: 7f 1a 5a        CLR   $1A5A
dc3e: 1a 5a           ORCC  #$5A
dc40: 09 09           ROL   $09
dc42: 06 06           ROR   $06
dc44: 00 00           NEG   $00
dc46: 80 00           SUBA  #$00
dc48: d6 f6           LDB   $F6
dc4a: f6 d6 00        LDB   $D600
dc4d: 00 00           NEG   $00
dc4f: 80 00           SUBA  #$00
dc51: 00 07           NEG   $07
dc53: 00 00           NEG   $00
dc55: 41              FCB   $41
dc56: 44              LSRA
dc57: 42              FCB   $42
dc58: 48              ASLA
dc59: 07 07           ASR   $07
dc5b: 07 07           ASR   $07
dc5d: 7f 7f 7f        CLR   $7F7F
dc60: 7f 1f 1f        CLR   $1F1F
dc63: 1f 1f           TFR   X,F
dc65: 05 05 05        EIM   #$05;$05
dc68: 05 00 00        EIM   #$00;$00
dc6b: 00 00           NEG   $00
dc6d: da da           ORB   $DA
dc6f: da da           ORB   $DA
dc71: 02 ba 05        AIM   #$BA;$05
dc74: 80 02           SUBA  #$02
dc76: 00 3d           NEG   $3D
dc78: 00 03           NEG   $03
dc7a: 71 78 13 11     OIM   #$78,$1311
dc7e: 00 07           NEG   $07
dc80: 07 07           ASR   $07
dc82: 50              NEGB
dc83: 7f 7f 7f        CLR   $7F7F
dc86: 5f              CLRB
dc87: 1f 5f           TFR   PC,F
dc89: 1f 08           TFR   D,A
dc8b: 09 09           ROL   $09
dc8d: 08 c1           ASL   $C1
dc8f: 00 00           NEG   $00
dc91: 00 10           NEG   $10
dc93: 05 05 04        EIM   #$05;$04
dc96: 00 00           NEG   $00
dc98: 00 80           NEG   $80
dc9a: 00 24           NEG   $24
dc9c: 34 00           PSHS  
dc9e: 00 46           NEG   $46
dca0: 4f              CLRA
dca1: 44              LSRA
dca2: 4e              FCB   $4E
dca3: 00 07           NEG   $07
dca5: 00 07           NEG   $07
dca7: 71 7f 70 7f     OIM   #$7F,$707F
dcab: 1f 1f           TFR   X,F
dcad: 1f 1f           TFR   X,F
dcaf: 00 0b           NEG   $0B
dcb1: 00 0b           NEG   $0B
dcb3: c0 43           SUBB  #$43
dcb5: 80 43           SUBA  #$43
dcb7: f0 05 f0        SUBB  $05F0
dcba: 04 02           LSR   $02
dcbc: cb 00           ADDB  #$00
dcbe: e4 02           ANDB  $2,X
dcc0: 00 3c           NEG   $3C
dcc2: 00 20           NEG   $20
dcc4: 42              FCB   $42
dcc5: 42              FCB   $42
dcc6: 42              FCB   $42
dcc7: 41              FCB   $41
dcc8: 00 02           NEG   $02
dcca: 00 02           NEG   $02
dccc: 65 7f 65        EIM   #$7F;$5,S
dccf: 7f 5f 54        CLR   $5F54
dcd2: 1f 54           TFR   PC,S
dcd4: 0a 0a           DEC   $0A
dcd6: 0a 0a           DEC   $0A
dcd8: 00 00           NEG   $00
dcda: 00 00           NEG   $00
dcdc: d7 e7           STB   $E7
dcde: d7 e7           STB   $E7
dce0: 02 cb 05        AIM   #$CB;$05
dce3: ee 02           LDU   $2,X
dce5: 00 3c           NEG   $3C
dce7: 28 21           BVC   $DD0A
dce9: 12              NOP
dcea: 71 42 41 00     OIM   #$42,$4100
dcee: 07 00           ASR   $00
dcf0: 06 70           ROR   $70
dcf2: 7f 6e 7f        CLR   $6E7F
dcf5: 5f              CLRB
dcf6: 5f              CLRB
dcf7: 1f 5f           TFR   PC,F
dcf9: 0a 0a           DEC   $0A
dcfb: 00 0a           NEG   $0A
dcfd: 00 00           NEG   $00
dcff: 00 00           NEG   $00
dd01: d0 ea           SUBB  $EA
dd03: d9 ea           ADCB  $EA
dd05: 02 cb 00        AIM   #$CB;$00
dd08: e4 02           ANDB  $2,X
dd0a: 00 3c           NEG   $3C
dd0c: 00 20           NEG   $20
dd0e: 11 72           FCB   $11,$72
dd10: 71 12 00 07     OIM   #$12,$0007
dd14: 00 07           NEG   $07
dd16: 6e 7f           JMP   -$1,S
dd18: 6e 7f           JMP   -$1,S
dd1a: 5f              CLRB
dd1b: 5f              CLRB
dd1c: 5f              CLRB
dd1d: 5f              CLRB
dd1e: 0a 0a           DEC   $0A
dd20: 00 0a           NEG   $0A
dd22: 00 01           NEG   $01
dd24: 00 01           NEG   $01
dd26: e2 ea           SBCB  F,S
dd28: fa ea 02        ORB   $EA02
dd2b: c8 0a           EORB  #$0A
dd2d: f8 02 18        EORB  $0218
dd30: 3c 00           CWAI  #$00
dd32: 21 14           BRN   $DD48
dd34: 71 74 11 00     OIM   #$74,$1100
dd38: 07 00           ASR   $00
dd3a: 07 64           ASR   $64
dd3c: 7f 69 7f        CLR   $697F
dd3f: 1f 5f           TFR   PC,F
dd41: 1f 5f           TFR   PC,F
dd43: 00 09           NEG   $09
dd45: 00 09           NEG   $09
dd47: 00 00           NEG   $00
dd49: 00 00           NEG   $00
dd4b: f2 74 f2        SBCB  $74F2
dd4e: 74 02 c9        LSR   $02C9
dd51: 00 d0           NEG   $D0
dd53: 02 00 3a        AIM   #$00;$3A
dd56: 00 30           NEG   $30
dd58: 41              FCB   $41
dd59: 41              FCB   $41
dd5a: 41              FCB   $41
dd5b: 42              FCB   $42
dd5c: 00 00           NEG   $00
dd5e: 02 02 64        AIM   #$02;$64
dd61: 6c 69           INC   $9,S
dd63: 7f 14 14        CLR   $1414
dd66: 1f 1f           TFR   X,F
dd68: 00 00           NEG   $00
dd6a: 00 00           NEG   $00
dd6c: 0c 0c           INC   $0C
dd6e: 01 01 f2        OIM   #$01;$F2
dd71: f2 f2 ff        SBCB  $F2FF
dd74: 00 00           NEG   $00
dd76: 00 80           NEG   $80
dd78: 00 00           NEG   $00
dd7a: 3b              RTI
dd7b: 00 00           NEG   $00
dd7d: 4f              CLRA
dd7e: 46              RORA
dd7f: 40              NEGA
dd80: 41              FCB   $41
dd81: 02 02 02        AIM   #$02;$02
dd84: 02 64 64        AIM   #$64;$64
dd87: 64 7f           LSR   -$1,S
dd89: 1f 1f           TFR   X,F
dd8b: 1f 1f           TFR   X,F
dd8d: 0c 00           INC   $00
dd8f: 0a 03           DEC   $03
dd91: 0f 00           CLR   $00
dd93: 00 01           NEG   $01
dd95: 03 f5           COM   $F5
dd97: a5 ac 00        BITA  $DD9A,PCR
dd9a: 00 00           NEG   $00
dd9c: 80 00           SUBA  #$00
dd9e: f4 3a 00        ANDB  $3A00
dda1: 00 72           NEG   $72
dda3: 11 12           FCB   $11,$12
dda5: 41              FCB   $41
dda6: 00 02           NEG   $02
dda8: 02 02 64        AIM   #$02;$64
ddab: 72 6e 7f 1f     AIM   #$6E,$7F1F
ddaf: 1f 1f           TFR   X,F
ddb1: 5f              CLRB
ddb2: 00 00           NEG   $00
ddb4: 00 00           NEG   $00
ddb6: 00 00           NEG   $00
ddb8: 00 01           NEG   $01
ddba: f3 f3 f3        ADDD  $F3F3
ddbd: fa 00 00        ORB   >$0000
ddc0: 00 80           NEG   $80
ddc2: 00 f4           NEG   $F4
ddc4: 3d              MUL
ddc5: 00 00           NEG   $00
ddc7: 71 71 71 71     OIM   #$71,$7171
ddcb: 03 07           COM   $07
ddcd: 07 07           ASR   $07
ddcf: 69 7f           ROL   -$1,S
ddd1: 7f 7f 14        CLR   $7F14
ddd4: 12              NOP
ddd5: 12              NOP
ddd6: 12              NOP
ddd7: 0f 0b           CLR   $0B
ddd9: 0c 0c           INC   $0C
dddb: 00 00           NEG   $00
dddd: 00 00           NEG   $00
dddf: e3 08           ADDD  $8,X
dde1: 08 08           ASL   $08
dde3: 02 ff 00        AIM   #$FF;$00
dde6: ff 03 f0        STU   $03F0
dde9: 3b              RTI
ddea: 00 70           NEG   $70
ddec: 43              COMA
dded: 40              NEGA
ddee: 41              FCB   $41
ddef: 40              NEGA
ddf0: 00 00           NEG   $00
ddf2: 00 00           NEG   $00
ddf4: 77 70 77        ASR   $7077
ddf7: 7f 1f 1f        CLR   $1F1F
ddfa: 1f 1f           TFR   X,F
ddfc: 0e 0e           JMP   $0E
ddfe: 0e 0e           JMP   $0E
de00: 04 14           LSR   $14
de02: 00 14           NEG   $14
de04: f8 5c 08        EORB  $5C08
de07: 5c              INCB
de08: 02 af 00        AIM   #$AF;$00
de0b: ff 02 00        STU   $0200
de0e: 06 00           ROR   $00
de10: 70 40 60        NEG   $4060
de13: 40              NEGA
de14: 40              NEGA
de15: 00 07           NEG   $07
de17: 07 07           ASR   $07
de19: 75 73 7f 7f     EIM   #$73,$7F7F
de1d: 1f 1f           TFR   X,F
de1f: 1f 1f           TFR   X,F
de21: 0f 11           CLR   $11
de23: 10 10           FCB   $10,$10
de25: 0f 00           CLR   $00
de27: 40              NEGA
de28: 40              NEGA
de29: fa 0a 0a        ORB   $0A0A
de2c: 0a 00           DEC   $00
de2e: 00 00           NEG   $00
de30: 80 00           SUBA  #$00
de32: 78 1b 00        ASL   $1B00
de35: 00 46           NEG   $46
de37: 45              FCB   $45
de38: 43              COMA
de39: 40              NEGA
de3a: 00 00           NEG   $00
de3c: 00 00           NEG   $00
de3e: 7f 7f 7f        CLR   $7F7F
de41: 7f 1f 1f        CLR   $1F1F
de44: 1f 1f           TFR   X,F
de46: 00 07           NEG   $07
de48: 14              SEXW
de49: 12              NOP
de4a: 00 c8           NEG   $C8
de4c: 00 c0           NEG   $C0
de4e: 0f 77           CLR   $77
de50: 0f 0a           CLR   $0A
de52: 00 00           NEG   $00
de54: 00 80           NEG   $80
de56: 00 ea           NEG   $EA
de58: 3a              ABX
de59: 00 00           NEG   $00
de5b: 4f              CLRA
de5c: 40              NEGA
de5d: 20 70           BRA   $DECF
de5f: 00 00           NEG   $00
de61: 00 00           NEG   $00
de63: 7f 7f 7f        CLR   $7F7F
de66: 77 1f 1f        ASR   $1F1F
de69: 1f 1f           TFR   X,F
de6b: 0d 0d           TST   $0D
de6d: 0d 0d           TST   $0D
de6f: 80 40           SUBA  #$40
de71: 00 00           NEG   $00
de73: 0e 0e           JMP   $0E
de75: 0e 0e           JMP   $0E
de77: 00 00           NEG   $00
de79: 00 80           NEG   $80
de7b: 00 00           NEG   $00
de7d: 3d              MUL
de7e: 00 00           NEG   $00
de80: 41              FCB   $41
de81: 40              NEGA
de82: 20 70           BRA   $DEF4
de84: 00 00           NEG   $00
de86: 00 00           NEG   $00
de88: 7f 7f 7f        CLR   $7F7F
de8b: 7f 1f 1f        CLR   $1F1F
de8e: 1f 1f           TFR   X,F
de90: 0e 0e           JMP   $0E
de92: 0e 0e           JMP   $0E
de94: 80 40           SUBA  #$40
de96: 00 00           NEG   $00
de98: 0f 0f           CLR   $0F
de9a: 0f 0f           CLR   $0F
de9c: 00 00           NEG   $00
de9e: 00 80           NEG   $80
dea0: 00 00           NEG   $00
dea2: 3a              ABX
dea3: c8 00           EORB  #$00
dea5: 60 11           NEG   -$F,X
dea7: 2f 74           BLE   $DF1D
dea9: 00 00           NEG   $00
deab: 00 00           NEG   $00
dead: 60 60           NEG   $0,S
deaf: 60 7f           NEG   -$1,S
deb1: 1f 1f           TFR   X,F
deb3: 1f 1f           TFR   X,F
deb5: 00 00           NEG   $00
deb7: 00 00           NEG   $00
deb9: 00 00           NEG   $00
debb: 00 00           NEG   $00
debd: f5 f5 f5        BITB  $F5F5
dec0: f5 00 00        BITB  >$0000
dec3: 00 80           NEG   $80
dec5: 00 00           NEG   $00
dec7: 3e              FCB   $3E
dec8: c8 00           EORB  #$00
deca: 6f 11           CLR   -$F,X
decc: 27 7a           BEQ   $DF48
dece: 00 00           NEG   $00
ded0: 00 00           NEG   $00
ded2: 6e 7f           JMP   -$1,S
ded4: 7f 7f 1f        CLR   $7F1F
ded7: 1f 1f           TFR   X,F
ded9: 1f 00           TFR   D,D
dedb: 00 00           NEG   $00
dedd: 00 80           NEG   $80
dedf: 40              NEGA
dee0: 00 00           NEG   $00
dee2: f2 f5 f5        SBCB  $F5F5
dee5: f5 02 c3        BITB  $02C3
dee8: 00 ff           NEG   $FF
deea: 02 00 3f        AIM   #$00;$3F
deed: 00 20           NEG   $20
deef: 1f 72           TFR   V,Y
def1: 74 11 02        LSR   $1102
def4: 02 02 02        AIM   #$02;$02
def7: 6e 7f           JMP   -$1,S
def9: 7f 7f 1d        CLR   $7F1D
defc: 1d              SEX
defd: 1d              SEX
defe: 1d              SEX
deff: 0a 0a           DEC   $0A
df01: 0a 0a           DEC   $0A
df03: 00 00           NEG   $00
df05: 00 00           NEG   $00
df07: 03 03           COM   $03
df09: 03 03           COM   $03
df0b: 02 cb 00        AIM   #$CB;$00
df0e: e4 02           ANDB  $2,X
df10: 00 3c           NEG   $3C
df12: 00 20           NEG   $20
df14: 42              FCB   $42
df15: 42              FCB   $42
df16: 42              FCB   $42
df17: 41              FCB   $41
df18: 00 02           NEG   $02
df1a: 00 02           NEG   $02
df1c: 70 7f 6e        NEG   $7F6E
df1f: 7f 5f 54        CLR   $5F54
df22: 1f 54           TFR   PC,S
df24: 0a 0a           DEC   $0A
df26: 0a 0a           DEC   $0A
df28: 00 00           NEG   $00
df2a: 00 00           NEG   $00
df2c: d6 e4           LDB   $E4
df2e: d6 e4           LDB   $E4
df30: 1a 8e           ORCC  #$8E
df32: 1c 8e           ANDCC #$8E
df34: 1e 8e           EXG   A,E
df36: 20 0e           BRA   $DF46
df38: 2b f8           BMI   $DF32
df3a: 08 08           ASL   $08
df3c: 08 f8           ASL   $F8
df3e: 40              NEGA
df3f: f8 20 08        EORB  $2008
df42: 50              NEGB
df43: 08 30           ASL   $30
df45: 08 18           ASL   $18
df47: 27 df           BEQ   $DF28
df49: 39              RTS
df4a: 09 71           ROL   $71
df4c: 09 70           ROL   $70
df4e: 8e 22 8e        LDX   #$228E
df51: 24 8e           BCC   $DEE1
df53: 26 8e           BNE   $DEE3
df55: 28 0e           BVC   $DF65
df57: 2a 27           BPL   $DF80
df59: df 69           STU   $69
df5b: 09 77           ROL   $77
df5d: 09 76           ROL   $76
df5f: 8e 22 8e        LDX   #$228E
df62: 2c 8e           BGE   $DEF2
df64: 26 0e           BNE   $DF74
df66: 28 8e           BVC   $DEF6
df68: 2e f8           BGT   $DF62
df6a: 08 08           ASL   $08
df6c: 08 f8           ASL   $F8
df6e: 40              NEGA
df6f: f8 20 08        EORB  $2008
df72: 50              NEGB
df73: 08 38           ASL   $38
df75: 08 20           ASL   $20
df77: 27 df           BEQ   $DF58
df79: 69 09           ROL   $9,X
df7b: 7d 09 7c        TST   $097C
df7e: 8e 1a 8e        LDX   #$1A8E
df81: 30 8e           LEAX  W,X
df83: 1e 0e           EXG   D,E
df85: 20 8e           BRA   $DF15
df87: 32 27           LEAS  $7,Y
df89: df 99           STU   $99
df8b: 8e 00 8e        LDX   #$008E
df8e: 02 0e 11        AIM   #$0E;$11
df91: 8e 04 8e        LDX   #$048E
df94: 06 09           ROR   $09
df96: 47              ASRA
df97: 09 46           ROL   $46
df99: f8 50 f8        EORB  $50F8
df9c: 30 f8 18        LEAX  [$18,S]
df9f: 08 40           ASL   $40
dfa1: 08 20           ASL   $20
dfa3: f8 08 08        EORB  $0808
dfa6: 08 27           ASL   $27
dfa8: df b8           STU   $B8
dfaa: 8e 00 0e        LDX   #$000E
dfad: 02 8e 12        AIM   #$8E;$12
dfb0: 8e 04 8e        LDX   #$048E
dfb3: 14              SEXW
dfb4: 09 57           ROL   $57
dfb6: 09 56           ROL   $56
dfb8: f8 50 f8        EORB  $50F8
dfbb: 38              FCB   $38
dfbc: f8 20 08        EORB  $2008
dfbf: 40              NEGA
dfc0: 08 20           ASL   $20
dfc2: f8 08 08        EORB  $0808
dfc5: 08 27           ASL   $27
dfc7: df 99           STU   $99
dfc9: 8e 08 8e        LDX   #$088E
dfcc: 0a 0e           DEC   $0E
dfce: 10 8e 0c 8e     LDY   #$0C8E
dfd2: 0e 09           JMP   $09
dfd4: 51              FCB   $51
dfd5: 09 50           ROL   $50
dfd7: 27 df           BEQ   $DFB8
dfd9: b8 8e 08        EORA  $8E08
dfdc: 0e 0a           JMP   $0A
dfde: 8e 16 8e        LDX   #$168E
dfe1: 0c 8e           INC   $8E
dfe3: 18              FCB   $18
dfe4: 09 5d           ROL   $5D
dfe6: 09 5c           ROL   $5C
dfe8: 05 c8 98        EIM   #$C8;$98
dfeb: 10 40           NEGD
dfed: c8 9a           EORB  #$9A
dfef: 10 20           FCB   $10,$20
dff1: 48              ASLA
dff2: a0 10           SUBA  -$10,X
dff4: 08 c8           ASL   $C8
dff6: 9c 00           CMPX  $00
dff8: 30 c8 9e        LEAX  -$62,U
dffb: 00 10           NEG   $10
dffd: e0 a3           SUBB  ,--Y
dfff: e0 c6           SUBB  A,U
e001: e0 d9 e0 ec     SUBB  [-$1F14,U]
e005: e0 ff e1 22     SUBB  [$E122]
e009: e1 35           CMPB  -$B,Y
e00b: e1 48           CMPB  $8,U
e00d: e1 5b           CMPB  -$5,U
e00f: e1 70           CMPB  -$10,S
e011: e1 91           CMPB  [,X++]
e013: e1 a6           CMPB  A,Y
e015: e1 bf e1 d0     CMPB  [$E1D0]
e019: e1 e9 e2 02     CMPB  -$1DFE,S
e01d: e2 13           SBCB  -$D,X
e01f: e2 28           SBCB  $8,Y
e021: e2 43           SBCB  $3,U
e023: e2 52           SBCB  -$E,U
e025: e2 7f           SBCB  -$1,S
e027: e2 8e           SBCB  W,X
e029: e2 af e2 d4     SBCB  -$1D2C,W
e02d: e2 ed e3 02     SBCB  $C333,PCR
e031: e3 02           ADDD  $2,X
e033: e3 02           ADDD  $2,X
e035: e3 02           ADDD  $2,X
e037: e3 02           ADDD  $2,X
e039: e3 02           ADDD  $2,X
e03b: e3 02           ADDD  $2,X
e03d: e3 02           ADDD  $2,X
e03f: e3 1b           ADDD  -$5,X
e041: e3 3c           ADDD  -$4,Y
e043: e3 3c           ADDD  -$4,Y
e045: e3 3c           ADDD  -$4,Y
e047: e3 3c           ADDD  -$4,Y
e049: e3 3c           ADDD  -$4,Y
e04b: e3 3c           ADDD  -$4,Y
e04d: e3 3c           ADDD  -$4,Y
e04f: e3 3c           ADDD  -$4,Y
e051: e3 3c           ADDD  -$4,Y
e053: e3 3c           ADDD  -$4,Y
e055: e3 3c           ADDD  -$4,Y
e057: e3 65           ADDD  $5,S
e059: e3 82           ADDD  ,-X
e05b: e3 9b           ADDD  [D,X]
e05d: e3 9b           ADDD  [D,X]
e05f: e3 9b           ADDD  [D,X]
e061: e3 9b           ADDD  [D,X]
e063: e3 9b           ADDD  [D,X]
e065: e3 9b           ADDD  [D,X]
e067: e3 c0           ADDD  ,U+
e069: e3 e1           ADDD  ,S++
e06b: e4 0e           ANDB  $E,X
e06d: e4 33           ANDB  -$D,Y
e06f: e4 33           ANDB  -$D,Y
e071: e4 33           ANDB  -$D,Y
e073: e4 33           ANDB  -$D,Y
e075: e4 33           ANDB  -$D,Y
e077: e4 33           ANDB  -$D,Y
e079: e4 33           ANDB  -$D,Y
e07b: e4 33           ANDB  -$D,Y
e07d: e4 33           ANDB  -$D,Y
e07f: e4 33           ANDB  -$D,Y
e081: e4 33           ANDB  -$D,Y
e083: e4 33           ANDB  -$D,Y
e085: e4 54           ANDB  -$C,U
e087: e4 71           ANDB  -$F,S
e089: e4 8e           ANDB  W,X
e08b: e4 ab           ANDB  D,Y
e08d: e4 c8 e4        ANDB  -$1C,U
e090: d9 e4           ADCB  $E4
e092: f2 e5 11        SBCB  $E511
e095: e5 22           BITB  $2,Y
e097: e5 41           BITB  $1,U
e099: e5 52           BITB  -$E,U
e09b: e5 71           BITB  -$F,S
e09d: e5 90           BITB  [,W]
e09f: e5 a1           BITB  ,Y++
e0a1: e5 b2           BITB  Illegal Postbyte
e0a3: 28 e0           BVC   $E085
e0a5: b6 0a 19        LDA   $0A19
e0a8: 09 5f           ROL   $5F
e0aa: 89 60           ADCA  #$60
e0ac: 09 67           ROL   $67
e0ae: 0a 1a           DEC   $1A
e0b0: 09 63           ROL   $63
e0b2: 89 64           ADCA  #$64
e0b4: 09 66           ROL   $66
e0b6: f8 48 f8        EORB  $48F8
e0b9: 38              FCB   $38
e0ba: f8 20 f8        EORB  $20F8
e0bd: 08 08           ASL   $08
e0bf: 48              ASLA
e0c0: 08 38           ASL   $38
e0c2: 08 20           ASL   $20
e0c4: 08 08           ASL   $08
e0c6: 28 e0           BVC   $E0A8
e0c8: b6 0a 1b        LDA   $0A1B
e0cb: 09 69           ROL   $69
e0cd: 89 6a           ADCA  #$6A
e0cf: 09 71           ROL   $71
e0d1: 0a 1c           DEC   $1C
e0d3: 09 6d           ROL   $6D
e0d5: 89 6e           ADCA  #$6E
e0d7: 09 70           ROL   $70
e0d9: 28 e0           BVC   $E0BB
e0db: b6 0a 1b        LDA   $0A1B
e0de: 09 69           ROL   $69
e0e0: 89 72           ADCA  #$72
e0e2: 09 77           ROL   $77
e0e4: 0a 1c           DEC   $1C
e0e6: 09 6d           ROL   $6D
e0e8: 89 74           ADCA  #$74
e0ea: 09 76           ROL   $76
e0ec: 28 e0           BVC   $E0CE
e0ee: b6 0a 19        LDA   $0A19
e0f1: 09 5f           ROL   $5F
e0f3: 89 78           ADCA  #$78
e0f5: 09 7d           ROL   $7D
e0f7: 0a 1a           DEC   $1A
e0f9: 09 63           ROL   $63
e0fb: 89 7a           ADCA  #$7A
e0fd: 09 7c           ROL   $7C
e0ff: 28 e1           BVC   $E0E2
e101: 12              NOP
e102: 0a 11           DEC   $11
e104: 0a 12           DEC   $12
e106: 89 40           ADCA  #$40
e108: 09 47           ROL   $47
e10a: 0a 13           DEC   $13
e10c: 0a 14           DEC   $14
e10e: 89 44           ADCA  #$44
e110: 09 46           ROL   $46
e112: f8 48 f8        EORB  $48F8
e115: 38              FCB   $38
e116: f8 20 f8        EORB  $20F8
e119: 08 08           ASL   $08
e11b: 48              ASLA
e11c: 08 38           ASL   $38
e11e: 08 20           ASL   $20
e120: 08 08           ASL   $08
e122: 28 e1           BVC   $E105
e124: 12              NOP
e125: 0a 11           DEC   $11
e127: 0a 12           DEC   $12
e129: 89 52           ADCA  #$52
e12b: 09 57           ROL   $57
e12d: 0a 13           DEC   $13
e12f: 0a 14           DEC   $14
e131: 89 54           ADCA  #$54
e133: 09 56           ROL   $56
e135: 28 e1           BVC   $E118
e137: 12              NOP
e138: 0a 15           DEC   $15
e13a: 0a 16           DEC   $16
e13c: 89 4a           ADCA  #$4A
e13e: 09 51           ROL   $51
e140: 0a 17           DEC   $17
e142: 0a 18           DEC   $18
e144: 89 4e           ADCA  #$4E
e146: 09 50           ROL   $50
e148: 28 e1           BVC   $E12B
e14a: 12              NOP
e14b: 0a 15           DEC   $15
e14d: 0a 16           DEC   $16
e14f: 89 58           ADCA  #$58
e151: 09 5d           ROL   $5D
e153: 0a 17           DEC   $17
e155: 0a 18           DEC   $18
e157: 89 5a           ADCA  #$5A
e159: 09 5c           ROL   $5C
e15b: 05 8a 1e        EIM   #$8A;$1E
e15e: f8 40 89        EORB  $4089
e161: 02 f8 20        AIM   #$F8;$20
e164: 09 0f           ROL   $0F
e166: f8 08 89        EORB  $0889
e169: 04 08           LSR   $08
e16b: 30 89 06 08     LEAX  $0608,X
e16f: 10 08           FCB   $10,$08
e171: 0a 1d           DEC   $1D
e173: f8 48 09        EORB  $4809
e176: 09 f8           ROL   $F8
e178: 38              FCB   $38
e179: 89 0a           ADCA  #$0A
e17b: f8 20 09        EORB  $2009
e17e: 0f f8           CLR   $F8
e180: 08 0a           ASL   $0A
e182: 2a 08           BPL   $E18C
e184: 48              ASLA
e185: 09 0d           ROL   $0D
e187: 08 38           ASL   $38
e189: 09 0e           ROL   $0E
e18b: 08 28           ASL   $28
e18d: 89 06           ADCA  #$06
e18f: 08 10           ASL   $10
e191: 05 8a 22        EIM   #$8A;$22
e194: e0 30           SUBB  -$10,Y
e196: 89 1a           ADCA  #$1A
e198: f0 30 89        SUBB  $3089
e19b: 1c 00           ANDCC #$00
e19d: 30 89 1e 00     LEAX  $1E00,X
e1a1: 10 89 20 10     ADCD  #$2010
e1a5: 20 06           BRA   $E1AD
e1a7: 8a 24           ORA   #$24
e1a9: d0 08           SUBB  $08
e1ab: 89 24           ADCA  #$24
e1ad: e0 18           SUBB  -$8,X
e1af: 09 29           ROL   $29
e1b1: e0 00           SUBB  $0,X
e1b3: 89 26           ADCA  #$26
e1b5: f0 18 09        SUBB  $1809
e1b8: 28 f0           BVC   $E1AA
e1ba: 00 89           NEG   $89
e1bc: 2a 00           BPL   $E1BE
e1be: 18              FCB   $18
e1bf: 04 88           LSR   $88
e1c1: d6 00           LDB   $00
e1c3: 30 88 d8        LEAX  -$28,X
e1c6: 00 10           NEG   $10
e1c8: 89 fa           ADCA  #$FA
e1ca: 10 40           NEGD
e1cc: 88 dc           EORA  #$DC
e1ce: 10 20           FCB   $10,$20
e1d0: 06 88           ROR   $88
e1d2: de 08           LDU   $08
e1d4: 10 88 e0 18     EORD  #$E018
e1d8: 10 88 e2 28     EORD  #$E228
e1dc: 20 08           BRA   $E1E6
e1de: d5 28           BITB  $28
e1e0: 08 09           ASL   $09
e1e2: f9 38 18        ADCB  $3818
e1e5: 08 e5           ASL   $E5
e1e7: 38              FCB   $38
e1e8: 08 06           ASL   $06
e1ea: 49              ROLA
e1eb: 2c 28           BGE   $E215
e1ed: 20 ca           BRA   $E1B9
e1ef: 26 28           BNE   $E219
e1f1: 08 c9           ASL   $C9
e1f3: 2e 18           BGT   $E20D
e1f5: 18              FCB   $18
e1f6: 49              ROLA
e1f7: 30 18           LEAX  -$8,X
e1f9: 00 c9           NEG   $C9
e1fb: 32 08           LEAS  $8,X
e1fd: 08 c9           ASL   $C9
e1ff: 34 f8           PSHS  PC,U,Y,X,DP
e201: 08 04           ASL   $04
e203: 89 10           ADCA  #$10
e205: 00 30           NEG   $30
e207: 89 12           ADCA  #$12
e209: 00 10           NEG   $10
e20b: 8a 20           ORA   #$20
e20d: 10 30 89        ADDR  A,B
e210: 16 10 10        LBRA  $F223
e213: 05 09 39        EIM   #$09;$39
e216: f0 08 89        SUBB  $0889
e219: 36 00           PSHU  
e21b: 20 09           BRA   $E226
e21d: 38              FCB   $38
e21e: 00 08           NEG   $08
e220: 8a 28           ORA   #$28
e222: 10 30 89        ADDR  A,B
e225: 3c 10           CWAI  #$10
e227: 10 26 e2 37     LBNE  $C462
e22b: 88 ca           EORA  #$CA
e22d: 88 cc           EORA  #$CC
e22f: 08 d3           ASL   $D3
e231: 8a 36           ORA   #$36
e233: 88 d0           EORA  #$D0
e235: 08 d2           ASL   $D2
e237: f8 40 f8        EORB  $40F8
e23a: 20 f8           BRA   $E234
e23c: 08 08           ASL   $08
e23e: 40              NEGA
e23f: 08 20           ASL   $20
e241: 08 08           ASL   $08
e243: 26 e2           BNE   $E227
e245: 37 88           PULU  DP,PC
e247: a2 88 a4        SBCA  -$5C,X
e24a: 08 a1           ASL   $A1
e24c: 8a 2c           ORA   #$2C
e24e: 88 a8           EORA  #$A8
e250: 08 d4           ASL   $D4
e252: 0b 88 aa        TIM   #$88;$AA
e255: f8 30 08        EORB  $3008
e258: a5 f8 18        BITA  [$18,S]
e25b: 08 a1           ASL   $A1
e25d: f8 08 0a        EORB  $080A
e260: 2b 08           BMI   $E26A
e262: 48              ASLA
e263: 08 ad           ASL   $AD
e265: 08 38           ASL   $38
e267: 08 b1           ASL   $B1
e269: 08 28           ASL   $28
e26b: 08 a9           ASL   $A9
e26d: 08 18           ASL   $18
e26f: 08 d4           ASL   $D4
e271: 08 08           ASL   $08
e273: 0a 38           DEC   $38
e275: 18              FCB   $18
e276: 48              ASLA
e277: 08 af           ASL   $AF
e279: 18              FCB   $18
e27a: 38              FCB   $38
e27b: 08 b0           ASL   $B0
e27d: 28 38           BVC   $E2B7
e27f: 26 e2           BNE   $E263
e281: 37 88           PULU  DP,PC
e283: b2 88 b4        SBCA  $88B4
e286: 08 bb           ASL   $BB
e288: 8a 2e           ORA   #$2E
e28a: 88 b8           EORA  #$B8
e28c: 08 ba           ASL   $BA
e28e: 08 88           ASL   $88
e290: bc f8 40        CMPX  $F840
e293: 08 c1           ASL   $C1
e295: f8 28 08        EORB  $2808
e298: b5 f8 18        BITA  $F818
e29b: 08 bb           ASL   $BB
e29d: f8 08 8a        EORB  $088A
e2a0: 30 08           LEAX  $8,X
e2a2: 40              NEGA
e2a3: 08 c0           ASL   $C0
e2a5: 08 28           ASL   $28
e2a7: 08 b9           ASL   $B9
e2a9: 08 18           ASL   $18
e2ab: 08 ba           ASL   $BA
e2ad: 08 08           ASL   $08
e2af: 09 88           ROL   $88
e2b1: c2 f8           SBCB  #$F8
e2b3: 30 08           LEAX  $8,X
e2b5: a5 f8 18        BITA  [$18,S]
e2b8: 08 a1           ASL   $A1
e2ba: f8 08 8a        EORB  $088A
e2bd: 32 08           LEAS  $8,X
e2bf: 40              NEGA
e2c0: 08 c9           ASL   $C9
e2c2: 08 28           ASL   $28
e2c4: 08 a9           ASL   $A9
e2c6: 08 18           ASL   $18
e2c8: 08 d4           ASL   $D4
e2ca: 08 08           ASL   $08
e2cc: 8a 34           ORA   #$34
e2ce: 18              FCB   $18
e2cf: 40              NEGA
e2d0: 08 c8           ASL   $C8
e2d2: 28 38           BVC   $E30C
e2d4: 06 83           ROR   $83
e2d6: d8 f8           EORB  $F8
e2d8: 40              NEGA
e2d9: 84 c8           ANDA  #$C8
e2db: f8 20 04        EORB  $2004
e2de: ca f8           ORB   #$F8
e2e0: 08 83           ASL   $83
e2e2: da 08           ORB   $08
e2e4: 40              NEGA
e2e5: 04 cd           LSR   $CD
e2e7: 08 28           ASL   $28
e2e9: 84 ce           ANDA  #$CE
e2eb: 08 10           ASL   $10
e2ed: 05 84 d0        EIM   #$84;$D0
e2f0: f8 30 84        EORB  $3084
e2f3: d2 f8           SBCB  $F8
e2f5: 10 83 dc 08     CMPD  #$DC08
e2f9: 30 84           LEAX  ,X
e2fb: d6 08           LDB   $08
e2fd: 10 84 d8 18     ANDD  #$D818
e301: 20 06           BRA   $E309
e303: 8f              FCB   $8F
e304: ba f8 40        ORA   $F840
e307: 89 ec           ADCA  #$EC
e309: f8 20 09        EORB  $2009
e30c: f3 f8 08        ADDD  $F808
e30f: 8f              FCB   $8F
e310: bc 08 40        CMPX  $0840
e313: 89 f0           ADCA  #$F0
e315: 08 20           ASL   $20
e317: 09 f2           ROL   $F2
e319: 08 08           ASL   $08
e31b: 08 8f           ASL   $8F
e31d: be f8 40        LDX   $F840
e320: 09 e9           ROL   $E9
e322: f8 28 09        EORB  $2809
e325: ed f8 18        STD   [$18,S]
e328: 09 f3           ROL   $F3
e32a: f8 08 8f        EORB  $088F
e32d: c0 08           SUBB  #$08
e32f: 40              NEGA
e330: 09 f8           ROL   $F8
e332: 08 28           ASL   $28
e334: 09 f1           ROL   $F1
e336: 08 18           ASL   $18
e338: 09 f2           ROL   $F2
e33a: 08 08           ASL   $08
e33c: 0a 4c           DEC   $4C
e33e: 57              ASRB
e33f: 10 38           PSHSW
e341: cd d6 00 40 cc  LDQ   #$D60040CC
e346: 5a              DECB
e347: 00 20           NEG   $20
e349: 4c              INCA
e34a: 63 00           COM   $0,X
e34c: 08 cd           ASL   $CD
e34e: da f0           ORB   $F0
e350: 40              NEGA
e351: cc 5e f0        LDD   #$5EF0
e354: 20 4c           BRA   $E3A2
e356: 62 f0 08        AIM   #$F0;$8,X
e359: cc 60 e0        LDD   #$60E0
e35c: 40              NEGA
e35d: 4c              INCA
e35e: 56              RORB
e35f: f0 58 4c        SUBB  $584C
e362: 55              FCB   $55
e363: e0 58           SUBB  -$8,U
e365: 07 cd           ASR   $CD
e367: f0 00 40        SUBB  >$0040
e36a: cc 72 00        LDD   #$7200
e36d: 20 4c           BRA   $E3BB
e36f: 78 00 08        ASL   >$0008
e372: cc 74 f0        LDD   #$74F0
e375: 30 cc 76        LEAX  $E3EE,PCR
e378: f0 10 4c        SUBB  $104C
e37b: 79 f0 48        ROL   $F048
e37e: cc 6e e0        LDD   #$6EE0
e381: 40              NEGA
e382: 06 4c           ROR   $4C
e384: 6d 10           TST   -$10,X
e386: 38              FCB   $38
e387: cd e4 00 40 cc  LDQ   #$E40040CC
e38c: 66 00           ROR   $0,X
e38e: 20 4c           BRA   $E3DC
e390: 6c 00           INC   $0,X
e392: 08 cc           ASL   $CC
e394: 68 f0           ASL   [,--W]
e396: 30 cc 6a        LEAX  $E403,PCR
e399: f0 10 09        SUBB  $1009
e39c: ca 00           ORB   #$00
e39e: 10 40           NEGD
e3a0: c8 64           EORB  #$64
e3a2: 10 20           FCB   $10,$20
e3a4: 48              ASLA
e3a5: 61 10 08        OIM   #$10;$8,X
e3a8: c8 66           EORB  #$66
e3aa: 00 30           NEG   $30
e3ac: c8 68           EORB  #$68
e3ae: 00 10           NEG   $10
e3b0: d8 4a           EORB  $4A
e3b2: 18              FCB   $18
e3b3: 20 58           BRA   $E40D
e3b5: 4f              CLRA
e3b6: 18              FCB   $18
e3b7: 08 d8           ASL   $D8
e3b9: 4c              INCA
e3ba: 08 20           ASL   $20
e3bc: 58              ASLB
e3bd: 4e              FCB   $4E
e3be: 08 08           ASL   $08
e3c0: 08 c8           ASL   $C8
e3c2: 6a 10           DEC   -$10,X
e3c4: 30 48           LEAX  $8,U
e3c6: 71 10 08 ca     OIM   #$10,$08CA
e3ca: 02 00 40        AIM   #$00;$40
e3cd: c8 6e           EORB  #$6E
e3cf: 00 20           NEG   $20
e3d1: 48              ASLA
e3d2: 70 00 08        NEG   >$0008
e3d5: d8 56           EORB  $56
e3d7: 14              SEXW
e3d8: 2c 58           BGE   $E432
e3da: 60 14           NEG   -$C,X
e3dc: 14              SEXW
e3dd: d8 58           EORB  $58
e3df: 04 2c           LSR   $2C
e3e1: 0b 48 71        TIM   #$48;$71
e3e4: 10 08           FCB   $10,$08
e3e6: 48              ASLA
e3e7: 6f 00           CLR   $0,X
e3e9: 18              FCB   $18
e3ea: 48              ASLA
e3eb: 70 00 08        NEG   >$0008
e3ee: c8 72           EORB  #$72
e3f0: 08 40           ASL   $40
e3f2: 48              ASLA
e3f3: 77 08 28        ASR   $0828
e3f6: ca 04           ORB   #$04
e3f8: f8 40 48        EORB  $4048
e3fb: 76 f8 28        ROR   $F828
e3fe: d8 50           EORB  $50
e400: 14              SEXW
e401: 48              ASLA
e402: 58              ASLB
e403: 55              FCB   $55
e404: 14              SEXW
e405: 30 d8 52        LEAX  [$52,U]
e408: 04 48           LSR   $48
e40a: 58              ASLB
e40b: 54              LSRB
e40c: 04 30           LSR   $30
e40e: 09 48           ROL   $48
e410: 71 10 08 48     OIM   #$10,$0848
e414: 6f 00           CLR   $0,X
e416: 18              FCB   $18
e417: 48              ASLA
e418: 70 00 08        NEG   >$0008
e41b: 4a              DECA
e41c: 06 fe           ROR   $FE
e41e: 48              ASLA
e41f: 48              ASLA
e420: 83 fe 38        SUBD  #$FE38
e423: 48              ASLA
e424: 87              FCB   $87
e425: fe 28 48        LDU   $2848
e428: 84 ee           ANDA  #$EE
e42a: 58              ASLB
e42b: 4a              DECA
e42c: 07 ee           ASR   $EE
e42e: 48              ASLA
e42f: 48              ASLA
e430: 86 ee           LDA   #$EE
e432: 38              FCB   $38
e433: 08 cd           ASL   $CD
e435: a2 10           SBCA  -$10,X
e437: 40              NEGA
e438: cd a4 10 20 4d  LDQ   #$A410204D
e43d: b6 10 08        LDA   $1008
e440: cd a6 00 40 cd  LDQ   #$A60040CD
e445: a8 00           EORA  $0,X
e447: 20 4d           BRA   $E496
e449: b7 00 08        STA   >$0008
e44c: cd aa f0 30 4d  LDQ   #$AAF0304D
e451: b8 f0 08        EORA  $F008
e454: 07 cd           ASR   $CD
e456: ac 18           CMPX  -$8,X
e458: 40              NEGA
e459: cd ae 18 20 4d  LDQ   #$AE18204D
e45e: b9 18 08        ADCA  $1808
e461: cd b0 08 40 cd  LDQ   #$B00840CD
e466: b2 08 20        SBCA  $0820
e469: 4d              TSTA
e46a: ba 08 08        ORA   $0808
e46d: cd b4 f8 30 07  LDQ   #$B4F83007
e472: cd bc 28 30 cd  LDQ   #$BC2830CD
e477: be 18 30        LDX   $1830
e47a: cd c0 18 10 cd  LDQ   #$C01810CD
e47f: c2 08           SBCB  #$08
e481: 40              NEGA
e482: cd c4 08 20 4d  LDQ   #$C408204D
e487: bb 08 08        ADDA  $0808
e48a: cd c6 00 30 07  LDQ   #$C6003007
e48f: 4d              TSTA
e490: d2 28           SBCB  $28
e492: 28 cd           BVC   $E461
e494: c8 18           EORB  #$18
e496: 40              NEGA
e497: cd ca 18 20 4d  LDQ   #$CA18204D
e49c: d1 18           CMPB  $18
e49e: 08 cd           ASL   $CD
e4a0: cc 08 40        LDD   #$0840
e4a3: cd ce 08 20 4d  LDQ   #$CE08204D
e4a8: d0 08           SUBB  $08
e4aa: 08 07           ASL   $07
e4ac: 48              ASLA
e4ad: 78 18 28        ASL   $1828
e4b0: 48              ASLA
e4b1: 79 18 08        ROL   $1808
e4b4: ca 08           ORB   #$08
e4b6: 08 30           ASL   $30
e4b8: c8 7c           EORB  #$7C
e4ba: 08 10           ASL   $10
e4bc: c8 7e           EORB  #$7E
e4be: f8 20 48        EORB  $2048
e4c1: 80 f8           SUBA  #$F8
e4c3: 08 48           ASL   $48
e4c5: 81 e8           CMPA  #$E8
e4c7: 08 04           ASL   $04
e4c9: ca 0a           ORB   #$0A
e4cb: 08 30           ASL   $30
e4cd: c8 8a           EORB  #$8A
e4cf: 08 10           ASL   $10
e4d1: ca 0c           ORB   #$0C
e4d3: f8 30 c8        EORB  $30C8
e4d6: 8e f8 10        LDX   #$F810
e4d9: 06 48           ROR   $48
e4db: 97 08           STA   $08
e4dd: 38              FCB   $38
e4de: c8 90           EORB  #$90
e4e0: 08 10           ASL   $10
e4e2: 4a              DECA
e4e3: 10 f8           FCB   $10,$F8
e4e5: 48              ASLA
e4e6: 48              ASLA
e4e7: 93 f8           SUBD  $F8
e4e9: 38              FCB   $38
e4ea: c8 94           EORB  #$94
e4ec: f8 20 48        EORB  $2048
e4ef: 96 f8           LDA   $F8
e4f1: 08 27           ASL   $27
e4f3: e5 03           BITB  $3,X
e4f5: 8f              FCB   $8F
e4f6: a0 8f           SUBA  ,W
e4f8: a2 8f           SBCA  ,W
e4fa: a4 8f           ANDA  ,W
e4fc: a6 0f           LDA   $F,X
e4fe: a8 09           EORA  $9,X
e500: 67 09           ASR   $9,X
e502: 66 f8 40        ROR   [$40,S]
e505: f8 20 08        EORB  $2008
e508: 50              NEGB
e509: 08 30           ASL   $30
e50b: 08 18           ASL   $18
e50d: f8 08 08        EORB  $0808
e510: 08 27           ASL   $27
e512: e5 03           BITB  $3,X
e514: 8f              FCB   $8F
e515: aa 8f           ORA   ,W
e517: ac 8f           CMPX  ,W
e519: ae 8f           LDX   ,W
e51b: b0 0f a9        SUBA  $0FA9
e51e: 09 71           ROL   $71
e520: 09 70           ROL   $70
e522: 27 e5           BEQ   $E509
e524: 33 8f           LEAU  ,W
e526: aa 8f           ORA   ,W
e528: b2 8f ae        SBCA  $8FAE
e52b: 0f b0           CLR   $B0
e52d: 8f              FCB   $8F
e52e: b4 09 77        ANDA  $0977
e531: 09 76           ROL   $76
e533: f8 40 f8        EORB  $40F8
e536: 20 08           BRA   $E540
e538: 50              NEGB
e539: 08 38           ASL   $38
e53b: 08 20           ASL   $20
e53d: f8 08 08        EORB  $0808
e540: 08 27           ASL   $27
e542: e5 33           BITB  -$D,Y
e544: 8f              FCB   $8F
e545: a0 8f           SUBA  ,W
e547: b6 8f a4        LDA   $8FA4
e54a: 0f a6           CLR   $A6
e54c: 8f              FCB   $8F
e54d: b8 09 7d        EORA  $097D
e550: 09 7c           ROL   $7C
e552: 27 e5           BEQ   $E539
e554: 63 8f           COM   ,W
e556: 86 8f           LDA   #$8F
e558: 88 0f           EORA  #$0F
e55a: 8e 8f 8a        LDX   #$8F8A
e55d: 8f              FCB   $8F
e55e: 8c 09 47        CMPX  #$0947
e561: 09 46           ROL   $46
e563: f8 50 f8        EORB  $50F8
e566: 30 f8 18        LEAX  [$18,S]
e569: 08 40           ASL   $40
e56b: 08 20           ASL   $20
e56d: f8 08 08        EORB  $0808
e570: 08 27           ASL   $27
e572: e5 82           BITB  ,-X
e574: 8f              FCB   $8F
e575: 86 0f           LDA   #$0F
e577: 88 8f           EORA  #$8F
e579: 98 8f           EORA  $8F
e57b: 8a 8f           ORA   #$8F
e57d: 9a 09           ORA   $09
e57f: 57              ASRB
e580: 09 56           ROL   $56
e582: f8 50 f8        EORB  $50F8
e585: 38              FCB   $38
e586: f8 20 08        EORB  $2008
e589: 40              NEGA
e58a: 08 20           ASL   $20
e58c: f8 08 08        EORB  $0808
e58f: 08 27           ASL   $27
e591: e5 63           BITB  $3,S
e593: 8f              FCB   $8F
e594: 90 8f           SUBA  $8F
e596: 92 0f           SBCA  $0F
e598: 8f              FCB   $8F
e599: 8f              FCB   $8F
e59a: 94 8f           ANDA  $8F
e59c: 96 09           LDA   $09
e59e: 51              FCB   $51
e59f: 09 50           ROL   $50
e5a1: 27 e5           BEQ   $E588
e5a3: 82 8f           SBCA  #$8F
e5a5: 90 0f           SUBA  $0F
e5a7: 92 8f           SBCA  $8F
e5a9: 9c 8f           CMPX  $8F
e5ab: 94 8f           ANDA  $8F
e5ad: 9e 09           LDX   $09
e5af: 5d              TSTB
e5b0: 09 5c           ROL   $5C
e5b2: 05 ca 0e        EIM   #$CA;$0E
e5b5: 10 40           NEGD
e5b7: c8 9a           EORB  #$9A
e5b9: 10 20           FCB   $10,$20
e5bb: 48              ASLA
e5bc: a0 10           SUBA  -$10,X
e5be: 08 c8           ASL   $C8
e5c0: 9c 00           CMPX  $00
e5c2: 30 c8 9e        LEAX  -$62,U
e5c5: 00 10           NEG   $10
e5c7: e6 be           LDB   [W,Y]
e5c9: e6 c3           LDB   ,--U
e5cb: e6 ce           LDB   W,U
e5cd: e6 d3           LDB   [,--U]
e5cf: e6 9b           LDB   [D,X]
e5d1: e6 a6           LDB   A,Y
e5d3: e6 ae           LDB   W,Y
e5d5: e6 b3           LDB   [,--Y]
e5d7: e6 de           LDB   [W,U]
e5d9: e6 ef           LDB   ,--W
e5db: e6 fa           LDB   [F,S]
e5dd: e7 0f           STB   $F,X
e5df: e7 18           STB   -$8,X
e5e1: e7 2b           STB   $B,Y
e5e3: e7 34           STB   -$C,Y
e5e5: e7 3d           STB   -$3,Y
e5e7: e7 48           STB   $8,U
e5e9: e7 55           STB   -$B,U
e5eb: e7 5a           STB   -$6,U
e5ed: e7 5f           STB   -$1,U
e5ef: e7 74           STB   -$C,S
e5f1: e7 79           STB   -$7,S
e5f3: e7 7e           STB   -$2,S
e5f5: e7 93           STB   [,--X]
e5f7: e7 98 e7        STB   [-$19,X]
e5fa: ad e7           JSR   E,S
e5fc: c2 e7           SBCB  #$E7
e5fe: c2 e7           SBCB  #$E7
e600: c2 e7           SBCB  #$E7
e602: c2 e7           SBCB  #$E7
e604: c2 e7           SBCB  #$E7
e606: c2 e7           SBCB  #$E7
e608: c2 e7           SBCB  #$E7
e60a: c2 e7           SBCB  #$E7
e60c: c2 e7           SBCB  #$E7
e60e: d5 e7           BITB  $E7
e610: da e7           ORB   $E7
e612: df e7           STU   $E7
e614: ea e7           ORB   E,S
e616: f5 e7 f5        BITB  $E7F5
e619: e7 f5           STB   [B,S]
e61b: e7 f5           STB   [B,S]
e61d: e7 f5           STB   [B,S]
e61f: e7 f5           STB   [B,S]
e621: e8 00           EORB  $0,X
e623: e8 05           EORB  $5,X
e625: e8 12           EORB  -$E,X
e627: e8 23           EORB  $3,Y
e629: e8 38           EORB  -$8,Y
e62b: e8 49           EORB  $9,U
e62d: e8 54           EORB  -$C,U
e62f: e8 5f           EORB  -$1,U
e631: e8 5f           EORB  -$1,U
e633: e8 70           EORB  -$10,S
e635: e8 70           EORB  -$10,S
e637: e8 70           EORB  -$10,S
e639: e8 70           EORB  -$10,S
e63b: e8 70           EORB  -$10,S
e63d: e8 70           EORB  -$10,S
e63f: e8 70           EORB  -$10,S
e641: e8 70           EORB  -$10,S
e643: e8 70           EORB  -$10,S
e645: e8 78           EORB  -$8,S
e647: e8 78           EORB  -$8,S
e649: e8 78           EORB  -$8,S
e64b: e8 78           EORB  -$8,S
e64d: e8 78           EORB  -$8,S
e64f: e8 95           EORB  [B,X]
e651: e8 b2           EORB  Illegal Postbyte
e653: e8 cf           EORB  ,W++
e655: e8 e8 e8        EORB  -$18,S
e658: e8 e8 e8        EORB  -$18,S
e65b: e8 e8 e8        EORB  -$18,S
e65e: e8 e8 e8        EORB  -$18,S
e661: e8 e8 e8        EORB  -$18,S
e664: e8 e8 e8        EORB  -$18,S
e667: e8 e8 e8        EORB  -$18,S
e66a: e8 e8 e8        EORB  -$18,S
e66d: e8 e8 e9        EORB  -$17,S
e670: 09 e9           ROL   $E9
e672: 26 e9           BNE   $E65D
e674: 43              COMA
e675: e9 64           ADCB  $4,S
e677: e9 85           ADCB  B,X
e679: e9 9e           ADCB  [W,X]
e67b: e9 bd e9 d6     ADCB  [$D055,PCR]
e67f: e9 e7           ADCB  E,S
e681: e9 f8 ea        ADCB  [-$16,S]
e684: 09 ea           ROL   $EA
e686: 2a ea           BPL   $E672
e688: 4f              CLRA
e689: ea 68           ORB   $8,S
e68b: ea 81           ORB   ,X++
e68d: ea a0           ORB   ,Y+
e68f: ea bd ea ce     ORB   [$D161,PCR]
e693: ea df eb 00     ORB   [$EB00]
e697: eb 15           ADDB  -$B,X
e699: eb 32           ADDB  -$E,Y
e69b: c4 87           ANDB  #$87
e69d: 00 f8           NEG   $F8
e69f: 30 f8 10        LEAX  [$10,S]
e6a2: 08 30           ASL   $30
e6a4: 08 10           ASL   $10
e6a6: a4 87           ANDA  E,X
e6a8: e6 9e           LDB   [W,X]
e6aa: 00 10           NEG   $10
e6ac: 04 12           LSR   $12
e6ae: e4 87           ANDB  E,X
e6b0: 08 e6           ASL   $E6
e6b2: 9e 24           LDX   $24
e6b4: e6 9e           LDB   [W,X]
e6b6: 87              FCB   $87
e6b7: 08 87           ASL   $87
e6b9: 14              SEXW
e6ba: 87              FCB   $87
e6bb: 0c 87           INC   $87
e6bd: 16 e4 87        LBRA  $CB47
e6c0: 18              FCB   $18
e6c1: e6 9e           LDB   [W,X]
e6c3: 24 e6           BCC   $E6AB
e6c5: 9e 87           LDX   $87
e6c7: 18              FCB   $18
e6c8: 87              FCB   $87
e6c9: 28 87           BVC   $E652
e6cb: 1c 87           ANDCC #$87
e6cd: 2a e4           BPL   $E6B3
e6cf: 87              FCB   $87
e6d0: 20 e6           BRA   $E6B8
e6d2: 9e 24           LDX   $24
e6d4: e6 9e           LDB   [W,X]
e6d6: 87              FCB   $87
e6d7: 20 87           BRA   $E660
e6d9: 2c 87           BGE   $E662
e6db: 24 87           BCC   $E664
e6dd: 2e 04           BGT   $E6E3
e6df: 86 a4           LDA   #$A4
e6e1: f8 30 86        EORB  $3086
e6e4: a6 f8 10        LDA   [$10,S]
e6e7: 06 a3           ROR   $A3
e6e9: 08 28           ASL   $28
e6eb: 86 a8           LDA   #$A8
e6ed: 08 10           ASL   $10
e6ef: c4 86           ANDB  #$86
e6f1: a6 f8 10        LDA   [$10,S]
e6f4: 08 10           ASL   $10
e6f6: f8 30 08        EORB  $3008
e6f9: 30 05           LEAX  $5,X
e6fb: 86 ae           LDA   #$AE
e6fd: e8 20           EORB  $0,Y
e6ff: 86 b0           LDA   #$B0
e701: f8 20 06        EORB  $2006
e704: b4 f8 08        ANDA  $F808
e707: 86 b2           LDA   #$B2
e709: 08 20           ASL   $20
e70b: 06 b5           ROR   $B5
e70d: 08 08           ASL   $08
e70f: c3 86 b6        ADDD  #$86B6
e712: d8 10           EORB  $10
e714: e8 10           EORB  -$10,X
e716: f8 10 24        EORB  $1024
e719: e7 23           STB   $3,Y
e71b: 06 c9           ROR   $C9
e71d: 86 ca           LDA   #$CA
e71f: 86 cc           LDA   #$CC
e721: 86 ce           LDA   #$CE
e723: f8 28 f8        EORB  $28F8
e726: 10 08           FCB   $10,$08
e728: 30 08           LEAX  $8,X
e72a: 10 c3           FCB   $10,$C3
e72c: 86 d0           LDA   #$D0
e72e: 08 10           ASL   $10
e730: 18              FCB   $18
e731: 10 28 10 c3     LBVC  $F7F8
e735: c6 bc           LDB   #$BC
e737: 18              FCB   $18
e738: 08 08           ASL   $08
e73a: 08 f8           ASL   $F8
e73c: 08 24           ASL   $24
e73e: e7 23           STB   $3,Y
e740: 06 c8           ROR   $C8
e742: 86 c2           LDA   #$C2
e744: 86 c4           LDA   #$C4
e746: 86 c6           LDA   #$C6
e748: 03 86           COM   $86
e74a: d6 f8           LDB   $F8
e74c: 10 86 d8 08     LDW   #$D808
e750: 20 06           BRA   $E758
e752: da 08           ORB   $08
e754: 08 e4           ASL   $E4
e756: 86 92           LDA   #$92
e758: e6 9e           LDB   [W,X]
e75a: e4 86           ANDB  A,X
e75c: 9a e6           ORA   $E6
e75e: 9e 05           LDX   $05
e760: 06 71           ROR   $71
e762: f8 28 86        EORB  $2886
e765: 72 f8 10 86     AIM   #$F8,$1086
e769: 74 08 30        LSR   $0830
e76c: 86 76           LDA   #$76
e76e: 08 10           ASL   $10
e770: 86 78           LDA   #$78
e772: 18              FCB   $18
e773: 30 e4           LEAX  ,S
e775: 86 7a           LDA   #$7A
e777: e6 9e           LDB   [W,X]
e779: e4 86           ANDB  A,X
e77b: 82 e6           SBCA  #$E6
e77d: 9e 05           LDX   $05
e77f: 06 a2           ROR   $A2
e781: f8 28 86        EORB  $2886
e784: 8a f8           ORA   #$F8
e786: 10 86 8c 08     LDW   #$8C08
e78a: 30 86           LEAX  A,X
e78c: 8e 08 10        LDX   #$0810
e78f: 86 90           LDA   #$90
e791: 18              FCB   $18
e792: 30 e4           LEAX  ,S
e794: 86 e4           LDA   #$E4
e796: e6 9e           LDB   [W,X]
e798: 05 86 ec        EIM   #$86;$EC
e79b: f8 20 06        EORB  $2006
e79e: f0 f8 08        SUBB  $F808
e7a1: 86 ee           LDA   #$EE
e7a3: 08 20           ASL   $20
e7a5: 06 f1           ROR   $F1
e7a7: 08 08           ASL   $08
e7a9: 06 f9           ROR   $F9
e7ab: 18              FCB   $18
e7ac: 28 05           BVC   $E7B3
e7ae: 86 f2           LDA   #$F2
e7b0: f8 20 06        EORB  $2006
e7b3: f6 f8 08        LDB   $F808
e7b6: 86 f4           LDA   #$F4
e7b8: 08 20           ASL   $20
e7ba: 06 f7           ROR   $F7
e7bc: 08 08           ASL   $08
e7be: 06 f8           ROR   $F8
e7c0: 18              FCB   $18
e7c1: 18              FCB   $18
e7c2: 24 e7           BCC   $E7AB
e7c4: cd 87 76 87 78  LDQ   #$87768778
e7c9: 87              FCB   $87
e7ca: 7a 07 75        DEC   $0775
e7cd: f8 30 f8        EORB  $30F8
e7d0: 10 08           FCB   $10,$08
e7d2: 30 08           LEAX  $8,X
e7d4: 18              FCB   $18
e7d5: e4 87           ANDB  E,X
e7d7: 7c e6 9e        INC   $E69E
e7da: e4 87           ANDB  E,X
e7dc: 84 e6           ANDA  #$E6
e7de: 9e 24           LDX   $24
e7e0: e7 cd 87 8c     STB   $6F70,PCR
e7e4: 87              FCB   $87
e7e5: 8e 87 90        LDX   #$8790
e7e8: 07 92           ASR   $92
e7ea: 24 e7           BCC   $E7D3
e7ec: cd 87 94 87 96  LDQ   #$87948796
e7f1: 87              FCB   $87
e7f2: 98 07           EORA  $07
e7f4: 93 c4           SUBD  $C4
e7f6: c7              FCB   $C7
e7f7: d8 08           EORB  $08
e7f9: 30 08           LEAX  $8,X
e7fb: 10 f8           FCB   $10,$F8
e7fd: 30 f8 10        LEAX  [$10,S]
e800: e4 c7           ANDB  E,U
e802: e0 e7           SUBB  E,S
e804: f8 c5 c7        EORB  $C5C7
e807: e8 18           EORB  -$8,X
e809: 20 08           BRA   $E813
e80b: 30 08           LEAX  $8,X
e80d: 10 f8           FCB   $10,$F8
e80f: 30 f8 10        LEAX  [$10,S]
e812: 04 c7           LSR   $C7
e814: ba 08 30        ORA   $0830
e817: c7              FCB   $C7
e818: 9a 10           ORA   $10
e81a: 10 c7           FCB   $10,$C7
e81c: bc f8 30        CMPX  $F830
e81f: c7              FCB   $C7
e820: 9e 00           LDX   $00
e822: 10 05           FCB   $10,$05
e824: 47              ASRA
e825: a9 10           ADCA  -$10,X
e827: 28 c7           BVC   $E7F0
e829: 9a 10           ORA   $10
e82b: 10 c7           FCB   $10,$C7
e82d: 9c 00           CMPX  $00
e82f: 30 c7           LEAX  E,U
e831: 9e 00           LDX   $00
e833: 10 c7           FCB   $10,$C7
e835: a0 f0           SUBA  [,--W]
e837: 30 04           LEAX  $4,X
e839: c7              FCB   $C7
e83a: a2 08           SBCA  $8,X
e83c: 30 c7           LEAX  E,U
e83e: a4 08           ANDA  $8,X
e840: 10 47           ASRD
e842: a8 f8 28        EORA  [$28,S]
e845: c7              FCB   $C7
e846: a6 f8 10        LDA   [$10,S]
e849: c4 c7           ANDB  #$C7
e84b: aa 10           ORA   -$10,X
e84d: 30 10           LEAX  -$10,X
e84f: 10 00           FCB   $10,$00
e851: 30 00           LEAX  $0,X
e853: 10 c4           FCB   $10,$C4
e855: c7              FCB   $C7
e856: b2 10 30        SBCA  $1030
e859: 10 10           FCB   $10,$10
e85b: 00 30           NEG   $30
e85d: 00 10           NEG   $10
e85f: 04 88           LSR   $88
e861: 22 00           BHI   $E863
e863: 30 88 24        LEAX  $24,X
e866: 00 10           NEG   $10
e868: 88 26           EORA  #$26
e86a: 10 20           FCB   $10,$20
e86c: 08 28           ASL   $28
e86e: 10 08           FCB   $10,$08
e870: f8 10 f8        EORB  $10F8
e873: f8 08 10        EORB  $0810
e876: 08 f8           ASL   $F8
e878: 07 12           ASR   $12
e87a: 7e e8 18        JMP   $E818
e87d: 07 c4           ASR   $C4
e87f: f8 28 87        EORB  $2887
e882: be f8 10        LDX   $F810
e885: 87              FCB   $87
e886: c0 08           SUBB  #$08
e888: 30 87           LEAX  E,X
e88a: c2 08           SBCB  #$08
e88c: 10 1f           FCB   $10,$1F
e88e: f8 f8 18        EORB  $F818
e891: 1f f9           TFR   F,B
e893: 08 18           ASL   $18
e895: 07 07           ASR   $07
e897: c5 f8           BITB  #$F8
e899: 28 87           BVC   $E822
e89b: c6 f8           LDB   #$F8
e89d: 10 87           FCB   $10,$87
e89f: c8 08           EORB  #$08
e8a1: 30 87           LEAX  E,X
e8a3: ca 08           ORB   #$08
e8a5: 10 1f           FCB   $10,$1F
e8a7: fb 0a 18        ADDB  $0A18
e8aa: 1f fa           TFR   F,CC
e8ac: 08 28           ASL   $28
e8ae: 1f fc           TFR   F,0
e8b0: fa 18 07        ORB   $1807
e8b3: 87              FCB   $87
e8b4: cc f8 30        LDD   #$F830
e8b7: 87              FCB   $87
e8b8: ce f8 10        LDU   #$F810
e8bb: 87              FCB   $87
e8bc: d0 08           SUBB  $08
e8be: 30 87           LEAX  E,X
e8c0: d2 08           SBCB  $08
e8c2: 10 12           FCB   $10,$12
e8c4: 9e 18           LDX   $18
e8c6: 28 12           BVC   $E8DA
e8c8: bd 28 28        JSR   $2828
e8cb: 1f fd           TFR   F,0
e8cd: 18              FCB   $18
e8ce: 28 06           BVC   $E8D6
e8d0: 12              NOP
e8d1: 98 e8           EORA  $E8
e8d3: 28 87           BVC   $E85C
e8d5: d4 f8           ANDB  $F8
e8d7: 30 87           LEAX  E,X
e8d9: ce f8 10        LDU   #$F810
e8dc: 87              FCB   $87
e8dd: d6 08           LDB   $08
e8df: 30 87           LEAX  E,X
e8e1: d2 08           SBCB  $08
e8e3: 10 1f           FCB   $10,$1F
e8e5: fe f8 28        LDU   $F828
e8e8: 08 91           ASL   $91
e8ea: 7a f8 20        DEC   $F820
e8ed: 11 87           FCB   $11,$87
e8ef: f8 08 91        EORB  $0891
e8f2: 7c 08 30        INC   $0830
e8f5: 91 7e           CMPA  $7E
e8f7: 08 10           ASL   $10
e8f9: 07 35           ASR   $35
e8fb: 08 28           ASL   $28
e8fd: 87              FCB   $87
e8fe: 30 18           LEAX  -$8,X
e900: 20 87           BRA   $E889
e902: 32 28           LEAS  $8,Y
e904: 20 07           BRA   $E90D
e906: 34 28           PSHS  Y,DP
e908: 08 07           ASL   $07
e90a: 91 80           CMPA  $80
e90c: f8 20 11        EORB  $2011
e90f: 86 f8           LDA   #$F8
e911: 08 91           ASL   $91
e913: 82 08           SBCA  #$08
e915: 30 91           LEAX  [,X++]
e917: 84 08           ANDA  #$08
e919: 10 87           FCB   $10,$87
e91b: 36 18           PSHU  X,DP
e91d: 20 87           BRA   $E8A6
e91f: 38              FCB   $38
e920: 28 20           BVC   $E942
e922: 07 3a           ASR   $3A
e924: 28 08           BVC   $E92E
e926: 07 91           ASR   $91
e928: 88 08           EORA  #$08
e92a: 30 91           LEAX  [,X++]
e92c: 8a 08           ORA   #$08
e92e: 10 91 8c        CMPW  $8C
e931: 18              FCB   $18
e932: 30 11           LEAX  -$F,X
e934: 93 18           SUBD  $18
e936: 18              FCB   $18
e937: 07 3b           ASR   $3B
e939: 18              FCB   $18
e93a: 28 87           BVC   $E8C3
e93c: 3c 28           CWAI  #$28
e93e: 20 07           BRA   $E947
e940: 3e              FCB   $3E
e941: 28 08           BVC   $E94B
e943: 08 91           ASL   $91
e945: 9c 00           CMPX  $00
e947: 30 91           LEAX  [,X++]
e949: 9e 00           LDX   $00
e94b: 10 91 a0        CMPW  $A0
e94e: 10 20           FCB   $10,$20
e950: 11 a2           FCB   $11,$A2
e952: 10 08           FCB   $10,$08
e954: 87              FCB   $87
e955: 40              NEGA
e956: 08 30           ASL   $30
e958: 87              FCB   $87
e959: 42              FCB   $42
e95a: 08 10           ASL   $10
e95c: 07 3f           ASR   $3F
e95e: 18              FCB   $18
e95f: 28 87           BVC   $E8E8
e961: 44              LSRA
e962: 18              FCB   $18
e963: 10 08           FCB   $10,$08
e965: 91 a4           CMPA  $A4
e967: eb 20           ADDB  $0,Y
e969: 91 a6           CMPA  $A6
e96b: fb 20 11        ADDB  $2011
e96e: ac fb           CMPX  [D,S]
e970: 08 91           ASL   $91
e972: a8 0b           EORA  $B,X
e974: 20 91           BRA   $E907
e976: aa 1b           ORA   -$5,X
e978: 20 87           BRA   $E901
e97a: 46              RORA
e97b: ec 2f           LDD   $F,Y
e97d: 87              FCB   $87
e97e: 48              ASLA
e97f: fc 2f 87        LDD   $2F87
e982: 4a              DECA
e983: 0c 2f           INC   $2F
e985: 06 c7           ROR   $C7
e987: 4c              INCA
e988: 10 30 c7        ADDR  0,V
e98b: 4e              FCB   $4E
e98c: 10 10           FCB   $10,$10
e98e: c7              FCB   $C7
e98f: 50              NEGB
e990: 00 20           NEG   $20
e992: 51              FCB   $51
e993: e3 10           ADDD  -$10,X
e995: 28 d1           BVC   $E968
e997: ca 00           ORB   #$00
e999: 30 d1           LEAX  [,U++]
e99b: cc 00 10        LDD   #$0010
e99e: 27 e9           BEQ   $E989
e9a0: af 51           STX   -$F,U
e9a2: e2 d1           SBCB  [,U++]
e9a4: de d1           LDU   $D1
e9a6: e0 c7           SUBB  E,U
e9a8: 5e              FCB   $5E
e9a9: c7              FCB   $C7
e9aa: 60 c7           NEG   E,U
e9ac: 62 c7 64        AIM   #$C7;$4,S
e9af: 10 28 00 30     LBVC  $E9E3
e9b3: 00 10           NEG   $10
e9b5: 10 30 10        ADDR  X,D
e9b8: 10 00           FCB   $10,$00
e9ba: 30 00           LEAX  $0,X
e9bc: 10 06           FCB   $10,$06
e9be: 47              ASRA
e9bf: 6a 10           DEC   -$10,X
e9c1: 28 c7           BVC   $E98A
e9c3: 52              FCB   $52
e9c4: 00 30           NEG   $30
e9c6: c7              FCB   $C7
e9c7: 54              LSRB
e9c8: 00 10           NEG   $10
e9ca: d1 c4           CMPB  $C4
e9cc: 10 30 d1        ADDR  0,X
e9cf: c6 10           LDB   #$10
e9d1: 10 d1           FCB   $10,$D1
e9d3: c8 00           EORB  #$00
e9d5: 20 27           BRA   $E9FE
e9d7: e9 af 47 6b     ADCB  $476B,W
e9db: c7              FCB   $C7
e9dc: 66 c7           ROR   E,U
e9de: 68 d1           ASL   [,U++]
e9e0: d6 d1           LDB   $D1
e9e2: d8 d1           EORB  $D1
e9e4: da d1           ORB   $D1
e9e6: dc 27           LDD   $27
e9e8: e9 af 51 e2     ADCB  $51E2,W
e9ec: d1 de           CMPB  $DE
e9ee: d1 e0           CMPB  $E0
e9f0: c7              FCB   $C7
e9f1: 56              RORB
e9f2: c7              FCB   $C7
e9f3: 60 c7           NEG   E,U
e9f5: 58              ASLB
e9f6: c7              FCB   $C7
e9f7: 64 27           LSR   $7,Y
e9f9: e9 af 51 e2     ADCB  $51E2,W
e9fd: d1 de           CMPB  $DE
e9ff: d1 e0           CMPB  $E0
ea01: c7              FCB   $C7
ea02: 5a              DECB
ea03: c7              FCB   $C7
ea04: 60 c7           NEG   E,U
ea06: 5c              INCB
ea07: c7              FCB   $C7
ea08: 64 08           LSR   $8,X
ea0a: 51              FCB   $51
ea0b: e2 10           SBCB  -$10,X
ea0d: 28 d1           BVC   $E9E0
ea0f: de 00           LDU   $00
ea11: 30 d1           LEAX  [,U++]
ea13: e0 00           SUBB  $0,X
ea15: 10 47           ASRD
ea17: 74 20 18        LSR   $2018
ea1a: c7              FCB   $C7
ea1b: 6c 10           INC   -$10,X
ea1d: 30 c7           LEAX  E,U
ea1f: 6e 10           JMP   -$10,X
ea21: 10 c7           FCB   $10,$C7
ea23: 70 00 30        NEG   >$0030
ea26: c7              FCB   $C7
ea27: 72 00 10 09     AIM   #$00,$1009
ea2b: 47              ASRA
ea2c: 6b 10 28        TIM   #$10;$8,Y
ea2f: c7              FCB   $C7
ea30: 66 00           ROR   $0,X
ea32: 30 c7           LEAX  E,U
ea34: 68 00           ASL   $0,X
ea36: 10 d2           FCB   $10,$D2
ea38: 5c              INCB
ea39: 10 40           NEGD
ea3b: 52              FCB   $52
ea3c: 61 10 28        OIM   #$10;$8,Y
ea3f: d1 d8           CMPB  $D8
ea41: 10 10           FCB   $10,$10
ea43: d2 5e           SBCB  $5E
ea45: 00 40           NEG   $40
ea47: 52              FCB   $52
ea48: 60 00           NEG   $0,X
ea4a: 28 d1           BVC   $EA1D
ea4c: dc 00           LDD   $00
ea4e: 10 06           FCB   $10,$06
ea50: 46              RORA
ea51: db 10           ADDB  $10
ea53: 18              FCB   $18
ea54: c6 dc           LDB   #$DC
ea56: 00 30           NEG   $30
ea58: c6 de           LDB   #$DE
ea5a: 00 10           NEG   $10
ea5c: d2 62           SBCB  $62
ea5e: 10 30 d2        ADDR  0,Y
ea61: 66 00           ROR   $0,X
ea63: 30 d2           LEAX  Illegal Postbyte
ea65: 64 08           LSR   $8,X
ea67: 10 06           FCB   $10,$06
ea69: c6 e0           LDB   #$E0
ea6b: 00 30           NEG   $30
ea6d: c6 e2           LDB   #$E2
ea6f: 00 10           NEG   $10
ea71: d2 68           SBCB  $68
ea73: 10 20           FCB   $10,$20
ea75: 52              FCB   $52
ea76: 6d 10           TST   -$10,X
ea78: 08 d2           ASL   $D2
ea7a: 6a 00           DEC   $0,X
ea7c: 20 52           BRA   $EAD0
ea7e: 6c 00           INC   $0,X
ea80: 08 27           ASL   $27
ea82: ea 92           ORB   Illegal Postbyte
ea84: 47              ASRA
ea85: 6b c7 66        TIM   #$C7;$6,S
ea88: c7              FCB   $C7
ea89: 68 d1           ASL   [,U++]
ea8b: e4 d1           ANDB  [,U++]
ea8d: e8 d1           EORB  [,U++]
ea8f: e6 d1           LDB   [,U++]
ea91: ea 10           ORB   -$10,X
ea93: 28 00           BVC   $EA95
ea95: 30 00           LEAX  $0,X
ea97: 10 10           FCB   $10,$10
ea99: 30 00           LEAX  $0,X
ea9b: 30 10           LEAX  -$10,X
ea9d: 10 00           FCB   $10,$00
ea9f: 10 07           FCB   $10,$07
eaa1: 47              ASRA
eaa2: 6b 10 28        TIM   #$10;$8,Y
eaa5: c7              FCB   $C7
eaa6: 66 00           ROR   $0,X
eaa8: 30 c7           LEAX  E,U
eaaa: 68 00           ASL   $0,X
eaac: 10 d1           FCB   $10,$D1
eaae: d6 10           LDB   $10
eab0: 30 d1           LEAX  [,U++]
eab2: da 00           ORB   $00
eab4: 30 d1           LEAX  [,U++]
eab6: ec 1a           LDD   -$6,X
eab8: 20 d1           BRA   $EA8B
eaba: ee 0a           LDU   $A,X
eabc: 10 27 ea 92     LBEQ  $D552
eac0: 47              ASRA
eac1: 6b c7 66        TIM   #$C7;$6,S
eac4: c7              FCB   $C7
eac5: 68 d1           ASL   [,U++]
eac7: ce d1 d0        LDU   #$D1D0
eaca: d1 d8           CMPB  $D8
eacc: d1 dc           CMPB  $DC
eace: 27 ea           BEQ   $EABA
ead0: 92 47           SBCA  $47
ead2: 6b c7 66        TIM   #$C7;$6,S
ead5: c7              FCB   $C7
ead6: 68 d1           ASL   [,U++]
ead8: d2 d1           SBCB  $D1
eada: d4 d1           ANDB  $D1
eadc: d8 d1           EORB  $D1
eade: dc 08           LDD   $08
eae0: 47              ASRA
eae1: 6b 10 28        TIM   #$10;$8,Y
eae4: c7              FCB   $C7
eae5: 66 00           ROR   $0,X
eae7: 30 c7           LEAX  E,U
eae9: 68 00           ASL   $0,X
eaeb: 10 51           FCB   $10,$51
eaed: c3 20 18        ADDD  #$2018
eaf0: d1 f0           CMPB  $F0
eaf2: 10 30 d1        ADDR  0,X
eaf5: f2 10 10        SBCB  $1010
eaf8: d1 f4           CMPB  $F4
eafa: 00 30           NEG   $30
eafc: d1 f6           CMPB  $F6
eafe: 00 10           NEG   $10
eb00: 05 03 ed        EIM   #$03;$ED
eb03: f8 20 83        EORB  $2083
eb06: ee f8 08        LDU   [$08,S]
eb09: 83 f0 08        SUBD  #$F008
eb0c: 18              FCB   $18
eb0d: 83 f2 08        SUBD  #$F208
eb10: f8 03 f4        EORB  $03F4
eb13: 08 e0           ASL   $E0
eb15: 07 c6           ASR   $C6
eb17: c4 18           ANDB  #$18
eb19: 30 c6           LEAX  A,U
eb1b: c6 18           LDB   #$18
eb1d: 10 46           RORD
eb1f: c8 28           EORB  #$28
eb21: 28 c6           BVC   $EAE9
eb23: c2 28           SBCB  #$28
eb25: 10 9b 28        ADDW  $28
eb28: 08 30           ASL   $30
eb2a: 9b 2a           ADDA  $2A
eb2c: 08 10           ASL   $10
eb2e: 9b 2c           ADDA  $2C
eb30: 18              FCB   $18
eb31: 30 09           LEAX  $9,X
eb33: c6 c4           LDB   #$C4
eb35: 18              FCB   $18
eb36: 30 c6           LEAX  A,U
eb38: c6 18           LDB   #$18
eb3a: 10 46           RORD
eb3c: c8 28           EORB  #$28
eb3e: 28 c6           BVC   $EB06
eb40: c2 28           SBCB  #$28
eb42: 10 9b 2e        ADDW  $2E
eb45: f8 20 1b        EORB  $201B
eb48: 36 f8           PSHU  PC,S,Y,X,DP
eb4a: 08 9b           ASL   $9B
eb4c: 30 08           LEAX  $8,X
eb4e: 30 9b           LEAX  [D,X]
eb50: 32 08           LEAS  $8,X
eb52: 10 9b 34        ADDW  $34
eb55: 18              FCB   $18
eb56: 30 ec 51        LEAX  $EBAA,PCR
eb59: ec 56           LDD   -$A,U
eb5b: ec 5b           LDD   -$5,U
eb5d: ec 66           LDD   $6,S
eb5f: ec 2b           LDD   $B,Y
eb61: ec 36           LDD   -$A,Y
eb63: ec 41           LDD   $1,U
eb65: ec 46           LDD   $6,U
eb67: ec 71           LDD   -$F,S
eb69: ec 76           LDD   -$A,S
eb6b: ec 87           LDD   E,X
eb6d: ec 9c ec        LDD   [$EB5C,PCR]
eb70: a5 ec b8        BITA  $EB2B,PCR
eb73: ec c1           LDD   ,U++
eb75: ec ca           LDD   F,U
eb77: ec d5           LDD   [B,U]
eb79: ec e2           LDD   ,-S
eb7b: ec ed ec f2     LDD   $D871,PCR
eb7f: ed 09           STD   $9,X
eb81: ed 0e           STD   $E,X
eb83: ed 13           STD   -$D,X
eb85: ed 20           STD   $0,Y
eb87: ed 25           STD   $5,Y
eb89: ed 3a           STD   -$6,Y
eb8b: ed 4f           STD   $F,U
eb8d: ed 4f           STD   $F,U
eb8f: ed 4f           STD   $F,U
eb91: ed 4f           STD   $F,U
eb93: ed 4f           STD   $F,U
eb95: ed 4f           STD   $F,U
eb97: ed 4f           STD   $F,U
eb99: ed 4f           STD   $F,U
eb9b: ed 4f           STD   $F,U
eb9d: ed 5a           STD   -$6,U
eb9f: ed 5f           STD   -$1,U
eba1: ed 64           STD   $4,S
eba3: ed 69           STD   $9,S
eba5: ed 6e           STD   $E,S
eba7: ed 6e           STD   $E,S
eba9: ed 6e           STD   $E,S
ebab: ed 6e           STD   $E,S
ebad: ed 6e           STD   $E,S
ebaf: ed 6e           STD   $E,S
ebb1: ed 6e           STD   $E,S
ebb3: ed 6e           STD   $E,S
ebb5: ed 6e           STD   $E,S
ebb7: ed 7c           STD   -$4,S
ebb9: ed 91           STD   [,X++]
ebbb: ed 9c ed        STD   [$EBAB,PCR]
ebbe: a7 ed ac ed     STA   $98AF,PCR
ebc2: ac ed b7 ed     CMPX  $A3B3,PCR
ebc6: b7 ed b7        STA   $EDB7
ebc9: ed b7           STD   [E,Y]
ebcb: ed b7           STD   [E,Y]
ebcd: ed b7           STD   [E,Y]
ebcf: ed b7           STD   [E,Y]
ebd1: ed b7           STD   [E,Y]
ebd3: ed b7           STD   [E,Y]
ebd5: ed bf ed bf     STD   [$EDBF]
ebd9: ed c7           STD   E,U
ebdb: ed c7           STD   E,U
ebdd: ed c7           STD   E,U
ebdf: ed e4           STD   ,S
ebe1: ee 01           LDU   $1,X
ebe3: ee 1e           LDU   -$2,X
ebe5: ee 37           LDU   -$9,Y
ebe7: ee 48           LDU   $8,U
ebe9: ee 59           LDU   -$7,U
ebeb: ee 62           LDU   $2,S
ebed: ee 79           LDU   -$7,S
ebef: ee 86           LDU   A,X
ebf1: ee 93           LDU   [,--X]
ebf3: ee a0           LDU   ,Y+
ebf5: ee b7           LDU   [E,Y]
ebf7: ee c4           LDU   ,U
ebf9: ee d1           LDU   [,U++]
ebfb: ee de           LDU   [W,U]
ebfd: ee ef           LDU   ,--W
ebff: ef 10           STU   -$10,X
ec01: ef 2d           STU   $D,Y
ec03: ef 4a           STU   $A,U
ec05: ef 6b           STU   $B,S
ec07: ef 8c ef        STU   $EBF9,PCR
ec0a: a9 ef           ADCA  ,--W
ec0c: c6 ef           LDB   #$EF
ec0e: df ef           STU   $EF
ec10: fe f0 0f        LDU   $F00F
ec13: f0 20 f0        SUBB  $20F0
ec16: 41              FCB   $41
ec17: f0 66 f0        SUBB  $66F0
ec1a: 7f f0 98        CLR   $F098
ec1d: f0 b7 f0        SUBB  $B7F0
ec20: d4 f0           ANDB  $F0
ec22: e5 f0           BITB  [,--W]
ec24: f6 f1 17        LDB   $F117
ec27: f1 17 f1        CMPB  $17F1
ec2a: 34 c4           PSHS  PC,U,B
ec2c: 85 ba           BITA  #$BA
ec2e: f8 30 f8        EORB  $30F8
ec31: 10 08           FCB   $10,$08
ec33: 30 08           LEAX  $8,X
ec35: 10 24 ec 2e     LBCC  $D867
ec39: 85 ba           BITA  #$BA
ec3b: 85 c2           BITA  #$C2
ec3d: 85 be           BITA  #$BE
ec3f: 85 c4           BITA  #$C4
ec41: e4 85           ANDB  B,X
ec43: d2 ec           SBCB  $EC
ec45: 2e 24           BGT   $EC6B
ec47: ec 2e           LDD   $E,Y
ec49: 85 d2           BITA  #$D2
ec4b: 85 da           BITA  #$DA
ec4d: 85 d6           BITA  #$D6
ec4f: 85 dc           BITA  #$DC
ec51: e4 85           ANDB  B,X
ec53: c6 ec           LDB   #$EC
ec55: 2e e4           BGT   $EC3B
ec57: 85 de           BITA  #$DE
ec59: ec 2e           LDD   $E,Y
ec5b: 24 ec           BCC   $EC49
ec5d: 2e 85           BGT   $EBE4
ec5f: de 85           LDU   $85
ec61: e6 85           LDB   B,X
ec63: e2 85           SBCB  B,X
ec65: e8 24           EORB  $4,Y
ec67: ec 2e           LDD   $E,Y
ec69: 85 c6           BITA  #$C6
ec6b: 85 ce           BITA  #$CE
ec6d: 85 ca           BITA  #$CA
ec6f: 85 d0           BITA  #$D0
ec71: e4 84           ANDB  ,X
ec73: 78 ec 2e        ASL   $EC2E
ec76: 04 84           LSR   $84
ec78: 80 f8           SUBA  #$F8
ec7a: 30 84           LEAX  ,X
ec7c: 82 08           SBCA  #$08
ec7e: 30 84           LEAX  ,X
ec80: 7a f8 10        DEC   $F810
ec83: 84 7e           ANDA  #$7E
ec85: 08 10           ASL   $10
ec87: 05 84 84        EIM   #$84;$84
ec8a: e8 20           EORB  $0,Y
ec8c: 84 86           ANDA  #$86
ec8e: f8 20 04        EORB  $2004
ec91: 8a f8           ORA   #$F8
ec93: 08 84           ASL   $84
ec95: 88 08           EORA  #$08
ec97: 20 04           BRA   $EC9D
ec99: 8b 08           ADDA  #$08
ec9b: 08 c3           ASL   $C3
ec9d: 84 92           ANDA  #$92
ec9f: d8 10           EORB  $10
eca1: e8 10           EORB  -$10,X
eca3: f8 10 24        EORB  $1024
eca6: ec b0 04 a4     LDD   [$04A4,W]
ecaa: 84 9e           ANDA  #$9E
ecac: 84 a0           ANDA  #$A0
ecae: 84 a2           ANDA  #$A2
ecb0: f8 28 f8        EORB  $28F8
ecb3: 10 08           FCB   $10,$08
ecb5: 30 08           LEAX  $8,X
ecb7: 10 c3           FCB   $10,$C3
ecb9: 84 a6           ANDA  #$A6
ecbb: 08 10           ASL   $10
ecbd: 18              FCB   $18
ecbe: 10 28 10 c3     LBVC  $FD85
ecc2: c4 98           ANDB  #$98
ecc4: 18              FCB   $18
ecc5: 08 08           ASL   $08
ecc7: 08 f8           ASL   $F8
ecc9: 08 24           ASL   $24
eccb: ec b0 04 b0     LDD   [$04B0,W]
eccf: 84 8c           ANDA  #$8C
ecd1: 84 8e           ANDA  #$8E
ecd3: 84 90           ANDA  #$90
ecd5: 03 84           COM   $84
ecd7: ac f8 10        CMPX  [$10,S]
ecda: 04 a5           LSR   $A5
ecdc: 08 28           ASL   $28
ecde: 84 ae           ANDA  #$AE
ece0: 08 10           ASL   $10
ece2: c4 84           ANDB  #$84
ece4: 3e              FCB   $3E
ece5: f8 30 08        EORB  $3008
ece8: 30 f8 10        LEAX  [$10,S]
eceb: 08 10           ASL   $10
eced: e4 84           ANDB  ,X
ecef: 46              RORA
ecf0: ec e5           LDD   B,S
ecf2: 25 ec           BCS   $ECE0
ecf4: ff 04 34        STU   $0434
ecf7: 84 1c           ANDA  #$1C
ecf9: 84 1e           ANDA  #$1E
ecfb: 84 20           ANDA  #$20
ecfd: 84 22           ANDA  #$22
ecff: f8 28 f8        EORB  $28F8
ed02: 10 08           FCB   $10,$08
ed04: 30 08           LEAX  $8,X
ed06: 10 18           FCB   $10,$18
ed08: 30 e4           LEAX  ,S
ed0a: 84 24           ANDA  #$24
ed0c: ec e5           LDD   B,S
ed0e: e4 84           ANDB  ,X
ed10: 2c ec           BGE   $ECFE
ed12: e5 25           BITB  $5,Y
ed14: ec ff 04 35     LDD   [$0435]
ed18: 84 36           ANDA  #$36
ed1a: 84 38           ANDA  #$38
ed1c: 84 3a           ANDA  #$3A
ed1e: 84 3c           ANDA  #$3C
ed20: e4 84           ANDB  ,X
ed22: b2 ec 2e        SBCA  $EC2E
ed25: 05 84 ba        EIM   #$84;$BA
ed28: f8 20 04        EORB  $2004
ed2b: be f8 08        LDX   $F808
ed2e: 84 bc           ANDA  #$BC
ed30: 08 20           ASL   $20
ed32: 04 bf           LSR   $BF
ed34: 08 08           ASL   $08
ed36: 09 96           ROL   $96
ed38: 18              FCB   $18
ed39: 28 05           BVC   $ED40
ed3b: 84 c0           ANDA  #$C0
ed3d: f8 20 04        EORB  $2004
ed40: c4 f8           ANDB  #$F8
ed42: 08 84           ASL   $84
ed44: c2 08           SBCB  #$08
ed46: 20 04           BRA   $ED4C
ed48: c5 08           BITB  #$08
ed4a: 08 04           ASL   $04
ed4c: b1 18 18        CMPA  $1818
ed4f: c4 86           ANDB  #$86
ed51: 00 f8           NEG   $F8
ed53: 30 f8 10        LEAX  [$10,S]
ed56: 08 30           ASL   $30
ed58: 08 10           ASL   $10
ed5a: e4 86           ANDB  A,X
ed5c: 08 ed           ASL   $ED
ed5e: 52              FCB   $52
ed5f: e4 86           ANDB  A,X
ed61: 18              FCB   $18
ed62: ed 52           STD   -$E,U
ed64: e4 86           ANDB  A,X
ed66: 20 ed           BRA   $ED55
ed68: 52              FCB   $52
ed69: e4 86           ANDB  A,X
ed6b: 10 ed 52        STQ   -$E,U
ed6e: 84 c5           ANDA  #$C5
ed70: b6 00 30        LDA   >$0030
ed73: 96 08           LDA   $08
ed75: 10 b8 f0 30     EORD  $F030
ed79: 9a f8           ORA   $F8
ed7b: 10 05           FCB   $10,$05
ed7d: 45              FCB   $45
ed7e: 95 08           BITA  $08
ed80: 28 c5           BVC   $ED47
ed82: 96 08           LDA   $08
ed84: 10 c5           FCB   $10,$C5
ed86: 98 f8           EORA  $F8
ed88: 30 c5           LEAX  B,U
ed8a: 9a f8           ORA   $F8
ed8c: 10 c5           FCB   $10,$C5
ed8e: 9c e8           CMPX  $E8
ed90: 30 c4           LEAX  ,U
ed92: c5 9e           BITB  #$9E
ed94: 00 30           NEG   $30
ed96: 00 10           NEG   $10
ed98: f0 30 f0        SUBB  $30F0
ed9b: 10 c4           FCB   $10,$C4
ed9d: c5 a6           BITB  #$A6
ed9f: 08 30           ASL   $30
eda1: 08 10           ASL   $10
eda3: f8 30 f8        EORB  $30F8
eda6: 10 e4           FCB   $10,$E4
eda8: c5 ae           BITB  #$AE
edaa: ed 9f c4 81     STD   [$C481]
edae: f8 f8 30        EORB  $F830
edb1: f8 10 08        EORB  $1008
edb4: 30 08           LEAX  $8,X
edb6: 10 f8           FCB   $10,$F8
edb8: 10 f8           FCB   $10,$F8
edba: f8 08 18        EORB  $0818
edbd: 08 00           ASL   $00
edbf: f8 18 f8        EORB  $18F8
edc2: 00 08           NEG   $08
edc4: 18              FCB   $18
edc5: 08 00           ASL   $00
edc7: 07 06           ASR   $06
edc9: 2e f8           BGT   $EDC3
edcb: 1c 12           ANDCC #$12
edcd: 7e e8 18        JMP   $E818
edd0: 86 28           LDA   #$28
edd2: f8 10 86        EORB  $1086
edd5: 2a 08           BPL   $EDDF
edd7: 30 86           LEAX  A,X
edd9: 2c 08           BGE   $EDE3
eddb: 10 1f           FCB   $10,$1F
eddd: f8 f8 18        EORB  $F818
ede0: 1f f9           TFR   F,B
ede2: 08 18           ASL   $18
ede4: 07 06           ASR   $06
ede6: 42              FCB   $42
ede7: f8 28 86        EORB  $2886
edea: 30 f8 10        LEAX  [$10,S]
eded: 86 32           LDA   #$32
edef: 08 30           ASL   $30
edf1: 86 34           LDA   #$34
edf3: 08 10           ASL   $10
edf5: 1f fb           TFR   F,DP
edf7: 0a 18           DEC   $18
edf9: 1f fa           TFR   F,CC
edfb: 08 28           ASL   $28
edfd: 1f fc           TFR   F,0
edff: fa 18 07        ORB   $1807
ee02: 86 36           LDA   #$36
ee04: f8 30 86        EORB  $3086
ee07: 38              FCB   $38
ee08: f8 10 86        EORB  $1086
ee0b: 3a              ABX
ee0c: 08 30           ASL   $30
ee0e: 86 3c           LDA   #$3C
ee10: 08 10           ASL   $10
ee12: 06 4a           ROR   $4A
ee14: 18              FCB   $18
ee15: 28 12           BVC   $EE29
ee17: bd 28 28        JSR   $2828
ee1a: 1f fd           TFR   F,0
ee1c: 18              FCB   $18
ee1d: 28 06           BVC   $EE25
ee1f: 86 3e           LDA   #$3E
ee21: f8 30 86        EORB  $3086
ee24: 40              NEGA
ee25: 08 30           ASL   $30
ee27: 86 38           LDA   #$38
ee29: f8 10 86        EORB  $1086
ee2c: 3c 08           CWAI  #$08
ee2e: 10 12           FCB   $10,$12
ee30: 98 e8           EORA  $E8
ee32: 28 1f           BVC   $EE53
ee34: fe f8 28        LDU   $F828
ee37: 04 86           LSR   $86
ee39: 4e              FCB   $4E
ee3a: f8 10 06        EORB  $1006
ee3d: 4d              TSTA
ee3e: 08 28           ASL   $28
ee40: 86 50           LDA   #$50
ee42: 08 10           ASL   $10
ee44: 06 70           ROR   $70
ee46: 18              FCB   $18
ee47: 18              FCB   $18
ee48: 04 06           LSR   $06
ee4a: 4c              INCA
ee4b: f8 28 86        EORB  $2886
ee4e: 44              LSRA
ee4f: f8 10 86        EORB  $1086
ee52: 46              RORA
ee53: 08 30           ASL   $30
ee55: 86 48           LDA   #$48
ee57: 08 10           ASL   $10
ee59: 02 86 52        AIM   #$86;$52
ee5c: 00 30           NEG   $30
ee5e: 86 54           LDA   #$54
ee60: 00 10           NEG   $10
ee62: 25 ee           BCS   $EE52
ee64: 6f 86           CLR   A,X
ee66: 66 06           ROR   $6,X
ee68: 6a 86           DEC   A,X
ee6a: 68 85           ASL   B,X
ee6c: c8 85           EORB  #$85
ee6e: cc f8 30        LDD   #$F830
ee71: 08 48           ASL   $48
ee73: 08 30           ASL   $30
ee75: f8 10 08        EORB  $1008
ee78: 10 25 ee 6f     LBCS  $DCEB
ee7c: 86 6c           LDA   #$6C
ee7e: 06 6b           ROR   $6B
ee80: 86 6e           LDA   #$6E
ee82: 85 e0           BITA  #$E0
ee84: 85 e4           BITA  #$E4
ee86: 25 ee           BCS   $EE76
ee88: 6f 86           CLR   A,X
ee8a: 66 06           ROR   $6,X
ee8c: 6a 86           DEC   A,X
ee8e: 68 85           ASL   B,X
ee90: e6 85           LDB   B,X
ee92: e8 25           EORB  $5,Y
ee94: ee 6f           LDU   $F,S
ee96: 86 6c           LDA   #$6C
ee98: 06 6b           ROR   $6B
ee9a: 86 6e           LDA   #$6E
ee9c: 85 ce           BITA  #$CE
ee9e: 85 d0           BITA  #$D0
eea0: 25 ee           BCS   $EE90
eea2: ad 06           JSR   $6,X
eea4: 5a              DECB
eea5: 86 56           LDA   #$56
eea7: 86 58           LDA   #$58
eea9: 85 bc           BITA  #$BC
eeab: 85 c0           BITA  #$C0
eead: f8 48 f8        EORB  $48F8
eeb0: 30 08           LEAX  $8,X
eeb2: 30 f8 10        LEAX  [$10,S]
eeb5: 08 10           ASL   $10
eeb7: 25 ee           BCS   $EEA7
eeb9: ad 06           JSR   $6,X
eebb: 5b              FCB   $5B
eebc: 86 5c           LDA   #$5C
eebe: 86 5e           LDA   #$5E
eec0: 85 c2           BITA  #$C2
eec2: 85 c4           BITA  #$C4
eec4: 25 ee           BCS   $EEB4
eec6: ad 06           JSR   $6,X
eec8: 5a              DECB
eec9: 86 56           LDA   #$56
eecb: 86 58           LDA   #$58
eecd: 85 d4           BITA  #$D4
eecf: 85 d8           BITA  #$D8
eed1: 25 ee           BCS   $EEC1
eed3: ad 06           JSR   $6,X
eed5: 5b              FCB   $5B
eed6: 86 5c           LDA   #$5C
eed8: 86 5e           LDA   #$5E
eeda: 85 da           BITA  #$DA
eedc: 85 dc           BITA  #$DC
eede: 04 06           LSR   $06
eee0: 62 00 28        AIM   #$00;$8,Y
eee3: 86 60           LDA   #$60
eee5: 00 10           NEG   $10
eee7: 86 64           LDA   #$64
eee9: 10 30 06        ADDR  D,W
eeec: 63 10           COM   -$10,X
eeee: 18              FCB   $18
eeef: 08 91           ASL   $91
eef1: 7a f8 20        DEC   $F820
eef4: 11 87           FCB   $11,$87
eef6: f8 08 91        EORB  $0891
eef9: 7c 08 30        INC   $0830
eefc: 91 7e           CMPA  $7E
eefe: 08 10           ASL   $10
ef00: 04 ff           LSR   $FF
ef02: 08 28           ASL   $28
ef04: 84 00           ANDA  #$00
ef06: 18              FCB   $18
ef07: 20 84           BRA   $EE8D
ef09: 02 28 20        AIM   #$28;$20
ef0c: 04 08           LSR   $08
ef0e: 28 08           BVC   $EF18
ef10: 07 91           ASR   $91
ef12: 80 f8           SUBA  #$F8
ef14: 20 11           BRA   $EF27
ef16: 86 f8           LDA   #$F8
ef18: 08 91           ASL   $91
ef1a: 82 08           SBCA  #$08
ef1c: 30 91           LEAX  [,X++]
ef1e: 84 08           ANDA  #$08
ef20: 10 84 04 18     ANDD  #$0418
ef24: 20 84           BRA   $EEAA
ef26: 06 28           ROR   $28
ef28: 20 04           BRA   $EF2E
ef2a: 09 28           ROL   $28
ef2c: 08 07           ASL   $07
ef2e: 91 88           CMPA  $88
ef30: 08 30           ASL   $30
ef32: 91 8a           CMPA  $8A
ef34: 08 10           ASL   $10
ef36: 91 8c           CMPA  $8C
ef38: 18              FCB   $18
ef39: 30 11           LEAX  -$F,X
ef3b: 93 18           SUBD  $18
ef3d: 18              FCB   $18
ef3e: 04 0a           LSR   $0A
ef40: 18              FCB   $18
ef41: 28 04           BVC   $EF47
ef43: 0b 28 28        TIM   #$28;$28
ef46: 84 0c           ANDA  #$0C
ef48: 28 10           BVC   $EF5A
ef4a: 08 91           ASL   $91
ef4c: 9c 00           CMPX  $00
ef4e: 30 91           LEAX  [,X++]
ef50: 9e 00           LDX   $00
ef52: 10 91 a0        CMPW  $A0
ef55: 10 20           FCB   $10,$20
ef57: 11 a2           FCB   $11,$A2
ef59: 10 08           FCB   $10,$08
ef5b: 84 0e           ANDA  #$0E
ef5d: 08 30           ASL   $30
ef5f: 84 12           ANDA  #$12
ef61: 08 10           ASL   $10
ef63: 84 10           ANDA  #$10
ef65: 18              FCB   $18
ef66: 30 84           LEAX  ,X
ef68: 14              SEXW
ef69: 18              FCB   $18
ef6a: 10 08           FCB   $10,$08
ef6c: 91 a4           CMPA  $A4
ef6e: eb 20           ADDB  $0,Y
ef70: 91 a6           CMPA  $A6
ef72: fb 20 11        ADDB  $2011
ef75: ac fb           CMPX  [D,S]
ef77: 08 91           ASL   $91
ef79: a8 0b           EORA  $B,X
ef7b: 20 91           BRA   $EF0E
ef7d: aa 1b           ORA   -$5,X
ef7f: 20 84           BRA   $EF05
ef81: 16 ec 2f        LBRA  $DBB3
ef84: 84 18           ANDA  #$18
ef86: fc 2f 84        LDD   $2F84
ef89: 1a 0c           ORCC  #$0C
ef8b: 2f 07           BLE   $EF94
ef8d: c4 4e           ANDB  #$4E
ef8f: 10 30 c4        ADDR  0,S
ef92: 50              NEGB
ef93: 10 10           FCB   $10,$10
ef95: 44              LSRA
ef96: 54              LSRB
ef97: 00 28           NEG   $28
ef99: c4 52           ANDB  #$52
ef9b: 00 10           NEG   $10
ef9d: 51              FCB   $51
ef9e: e3 10           ADDD  -$10,X
efa0: 28 d1           BVC   $EF73
efa2: ca 00           ORB   #$00
efa4: 30 d1           LEAX  [,U++]
efa6: cc 00 10        LDD   #$0010
efa9: 07 51           ASR   $51
efab: e2 10           SBCB  -$10,X
efad: 28 d1           BVC   $EF80
efaf: de 00           LDU   $00
efb1: 30 d1           LEAX  [,U++]
efb3: e0 00           SUBB  $0,X
efb5: 10 c4           FCB   $10,$C4
efb7: 62 10 30        AIM   #$10;-$10,Y
efba: c4 66           ANDB  #$66
efbc: 10 10           FCB   $10,$10
efbe: c4 64           ANDB  #$64
efc0: 00 30           NEG   $30
efc2: c4 68           ANDB  #$68
efc4: 00 10           NEG   $10
efc6: 06 44           ROR   $44
efc8: 55              FCB   $55
efc9: 10 28 c4 56     LBVC  $B423
efcd: 00 30           NEG   $30
efcf: c4 58           ANDB  #$58
efd1: 00 10           NEG   $10
efd3: d1 c4           CMPB  $C4
efd5: 10 30 d1        ADDR  0,X
efd8: c6 10           LDB   #$10
efda: 10 d1           FCB   $10,$D1
efdc: c8 00           EORB  #$00
efde: 20 27           BRA   $F007
efe0: ef f0           STU   [,--W]
efe2: 44              LSRA
efe3: 6e c4           JMP   ,U
efe5: 6a c4           DEC   ,U
efe7: 6c d1           INC   [,U++]
efe9: d6 d1           LDB   $D1
efeb: d8 d1           EORB  $D1
efed: da d1           ORB   $D1
efef: dc 10           LDD   $10
eff1: 28 00           BVC   $EFF3
eff3: 30 00           LEAX  $0,X
eff5: 10 10           FCB   $10,$10
eff7: 30 10           LEAX  -$10,X
eff9: 10 00           FCB   $10,$00
effb: 30 00           LEAX  $0,X
effd: 10 27 ef f0     LBEQ  $DFF1
f001: 51              FCB   $51
f002: e2 d1           SBCB  [,U++]
f004: de d1           LDU   $D1
f006: e0 c4           SUBB  ,U
f008: 5a              DECB
f009: c4 66           ANDB  #$66
f00b: c4 5c           ANDB  #$5C
f00d: c4 68           ANDB  #$68
f00f: 27 ef           BEQ   $F000
f011: f0 51 e2        SUBB  $51E2
f014: d1 de           CMPB  $DE
f016: d1 e0           CMPB  $E0
f018: c4 5e           ANDB  #$5E
f01a: c4 66           ANDB  #$66
f01c: c4 60           ANDB  #$60
f01e: c4 68           ANDB  #$68
f020: 08 51           ASL   $51
f022: e2 10           SBCB  -$10,X
f024: 28 d1           BVC   $EFF7
f026: de 00           LDU   $00
f028: 30 d1           LEAX  [,U++]
f02a: e0 00           SUBB  $0,X
f02c: 10 44           LSRD
f02e: 6f 20           CLR   $0,Y
f030: 18              FCB   $18
f031: c4 70           ANDB  #$70
f033: 10 30 c4        ADDR  0,S
f036: 72 10 10 c4     AIM   #$10,$10C4
f03a: 74 00 30        LSR   >$0030
f03d: c4 76           ANDB  #$76
f03f: 00 10           NEG   $10
f041: 09 44           ROL   $44
f043: 6e 10           JMP   -$10,X
f045: 28 c4           BVC   $F00B
f047: 6a 00           DEC   $0,X
f049: 30 c4           LEAX  ,U
f04b: 6c 00           INC   $0,X
f04d: 10 d2           FCB   $10,$D2
f04f: 5c              INCB
f050: 10 40           NEGD
f052: 52              FCB   $52
f053: 61 10 28        OIM   #$10;$8,Y
f056: d1 d8           CMPB  $D8
f058: 10 10           FCB   $10,$10
f05a: d2 5e           SBCB  $5E
f05c: 00 40           NEG   $40
f05e: 52              FCB   $52
f05f: 60 00           NEG   $0,X
f061: 28 d1           BVC   $F034
f063: dc 00           LDD   $00
f065: 10 06           FCB   $10,$06
f067: 44              LSRA
f068: f6 10 18        LDB   $1018
f06b: c4 ee           ANDB  #$EE
f06d: 00 30           NEG   $30
f06f: c4 f0           ANDB  #$F0
f071: 00 10           NEG   $10
f073: d2 62           SBCB  $62
f075: 10 30 d2        ADDR  0,Y
f078: 66 00           ROR   $0,X
f07a: 30 d2           LEAX  Illegal Postbyte
f07c: 64 08           LSR   $8,X
f07e: 10 06           FCB   $10,$06
f080: c4 f2           ANDB  #$F2
f082: 00 30           NEG   $30
f084: c4 f4           ANDB  #$F4
f086: 00 10           NEG   $10
f088: d2 68           SBCB  $68
f08a: 10 20           FCB   $10,$20
f08c: 52              FCB   $52
f08d: 6d 10           TST   -$10,X
f08f: 08 d2           ASL   $D2
f091: 6a 00           DEC   $0,X
f093: 20 52           BRA   $F0E7
f095: 6c 00           INC   $0,X
f097: 08 27           ASL   $27
f099: f0 a9 44        SUBB  $A944
f09c: 6e c4           JMP   ,U
f09e: 6a c4           DEC   ,U
f0a0: 6c d1           INC   [,U++]
f0a2: e4 d1           ANDB  [,U++]
f0a4: e8 d1           EORB  [,U++]
f0a6: e6 d1           LDB   [,U++]
f0a8: ea 10           ORB   -$10,X
f0aa: 28 00           BVC   $F0AC
f0ac: 30 00           LEAX  $0,X
f0ae: 10 10           FCB   $10,$10
f0b0: 30 00           LEAX  $0,X
f0b2: 30 10           LEAX  -$10,X
f0b4: 10 00           FCB   $10,$00
f0b6: 10 07           FCB   $10,$07
f0b8: 44              LSRA
f0b9: 6e 10           JMP   -$10,X
f0bb: 28 c4           BVC   $F081
f0bd: 6a 00           DEC   $0,X
f0bf: 30 c4           LEAX  ,U
f0c1: 6c 00           INC   $0,X
f0c3: 10 d1           FCB   $10,$D1
f0c5: d6 10           LDB   $10
f0c7: 30 d1           LEAX  [,U++]
f0c9: da 00           ORB   $00
f0cb: 30 d1           LEAX  [,U++]
f0cd: ec 1a           LDD   -$6,X
f0cf: 20 d1           BRA   $F0A2
f0d1: ee 0a           LDU   $A,X
f0d3: 10 27 f0 a9     LBEQ  $E180
f0d7: 44              LSRA
f0d8: 6e c4           JMP   ,U
f0da: 6a c4           DEC   ,U
f0dc: 6c d1           INC   [,U++]
f0de: ce d1 d0        LDU   #$D1D0
f0e1: d1 d8           CMPB  $D8
f0e3: d1 dc           CMPB  $DC
f0e5: 27 f0           BEQ   $F0D7
f0e7: a9 44           ADCA  $4,U
f0e9: 6e c4           JMP   ,U
f0eb: 6a c4           DEC   ,U
f0ed: 6c d1           INC   [,U++]
f0ef: d2 d1           SBCB  $D1
f0f1: d4 d1           ANDB  $D1
f0f3: d8 d1           EORB  $D1
f0f5: dc 08           LDD   $08
f0f7: 44              LSRA
f0f8: 6e 10           JMP   -$10,X
f0fa: 28 c4           BVC   $F0C0
f0fc: 6a 00           DEC   $0,X
f0fe: 30 c4           LEAX  ,U
f100: 6c 00           INC   $0,X
f102: 10 51           FCB   $10,$51
f104: c3 20 18        ADDD  #$2018
f107: d1 f0           CMPB  $F0
f109: 10 30 d1        ADDR  0,X
f10c: f2 10 10        SBCB  $1010
f10f: d1 f4           CMPB  $F4
f111: 00 30           NEG   $30
f113: d1 f6           CMPB  $F6
f115: 00 10           NEG   $10
f117: 07 c4           ASR   $C4
f119: 8e 18 30        LDX   #$1830
f11c: c4 90           ANDB  #$90
f11e: 18              FCB   $18
f11f: 10 44           LSRD
f121: b0 28 28        SUBA  $2828
f124: c4 8c           ANDB  #$8C
f126: 28 10           BVC   $F138
f128: 9b 28           ADDA  $28
f12a: 08 30           ASL   $30
f12c: 9b 2a           ADDA  $2A
f12e: 08 10           ASL   $10
f130: 9b 2c           ADDA  $2C
f132: 18              FCB   $18
f133: 30 09           LEAX  $9,X
f135: c4 8e           ANDB  #$8E
f137: 18              FCB   $18
f138: 30 c4           LEAX  ,U
f13a: 90 18           SUBA  $18
f13c: 10 44           LSRD
f13e: b0 28 28        SUBA  $2828
f141: c4 8c           ANDB  #$8C
f143: 28 10           BVC   $F155
f145: 9b 2e           ADDA  $2E
f147: f8 20 1b        EORB  $201B
f14a: 36 f8           PSHU  PC,S,Y,X,DP
f14c: 08 9b           ASL   $9B
f14e: 30 08           LEAX  $8,X
f150: 30 9b           LEAX  [D,X]
f152: 32 08           LEAS  $8,X
f154: 10 9b 34        ADDW  $34
f157: 18              FCB   $18
f158: 30 f1           LEAX  [,S++]
f15a: c1 f1           CMPB  #$F1
f15c: cc f1 d7        LDD   #$F1D7
f15f: f1 dc f1        CMPB  $DCF1
f162: e7 f1           STB   [,S++]
f164: ec f1           LDD   [,S++]
f166: f7 f1 fc        STB   $F1FC
f169: f2 07 f2        SBCB  $07F2
f16c: 18              FCB   $18
f16d: f2 2d f2        SBCB  $2DF2
f170: 42              FCB   $42
f171: f2 4b f2        SBCB  $4BF2
f174: 4b              FCB   $4B
f175: f2 4b f2        SBCB  $4BF2
f178: 54              LSRB
f179: f2 54 f2        SBCB  $54F2
f17c: 61 f2 66        OIM   #$F2;$6,S
f17f: f2 6b f2        SBCB  $6BF2
f182: 80 f2           SUBA  #$F2
f184: 85 f2           BITA  #$F2
f186: 8a f2           ORA   #$F2
f188: 9f f2           STX   $F2
f18a: 9f f2           STX   $F2
f18c: 9f f2           STX   $F2
f18e: 9f f2           STX   $F2
f190: 9f f2           STX   $F2
f192: 9f f2           STX   $F2
f194: ad f2           JSR   Illegal Postbyte
f196: b8 f2 b8        EORA  $F2B8
f199: f2 b8 f2        SBCB  $B8F2
f19c: b8 f2 b8        EORA  $F2B8
f19f: f2 b8 f2        SBCB  $B8F2
f1a2: b8 f2 b8        EORA  $F2B8
f1a5: f2 b8 f2        SBCB  $B8F2
f1a8: b8 f2 b8        EORA  $F2B8
f1ab: f2 b8 f2        SBCB  $B8F2
f1ae: b8 f2 b8        EORA  $F2B8
f1b1: f2 b8 f2        SBCB  $B8F2
f1b4: b8 f2 b8        EORA  $F2B8
f1b7: f2 b8 f2        SBCB  $B8F2
f1ba: c9 f2           ADCB  #$F2
f1bc: de f2           LDU   $F2
f1be: ef f2           STU   Illegal Postbyte
f1c0: fa c4 8d        ORB   $C48D
f1c3: 4a              DECA
f1c4: f8 30 f8        EORB  $30F8
f1c7: 10 08           FCB   $10,$08
f1c9: 30 08           LEAX  $8,X
f1cb: 10 24 f1 c4     LBCC  $E393
f1cf: 8d 4a           BSR   $F21B
f1d1: 8d 5a           BSR   $F22D
f1d3: 8d 4e           BSR   $F223
f1d5: 8d 5c           BSR   $F233
f1d7: e4 8d 52 f1     ANDB  $144CC,PCR
f1db: c4 24           ANDB  #$24
f1dd: f1 c4 8d        CMPB  $C48D
f1e0: 52              FCB   $52
f1e1: 8d 5e           BSR   $F241
f1e3: 8d 56           BSR   $F23B
f1e5: 8d 60           BSR   $F247
f1e7: e4 8d 32 f1     ANDB  $124DC,PCR
f1eb: c4 24           ANDB  #$24
f1ed: f1 c4 8d        CMPB  $C48D
f1f0: 32 8d 42 8d     LEAS  $13481,PCR
f1f4: 36 8d           PSHU  PC,DP,B,CC
f1f6: 44              LSRA
f1f7: e4 8d 3a f1     ANDB  $12CEC,PCR
f1fb: c4 24           ANDB  #$24
f1fd: f1 c4 8d        CMPB  $C48D
f200: 3a              ABX
f201: 8d 46           BSR   $F249
f203: 8d 3e           BSR   $F243
f205: 8d 48           BSR   $F24F
f207: 04 8c           LSR   $8C
f209: 00 f8           NEG   $F8
f20b: 30 8c 02        LEAX  $F210,PCR
f20e: f8 10 8c        EORB  $108C
f211: 04 08           LSR   $08
f213: 20 0c           BRA   $F221
f215: 23 08           BLS   $F21F
f217: 08 05           ASL   $05
f219: 8c 06 f8        CMPX  #$06F8
f21c: 30 8c 02        LEAX  $F221,PCR
f21f: f8 10 8c        EORB  $108C
f222: 08 08           ASL   $08
f224: 30 0c           LEAX  $C,X
f226: 05 08 18        EIM   #$08;$18
f229: 0c 23           INC   $23
f22b: 08 08           ASL   $08
f22d: 05 8c 0a        EIM   #$8C;$0A
f230: e8 20           EORB  $0,Y
f232: 8c 0c f8        CMPX  #$0CF8
f235: 20 0c           BRA   $F243
f237: 11 f8           FCB   $11,$F8
f239: 08 8c           ASL   $8C
f23b: 0e 08           JMP   $08
f23d: 20 0c           BRA   $F24B
f23f: 10 08           FCB   $10,$08
f241: 08 c3           ASL   $C3
f243: 8c 12 d8        CMPX  #$12D8
f246: 10 e8           FCB   $10,$E8
f248: 10 f8           FCB   $10,$F8
f24a: 10 c3           FCB   $10,$C3
f24c: cc 18 18        LDD   #$1818
f24f: 08 08           ASL   $08
f251: 08 f8           ASL   $F8
f253: 08 03           ASL   $03
f255: 8c 1e f8        CMPX  #$1EF8
f258: 10 8c 20 08     CMPY  #$2008
f25c: 20 0c           BRA   $F26A
f25e: 22 08           BHI   $F268
f260: 08 e4           ASL   $E4
f262: 8d 22           BSR   $F286
f264: f1 c4 e4        CMPB  $C4E4
f267: 8d 2a           BSR   $F293
f269: f1 c4 05        CMPB  $C405
f26c: 8d 00           BSR   $F26E
f26e: f8 20 0d        EORB  $200D
f271: 21 f8           BRN   $F26B
f273: 08 8d           ASL   $8D
f275: 02 08 30        AIM   #$08;$30
f278: 8d 04           BSR   $F27E
f27a: 08 10           ASL   $10
f27c: 8d 06           BSR   $F284
f27e: 18              FCB   $18
f27f: 30 e4           LEAX  ,S
f281: 8d 08           BSR   $F28B
f283: f1 c4 e4        CMPB  $C4E4
f286: 8d 10           BSR   $F298
f288: f1 c4 05        CMPB  $C405
f28b: 8d 18           BSR   $F2A5
f28d: f8 20 0d        EORB  $200D
f290: 20 f8           BRA   $F28A
f292: 08 8d           ASL   $8D
f294: 1a 08           ORCC  #$08
f296: 30 8d 1c 08     LEAX  $10EA2,PCR
f29a: 10 8d           FCB   $10,$8D
f29c: 1e 18           EXG   X,A
f29e: 30 84           LEAX  ,X
f2a0: 8d 98           BSR   $F23A
f2a2: f8 10 9e        EORB  $109E
f2a5: f8 30 a0        EORB  $30A0
f2a8: 08 30           ASL   $30
f2aa: 9c 08           CMPX  $08
f2ac: 10 c4           FCB   $10,$C4
f2ae: 8d 96           BSR   $F246
f2b0: f4 30 f4        ANDB  $30F4
f2b3: 10 04           FCB   $10,$04
f2b5: 30 04           LEAX  $4,X
f2b7: 10 04           FCB   $10,$04
f2b9: 4c              INCA
f2ba: e7 10           STB   -$10,X
f2bc: 08 cc           ASL   $CC
f2be: dc 00           LDD   $00
f2c0: 10 cc           FCB   $10,$CC
f2c2: f8 08 30        EORB  $0830
f2c5: cc fa f8        LDD   #$FAF8
f2c8: 30 05           LEAX  $5,X
f2ca: cc d8 10        LDD   #$D810
f2cd: 20 4c           BRA   $F31B
f2cf: e7 10           STB   -$10,X
f2d1: 08 cc           ASL   $CC
f2d3: da 00           ORB   $00
f2d5: 30 cc dc        LEAX  $F2B4,PCR
f2d8: 00 10           NEG   $10
f2da: cc de f0        LDD   #$DEF0
f2dd: 30 04           LEAX  $4,X
f2df: cc e0 08        LDD   #$E008
f2e2: 30 cc e2        LEAX  $F2C7,PCR
f2e5: 08 10           ASL   $10
f2e7: cc e4 f8        LDD   #$E4F8
f2ea: 20 4c           BRA   $F338
f2ec: e6 f8 08        LDB   [$08,S]
f2ef: c4 cc           ANDB  #$CC
f2f1: e8 10           EORB  -$10,X
f2f3: 30 10           LEAX  -$10,X
f2f5: 10 00           FCB   $10,$00
f2f7: 30 00           LEAX  $0,X
f2f9: 10 c4           FCB   $10,$C4
f2fb: cc f0 0c        LDD   #$F00C
f2fe: 30 0c           LEAX  $C,X
f300: 10 fc 30 fc     LDQ   $30FC
f304: 10 00           FCB   $10,$00
f306: 00 00           NEG   $00
f308: 00 00           NEG   $00
f30a: 00 00           NEG   $00
f30c: 00 00           NEG   $00
f30e: 00 00           NEG   $00
f310: 00 00           NEG   $00
f312: 00 00           NEG   $00
f314: 00 00           NEG   $00
f316: 00 00           NEG   $00
f318: 00 00           NEG   $00
f31a: 00 00           NEG   $00
f31c: 00 00           NEG   $00
f31e: 00 00           NEG   $00
f320: 00 00           NEG   $00
f322: 00 00           NEG   $00
f324: 00 00           NEG   $00
f326: 00 00           NEG   $00
f328: 00 00           NEG   $00
f32a: 00 00           NEG   $00
f32c: 00 00           NEG   $00
f32e: 00 00           NEG   $00
f330: 00 00           NEG   $00
f332: 00 00           NEG   $00
f334: 00 00           NEG   $00
f336: 00 00           NEG   $00
f338: 00 00           NEG   $00
f33a: 00 00           NEG   $00
f33c: 00 00           NEG   $00
f33e: 00 00           NEG   $00
f340: 00 00           NEG   $00
f342: 00 00           NEG   $00
f344: 00 00           NEG   $00
f346: 00 00           NEG   $00
f348: 00 00           NEG   $00
f34a: 00 00           NEG   $00
f34c: 00 00           NEG   $00
f34e: 00 00           NEG   $00
f350: 00 00           NEG   $00
f352: 00 00           NEG   $00
f354: 00 00           NEG   $00
f356: 00 00           NEG   $00
f358: 00 00           NEG   $00
f35a: 00 00           NEG   $00
f35c: 00 00           NEG   $00
f35e: 00 00           NEG   $00
f360: 00 00           NEG   $00
f362: 00 00           NEG   $00
f364: 00 00           NEG   $00
f366: 00 00           NEG   $00
f368: 00 00           NEG   $00
f36a: 00 00           NEG   $00
f36c: 00 00           NEG   $00
f36e: 00 00           NEG   $00
f370: 00 00           NEG   $00
f372: 00 00           NEG   $00
f374: 00 00           NEG   $00
f376: 00 00           NEG   $00
f378: 00 00           NEG   $00
f37a: 00 00           NEG   $00
f37c: 00 00           NEG   $00
f37e: 00 00           NEG   $00
f380: 00 00           NEG   $00
f382: 00 00           NEG   $00
f384: 00 00           NEG   $00
f386: 00 00           NEG   $00
f388: 00 00           NEG   $00
f38a: 00 00           NEG   $00
f38c: 00 00           NEG   $00
f38e: 00 00           NEG   $00
f390: f3 b2 f3        ADDD  $B2F3
f393: c7              FCB   $C7
f394: f3 d4 f3        ADDD  $D4F3
f397: e1 f3           CMPB  [,--S]
f399: f6 f4 07        LDB   $F407
f39c: f4 1a f4        ANDB  $1AF4
f39f: 25 f4           BCS   $F395
f3a1: 36 f4           PSHU  PC,S,Y,X,B
f3a3: 47              ASRA
f3a4: f4 58 f4        ANDB  $58F4
f3a7: 69 f4           ROL   [,S]
f3a9: 7a f4 8b        DEC   $F48B
f3ac: f4 9c f4        ANDB  $9CF4
f3af: a9 f4           ADCA  [,S]
f3b1: be 05 8e        LDX   $058E
f3b4: be ec 1e        LDX   $EC1E
f3b7: 8e c0 fc        LDX   #$C0FC
f3ba: 1e 0e           EXG   D,E
f3bc: c5 fc           BITB  #$FC
f3be: 06 8e           ROR   $8E
f3c0: c2 0c           SBCB  #$0C
f3c2: 1e 0e           EXG   D,E
f3c4: c4 0c           ANDB  #$0C
f3c6: 06 03           ROR   $03
f3c8: 8e c6 00        LDX   #$C600
f3cb: 0e 8e           JMP   $8E
f3cd: c8 10           EORB  #$10
f3cf: 0e 8e           JMP   $8E
f3d1: ca 20           ORB   #$20
f3d3: 0e 03           JMP   $03
f3d5: 8e cc fd        LDX   #$CCFD
f3d8: 0f 8e           CLR   $8E
f3da: ce 0d 0f        LDU   #$0D0F
f3dd: 8e d0 1d        LDX   #$D01D
f3e0: 0f 05           CLR   $05
f3e2: 8e d2 fb        LDX   #$D2FB
f3e5: 18              FCB   $18
f3e6: 8e d4 0b        LDX   #$D40B
f3e9: 18              FCB   $18
f3ea: 8e d6 1b        LDX   #$D61B
f3ed: 18              FCB   $18
f3ee: 0e d8           JMP   $D8
f3f0: fb 00 0e        ADDB  >$000E
f3f3: d9 0b           ADCB  $0B
f3f5: 00 04           NEG   $04
f3f7: 8f              FCB   $8F
f3f8: 00 02           NEG   $02
f3fa: 18              FCB   $18
f3fb: 0f 0e           CLR   $0E
f3fd: 02 00 8f        AIM   #$00;$8F
f400: 02 12 18        AIM   #$12;$18
f403: 0f 12           CLR   $12
f405: 12              NOP
f406: 00 24           NEG   $24
f408: f4 12 8f        ANDB  $128F
f40b: 04 0f           LSR   $0F
f40d: 09 8f           ROL   $8F
f40f: 06 0f           ROR   $0F
f411: 08 04           ASL   $04
f413: 18              FCB   $18
f414: 04 00           LSR   $00
f416: 14              SEXW
f417: 18              FCB   $18
f418: 14              SEXW
f419: 00 24           NEG   $24
f41b: f4 12 8f        ANDB  $128F
f41e: 0a 0f           DEC   $0F
f420: 16 8f 0c        LBRA  $832F
f423: 0f 1a           CLR   $1A
f425: 04 0f           LSR   $0F
f427: 0f 00           CLR   $00
f429: 1e 8f           EXG   A,F
f42b: 10 00           FCB   $10,$00
f42d: 06 0f           ROR   $0F
f42f: 13              SYNC
f430: 10 1e           FCB   $10,$1E
f432: 8f              FCB   $8F
f433: 14              SEXW
f434: 10 06           FCB   $10,$06
f436: 04 0f           LSR   $0F
f438: 17 04 28        LBSR  $F863
f43b: 8f              FCB   $8F
f43c: 18              FCB   $18
f43d: 04 10           LSR   $10
f43f: 0f 1b           CLR   $1B
f441: 14              SEXW
f442: 28 8f           BVC   $F3D3
f444: 1c 14           ANDCC #$14
f446: 10 04           FCB   $10,$04
f448: 8f              FCB   $8F
f449: 1e 01           EXG   D,X
f44b: 1c 0f           ANDCC #$0F
f44d: 23 01           BLS   $F450
f44f: 04 8f           LSR   $8F
f451: 20 11           BRA   $F464
f453: 1c 0f           ANDCC #$0F
f455: 22 11           BHI   $F468
f457: 04 04           LSR   $04
f459: 8f              FCB   $8F
f45a: 24 01           BCC   $F45D
f45c: 1f 0f           TFR   D,F
f45e: 29 01           BVS   $F461
f460: 07 8f           ASR   $8F
f462: 26 11           BNE   $F475
f464: 1f 0f           TFR   D,F
f466: 28 11           BVC   $F479
f468: 07 04           ASR   $04
f46a: 8f              FCB   $8F
f46b: 2a 03           BPL   $F470
f46d: 1f 0f           TFR   D,F
f46f: 2f 03           BLE   $F474
f471: 07 8f           ASR   $8F
f473: 2c 13           BGE   $F488
f475: 1f 0f           TFR   D,F
f477: 2e 13           BGT   $F48C
f479: 07 04           ASR   $04
f47b: 8f              FCB   $8F
f47c: 30 fc 1f        LEAX  [$F49E,PCR]
f47f: 0f 35           CLR   $35
f481: fc 07 8f        LDD   $078F
f484: 32 0c           LEAS  $C,X
f486: 1f 0f           TFR   D,F
f488: 34 0c           PSHS  DP,B
f48a: 07 04           ASR   $04
f48c: 8f              FCB   $8F
f48d: 36 06           PSHU  B,A
f48f: 1c 0f           ANDCC #$0F
f491: 3b              RTI
f492: 06 04           ROR   $04
f494: 8f              FCB   $8F
f495: 38              FCB   $38
f496: 16 1c 0f        LBRA  $10A8
f499: 3a              ABX
f49a: 16 04 03        LBRA  $F8A0
f49d: 8f              FCB   $8F
f49e: 3c dc           CWAI  #$DC
f4a0: 10 8f           FCB   $10,$8F
f4a2: 3e              FCB   $3E
f4a3: ec 10           LDD   -$10,X
f4a5: 8f              FCB   $8F
f4a6: 40              NEGA
f4a7: fc 10 05        LDD   $1005
f4aa: 8f              FCB   $8F
f4ab: 42              FCB   $42
f4ac: f0 20 0f        SUBB  $200F
f4af: 49              ROLA
f4b0: f0 08 8f        SUBB  $088F
f4b3: 44              LSRA
f4b4: 00 20           NEG   $20
f4b6: 0f 48           CLR   $48
f4b8: 00 08           NEG   $08
f4ba: 8f              FCB   $8F
f4bb: 46              RORA
f4bc: 10 10           FCB   $10,$10
f4be: 89 00           ADCA  #$00
f4c0: 00 f0           NEG   $F0
f4c2: 10 00           FCB   $10,$00
f4c4: f0 00 00        SUBB  >$0000
f4c7: f0 f0 00        SUBB  $F000
f4ca: 00 10           NEG   $10
f4cc: 00 00           NEG   $00
f4ce: 00 00           NEG   $00
f4d0: 00 f0           NEG   $F0
f4d2: 00 10           NEG   $10
f4d4: 10 00           FCB   $10,$00
f4d6: 10 00           FCB   $10,$00
f4d8: 00 10           NEG   $10
f4da: f0 f4 e7        SUBB  $F4E7
f4dd: f4 f2 f4        ANDB  $F2F4
f4e0: f9 f5 0c        ADCB  $F50C
f4e3: f5 17 f5        BITB  $17F5
f4e6: 22 22           BHI   $F50A
f4e8: f4 ee 8d        ANDB  $EE8D
f4eb: 62 8d 64        AIM   #$8D;$4,S
f4ee: f8 10 08        EORB  $1008
f4f1: 10 22 f4 ee     LBHI  $E9E3
f4f5: 8d 66           BSR   $F55D
f4f7: 8d 68           BSR   $F561
f4f9: 24 f5           BCC   $F4F0
f4fb: 04 8d           LSR   $8D
f4fd: 6a 0d           DEC   $D,X
f4ff: 6f 8d 6c 0d     CLR   $16110,PCR
f503: 6e f8 20        JMP   [$20,S]
f506: f8 08 08        EORB  $0808
f509: 20 08           BRA   $F513
f50b: 08 24           ASL   $24
f50d: f5 04 8d        BITB  $048D
f510: 70 0d 75        NEG   $0D75
f513: 8d 72           BSR   $F587
f515: 0d 74           TST   $74
f517: 24 f5           BCC   $F50E
f519: 04 8d           LSR   $8D
f51b: 76 0d 7b        ROR   $0D7B
f51e: 8d 78           BSR   $F598
f520: 0d 7a           TST   $7A
f522: 24 f5           BCC   $F519
f524: 04 8d           LSR   $8D
f526: 7c 0d 81        INC   $0D81
f529: 8d 7e           BSR   $F5A9
f52b: 0d 80           TST   $80
f52d: f5 39 f5        BITB  $39F5
f530: 44              LSRA
f531: f5 4b f5        BITB  $4BF5
f534: 52              FCB   $52
f535: f5 59 f5        BITB  $59F5
f538: 60 22           NEG   $2,Y
f53a: f5 40 8d        BITB  $408D
f53d: 82 8d           SBCA  #$8D
f53f: 84 f8           ANDA  #$F8
f541: 10 08           FCB   $10,$08
f543: 10 22 f5 40     LBHI  $EA87
f547: 8d 86           BSR   $F4CF
f549: 8d 88           BSR   $F4D3
f54b: 22 f5           BHI   $F542
f54d: 40              NEGA
f54e: 8d 8a           BSR   $F4DA
f550: 8d 8c           BSR   $F4DE
f552: 22 f5           BHI   $F549
f554: 40              NEGA
f555: 8d 8e           BSR   $F4E5
f557: 8d 90           BSR   $F4E9
f559: 22 f5           BHI   $F550
f55b: 40              NEGA
f55c: 8d 92           BSR   $F4F0
f55e: 8d 94           BSR   $F4F4
f560: 84 00           ANDA  #$00
f562: 00 f8           NEG   $F8
f564: 08 00           ASL   $00
f566: f8 f8 00        EORB  $F800
f569: 08 08           ASL   $08
f56b: 00 08           NEG   $08
f56d: f8 f5 a2        EORB  $F5A2
f570: f5 a7 f5        BITB  $A7F5
f573: ac f5           CMPX  [B,S]
f575: b1 f5 b6        CMPA  $F5B6
f578: f5 bb f5        BITB  $BBF5
f57b: c0 f5           SUBB  #$F5
f57d: c5 f5           BITB  #$F5
f57f: ca f5           ORB   #$F5
f581: cf              FCB   $CF
f582: f5 d4 f5        BITB  $D4F5
f585: d9 f5           ADCB  $F5
f587: de f5           LDU   $F5
f589: e3 f5           ADDD  [B,S]
f58b: e8 f5           EORB  [B,S]
f58d: ed f5           STD   [B,S]
f58f: f2 f5 f7        SBCB  $F5F7
f592: f5 fc f6        BITB  $FCF6
f595: 01 f6 06        OIM   #$F6;$06
f598: f6 0b f6        LDB   $0BF6
f59b: 10 f6           FCB   $10,$F6
f59d: 15              FCB   $15
f59e: f6 1a f6        LDB   $1AF6
f5a1: 1f 01           TFR   D,X
f5a3: 09 a8           ROL   $A8
f5a5: 00 00           NEG   $00
f5a7: 01 09 a9        OIM   #$09;$A9
f5aa: 00 00           NEG   $00
f5ac: 01 09 aa        OIM   #$09;$AA
f5af: 00 00           NEG   $00
f5b1: 01 09 ab        OIM   #$09;$AB
f5b4: 00 00           NEG   $00
f5b6: 01 09 ac        OIM   #$09;$AC
f5b9: 00 00           NEG   $00
f5bb: 01 09 ad        OIM   #$09;$AD
f5be: 00 00           NEG   $00
f5c0: 01 09 ae        OIM   #$09;$AE
f5c3: 00 00           NEG   $00
f5c5: 01 09 af        OIM   #$09;$AF
f5c8: 00 00           NEG   $00
f5ca: 01 09 b0        OIM   #$09;$B0
f5cd: 00 00           NEG   $00
f5cf: 01 09 b1        OIM   #$09;$B1
f5d2: 00 00           NEG   $00
f5d4: 01 09 b2        OIM   #$09;$B2
f5d7: 00 00           NEG   $00
f5d9: 01 09 b3        OIM   #$09;$B3
f5dc: 00 00           NEG   $00
f5de: 01 09 b4        OIM   #$09;$B4
f5e1: 00 00           NEG   $00
f5e3: 01 09 b5        OIM   #$09;$B5
f5e6: 00 00           NEG   $00
f5e8: 01 09 b6        OIM   #$09;$B6
f5eb: 00 00           NEG   $00
f5ed: 01 09 b7        OIM   #$09;$B7
f5f0: 00 00           NEG   $00
f5f2: 01 09 b8        OIM   #$09;$B8
f5f5: 00 00           NEG   $00
f5f7: 01 09 b9        OIM   #$09;$B9
f5fa: 00 00           NEG   $00
f5fc: 01 09 ba        OIM   #$09;$BA
f5ff: 00 00           NEG   $00
f601: 01 09 bb        OIM   #$09;$BB
f604: 00 00           NEG   $00
f606: 01 09 bc        OIM   #$09;$BC
f609: 00 00           NEG   $00
f60b: 01 09 bd        OIM   #$09;$BD
f60e: 00 00           NEG   $00
f610: 01 09 be        OIM   #$09;$BE
f613: 00 00           NEG   $00
f615: 01 09 bf        OIM   #$09;$BF
f618: 00 00           NEG   $00
f61a: 01 09 c0        OIM   #$09;$C0
f61d: 00 00           NEG   $00
f61f: 01 00 00        OIM   #$00;$00
f622: 00 00           NEG   $00
f624: f6 4e f6        LDB   $4EF6
f627: 59              ROLB
f628: f6 64 f6        LDB   $64F6
f62b: 6b f6 72        TIM   #$F6;-$E,S
f62e: f6 79 f6        LDB   $79F6
f631: 80 f6           SUBA  #$F6
f633: 87              FCB   $87
f634: f6 87 f6        LDB   $87F6
f637: 8e f6 95        LDX   #$F695
f63a: f6 9c f6        LDB   $9CF6
f63d: a3 f6           SUBD  [A,S]
f63f: ac f6           CMPX  [A,S]
f641: b5 f6 c0        BITA  $F6C0
f644: f6 c7 f6        LDB   $C7F6
f647: d5 f6           BITB  $F6
f649: de f6           LDU   $F6
f64b: e3 f6           ADDD  [A,S]
f64d: ec 22           LDD   $2,Y
f64f: f6 55 09        LDB   $5509
f652: c1 09           CMPB  #$09
f654: c5 f8           BITB  #$F8
f656: 00 08           NEG   $08
f658: 00 22           NEG   $22
f65a: f6 60 89        LDB   $6089
f65d: c2 09           SBCB  #$09
f65f: c4 00           ANDB  #$00
f661: 08 00           ASL   $00
f663: f0 22 f6        SUBB  $22F6
f666: 60 89 c6 09     NEG   -$39F7,X
f66a: cb 22           ADDB  #$22
f66c: f6 60 89        LDB   $6089
f66f: c8 09           EORB  #$09
f671: ca 22           ORB   #$22
f673: f6 55 09        LDB   $5509
f676: cc 09 cd        LDD   #$09CD
f679: 22 f6           BHI   $F671
f67b: 55              FCB   $55
f67c: 09 ce           ROL   $CE
f67e: 09 cf           ROL   $CF
f680: 22 f6           BHI   $F678
f682: 55              FCB   $55
f683: 09 d0           ROL   $D0
f685: 09 d1           ROL   $D1
f687: 22 f6           BHI   $F67F
f689: 55              FCB   $55
f68a: 09 d8           ROL   $D8
f68c: 09 d9           ROL   $D9
f68e: 22 f6           BHI   $F686
f690: 55              FCB   $55
f691: 09 dc           ROL   $DC
f693: 09 dd           ROL   $DD
f695: 22 f6           BHI   $F68D
f697: 55              FCB   $55
f698: 09 e4           ROL   $E4
f69a: 09 e5           ROL   $E5
f69c: 22 f6           BHI   $F694
f69e: 55              FCB   $55
f69f: 09 da           ROL   $DA
f6a1: 09 db           ROL   $DB
f6a3: 02 09 d3        AIM   #$09;$D3
f6a6: f8 f8 89        EORB  $F889
f6a9: d6 08           LDB   $08
f6ab: 00 02           NEG   $02
f6ad: 09 e8           ROL   $E8
f6af: f8 f8 89        EORB  $F889
f6b2: e6 08           LDB   $8,X
f6b4: 00 22           NEG   $22
f6b6: f6 bc 89        LDB   $BC89
f6b9: de 09           LDU   $09
f6bb: e3 00           ADDD  $0,X
f6bd: 08 00           ASL   $00
f6bf: f0 22 f6        SUBB  $22F6
f6c2: bc 89 e0        CMPX  $89E0
f6c5: 09 e2           ROL   $E2
f6c7: 84 00           ANDA  #$00
f6c9: 00 f8           NEG   $F8
f6cb: 08 00           ASL   $00
f6cd: f8 f8 00        EORB  $F800
f6d0: 08 08           ASL   $08
f6d2: 00 08           NEG   $08
f6d4: f8 02 09        EORB  $0209
f6d7: dc f8           LDD   $F8
f6d9: 00 09           NEG   $09
f6db: db 08           ADDB  $08
f6dd: 00 01           NEG   $01
f6df: 09 dc           ROL   $DC
f6e1: 00 00           NEG   $00
f6e3: 02 09 da        AIM   #$09;$DA
f6e6: f8 00 09        EORB  >$0009
f6e9: db 09           ADDB  $09
f6eb: 00 01           NEG   $01
f6ed: 09 db           ROL   $DB
f6ef: 00 00           NEG   $00
f6f1: f7 2f f7        STB   $2FF7
f6f4: 34 f7           PSHS  PC,U,Y,X,B,A,CC
f6f6: 39              RTS
f6f7: f7 3e f7        STB   $3EF7
f6fa: 43              COMA
f6fb: f7 48 f7        STB   $48F7
f6fe: 4d              TSTA
f6ff: f7 52 f7        STB   $52F7
f702: 57              ASRB
f703: f7 5c f7        STB   $5CF7
f706: 61 f7 66        OIM   #$F7;$6,S
f709: f7 6b f7        STB   $6BF7
f70c: 70 f7 75        NEG   $F775
f70f: f7 7a f7        STB   $7AF7
f712: 7f f7 84        CLR   $F784
f715: f7 89 f7        STB   $89F7
f718: 8e f7 93        LDX   #$F793
f71b: f7 98 f7        STB   $98F7
f71e: 9d f7           JSR   $F7
f720: a2 f7           SBCA  [E,S]
f722: a7 f7           STA   [E,S]
f724: ac f7           CMPX  [E,S]
f726: b1 f7 bc        CMPA  $F7BC
f729: f7 c3 f7        STB   $C3F7
f72c: ca f7           ORB   #$F7
f72e: d1 01           CMPB  $01
f730: 0e 7e           JMP   $7E
f732: 00 00           NEG   $00
f734: 01 0e 82        OIM   #$0E;$82
f737: 00 00           NEG   $00
f739: 01 0e 86        OIM   #$0E;$86
f73c: 00 00           NEG   $00
f73e: 01 0e 8a        OIM   #$0E;$8A
f741: 00 00           NEG   $00
f743: 01 0e 8e        OIM   #$0E;$8E
f746: 00 00           NEG   $00
f748: 01 0e 7f        OIM   #$0E;$7F
f74b: 00 00           NEG   $00
f74d: 01 0e 83        OIM   #$0E;$83
f750: 00 00           NEG   $00
f752: 01 0e 87        OIM   #$0E;$87
f755: 00 00           NEG   $00
f757: 01 0e 8b        OIM   #$0E;$8B
f75a: 00 00           NEG   $00
f75c: 01 0e 8f        OIM   #$0E;$8F
f75f: 00 00           NEG   $00
f761: 01 0e 92        OIM   #$0E;$92
f764: 00 00           NEG   $00
f766: 01 0e 80        OIM   #$0E;$80
f769: 00 00           NEG   $00
f76b: 01 0e 84        OIM   #$0E;$84
f76e: 00 00           NEG   $00
f770: 01 0e 88        OIM   #$0E;$88
f773: 00 00           NEG   $00
f775: 01 0e 8c        OIM   #$0E;$8C
f778: 00 00           NEG   $00
f77a: 01 0e 90        OIM   #$0E;$90
f77d: 00 00           NEG   $00
f77f: 01 0e 93        OIM   #$0E;$93
f782: 00 00           NEG   $00
f784: 01 0e 81        OIM   #$0E;$81
f787: 00 00           NEG   $00
f789: 01 0e 85        OIM   #$0E;$85
f78c: 00 00           NEG   $00
f78e: 01 0e 89        OIM   #$0E;$89
f791: 00 00           NEG   $00
f793: 01 0e 8d        OIM   #$0E;$8D
f796: 00 00           NEG   $00
f798: 01 0e 91        OIM   #$0E;$91
f79b: 00 00           NEG   $00
f79d: 01 0e 7d        OIM   #$0E;$7D
f7a0: 00 00           NEG   $00
f7a2: 01 0e aa        OIM   #$0E;$AA
f7a5: 00 00           NEG   $00
f7a7: 01 0e 94        OIM   #$0E;$94
f7aa: 00 00           NEG   $00
f7ac: 01 0e 95        OIM   #$0E;$95
f7af: 00 00           NEG   $00
f7b1: 22 f7           BHI   $F7AA
f7b3: b8 8e 96        EORA  $8E96
f7b6: 8e 9a f8        LDX   #$9AF8
f7b9: 00 08           NEG   $08
f7bb: 00 22           NEG   $22
f7bd: f7 b8 8e        STB   $B88E
f7c0: 9e 8e           LDX   $8E
f7c2: a2 22           SBCA  $2,Y
f7c4: f7 b8 8e        STB   $B88E
f7c7: 98 8e           EORA  $8E
f7c9: 9c 22           CMPX  $22
f7cb: f7 b8 8e        STB   $B88E
f7ce: a0 8e           SUBA  W,X
f7d0: a4 22           ANDA  $2,Y
f7d2: f7 b8 8e        STB   $B88E
f7d5: a6 8e           LDA   W,X
f7d7: a8 f8 06        EORA  [$06,S]
f7da: f8 0b f8        EORB  $0BF8
f7dd: 10 f8           FCB   $10,$F8
f7df: 15              FCB   $15
f7e0: f8 1a f8        EORB  $1AF8
f7e3: 1f f8           TFR   F,A
f7e5: 24 f8           BCC   $F7DF
f7e7: 29 f8           BVS   $F7E1
f7e9: 2e f8           BGT   $F7E3
f7eb: 33 f8 38        LEAU  [$38,S]
f7ee: f8 3d f8        EORB  $3DF8
f7f1: 42              FCB   $42
f7f2: f8 47 f8        EORB  $47F8
f7f5: 4c              INCA
f7f6: f8 51 f8        EORB  $51F8
f7f9: 56              RORB
f7fa: f8 5b f8        EORB  $5BF8
f7fd: 60 f8 69        NEG   [$69,S]
f800: f8 72 f8        EORB  $72F8
f803: 77 f8 7c        ASR   $F87C
f806: 01 00 e7        OIM   #$00;$E7
f809: 00 00           NEG   $00
f80b: 01 00 e8        OIM   #$00;$E8
f80e: 00 00           NEG   $00
f810: 01 00 e9        OIM   #$00;$E9
f813: 00 00           NEG   $00
f815: 01 00 ea        OIM   #$00;$EA
f818: 00 00           NEG   $00
f81a: 01 00 eb        OIM   #$00;$EB
f81d: 00 00           NEG   $00
f81f: 01 00 ec        OIM   #$00;$EC
f822: 00 00           NEG   $00
f824: 01 00 ed        OIM   #$00;$ED
f827: 00 00           NEG   $00
f829: 01 00 ee        OIM   #$00;$EE
f82c: 00 00           NEG   $00
f82e: 01 00 ef        OIM   #$00;$EF
f831: 00 00           NEG   $00
f833: 01 00 f0        OIM   #$00;$F0
f836: 00 00           NEG   $00
f838: 01 00 f1        OIM   #$00;$F1
f83b: 00 00           NEG   $00
f83d: 01 00 f2        OIM   #$00;$F2
f840: 00 00           NEG   $00
f842: 01 00 f3        OIM   #$00;$F3
f845: 00 00           NEG   $00
f847: 01 00 f4        OIM   #$00;$F4
f84a: 00 00           NEG   $00
f84c: 01 00 f5        OIM   #$00;$F5
f84f: 00 00           NEG   $00
f851: 01 00 f6        OIM   #$00;$F6
f854: 00 00           NEG   $00
f856: 01 00 f7        OIM   #$00;$F7
f859: 00 00           NEG   $00
f85b: 01 80 f8        OIM   #$80;$F8
f85e: 00 10           NEG   $10
f860: 02 00 fa        AIM   #$00;$FA
f863: f8 08 00        EORB  $0800
f866: fb 08 08        ADDB  $0808
f869: 02 00 fe        AIM   #$00;$FE
f86c: 08 18           ASL   $18
f86e: 00 ff           NEG   $FF
f870: 00 08           NEG   $08
f872: 01 80 fc        OIM   #$80;$FC
f875: 00 10           NEG   $10
f877: 01 03 f7        OIM   #$03;$F7
f87a: 00 10           NEG   $10
f87c: 02 0a ae        AIM   #$0A;$AE
f87f: f8 08 0a        EORB  $080A
f882: af 08           STX   $8,X
f884: 08 f8           ASL   $F8
f886: 87              FCB   $87
f887: 03 86           COM   $86
f889: fa f0 00        ORB   $F000
f88c: 86 fc           LDA   #$FC
f88e: 00 00           NEG   $00
f890: 86 fe           LDA   #$FE
f892: 10 00           FCB   $10,$00
f894: f8 a0 f8        EORB  $A0F8
f897: b5 f8 d0        BITA  $F8D0
f89a: f8 df f8        EORB  $DFF8
f89d: ee f8 fd        LDU   [-$03,S]
f8a0: 05 8e 46        EIM   #$8E;$46
f8a3: e0 f0           SUBB  [,--W]
f8a5: 8e 48 f0        LDX   #$48F0
f8a8: f0 8e 4a        SUBB  $8E4A
f8ab: 00 f0           NEG   $F0
f8ad: 8e 4c 10        LDX   #$4C10
f8b0: f0 8e 4e        SUBB  $8E4E
f8b3: 20 f0           BRA   $F8A5
f8b5: 26 f8           BNE   $F8AF
f8b7: c4 0e           ANDB  #$0E
f8b9: 5c              INCB
f8ba: 0e 5d           JMP   $5D
f8bc: 0e 5d           JMP   $5D
f8be: 0e 5d           JMP   $5D
f8c0: 0e 5d           JMP   $5D
f8c2: 0e 45           JMP   $45
f8c4: da 08           ORB   $08
f8c6: ea 08           ORB   $8,X
f8c8: fa 08 0a        ORB   $080A
f8cb: 08 1a           ASL   $1A
f8cd: 08 2a           ASL   $2A
f8cf: 08 26           ASL   $26
f8d1: f8 c4 0e        EORB  $C40E
f8d4: 50              NEGB
f8d5: 0e 54           JMP   $54
f8d7: 0e 54           JMP   $54
f8d9: 0e 54           JMP   $54
f8db: 0e 54           JMP   $54
f8dd: 0e 58           JMP   $58
f8df: 26 f8           BNE   $F8D9
f8e1: c4 0e           ANDB  #$0E
f8e3: 51              FCB   $51
f8e4: 0e 55           JMP   $55
f8e6: 0e 55           JMP   $55
f8e8: 0e 55           JMP   $55
f8ea: 0e 55           JMP   $55
f8ec: 0e 59           JMP   $59
f8ee: 26 f8           BNE   $F8E8
f8f0: c4 0e           ANDB  #$0E
f8f2: 52              FCB   $52
f8f3: 0e 56           JMP   $56
f8f5: 0e 56           JMP   $56
f8f7: 0e 56           JMP   $56
f8f9: 0e 56           JMP   $56
f8fb: 0e 5a           JMP   $5A
f8fd: 26 f8           BNE   $F8F7
f8ff: c4 0e           ANDB  #$0E
f901: 53              COMB
f902: 0e 57           JMP   $57
f904: 0e 57           JMP   $57
f906: 0e 57           JMP   $57
f908: 0e 57           JMP   $57
f90a: 0e 5b           JMP   $5B
f90c: f9 14 f9        ADCB  $14F9
f90f: 1f f9           TFR   F,B
f911: 26 f9           BNE   $F90C
f913: 2d 22           BLT   $F937
f915: f9 1b 0a        ADCB  $1B0A
f918: f4 0a f6        ANDB  $0AF6
f91b: f8 00 08        EORB  >$0008
f91e: 00 22           NEG   $22
f920: f9 1b 0a        ADCB  $1B0A
f923: f5 0a f7        BITB  $0AF7
f926: 22 f9           BHI   $F921
f928: 1b              FCB   $1B
f929: 0a f9           DEC   $F9
f92b: 0a f8           DEC   $F8
f92d: 09 0a           ROL   $0A
f92f: fa f8 48        ORB   $F848
f932: 0a fa           DEC   $FA
f934: f8 38 0a        EORB  $380A
f937: fa f8 28        ORB   $F828
f93a: 8a fc           ORA   #$FC
f93c: f8 10 0a        EORB  $100A
f93f: fb 08 48        ADDB  $0848
f942: 0a fb           DEC   $FB
f944: 08 38           ASL   $38
f946: 0a fb           DEC   $FB
f948: 08 28           ASL   $28
f94a: 0a fb           DEC   $FB
f94c: 08 18           ASL   $18
f94e: 0a fe           DEC   $FE
f950: 08 08           ASL   $08
f952: f9 5a f9        ADCB  $5AF9
f955: 67 f9 80 f9     ASR   [-$7F07,S]
f959: 9d 03           JSR   $03
f95b: 82 c6           SBCA  #$C6
f95d: f0 00 82        SUBB  >$0082
f960: c8 00           EORB  #$00
f962: 00 82           NEG   $82
f964: ca 10           ORB   #$10
f966: 00 06           NEG   $06
f968: 82 cc           SBCA  #$CC
f96a: f0 08 02        SUBB  $0802
f96d: d5 f0           BITB  $F0
f96f: f0 82 ce        SUBB  $82CE
f972: 00 18           NEG   $18
f974: 82 d0           SBCA  #$D0
f976: 00 f8           NEG   $F8
f978: 82 d2           SBCA  #$D2
f97a: 10 08           FCB   $10,$08
f97c: 02 d4 10        AIM   #$D4;$10
f97f: f0 07 82        SUBB  $0782
f982: d6 f0           LDB   $F0
f984: 10 82 d8 f0     SBCD  #$D8F0
f988: f0 82 da        SUBB  $82DA
f98b: 00 10           NEG   $10
f98d: 82 dc           SBCA  #$DC
f98f: 00 f0           NEG   $F0
f991: 82 de           SBCA  #$DE
f993: 10 10           FCB   $10,$10
f995: 82 e0           SBCA  #$E0
f997: 10 f0           FCB   $10,$F0
f999: 02 c5 20        AIM   #$C5;$20
f99c: e8 04           EORB  $4,X
f99e: 02 e6 e8        AIM   #$E6;$E8
f9a1: 08 82           ASL   $82
f9a3: e2 f8 00        SBCB  [$00,S]
f9a6: 82 e4           SBCA  #$E4
f9a8: 08 00           ASL   $00
f9aa: 02 e7 18        AIM   #$E7;$18
f9ad: 08 f9           ASL   $F9
f9af: b4 f9 d5        ANDA  $F9D5
f9b2: f9 fe 08        ADCB  $FE08
f9b5: 8e 5e 08        LDX   #$5E08
f9b8: 00 8e           NEG   $8E
f9ba: 64 18           LSR   -$8,X
f9bc: 00 0e           NEG   $0E
f9be: 71 28 f8 8e     OIM   #$28,$F88E
f9c2: 60 f0           NEG   [,--W]
f9c4: f0 0e 62        SUBB  $0E62
f9c7: f0 d8 0e        SUBB  $D80E
f9ca: 63 e0           COM   ,S+
f9cc: d8 0e           EORB  $0E
f9ce: 77 d8 d8        ASR   $D8D8
f9d1: 0e 7c           JMP   $7C
f9d3: c8 d0           EORB  #$D0
f9d5: 0a 8e           DEC   $8E
f9d7: 66 10           ROR   -$10,X
f9d9: f8 8e 68        EORB  $8E68
f9dc: 20 f8           BRA   $F9D6
f9de: 8e 6a d8        LDX   #$6AD8
f9e1: e0 8e           SUBB  W,X
f9e3: 6c e8 f0        INC   -$10,S
f9e6: 0e 70           JMP   $70
f9e8: e8 d8 8e        EORB  [-$72,U]
f9eb: 6e f8 f0        JMP   [-$10,S]
f9ee: 0e 77           JMP   $77
f9f0: c8 d0           EORB  #$D0
f9f2: 0e 77           JMP   $77
f9f4: b8 c8 0e        EORA  $C80E
f9f7: 77 a8 c0        ASR   $A8C0
f9fa: 0e 7c           JMP   $7C
f9fc: 98 b8           EORA  $B8
f9fe: 08 8e           ASL   $8E
fa00: 78 10 00        ASL   $1000
fa03: 8e 7a 20        LDX   #$7A20
fa06: 00 8e           NEG   $8E
fa08: 72 e8 f0 0e     AIM   #$E8,$F00E
fa0c: 76 e8 d8        ROR   $E8D8
fa0f: 8e 74 f8        LDX   #$74F8
fa12: f0 0e 77        SUBB  $0E77
fa15: d8 d8           EORB  $D8
fa17: 0e 77           JMP   $77
fa19: c8 d0           EORB  #$D0
fa1b: 0e 7c           JMP   $7C
fa1d: b8 c8 fa        EORA  $C8FA
fa20: 25 fa           BCS   $FA1C
fa22: 56              RORB
fa23: fa 6f 0c        ORB   $6F0C
fa26: 82 46           SBCA  #$46
fa28: e8 50           EORB  -$10,U
fa2a: 82 48           SBCA  #$48
fa2c: e8 30           EORB  -$10,Y
fa2e: 82 4a           SBCA  #$4A
fa30: e8 10           EORB  -$10,X
fa32: 82 4c           SBCA  #$4C
fa34: f8 50 82        EORB  $5082
fa37: 4e              FCB   $4E
fa38: f8 30 82        EORB  $3082
fa3b: 50              NEGB
fa3c: f8 10 c2        EORB  $10C2
fa3f: 4c              INCA
fa40: 08 50           ASL   $50
fa42: c2 4e           SBCB  #$4E
fa44: 08 30           ASL   $30
fa46: c2 50           SBCB  #$50
fa48: 08 10           ASL   $10
fa4a: c2 46           SBCB  #$46
fa4c: 18              FCB   $18
fa4d: 50              NEGB
fa4e: c2 48           SBCB  #$48
fa50: 18              FCB   $18
fa51: 30 c2           LEAX  ,-U
fa53: 4a              DECA
fa54: 18              FCB   $18
fa55: 10 06           FCB   $10,$06
fa57: 82 3a           SBCA  #$3A
fa59: e8 50           EORB  -$10,U
fa5b: 82 3c           SBCA  #$3C
fa5d: e8 30           EORB  -$10,Y
fa5f: 82 3e           SBCA  #$3E
fa61: e8 10           EORB  -$10,X
fa63: c2 3a           SBCB  #$3A
fa65: 18              FCB   $18
fa66: 50              NEGB
fa67: c2 3c           SBCB  #$3C
fa69: 18              FCB   $18
fa6a: 30 c2           LEAX  ,-U
fa6c: 3e              FCB   $3E
fa6d: 18              FCB   $18
fa6e: 10 06           FCB   $10,$06
fa70: 82 40           SBCA  #$40
fa72: e8 50           EORB  -$10,U
fa74: 82 42           SBCA  #$42
fa76: e8 30           EORB  -$10,Y
fa78: 82 44           SBCA  #$44
fa7a: e8 10           EORB  -$10,X
fa7c: c2 40           SBCB  #$40
fa7e: 18              FCB   $18
fa7f: 50              NEGB
fa80: c2 42           SBCB  #$42
fa82: 18              FCB   $18
fa83: 30 c2           LEAX  ,-U
fa85: 44              LSRA
fa86: 18              FCB   $18
fa87: 10 fa           FCB   $10,$FA
fa89: 8c fa b5        CMPX  #$FAB5
fa8c: 0a 02           DEC   $02
fa8e: ec f0           LDD   [,--W]
fa90: 48              ASLA
fa91: 02 ec f0        AIM   #$EC;$F0
fa94: 38              FCB   $38
fa95: 82 ec           SBCA  #$EC
fa97: f0 20 02        SUBB  $2002
fa9a: f2 f0 08        SBCB  $F008
fa9d: 82 e8           SBCA  #$E8
fa9f: 00 40           NEG   $40
faa1: 82 ee           SBCA  #$EE
faa3: 00 20           NEG   $20
faa5: 02 f3 00        AIM   #$F3;$00
faa8: 08 82           ASL   $82
faaa: ea 10           ORB   -$10,X
faac: 40              NEGA
faad: 82 f0           SBCA  #$F0
faaf: 10 20           FCB   $10,$20
fab1: 02 f4 10        AIM   #$F4;$10
fab4: 08 06           ASL   $06
fab6: 82 f6           SBCA  #$F6
fab8: f0 40 82        SUBB  $4082
fabb: f8 f0 20        EORB  $F020
fabe: 02 f5 f0        AIM   #$F5;$F0
fac1: 08 82           ASL   $82
fac3: fa 10 40        ORB   $1040
fac6: 82 fc           SBCA  #$FC
fac8: 10 20           FCB   $10,$20
faca: 02 fe 10        AIM   #$FE;$10
facd: 08 fa           ASL   $FA
facf: d6 fa           LDB   $FA
fad1: dd fa           STD   $FA
fad3: ee fa           LDU   [F,S]
fad5: fb c2 8a        ADDB  $C28A
fad8: a0 f8 10        SUBA  [$10,S]
fadb: 08 10           ASL   $10
fadd: 04 0e           LSR   $0E
fadf: dc f8           LDD   $F8
fae1: 18              FCB   $18
fae2: 0e da           JMP   $DA
fae4: f8 08 0e        EORB  $080E
fae7: de 08           LDU   $08
fae9: 18              FCB   $18
faea: 0e db           JMP   $DB
faec: 08 08           ASL   $08
faee: 03 0d           COM   $0D
faf0: fb 00 38        ADDB  >$0038
faf3: 0d fc           TST   $FC
faf5: 00 28           NEG   $28
faf7: 8e de 00        LDX   #$DE00
fafa: 10 03           FCB   $10,$03
fafc: 0d fd           TST   $FD
fafe: 00 38           NEG   $38
fb00: 0d fe           TST   $FE
fb02: 00 28           NEG   $28
fb04: 8e dc 00        LDX   #$DC00
fb07: 10 fb           FCB   $10,$FB
fb09: 16 fb 1f        LBRA  $F62B
fb0c: fb 28 fb        ADDB  $28FB
fb0f: 35 fb           PULS  CC,A,DP,X,Y,U,PC
fb11: 50              NEGB
fb12: fb 5f fb        ADDB  $5FFB
fb15: 82 02           SBCA  #$02
fb17: 0e da           JMP   $DA
fb19: f8 08 0e        EORB  $080E
fb1c: db 08           ADDB  $08
fb1e: 08 02           ASL   $02
fb20: 8e dc f8        LDX   #$DCF8
fb23: 10 8e de 08     LDY   #$DE08
fb27: 10 03           FCB   $10,$03
fb29: 8e e8 08        LDX   #$E808
fb2c: f0 0e eb        SUBB  $0EEB
fb2f: 18              FCB   $18
fb30: f8 0e ec        EORB  $0EEC
fb33: 18              FCB   $18
fb34: e8 26           EORB  $6,Y
fb36: fb 44 0e        ADDB  $440E
fb39: f1 8e f2        CMPB  $8EF2
fb3c: 0e f5           JMP   $F5
fb3e: 8e f6 8e        LDX   #$F68E
fb41: f8 0e fa        EORB  $0EFA
fb44: 08 f8           ASL   $F8
fb46: 08 e0           ASL   $E0
fb48: 18              FCB   $18
fb49: f8 18 e0        EORB  $18E0
fb4c: 28 f0           BVC   $FB3E
fb4e: 28 d8           BVC   $FB28
fb50: 26 fb           BNE   $FB4D
fb52: 44              LSRA
fb53: 0e e3           JMP   $E3
fb55: 8e e4 0e        LDX   #$E40E
fb58: e7 8e           STB   W,X
fb5a: e8 8e           EORB  W,X
fb5c: ea 0e           ORB   $E,X
fb5e: ec 28           LDD   $8,Y
fb60: fb 72 8e        ADDB  $728E
fb63: ee 0e           LDU   $E,X
fb65: fb 8e f0        ADDB  $8EF0
fb68: 8e f2 8e        LDX   #$F28E
fb6b: f4 8e f6        ANDB  $8EF6
fb6e: 8e f8 0e        LDX   #$F80E
fb71: fa 08 f0        ORB   $08F0
fb74: 08 d8           ASL   $D8
fb76: 18              FCB   $18
fb77: f0 18 d0        SUBB  $18D0
fb7a: 28 f0           BVC   $FB6C
fb7c: 28 d0           BVC   $FB4E
fb7e: 38              FCB   $38
fb7f: e0 38           SUBB  -$8,Y
fb81: c8 28           EORB  #$28
fb83: fb 72 8e        ADDB  $728E
fb86: e0 0e           SUBB  $E,X
fb88: ed 8e           STD   W,X
fb8a: e2 8e           SBCB  W,X
fb8c: e4 8e           ANDB  W,X
fb8e: e6 8e           LDB   W,X
fb90: e8 8e           EORB  W,X
fb92: ea 0e           ORB   $E,X
fb94: ec fb           LDD   [D,S]
fb96: 9d fb           JSR   $FB
fb98: ce fb ff        LDU   #$FBFF
fb9b: fc 34 0c        LDD   $340C
fb9e: 85 ec           BITA  #$EC
fba0: f0 40 05        SUBB  $4005
fba3: f2 f0 28        SBCB  $F028
fba6: 05 f2 f0        EIM   #$F2;$F0
fba9: 18              FCB   $18
fbaa: 05 f4 f0        EIM   #$F4;$F0
fbad: 08 85           ASL   $85
fbaf: ee 00           LDU   $0,X
fbb1: 40              NEGA
fbb2: 05 ef 00        EIM   #$EF;$00
fbb5: 28 05           BVC   $FBBC
fbb7: ef 00           STU   $0,X
fbb9: 18              FCB   $18
fbba: 05 f5 00        EIM   #$F5;$00
fbbd: 08 85           ASL   $85
fbbf: f0 10 40        SUBB  $1040
fbc2: 05 f1 10        EIM   #$F1;$10
fbc5: 28 05           BVC   $FBCC
fbc7: f1 10 18        CMPB  $1018
fbca: 05 f6 10        EIM   #$F6;$10
fbcd: 08 0c           ASL   $0C
fbcf: 85 ec           BITA  #$EC
fbd1: f0 40 05        SUBB  $4005
fbd4: f2 f0 28        SBCB  $F028
fbd7: 05 f2 f0        EIM   #$F2;$F0
fbda: 18              FCB   $18
fbdb: 05 f4 f0        EIM   #$F4;$F0
fbde: 08 85           ASL   $85
fbe0: ee 00           LDU   $0,X
fbe2: 40              NEGA
fbe3: 05 ef 00        EIM   #$EF;$00
fbe6: 28 05           BVC   $FBED
fbe8: ef 00           STU   $0,X
fbea: 18              FCB   $18
fbeb: 05 f5 00        EIM   #$F5;$00
fbee: 08 85           ASL   $85
fbf0: ea 10           ORB   -$10,X
fbf2: 40              NEGA
fbf3: 05 eb 10        EIM   #$EB;$10
fbf6: 28 05           BVC   $FBFD
fbf8: eb 10           ADDB  -$10,X
fbfa: 18              FCB   $18
fbfb: 05 f3 10        EIM   #$F3;$10
fbfe: 08 0d           ASL   $0D
fc00: 85 ec           BITA  #$EC
fc02: f0 40 05        SUBB  $4005
fc05: f2 f0 28        SBCB  $F028
fc08: 05 f2 f0        EIM   #$F2;$F0
fc0b: 18              FCB   $18
fc0c: 05 f4 f0        EIM   #$F4;$F0
fc0f: 08 85           ASL   $85
fc11: f8 00 40        EORB  >$0040
fc14: 05 f9 00        EIM   #$F9;$00
fc17: 28 05           BVC   $FC1E
fc19: f9 00 18        ADCB  >$0018
fc1c: 05 f7 00        EIM   #$F7;$00
fc1f: 08 05           ASL   $05
fc21: fa 10 48        ORB   $1048
fc24: 05 fb 10        EIM   #$FB;$10
fc27: 38              FCB   $38
fc28: 05 fb 10        EIM   #$FB;$10
fc2b: 28 05           BVC   $FC32
fc2d: fb 10 18        ADDB  $1018
fc30: 05 fe 10        EIM   #$FE;$10
fc33: 08 08           ASL   $08
fc35: 85 fc           BITA  #$FC
fc37: f0 40 05        SUBB  $4005
fc3a: fd f0 28        STD   $F028
fc3d: 05 fd f0        EIM   #$FD;$F0
fc40: 18              FCB   $18
fc41: 05 ff f0        EIM   #$FF;$F0
fc44: 08 85           ASL   $85
fc46: fa 00 40        ORB   >$0040
fc49: 05 fb 00        EIM   #$FB;$00
fc4c: 28 05           BVC   $FC53
fc4e: fb 00 18        ADDB  >$0018
fc51: 05 fe 00        EIM   #$FE;$00
fc54: 08 fc           ASL   $FC
fc56: 57              ASRB
fc57: 06 0b           ROR   $0B
fc59: f7 d8 f0        STB   $D8F0
fc5c: 0b f8 e8        TIM   #$F8;$E8
fc5f: f0 8b fa        SUBB  $8BFA
fc62: f8 08 0b        EORB  $080B
fc65: f9 f8 f0        ADCB  $F8F0
fc68: 8b fc           ADDA  #$FC
fc6a: 08 08           ASL   $08
fc6c: 0b fe 18        TIM   #$FE;$18
fc6f: 10 fc 7a fc     LDQ   $7AFC
fc73: bf fc f4        STX   $FCF4
fc76: fd 35 fd        STD   $35FD
fc79: 66 11           ROR   -$F,X
fc7b: 0f 4a           CLR   $4A
fc7d: f0 48 0f        SUBB  $480F
fc80: 4a              DECA
fc81: f0 38 0f        SUBB  $380F
fc84: 4a              DECA
fc85: f0 28 0f        SUBB  $280F
fc88: 4a              DECA
fc89: f0 18 0f        SUBB  $180F
fc8c: 4a              DECA
fc8d: f0 08 0f        SUBB  $080F
fc90: 68 f0           ASL   [,--W]
fc92: f8 0f 4a        EORB  $0F4A
fc95: 00 48           NEG   $48
fc97: 0f 4b           CLR   $4B
fc99: 00 38           NEG   $38
fc9b: 0f 4c           CLR   $4C
fc9d: 00 28           NEG   $28
fc9f: 0f 4d           CLR   $4D
fca1: 00 18           NEG   $18
fca3: 0f 4a           CLR   $4A
fca5: 00 08           NEG   $08
fca7: 0f 69           CLR   $69
fca9: 00 f8           NEG   $F8
fcab: 0f 4a           CLR   $4A
fcad: 10 48           ASLD
fcaf: 0f 4a           CLR   $4A
fcb1: 10 38           PSHSW
fcb3: 0f 4a           CLR   $4A
fcb5: 10 28 0f 4a     LBVC  $0C03
fcb9: 10 18           FCB   $10,$18
fcbb: 0f 4a           CLR   $4A
fcbd: 10 08           FCB   $10,$08
fcbf: 0d 8f           TST   $8F
fcc1: 4e              FCB   $4E
fcc2: f0 40 8f        SUBB  $408F
fcc5: 50              NEGB
fcc6: f0 20 0f        SUBB  $200F
fcc9: 59              ROLB
fcca: f0 08 0f        SUBB  $080F
fccd: 6a f0           DEC   [,--W]
fccf: f8 8f 52        EORB  $8F52
fcd2: 00 40           NEG   $40
fcd4: 8f              FCB   $8F
fcd5: 54              LSRB
fcd6: 00 20           NEG   $20
fcd8: 0f 5a           CLR   $5A
fcda: 00 08           NEG   $08
fcdc: 0f 6b           CLR   $6B
fcde: 00 f8           NEG   $F8
fce0: 0f 4a           CLR   $4A
fce2: 10 48           ASLD
fce4: 0f 56           CLR   $56
fce6: 10 38           PSHSW
fce8: 8f              FCB   $8F
fce9: 57              ASRB
fcea: 10 20           FCB   $10,$20
fcec: 0f 4a           CLR   $4A
fcee: 10 08           FCB   $10,$08
fcf0: 0f 6c           CLR   $6C
fcf2: 10 f8           FCB   $10,$F8
fcf4: 10 0f           FCB   $10,$0F
fcf6: 4e              FCB   $4E
fcf7: f0 48 0f        SUBB  $480F
fcfa: 5b              FCB   $5B
fcfb: f0 38 8f        SUBB  $388F
fcfe: 5c              INCB
fcff: f0 20 0f        SUBB  $200F
fd02: 5e              FCB   $5E
fd03: f0 08 8f        SUBB  $088F
fd06: 6e f0           JMP   [,--W]
fd08: f0 0f 5f        SUBB  $0F5F
fd0b: 00 48           NEG   $48
fd0d: 0f 60           CLR   $60
fd0f: 00 58           NEG   $58
fd11: 0f 63           CLR   $63
fd13: 00 18           NEG   $18
fd15: 0f 64           CLR   $64
fd17: 00 08           NEG   $08
fd19: 0f 6d           CLR   $6D
fd1b: 00 f8           NEG   $F8
fd1d: 0f 61           CLR   $61
fd1f: 10 48           ASLD
fd21: 0f 62           CLR   $62
fd23: 10 38           PSHSW
fd25: 0f 65           CLR   $65
fd27: 10 28 0f 66     LBVC  $0C91
fd2b: 10 18           FCB   $10,$18
fd2d: 0f 67           CLR   $67
fd2f: 10 08           FCB   $10,$08
fd31: 8f              FCB   $8F
fd32: 70 10 f0        NEG   $10F0
fd35: 0c 0f           INC   $0F
fd37: 4e              FCB   $4E
fd38: f0 48 8f        SUBB  $488F
fd3b: 72 f0 30 8f     AIM   #$F0,$308F
fd3f: 74 f0 10        LSR   $F010
fd42: 8f              FCB   $8F
fd43: 80 f0           SUBA  #$F0
fd45: f0 8f 76        SUBB  $8F76
fd48: 00 40           NEG   $40
fd4a: 8f              FCB   $8F
fd4b: 78 00 20        ASL   >$0020
fd4e: 0f 7f           CLR   $7F
fd50: 00 08           NEG   $08
fd52: 8f              FCB   $8F
fd53: 82 00           SBCA  #$00
fd55: f0 8f 7a        SUBB  $8F7A
fd58: 10 40           NEGD
fd5a: 8f              FCB   $8F
fd5b: 7c 10 20        INC   $1020
fd5e: 0f 7e           CLR   $7E
fd60: 10 08           FCB   $10,$08
fd62: 8f              FCB   $8F
fd63: 84 10           ANDA  #$10
fd65: f0 c3 8f        SUBB  $C38F
fd68: 80 f0           SUBA  #$F0
fd6a: f0 00 f0        SUBB  >$00F0
fd6d: 10 f0           FCB   $10,$F0
fd6f: fd 81 fd        STD   $81FD
fd72: 8a fd           ORA   #$FD
fd74: 8f              FCB   $8F
fd75: fd 98 fd        STD   $98FD
fd78: 9d fd           JSR   $FD
fd7a: a2 fd a7 fd     SBCA  [$A57B,PCR]
fd7e: ac fd b1 02     CMPX  [$AE84,PCR]
fd82: 04 f9           LSR   $F9
fd84: 00 00           NEG   $00
fd86: 02 ff 00        AIM   #$FF;$00
fd89: d8 01           EORB  $01
fd8b: 03 fd           COM   $FD
fd8d: 00 00           NEG   $00
fd8f: 02 84 fa        AIM   #$84;$FA
fd92: f8 00 84        EORB  >$0084
fd95: fc 08 00        LDD   $0800
fd98: 01 03 f9        OIM   #$03;$F9
fd9b: 00 00           NEG   $00
fd9d: 01 03 fa        OIM   #$03;$FA
fda0: 00 00           NEG   $00
fda2: 01 03 fb        OIM   #$03;$FB
fda5: 00 00           NEG   $00
fda7: 01 03 fc        OIM   #$03;$FC
fdaa: 00 00           NEG   $00
fdac: 01 03 fd        OIM   #$03;$FD
fdaf: 00 00           NEG   $00
fdb1: 01 03 fe        OIM   #$03;$FE
fdb4: 00 00           NEG   $00
fdb6: fd b8 09        STD   $B809
fdb9: 03 e8           COM   $E8
fdbb: f0 08 03        SUBB  $0803
fdbe: e9 00           ADCB  $0,X
fdc0: 08 03           ASL   $03
fdc2: ea 10           ORB   -$10,X
fdc4: 08 03           ASL   $03
fdc6: e8 00           EORB  $0,X
fdc8: 18              FCB   $18
fdc9: 03 e9           COM   $E9
fdcb: 10 18           FCB   $10,$18
fdcd: 03 ea           COM   $EA
fdcf: 20 18           BRA   $FDE9
fdd1: 03 e8           COM   $E8
fdd3: 10 28 03 e9     LBVC  $01C0
fdd7: 20 28           BRA   $FE01
fdd9: 03 ea           COM   $EA
fddb: 30 28           LEAX  $8,Y
fddd: fe 11 fe        LDU   $11FE
fde0: 20 fe           BRA   $FDE0
fde2: 25 fe           BCS   $FDE2
fde4: 32 fe           LEAS  [W,S]
fde6: 4f              CLRA
fde7: fe 6a fe        LDU   $6AFE
fdea: 79 fe 98        ROL   $FE98
fded: fe a9 fe        LDU   $A9FE
fdf0: b4 fe bc        ANDA  $FEBC
fdf3: fe c1 fe        LDU   $C1FE
fdf6: c9 fe           ADCB  #$FE
fdf8: f4 ff 1b        ANDB  $FF1B
fdfb: ff 3a ff        STU   $3AFF
fdfe: 4b              FCB   $4B
fdff: ff 62 ff        STU   $62FF
fe02: 77 ff 88        ASR   $FF88
fe05: ff 99 ff        STU   $99FF
fe08: b4 ff c3        ANDA  $FFC3
fe0b: ff c8 ff        STU   $C8FF
fe0e: cd ff d6 23 fe  LDQ   #$FFD623FE
fe13: 1a 8f           ORCC  #$8F
fe15: ca 8f           ORB   #$8F
fe17: cc 0f d9        LDD   #$0FD9
fe1a: 00 30           NEG   $30
fe1c: 00 10           NEG   $10
fe1e: 10 30 e3        ADDR  E,U
fe21: 8f              FCB   $8F
fe22: ce fe 1a        LDU   #$FE1A
fe25: 03 8f           COM   $8F
fe27: d4 00           ANDB  $00
fe29: 10 8f           FCB   $10,$8F
fe2b: d6 10           LDB   $10
fe2d: 20 0f           BRA   $FE3E
fe2f: d8 10           EORB  $10
fe31: 08 07           ASL   $07
fe33: af e2           STX   ,-S
fe35: 08 20           ASL   $20
fe37: 2f e7           BLE   $FE20
fe39: 08 08           ASL   $08
fe3b: af e4           STX   ,S
fe3d: 18              FCB   $18
fe3e: 20 2f           BRA   $FE6F
fe40: e6 18           LDB   -$8,X
fe42: 08 8f           ASL   $8F
fe44: de 00           LDU   $00
fe46: 20 0f           BRA   $FE57
fe48: e0 00           SUBB  $0,X
fe4a: 08 0f           ASL   $0F
fe4c: dd 10           STD   $10
fe4e: 28 26           BVC   $FE76
fe50: fe 5e af        LDU   $5EAF
fe53: e8 a7           EORB  E,Y
fe55: 02 a7 04        AIM   #$A7;$04
fe58: a7 06           STA   $6,X
fe5a: 8f              FCB   $8F
fe5b: da 0f           ORB   $0F
fe5d: dc f8           LDD   $F8
fe5f: 30 f8 10        LEAX  [$10,S]
fe62: 08 30           ASL   $30
fe64: 08 10           ASL   $10
fe66: fc 2e fc        LDD   $2EFC
fe69: 16 26 fe        LBRA  $256A
fe6c: 5e              FCB   $5E
fe6d: af e8 a7        STX   -$59,S
fe70: 10 a7 04        STW   $4,X
fe73: a7 12           STA   -$E,X
fe75: 8f              FCB   $8F
fe76: da 0f           ORB   $0F
fe78: dc 27           LDD   $27
fe7a: fe 8a af        LDU   $8AAF
fe7d: ea a7           ORB   E,Y
fe7f: 0a 27           DEC   $27
fe81: 0c 2f           INC   $2F
fe83: e1 a7           CMPB  E,Y
fe85: 0e 8f           JMP   $8F
fe87: da 0f           ORB   $0F
fe89: dc f8           LDD   $F8
fe8b: 30 f8 10        LEAX  [$10,S]
fe8e: 08 38           ASL   $38
fe90: 08 28           ASL   $28
fe92: 08 10           ASL   $10
fe94: fd 2e fd        STD   $2EFD
fe97: 16 27 fe        LBRA  $2698
fe9a: 8a af           ORA   #$AF
fe9c: ea a7           ORB   E,Y
fe9e: 14              SEXW
fe9f: 27 0c           BEQ   $FEAD
fea1: 2f e1           BLE   $FE84
fea3: a7 16           STA   -$A,X
fea5: 8f              FCB   $8F
fea6: da 0f           ORB   $0F
fea8: dc c4           LDD   $C4
feaa: 83 48 f8        SUBD  #$48F8
fead: 30 f8 10        LEAX  [$10,S]
feb0: 08 30           ASL   $30
feb2: 08 10           ASL   $10
feb4: a4 83           ANDA  ,--X
feb6: fe ac 48        LDU   $AC48
feb9: 50              NEGB
feba: 4c              INCA
febb: 52              FCB   $52
febc: e4 83           ANDB  ,--X
febe: 54              LSRB
febf: fe ac a4        LDU   $ACA4
fec2: 83 fe ac        SUBD  #$FEAC
fec5: 54              LSRB
fec6: 5c              INCB
fec7: 58              ASLB
fec8: 5e              FCB   $5E
fec9: 2a fe           BPL   $FEC9
fecb: e0 1f           SUBB  -$1,X
fecd: ec 9f f4 1f     LDD   [$F41F]
fed1: ef 1f           STU   -$1,X
fed3: f0 9f f6        SUBB  $9FF6
fed6: 1f f3           TFR   F,U
fed8: 83 48 83        SUBD  #$4883
fedb: 50              NEGB
fedc: 83 4c 83        SUBD  #$4C83
fedf: 52              FCB   $52
fee0: 0a 38           DEC   $38
fee2: 0a 20           DEC   $20
fee4: 0a 08           DEC   $08
fee6: 1a 38           ORCC  #$38
fee8: 1a 20           ORCC  #$20
feea: 1a 08           ORCC  #$08
feec: f8 30 f8        EORB  $30F8
feef: 10 08           FCB   $10,$08
fef1: 30 08           LEAX  $8,X
fef3: 10 29 ff 09     LBVS  $FE00
fef7: 1f ec           TFR   E,0
fef9: 9f f4           STX   $F4
fefb: 1f ef           TFR   E,F
fefd: 1f f0           TFR   F,D
feff: 9f f6           STX   $F6
ff01: 1f f3           TFR   F,U
ff03: 87              FCB   $87
ff04: f2 87 f4        SBCB  $87F4
ff07: 87              FCB   $87
ff08: f6 0a 38        LDB   $0A38
ff0b: 0a 20           DEC   $20
ff0d: 0a 08           DEC   $08
ff0f: 1a 38           ORCC  #$38
ff11: 1a 20           ORCC  #$20
ff13: 1a 08           ORCC  #$08
ff15: 08 30           ASL   $30
ff17: 08 10           ASL   $10
ff19: 18              FCB   $18
ff1a: 30 27           LEAX  $7,Y
ff1c: ff 2c 9f        STU   $2C9F
ff1f: ec 9f ee 9f     LDD   [$EE9F]
ff23: f0 9f f2        SUBB  $9FF2
ff26: 87              FCB   $87
ff27: f8 87 fa        EORB  $87FA
ff2a: 87              FCB   $87
ff2b: fc 0a 30        LDD   $0A30
ff2e: 0a 10           DEC   $10
ff30: 1a 30           ORCC  #$30
ff32: 1a 10           ORCC  #$10
ff34: 08 30           ASL   $30
ff36: 08 10           ASL   $10
ff38: 18              FCB   $18
ff39: 30 27           LEAX  $7,Y
ff3b: ff 2c 9f        STU   $2C9F
ff3e: ec 9f ee 9f     LDD   [$EE9F]
ff42: f0 9f f2        SUBB  $9FF2
ff45: 87              FCB   $87
ff46: f2 87 f4        SBCB  $87F4
ff49: 87              FCB   $87
ff4a: f6 2a fe        LDB   $2AFE
ff4d: e0 0f           SUBB  $F,X
ff4f: ec 8f           LDD   ,W
ff51: f4 0f ef        ANDB  $0FEF
ff54: 0f f0           CLR   $F0
ff56: 8f              FCB   $8F
ff57: f6 0f f3        LDB   $0FF3
ff5a: 83 48 83        SUBD  #$4883
ff5d: 50              NEGB
ff5e: 83 4c 83        SUBD  #$4C83
ff61: 52              FCB   $52
ff62: 29 ff           BVS   $FF63
ff64: 09 0f           ROL   $0F
ff66: ec 8f           LDD   ,W
ff68: f4 0f ef        ANDB  $0FEF
ff6b: 0f f0           CLR   $F0
ff6d: 8f              FCB   $8F
ff6e: f6 0f f3        LDB   $0FF3
ff71: 87              FCB   $87
ff72: f2 87 f4        SBCB  $87F4
ff75: 87              FCB   $87
ff76: f6 27 ff        LDB   $27FF
ff79: 2c 8f           BGE   $FF0A
ff7b: ec 8f           LDD   ,W
ff7d: ee 8f           LDU   ,W
ff7f: f0 8f f2        SUBB  $8FF2
ff82: 87              FCB   $87
ff83: f8 87 fa        EORB  $87FA
ff86: 87              FCB   $87
ff87: fc 27 ff        LDD   $27FF
ff8a: 2c 8f           BGE   $FF1B
ff8c: ec 8f           LDD   ,W
ff8e: ee 8f           LDU   ,W
ff90: f0 8f f2        SUBB  $8FF2
ff93: 87              FCB   $87
ff94: f2 87 f4        SBCB  $87F4
ff97: 87              FCB   $87
ff98: f6 26 ff        LDB   $26FF
ff9b: a8 1f           EORA  -$1,X
ff9d: ec 9f f4 1f     LDD   [$F41F]
ffa1: ef 1f           STU   -$1,X
ffa3: f0 9f f6        SUBB  $9FF6
ffa6: 1f f3           TFR   F,U
ffa8: f8 38 f8        EORB  $38F8
ffab: 20 f8           BRA   $FFA5
ffad: 08 08           ASL   $08
ffaf: 38              FCB   $38
ffb0: 08 20           ASL   $20
ffb2: 08 08           ASL   $08
ffb4: 26 ff           BNE   $FFB5
ffb6: a8 0f           EORA  $F,X
ffb8: ec 8f           LDD   ,W
ffba: f4 0f ef        ANDB  $0FEF
ffbd: 0f f0           CLR   $F0
ffbf: 8f              FCB   $8F
ffc0: f6 0f f3        LDB   $0FF3
ffc3: 01 07 fe        OIM   #$07;$FE
ffc6: 00 00           NEG   $00
ffc8: 01 07 ff        OIM   #$07;$FF
ffcb: 00 00           NEG   $00
ffcd: 02 18 00        AIM   #$18;$00
ffd0: f8 00 18        EORB  >$0018
ffd3: 01 08 00        OIM   #$08;$00
ffd6: 02 08 02        AIM   #$08;$02
ffd9: f8 00 08        EORB  >$0008
ffdc: 03 08           COM   $08
ffde: 00 00           NEG   $00
ffe0: 00 00           NEG   $00
ffe2: 00 00           NEG   $00
ffe4: 00 00           NEG   $00
ffe6: 00 00           NEG   $00
ffe8: 00 00           NEG   $00
ffea: c0 00           SUBB  #$00
ffec: c0 01           SUBB  #$01
ffee: c0 02           SUBB  #$02
fff0: 80 00           SUBA  #$00
fff2: 80 00           SUBA  #$00
fff4: 80 00           SUBA  #$00
fff6: 88 85           EORA  #$85
fff8: 88 0d           EORA  #$0D
fffa: 80 00           SUBA  #$00
fffc: 80 00           SUBA  #$00
fffe: 80 00           SUBA  #$00
