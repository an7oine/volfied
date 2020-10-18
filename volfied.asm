#include "usgard.h"

wtemp	= TEXT_MEM2
btemp	= wtemp+2
P2nd	= btemp+1
koord0	= P2nd+1
koord1	= koord0+2
pros	= koord1+2
taso	= pros+1
elamat	= taso+1
pisteet	= elamat+1
ajastin	= pisteet+2
pulssi0	= ajastin+1
pulssi1	= pulssi0+2
bonus	= pulssi1+2
b_aika	= bonus+1
aika	= b_aika+2
am_hl	= aika+2
am_a	= am_hl+2
am_bc	= am_a+1
am_funk	= am_bc+2
am_de	= am_funk+2
chr_num	= am_de+2
chrs 	= chr_num+1

.org 0

.db	"Volfied",0

MAIN:
	ld	hl,&KeskeytysFunktio
	call	INT_INSTALL
	call	c,OTH_EXIT
	
	ld	hl,&TalletusNimi
	call	VAR_GET
	jr	c,MAIN_0
	
	push	hl
	ld	hl,GRAPH_MEM
	ld	bc,1023
	call	OTH_CLEAR
	pop	hl
	ld	de,GRAPH_MEM+$30
	ld	bc,53*16
	ldir
	ld	de,koord0
	ld	bc,chrs-koord0+60
	ldir
	ld	hl,&TalletusNimi
	call	VAR_DELETE
	call	&TulostaKaikki
	jp	&MAIN_loop_7

MAIN_0:
	call	CLEARLCD
	ld	hl,&_logoLoppu-1
	ld	b,25
MAIN_loop_0:
	push	bc
	push	hl
	ld	de,$FFFF
	ld	hl,$FFEF
	ld	bc,$03F0
	lddr	
	pop	hl
	ld	de,VIDEO_MEM+11
	ld	bc,8
	lddr	
MAIN_loop_1:
	ld	a,(ajastin)
	and	7
	jr	nz,MAIN_loop_1
	pop	bc
	djnz	MAIN_loop_0
	ld	hl,$0262
	ld	(CURSOR_X),hl
	ld	a,42
	call	M_CHARPUT
	ld	hl,&ParasPelaaja
	ld	b,3
	call	D_LM_STR
	ld	a,42
	call	M_CHARPUT
	ld	de,$0864
	ld	(CURSOR_X),de
	call	LD_HL_MHL
	call	DM_HL_DECI
	ld	hl,$1A04
	ld	(CURSOR_X),hl
	ld	hl,&AlkuTeksti
MAIN_loop_2:
	ld	a,(hl)
	cp	255
	jr	z,MAIN_loop_3
	call	D_ZM_STR
	ld	de,(CURSOR_X)
	ld	a,6
	add	a,d
	ld	d,a
	ld	e,16
	ld	(CURSOR_X),de
	jr	MAIN_loop_2
MAIN_loop_3:
	call	GET_KEY
	cp	9
	jr	z,MAIN_1
	cp	55
	jr	nz,MAIN_loop_3
	call	INT_REMOVE
	call	OTH_EXIT
MAIN_1:
	xor	a
	ld	(taso),a
	ld	(pisteet),a
	ld	(pisteet+1),a
	ld	a,5
	ld	(elamat),a
MAIN_2:
	ld	hl,&AlkuData
	ld	de,chrs
	ld	bc,8
	ldir	
	ld	(pulssi0),bc
	push	de
	ld	hl,$0FA0
	ld	(aika),hl
	ld	hl,&_kentat+1
	ld	a,(taso)
	rlca	
	ld	d,0
	ld	e,a
	add	hl,de
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	add	hl,de
	pop	de
	ld	b,(hl)
	inc	hl
	ld	a,(hl)
	inc	hl
	push	af
	add	a,b
	inc	a
	inc	a
	ld	(chr_num),a
MAIN_loop_4:
	ld	a,32
	ld	(de),a
	inc	de
	ld	a,64
	ld	(de),a
	inc	de
	ld	a,2
	ld	(de),a
	inc	de
	ld	a,17
	ld	(de),a
	inc	de
	djnz	MAIN_loop_4
	pop	bc
MAIN_loop_5:
	push	bc
	ldi	
	ldi	
	pop	bc
	ld	a,3
	ld	(de),a
	inc	de
	xor	a
	ld	(de),a
	inc	de
	djnz	MAIN_loop_5
	ld	(bonus),a
	ld	(am_a),a
	ld	hl,GRAPH_MEM
	ld	bc,$03FF
	call	OTH_CLEAR
	ld	hl,GRAPH_MEM+48
	call	&AlustaRivi
	ld	b,51
MAIN_loop_6:
	ld	(hl),16
	push	bc
	ld	bc,$000F
	add	hl,bc
	pop	bc
	ld	(hl),16
	inc	hl
	djnz	MAIN_loop_6
	call	&AlustaRivi
	call	&TulostaKaikki
MAIN_loop_7:
	ld	a,(ajastin)
	cp	5
	jr	c,MAIN_loop_7
	xor	a
	ld	(ajastin),a
	ld	hl,(aika)
	ld	a,h
	or	l
	jp	z,&MAIN_8
	dec	hl
	ld	(aika),hl
	ld	a,(am_a)
	or	a
	jp	z,&MAIN_8
	ld	hl,(am_funk)
	ld	(&MAIN_ammusloop+1),hl
	ld	hl,(am_hl)
	ld	d,4
	ld	bc,(am_bc)
MAIN_ammusloop:
	call	0
	ld	e,a
	push	de
	ld	de,(am_de)
	add	hl,de
	ld	de,GRAPH_MEM-VIDEO_MEM
	ex	de,hl
	add	hl,de
	and	(hl)
	ex	de,hl
	pop	de
	jp	nz,&MAIN_7
	ld	a,e
	or	(hl)
	ld	(hl),a
	ld	a,e
	push	de
	ld	de,(am_de)
	sbc	hl,de
	pop	de
	cpl	
	and	(hl)
	ld	(hl),a
	ld	a,e
	dec	d
	ld	(am_a),a
	ld	(am_hl),hl
	jr	nz,MAIN_ammusloop
	ld	(am_bc),bc
	ld	a,b
	and	128
	jr	nz,MAIN_7
	ld	a,c
	and	64
	jr	nz,MAIN_7
	ld	ix,chrs+8
	ld	a,(chr_num)
	ld	l,a
	dec	l
	dec	l
	jr	z,MAIN_8
MAIN_loop_9:
	ld	a,(ix+2)
	cp	2
	jr	nz,MAIN_8
	ld	a,b
	sub	(ix+1)
	jr	nc,MAIN_3
	neg	
MAIN_3:
	cp	3
	jr	nc,MAIN_5
	ld	a,c
	sub	(ix)
	jr	nc,MAIN_4
	neg	
MAIN_4:
	cp	3
	jr	c,MAIN_6
MAIN_5:
	ld	de,$0004
	add	ix,de
	dec	l
	jr	nz,MAIN_loop_9
	jr	MAIN_8
MAIN_6:
	push	ix
	push	hl
	ld	c,(ix)
	ld	b,(ix+1)
	call	&PoistaSprite
	ld	hl,(pisteet)
	ld	de,100
	add	hl,de
	ld	(pisteet),hl
	call	&TulostaPalkki
	ld	a,(chr_num)
	dec	a
	ld	(chr_num),a
	pop	bc
	pop	de
	dec	c
	jr	z,MAIN_7
	xor	a
	ld	b,a
	rl	c
	rl	c
	ld	hl,$0004
	add	hl,de
	ldir	
MAIN_7:
	ld	hl,(am_funk)
	ld	(&MAIN_poistaAmL+1),hl
	ld	hl,(am_hl)
	ld	a,(am_a)
	ld	d,8
MAIN_poistaAmL:
	call	0
	push	af
	cpl	
	and	(hl)
	ld	(hl),a
	pop	af
	dec	d
	jr	nz,MAIN_poistaAmL
	xor	a
	ld	(am_a),a
MAIN_8:
	call	&TulostaAika
	ld	a,(bonus)
	or	a
	jr	z,MAIN_9
	ld	hl,(b_aika)
	dec	hl
	ld	(b_aika),hl
	ld	a,h
	or	a
	jr	nz,MAIN_9
	ld	a,l
	or	a
	jr	nz,MAIN_9
	ld	(bonus),a
MAIN_9:
	ld	a,(chr_num)
	dec	a
	ld	b,a
	ld	e,1
	ld	ix,chrs+4
MAIN_siirraVihL:
	push	bc
	ld	a,(ix+2)
	cp	3
	jr	z,MAIN_10
	push	ix
	call	&SiirraVihollinen
	pop	ix
	jr	MAIN_11
MAIN_10:
	call	&TulostaHahmo
MAIN_11:
	ld	bc,$0004
	add	ix,bc
	pop	bc
	inc	e
	ld	a,(chr_num)
	dec	a
	cp	e
	jr	nc,MAIN_siirraVihL
	ld	de,(pulssi0)
	ld	a,d
	or	e
	jr	z,MAIN_loop_12
	ld	bc,(pulssi1)
	push	bc
	push	de
	call	&PoistaSprite
	ld	a,3
	ld	(btemp),a
	pop	de
	pop	bc
	ld	hl,&Kulje3Eteen
	call	&KuljeReuna
	ld	a,c
	or	a
	jr	z,MAIN_13
	ld	(pulssi0),de
	ld	(pulssi1),bc
	ld	hl,&_spritet
	ld	de,$0020
	add	hl,de
	call	&TulostaSprite
	jr	MAIN_loop_12

;******
Kulje3Eteen:
	ld	a,(btemp)
	dec	a
	ld	(btemp),a
	ret	nz
	scf	
	ret	

MAIN_13:
	call	&Viikate
MAIN_loop_12:
	ld	a,(taso)
	cp	10
	jp	nc,&MAIN_23
	ld	a,(bonus)
	cp	3
	jr	z,MAIN_14
	ld	a,r
	and	8
	jp	z,&MAIN_21
MAIN_14:
	xor	a
	out	(1),a
	in	a,(1)
	push	af
	and	160
	ld	(P2nd),a
	pop	af
	bit	6,a
	jp	z,&MAIN_23
	bit	4,a
	jr	nz,MAIN_15
MAIN_PauseLoop0:
	call	GET_KEY
	or	a
	jr	nz,MAIN_PauseLoop0
	ld	hl,$3A07
	ld	(CURSOR_X),hl
	ld	hl,&PauseTeksti
	call	D_ZM_STR
MAIN_loop_13:
	call	GET_KEY
	or	a
	jr	z,MAIN_loop_13
	cp	K_F1
	jr	nz,MAIN_loop_12

	ld	hl,&TalletusNimi
	push	hl
	call	VAR_GET
	pop	de
	jr	nc,MAIN_talleta
	ex	de,hl
	push	hl
	ld	a,$0C
	ld	bc,(53*16)+chrs-koord0+60
	call	VAR_NEW
	pop	hl
	jr	c,MAIN_loop_13
	call	VAR_GET
MAIN_talleta:
	ex	de,hl
	ld	hl,GRAPH_MEM+$30
	ld	bc,53*16
	ldir
	ld	hl,koord0
	ld	bc,chrs-koord0+60
	ldir
	call	INT_REMOVE
	ld	hl,USG_BITS
	set	1,(hl)
	call	OTH_EXIT

MAIN_15:
	bit	0,a
	jr	z,MAIN_17
	bit	1,a
	jr	z,MAIN_18
	bit	2,a
	jr	z,MAIN_19
	bit	3,a
	jr	z,MAIN_16
	ld	ix,chrs
	call	&TulostaHahmo
	jr	MAIN_21
MAIN_16:
	ld	d,14
	jr	MAIN_20
MAIN_17:
	ld	d,2
	jr	MAIN_20
MAIN_18:
	ld	d,224
	jr	MAIN_20
MAIN_19:
	ld	d,32
MAIN_20:
	xor	a
	call	&SiirraHahmo
MAIN_21:
	ld	a,(bonus)
	cp	1
	jr	nz,MAIN_22
	ld	a,(b_aika)
	and	31
	jr	nz,MAIN_22
	ld	a,(b_aika)
	call	DIV_A_16
	srl	a
	add	a,48
	ld	hl,$0101
	ld	(CURSOR_ROW),hl
	set	3,(iy+5)
	call	TX_CHARPUT
MAIN_22:
	ld	a,(pros)
	sub	80
	jp	c,&MAIN_loop_7
	ld	hl,&KenttaBonukset
	ld	d,0
	ld	e,a
	add	hl,de
	ld	l,(hl)
	ld	h,100
	call	MUL_HL
	push	hl
	ld	de,(pisteet)
	add	hl,de
	ld	(pisteet),hl
	pop	hl
	ld	a,(taso)
	inc	a
	cp	10
	jr	nc,MAIN_23
	ld	(taso),a
	push	hl
	ld	hl,$0403
	ld	(CURSOR_ROW),hl
	set	3,(iy+5)
	ld	hl,(pros)
	ld	h,0
	call	D_HL_DECI
	ld	hl,&LapaisyTeksti
	call	D_ZT_STR
	pop	hl
	call	D_HL_DECI
	ld	a,112
	call	TX_CHARPUT
	ld	b,2
MAIN_loop_14:
	ld	a,1
	ld	(ajastin),a
MAIN_loop_15:
	ld	a,(ajastin)
	or	a
	jr	nz,MAIN_loop_15
	djnz	MAIN_loop_14
	jp	&MAIN_2
MAIN_23:
	ld	hl,&ParasTulos
	push	hl
	call	LD_HL_MHL
	ld	de,(pisteet)
	call	CP_HL_DE
	pop	hl
	jr	nc,MAIN_24

	ld	hl,$0103
	ld	(CURSOR_ROW),hl
	set	3,(iy+5)
	ld	hl,&TulosTeksti
	call	D_ZT_STR
	ld	de,$0204
	ld	(CURSOR_ROW),de
	call	D_ZT_STR
	ex	de,hl
	ld	hl,$0405
	ld	(CURSOR_ROW),hl
	ld	b,3
	ld	a,222
	call	TX_CHARPUT
MAIN_loop_16:
	call	GET_KEY
	or	a
	jr	z,MAIN_loop_16
	ld	l,a
	xor	a
	ld	h,a
	push	bc
	ld	bc,$7989
	add	hl,bc
	ld	l,(hl)
	ld	h,a
	add	hl,hl
	ld	bc,$0669
	add	hl,bc
	pop	bc
	ld	a,(hl)
	cp	65
	jr	c,MAIN_loop_16
	cp	91
	jr	nc,MAIN_loop_16
	ld	(de),a
	ld	a,(CURSOR_COL)
	dec	a
	ld	(CURSOR_COL),a
	ld	a,(de)
	inc	de
	call	TX_CHARPUT
	ld	a,222
	call	TX_CHARPUT
	djnz	MAIN_loop_16
	ld	hl,pisteet
	ldi	
	ldi	
MAIN_24:
	jp	&MAIN_0

AlkuTeksti:
.db	"Taiton alkuper. "
.db	"videopelin pohja"
.db	"lta",0
.db	"Nappaimet: [nuol"
.db	"et]-liiku",0
.db	"  [alpha]-tulita"
.db	"  [exit]-lopeta",0
.db	"  [2nd]-leikkaa "
.db	"  [f1]-tauko",0,0
.db	"[enter]-pelaa  ["
.db	"exit]-poistu",0,255

PauseTeksti:
.db	"PAUSE",0

TalletusNimi:
.db 	"VfSave",0

LapaisyTeksti:
.db	"% : ",0

TulosTeksti:
.db	"Uusi huipputulos"
.db	"!",0
.db	"Nimikirjaimesi:",0

ParasPelaaja:
.db	"VfD"

ParasTulos:
.dw	9999

AlkuData:
.db	55,63,0,0,28,63,1,0

KenttaBonukset:
.db	10,11,12,13,14,15,16,17,18,19,20,22,24,26,28,30
.db	"#(2d"

;******
AlustaRivi:
	ld	(hl),31
	inc	hl
	ld	c,b
	ld	b,14
Rivi_loop:
	ld	(hl),255
	inc	hl
	djnz	Rivi_loop
	ld	(hl),240
	inc	hl
	ld	b,c
	ret	

;******
KeskeytysFunktio:
	ld	hl,ajastin
	inc	(hl)
	ret	

;******
TulostaKaikki:
	ld	bc,$03B0
	ld	de,VIDEO_MEM
	ld	hl,GRAPH_MEM
	ldir	
	ld	hl,chr_num
	ld	d,(hl)
	ld	ix,chrs
Tulosta_loop_0:
	call	&TulostaHahmo
	ld	bc,$0004
	add	ix,bc
	dec	d
	jr	nz,Tulosta_loop_0
	ld	ix,$89B0
	ld	a,1
	ld	bc,$1980
	ld	de,$0001
	ld	hl,$0000
Tulosta_loop_1:
	and	(ix)
	jr	z,Tulosta_0
	and	(ix+16)
	jr	z,Tulosta_1
	inc	d
	jr	Tulosta_1
Tulosta_0:
	bit	0,d
	jr	z,Tulosta_1
	inc	hl
Tulosta_1:
	dec	bc
	xor	a
	cp	c
	jr	nz,Tulosta_2
	cp	b
	jr	z,Tulosta_3
Tulosta_2:
	rlc	e
	ld	a,e
	jr	nc,Tulosta_loop_1
	dec	ix
	jr	Tulosta_loop_1
Tulosta_3:
	ld	a,61
	call	DIV_HL_A
	ld	a,99
	sub	l
	ld	(pros),a
	cp	80
	ret	nc

;******
TulostaPalkki:
	ld	a,(pros)
	ld	l,a
	ld	ix,&_palkki
	ld	(ix+8),32
	ld	h,0
	call	UNPACK_HL
	add	a,48
	ld	(ix+9),a
	call	UNPACK_HL
	or	a
	jr	z,TulPalkki_0
	add	a,48
	ld	(ix+8),a
TulPalkki_0:
	push	ix
	ld	hl,(pisteet)
	ld	b,5
TulPalkki_loop_0:
	call	UNPACK_HL
	add	a,48
	ld	(ix+4),a
	dec	ix
	djnz	TulPalkki_loop_0
	ld	b,80
	ld	hl,$FFB0
	call	CLEAR_B_HL
	ld	hl,$3A24
	ld	(CURSOR_X),hl
	pop	hl
	call	D_ZM_STR
	ld	hl,&_spritet
	ld	bc,$783D
	ld	de,(elamat)
	ld	d,7
	xor	a
	or	e
	jr	z,TulPalkki_1
TulPalkki_loop_1:
	push	bc
	push	de
	push	hl
	call	&TulostaSprite
	pop	hl
	pop	de
	pop	bc
	ld	a,b
	sub	d
	ld	b,a
	dec	e
	jr	nz,TulPalkki_loop_1
TulPalkki_1:
	ld	de,$89F1
	ld	hl,$FFB0
	ld	bc,$50
	ldir	

TulostaAika:
	res	3,(iy+5)
	ld	hl,$3A17
	ld	(CURSOR_X),hl
	ld	hl,(aika)
	ld	b,5
TulAikaLoop:
	call	UNPACK_HL
	add	a,'0'
	call	M_CHARPUT
	ld	a,b
	rlca \ rlca
	dec	a
	ld	(CURSOR_X),a
	djnz	TulAikaLoop
	ret	

_palkki:
.db	"00017    5 %",0

;******
TulostaHahmo:
	ld	a,(ix+2)
	rlca	
	rlca	
	rlca	
	ld	b,0
	ld	c,a
	ld	hl,&_spritet
	add	hl,bc
	ld	b,(ix+1)
	ld	c,(ix)
	push	de
	push	ix
	call	&TulostaSprite
	pop	ix
	pop	de
	ret	

;******
Viikate:
	xor	a
	ld	(pulssi0),a
	ld	(pulssi0+1),a
	ld	(bonus),a
	ld	a,(chrs+3)
	or	a
	jr	z,Viikate_EiKentalla
	xor	a
	ld	(chrs+3),a
	ld	de,(koord0)
	ld	bc,(koord1)
	ld	hl,&NollaaPikseli
	ld	(chrs),de
	call	&KuljeReuna
Viikate_EiKentalla:
	ld	a,(elamat)
	or	a
	jr	z,Viikate_Gameover
	dec	a
	ld	(elamat),a
	call	&TulostaKaikki
	ret	
Viikate_Gameover:
	ld	a,255
	ld	(taso),a
	ret	

;******
PaivitaKentta:
	ld	bc,(chrs+4)
	xor	a
	ld	(btemp),a
PK_loop_0:
	dec	c
	call	&OtaPikseli
	jr	z,PK_loop_0
	push	bc
	inc	b
	call	&OtaPikseli
	pop	bc
	jr	z,PK_loop_0
	call	&UusiPikseli
	jr	nz,PK_0
	ld	a,(btemp)
	inc	a
	ld	(btemp),a
	jr	PK_loop_0
PK_0:
	ld	hl,&KuljeTyhjaF
	push	bc
	pop	de
	inc	d
	call	&KuljeReuna
	ld	a,(btemp)
	and	1
	jr	nz,PK_5
	push	bc
	dec	c
	ld	a,e
	cp	c
	jr	z,PK_1
	call	&OtaPikseli
	jr	z,PK_1
	call	&UusiPikseli
	jr	nz,PK_4
PK_1:
	inc	c
	inc	b
	ld	a,d
	cp	b
	jr	z,PK_2
	call	&OtaPikseli
	jr	z,PK_2
	call	&UusiPikseli
	jr	nz,PK_4
PK_2:
	dec	b
	inc	c
	ld	a,e
	cp	c
	jr	z,PK_3
	call	&OtaPikseli
	jr	z,PK_3
	call	&UusiPikseli
	jr	nz,PK_4
PK_3:
	dec	c
	dec	b
PK_4:
	pop	de
	jr	PK_6
PK_5:
	push	bc
	push	de
	pop	bc
	pop	de
PK_6:
	ld	hl,&NollaaPikseli
	call	&KuljeReuna
	ld	bc,(chr_num-1)
	dec	b
	ld	ix,chrs+4
PK_loop_1:
	dec	b
	ret	z
	ld	de,$0004
	add	ix,de
	ld	e,(ix)
	ld	d,(ix+1)
	ld	(wtemp),de
	call	&PisteKentassa
	jr	nz,PK_loop_1
	ld	a,(ix+2)
	cp	3
	jr	nz,PK_8
	ld	a,r
	and	3
	ld	(bonus),a
	cp	1
	jr	z,PK_7
	ld	hl,$01F4
	ld	(b_aika),hl
	jr	PK_9
PK_7:
	ld	hl,$00E0
	ld	(b_aika),hl
	jr	PK_9
PK_8:
	ld	hl,(pisteet)
	ld	de,100
	add	hl,de
	ld	(pisteet),hl
PK_9:
	ld	a,(chr_num)
	dec	a
	ld	(chr_num),a
	ld	a,b
	dec	a
	ret	z
	rlca	
	rlca	
	push	ix
	pop	hl
	push	ix
	pop	de
	push	bc
	ld	bc,$0004
	add	hl,bc
	ld	c,a
	ldir	
	ld	bc,$FFFC
	add	ix,bc
	pop	bc
	jr	PK_loop_1

;******
UusiPikseli:
	ld	a,(chrs+3)
	cp	1
	ret	nz
	ld	(&KuljeEtsiF+1),bc
	push	bc
	push	de
	push	hl
	ld	de,(koord0)
	ld	bc,(koord1)
	ld	hl,&KuljeEtsiF
	call	&KuljeReuna
	pop	hl
	pop	de
	pop	bc
	jr	c,UusiTosi
	or	1
	ret	
UusiTosi:
	xor	a
	ret	

;******
KuljeReuna:
	ld	(&KR_ins_0+1),hl
KR_loop_0:
	push	bc
	push	bc
	ld	a,63
	sub	c
	ld	c,a
	call	FIND_PIXEL
	ld	bc,GRAPH_MEM
	add	hl,bc
	pop	bc
	ld	lx,0
	call	&PikseliVasemmalle
	ld	(&KR_0+1),a
	and	(hl)
	jr	z,KR_0
	ld	a,d
	cp	b
	jr	z,KR_0
	push	bc
	pop	ix
KR_0:
	ld	a,128
	call	&PikseliOikealle
	call	&PikseliYlos
	ld	(&KR_1+1),a
	and	(hl)
	jr	z,KR_1
	ld	a,e
	cp	c
	jr	z,KR_1
	ld	a,lx
	or	a
	jr	nz,KR_4
	push	bc
	pop	ix
KR_1:
	ld	a,64
	call	&PikseliAlas
	call	&PikseliOikealle
	ld	(&KR_2+1),a
	and	(hl)
	jr	z,KR_2
	ld	a,d
	cp	b
	jr	z,KR_2
	ld	a,lx
	or	a
	jr	nz,KR_4
	push	bc
	pop	ix
KR_2:
	ld	a,32
	call	&PikseliVasemmalle
	call	&PikseliAlas
	and	(hl)
	jr	z,KR_3
	ld	a,e
	cp	c
	jr	z,KR_3
	ld	a,lx
	or	a
	jr	nz,KR_4
	push	bc
	pop	ix
KR_3:
	pop	bc
	push	ix
	push	bc
KR_ins_0:
	call	0
	pop	de
	pop	bc
	ret	c
	ld	a,c
	or	a
	ret	z
	jr	KR_loop_0
KR_4:
	pop	bc
	ret	

;******
KuljeEtsiF:
	ld	hl,0
	sbc	hl,bc
	jr	z,EtsiLoppu
	or	a
	ret	
EtsiLoppu:
	scf	

KuljeTyhjaF:
	ret	

;******
PisteKentassa:
	push	bc
	push	ix
	ld	hl,(chrs+4)
	ld	bc,(wtemp)
	ld	ix,&Kentassa_loop_0
	ld	a,h
	sub	b
	jr	nc,Kentassa_0
	ld	(ix),5
	ld	(ix+39),15
	ld	(ix+42),35
	neg	
	jr	Kentassa_1
Kentassa_0:
	ld	(ix),4
	ld	(ix+39),7
	ld	(ix+42),43
Kentassa_1:
	ld	ix,&Kentassa_ins_0+2
	ld	d,a
	ld	a,l
	sub	c
	jr	nc,Kentassa_2
	ld	(ix),240
	ld	(ix+16),13
	neg	
	jr	Kentassa_3
Kentassa_2:
	ld	(ix),16
	ld	(ix+16),12
Kentassa_3:
	ld	e,a
	xor	a
	ld	(btemp),a
	ld	a,d
	or	a
	jr	z,Kentassa_4
Kentassa_loop_0:
	inc	b
	dec	d
	jr	z,Kentassa_4
	call	&OtaPikseli
	jr	z,Kentassa_loop_0
	push	hl
	pop	ix
Kentassa_ins_0:
	and	(ix+16)
	jr	z,Kentassa_loop_0
	ld	a,(btemp)
	inc	a
	ld	(btemp),a
	jr	Kentassa_loop_0
Kentassa_4:
	ld	a,e
	or	a
	jr	z,Kentassa_6
Kentassa_loop_1:
	inc	c
	dec	e
	jr	z,Kentassa_6
	call	&OtaPikseli
	jr	z,Kentassa_loop_1
	rlca	
	jr	nc,Kentassa_5
	dec	hl
Kentassa_5:
	and	(hl)
	jr	z,Kentassa_loop_1
	ld	a,(btemp)
	inc	a
	ld	(btemp),a
	jr	Kentassa_loop_1
Kentassa_6:
	ld	a,(btemp)
	cpl	
	and	1
	pop	ix
	pop	bc
	ret	

;******
TarkistaHahmo:
	ld	(wtemp),de
	ld	a,63
	sub	e
	ld	c,a
	ld	b,d
	call	FIND_PIXEL
	ld	de,GRAPH_MEM
	add	hl,de
	ld	b,a
	and	(hl)
	push	af
	ld	a,(ix+2)
	or	a
	jr	nz,Tark_0
	ld	a,(ix+3)
	or	a
	jr	nz,Tark_3
	ld	a,(P2nd)
	and	32
	jr	z,Tark_2
	pop	af
	ret	
Tark_0:
	pop	af
	cp	b
	ret	nz
	ld	bc,(wtemp)
	call	&UusiPikseli
	jr	nz,Tark_1
	ld	de,(pulssi0)
	ld	a,d
	or	e
	jr	nz,Tark_1
	ld	(&KuljeEtsiF+1),bc
	ld	de,(koord0)
	ld	bc,(koord1)
	ld	hl,&KuljeEtsiF
	call	&KuljeReuna
	ld	(pulssi0),de
	ld	(pulssi1),bc
Tark_1:
	xor	a
	ret	
Tark_2:
	pop	af
	ret	nz
	push	af
	push	hl
	call	&PisteKentassa
	pop	hl
	jr	nz,Tark_3
	pop	af
	ret	
Tark_3:
	ld	ix,(chr_num)
	ld	hx,0
	dec	ix
	add	ix,ix
	add	ix,ix
	ld	de,chrs
	add	ix,de
Tark_loop_0:
	ld	a,(ix+2)
	cp	3
	jr	nz,Tark_7
	ld	a,(wtemp+1)
	sub	(ix+1)
	jr	nc,Tark_4
	neg	
Tark_4:
	cp	3
	jr	nc,Tark_6
	ld	a,(wtemp)
	sub	(ix)
	jr	nc,Tark_5
	neg	
Tark_5:
	cp	3
	jr	nc,Tark_6
	pop	af
	xor	a
	ret	
Tark_6:
	ld	de,$FFFC
	add	ix,de
	jr	Tark_loop_0
Tark_7:
	pop	af
	push	af
	jr	z,Tark_9
	ld	de,(wtemp)
	push	hl
	ld	hl,(koord0)
	sbc	hl,de
	pop	hl
	jr	z,Tark_8
	push	bc
	ld	bc,(wtemp)
	call	&UusiPikseli
	pop	bc
	jr	nz,Tark_9
Tark_8:
	pop	af
	xor	a
	ret	
Tark_9:
	ld	a,b
	ld	(&Tark_ins_0+1),a
	or	(hl)
	ld	(hl),a
	ld	de,(chrs)
	ld	bc,(wtemp)
	ld	a,d
	cp	b
Tark_ins_0:
	ld	a,16
	call	c,&PikseliVasemmalle
	call	nz,&PikseliOikealle
	ld	(&Tark_ins_1+1),a
	ld	a,e
	cp	c
Tark_ins_1:
	ld	a,8
	call	c,&PikseliYlos
	call	nz,&PikseliAlas
	or	(hl)
	ld	(hl),a
	ld	a,(chrs+3)
	or	a
	jr	nz,Tark_10
	ld	(koord1),bc
	ld	(koord0),de
	ld	a,1
	ld	(chrs+3),a
Tark_10:
	ld	hl,(pisteet)
	inc	hl
	ld	(pisteet),hl
	pop	af
	jr	nz,Tark_11
	or	1
	ret	
Tark_11:
	ld	a,(bonus)
	sub	1
	jr	nz,Tark_12
	ld	(bonus),a
Tark_12:
	call	&PaivitaKentta
	xor	a
	ld	(chrs+3),a
	ld	h,a
	ld	l,a
	ld	(pulssi0),hl
	call	&TulostaKaikki
	or	1
	ret	

;******
SiirraHahmo:
	push	af
	or	a
	jr	nz,SH_0
	ld	a,(P2nd)
	and	128
	jr	nz,SH_0
	ld	a,(bonus)
	cp	2
SH_0:
	jp	nz,&SH_6
	pop	af
	ld	a,(am_a)
	or	a
	jr	z,SH_1
	ld	hl,(am_hl)
	ld	b,8
SH_loop_0:
	push	af
	cpl	
	and	(hl)
	ld	(hl),a
	pop	af
	djnz	SH_loop_0
SH_1:
	ld	bc,(chrs)
	ld	(am_bc),bc
	ld	a,63
	sub	c
	ld	c,a
	call	FIND_PIXEL
	ld	bc,VIDEO_MEM
	add	hl,bc
	ld	(am_a),a
	ld	(am_hl),hl
	push	af
	ld	a,d
	cp	224
	jr	nz,SH_2
	ld	bc,&PikseliVasemmalle
	ld	de,$FFFF
	jr	SH_5
SH_2:
	cp	14
	jr	nz,SH_3
	ld	bc,&PikseliYlos
	ld	de,$FF80
	jr	SH_5
SH_3:
	cp	32
	jr	nz,SH_4
	ld	bc,&PikseliOikealle
	ld	de,$0001
	jr	SH_5
SH_4:
	cp	2
	jr	nz,SH_5
	ld	bc,&PikseliAlas
	ld	de,$0080
SH_5:
	ld	(am_de),de
	ld	(am_funk),bc
	ld	(&SH_loop_1+1),bc
	ld	bc,(am_bc)
	pop	af
	ld	d,8
SH_loop_1:
	call	0
	push	af
	or	(hl)
	ld	(hl),a
	pop	af
	dec	d
	jr	nz,SH_loop_1
	ld	(am_bc),bc
	ret	
SH_6:
	pop	af
	rlca	
	rlca	
	push	de
	ld	d,0
	ld	e,a
	ld	ix,chrs
	add	ix,de
	pop	de
	ld	c,(ix)
	ld	b,(ix+1)
	ld	a,d
	and	15
	bit	3,a
	jr	z,SH_7
	or	240
SH_7:
	add	a,c
	ld	e,a
	ld	a,d
	and	240
	sra	a
	sra	a
	sra	a
	sra	a
	add	a,b
	ld	d,a
	push	de
	push	ix
	push	bc
	call	&TarkistaHahmo
	pop	bc
	jr	z,SH_8
	call	&PoistaSprite
	pop	ix
	pop	bc
	ld	(ix),c
	ld	(ix+1),b
	call	&TulostaHahmo
	or	1
	ret	
SH_8:
	pop	ix
	pop	de
	ret	

;******
SiirraVihollinen:
	ld	hl,(aika)
	ld	a,h
	or	l
	jr	z,SV_0
	ld	a,32
	ld	(&SV_ins_0),a
	ld	a,(chrs+3)
	or	a
	jr	z,SV_4
	jr	SV_1
SV_0:
	ld	a,24
	ld	(&SV_ins_0),a
SV_1:
	ld	a,(chrs)
	sub	(ix)
	jr	nc,SV_2
	neg	
SV_2:
	cp	4
	jr	nc,SV_4
	ld	a,(chrs+1)
	sub	(ix+1)
	jr	nc,SV_3
	neg	
SV_3:
	cp	4
	jp	c,&Viikate
SV_4:
	ld	a,(bonus)
	cp	1
	jr	nz,SV_5
	call	&TulostaHahmo
	ret	
SV_5:
	ld	a,(ix+3)
	sub	4
	ld	(ix+3),a
	ld	d,a
	srl	a
	srl	a
	jr	nz,SV_8
	ld	a,r
	and	63
	or	16
	ld	d,a
	ld	a,(chrs+3)
	or	a
SV_ins_0:
	jr	nz,SV_6
	ld	a,r
	cp	64
	rl	d
	and	63
	cp	32
	rl	d
	jr	SV_7
SV_6:
	ld	a,(chrs)
	cp	(ix)
	rl	d
	ld	a,(chrs+1)
	cp	(ix+1)
	rl	d
SV_7:
	ld	(ix+3),d
SV_8:
	ld	a,17
	bit	0,d
	jr	z,SV_9
	xor	224
SV_9:
	bit	1,d
	jr	z,SV_10
	xor	14
SV_10:
	ld	d,a
	ld	a,e
	push	de
	call	&SiirraHahmo
	pop	de
	ret	nz
	ld	a,d
	xor	224
	ld	d,a
	ld	a,(ix+3)
	xor	1
	ld	(ix+3),a
	ld	a,e
	push	de
	call	&SiirraHahmo
	pop	de
	ret	nz
	ld	a,d
	xor	238
	ld	d,a
	ld	a,(ix+3)
	xor	3
	ld	(ix+3),a
	ld	a,e
	push	de
	call	&SiirraHahmo
	pop	de
	ret	nz
	ld	a,d
	xor	224
	ld	d,a
	ld	a,(ix+3)
	xor	1
	ld	(ix+3),a
	ld	a,e
	push	de
	call	&SiirraHahmo
	pop	de
	ret	

;******
OtaPikseli:
	push	bc
	ld	a,63
	sub	c
	ld	c,a
	call	FIND_PIXEL
	ld	bc,GRAPH_MEM
	add	hl,bc
	and	(hl)
	pop	bc
	ret	

;******
NollaaPikseli:
	push	bc
	ld	a,63
	sub	c
	ld	c,a
	call	FIND_PIXEL
	ld	bc,GRAPH_MEM
	add	hl,bc
	cpl	
	and	(hl)
	ld	(hl),a
	pop	bc
	ret	

;******
PikseliVasemmalle:
	dec	b
	cp	a
	rlca	
	ret	nc
	dec	hl
	ret	

;******
PikseliOikealle:
	inc	b
	cp	a
	rrca	
	ret	nc
	inc	hl
	ret	

;******
PikseliYlos:
	push	bc
	ld	bc,$FFF0
	add	hl,bc
	pop	bc
	dec	c
	cp	a
	ret	

;******
PikseliAlas:
	push	bc
	ld	bc,$0010
	add	hl,bc
	pop	bc
	inc	c
	cp	a
	ret	

;******
TulostaSprite:
	push	hl
	call	&YlaKulma
	ld	de,VIDEO_MEM
	add	hl,de
	pop	ix
	ld	bc,$0808
TS_loop_0:
	ld	d,(ix)
	inc	ix
	push	af
	push	hl
TS_loop_1:
	rl	d
	ld	e,a
	jr	nc,TS_0
	or	(hl)
	ld	(hl),a
TS_0:
	ld	a,e
	rrca	
	jr	nc,TS_1
	inc	hl
TS_1:
	djnz	TS_loop_1
	pop	hl
	pop	af
	ld	de,$0010
	add	hl,de
	ld	b,8
	dec	c
	jr	nz,TS_loop_0
	ret	

;******
YlaKulma:
	ld	a,b
	sub	3
	ld	b,a
	ld	a,66
	sub	c
	ld	c,a
	call	FIND_PIXEL
	ret	

;******
PoistaSprite:
	call	&YlaKulma
	ex	de,hl
	ld	ix,GRAPH_MEM
	add	ix,de
	ld	hl,VIDEO_MEM
	add	hl,de
	ld	bc,$0808
PS_loop_0:
	push	af
	push	ix
	push	hl
PS_loop_1:
	ld	d,(ix)
	ld	e,a
	and	d
	ld	a,e
	jr	z,PS_0
	or	(hl)
	ld	(hl),a
	jr	PS_1
PS_0:
	cpl	
	and	(hl)
	ld	(hl),a
PS_1:
	ld	a,e
	rrca	
	jr	nc,PS_2
	inc	hl
	inc	ix
PS_2:
	djnz	PS_loop_1
	pop	hl
	pop	ix
	pop	af
	ld	de,$0010
	add	hl,de
	add	ix,de
	ld	b,8
	dec	c
	jr	nz,PS_loop_0
	ret	

_spritet:
.db	%00000000
.db	%00111000
.db	%01010100
.db	%01101100
.db	%01010100
.db	%00111000
.db	%00000000
.db	%00000000

.db	%00111100
.db	%01111110
.db	%01010110
.db	%11010111
.db	%11111111
.db	%11111111
.db	%11111111
.db	%10110101

.db	%00100000
.db	%00110011
.db	%00111111
.db	%11111110
.db	%01111110
.db	%00111111
.db	%00110011
.db	%00100000

.db	%11111110
.db	%10000010
.db	%10111010
.db	%10101010
.db	%10111010
.db	%10000010
.db	%11111110
.db	%00000000

.db	%00001100
.db	%00011000
.db	%00110000
.db	%01111100
.db	%00011000
.db	%00110000
.db	%01100000
.db	%00000000

_kentta1:
.db 4,4					; Apurit > 0, laatikot > 0
.db	51,7,	51,63,	51,119,	29,63	; laatikot: y1,x1, y2,x2, ...

_kentta2:
.db 5,4
.db	7,41,	7,83,	51,41,	51,83

_kentta3:
.db 6,4
.db	29,7,	29,119,	51,63,	7,63

_kentta4:
.db 5,4
.db	25,59,	25,67,	33,59,	33,67

_kentta5:
.db 6,4
.db	17,17,	17,109,	41,17,	41,109

_kentta6:
.db 5,3
.db	29,31,	29,63,	29,95

_kentta7:
.db 6,4
.db	15,63,	21,63,	35,63,	41,63

_kentta8:
.db 1,6
.db	41,65,	41,71,	41,77,	41,87,	41,93,	41,99

_kentta9:
.db 6,3
.db	41,17,	41,109,	29,63

_kentta10:
.db 5,6
.db	21,59,	21,65,	37,59,	37,65,	29,51,	29,75

_kentat:		; siirrokset kenttien osoitteisiin
.dw	_kentta1-$
.dw	_kentta2-$
.dw	_kentta3-$
.dw	_kentta4-$
.dw	_kentta5-$
.dw	_kentta6-$
.dw	_kentta7-$
.dw	_kentta8-$
.dw	_kentta9-$
.dw	_kentta10-$

.db	%10000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000100
.db	%11000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00001100
.db	%01110000,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%00111000
.db	%01111100,%00000000,%00000000,%00000000,%00000000,%00000000,%00000000,%11111000
.db	%00111111,%00000000,%00000000,%00000000,%00000000,%00000000,%00000011,%11111000
.db	%00111111,%11000000,%00000000,%00000000,%00000000,%00000000,%00001111,%11110000
.db	%00111111,%11110000,%00000000,%00000000,%00000000,%00000000,%00111111,%11110000
.db	%00011101,%11111100,%00000000,%00000000,%00000000,%00000000,%11111110,%11110000
.db	%00011100,%01111110,%00000000,%00000000,%00000000,%00000111,%11111000,%11100000
.db	%00011100,%00111101,%11110000,%00000000,%00000000,%00111111,%11110000,%11100000
.db	%00011110,%00111111,%11111111,%00000000,%00000010,%11111111,%01110000,%11100000
.db	%00001110,%00111111,%11111011,%10000111,%11101110,%11111000,%01110001,%11100000
.db	%00001110,%01111111,%00111011,%10000111,%11101110,%11110011,%01111001,%11000000
.db	%00001111,%01111111,%00111011,%10000111,%00101110,%11111111,%00111001,%11000000
.db	%00000111,%01110110,%00111111,%10000111,%00001110,%11111111,%00111101,%11000100
.db	%11111111,%00000000,%00000000,%00000000,%00000000,%00000000,%00000001,%11110111
.db	%00000111,%11110111,%00111111,%10000111,%11101110,%11110000,%00011111,%10000100
.db	%00000111,%11100111,%01111111,%10000111,%11101110,%11110011,%00011111,%10000000
.db	%00000011,%11100111,%11111011,%10010111,%00101110,%11111111,%00001111,%10000000
.db	%00000011,%11000011,%11110111,%11110111,%00001110,%11111111,%00001111,%00000000
.db	%00000011,%11000000,%11100111,%11110111,%00001110,%11111100,%00001111,%00000000
.db	%00000001,%10000000,%00000000,%11110111,%10011100,%00000000,%00000111,%00000000
.db	%00000001,%10000000,%00000000,%00000000,%00000000,%00000000,%00000111,%00000000
.db	%00000001,%00000000,%00000000,%00000000,%00000000,%00000000,%00000010,%00000000
.db	%00000001,%00000000,%00000000,%00000000,%00000000,%00000000,%00000010,%00000000
_logoLoppu:

.end
