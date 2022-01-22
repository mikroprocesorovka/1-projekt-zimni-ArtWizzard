   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  15                     	bsct
  16  0000               _status:
  17  0000 0a            	dc.b	10
  18  0001               _heslo:
  19  0001 07            	dc.b	7
  20  0002 05            	dc.b	5
  21  0003 01            	dc.b	1
  22  0004 01            	dc.b	1
  23  0005 00            	ds.b	1
  24  0006               _entry:
  25  0006 0a            	dc.b	10
  26  0007 0a            	dc.b	10
  27  0008 0a            	dc.b	10
  28  0009 0a            	dc.b	10
  29  000a 00            	ds.b	1
  30  000b               _pointer:
  31  000b 00            	dc.b	0
  62                     ; 31 void main(void){
  64                     	switch	.text
  65  0000               _main:
  69                     ; 32 	init();
  71  0000 ad04          	call	_init
  73  0002               L12:
  74                     ; 35 		process_keypad();			// Aktualizuje stisk klávesy
  76  0002 ad10          	call	_process_keypad
  79  0004 20fc          	jra	L12
 106                     ; 43 void init(void){
 107                     	switch	.text
 108  0006               _init:
 112                     ; 44 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z interního RC oscilátoru
 114  0006 4f            	clr	a
 115  0007 cd0000        	call	_CLK_HSIPrescalerConfig
 117                     ; 46 	init_milis();						// Dekralace vnitøního èasu v STM 
 119  000a cd0000        	call	_init_milis
 121                     ; 47 	keypad_init();					// Deklarace nastavení pinù na klávesnici
 123  000d cd0000        	call	_keypad_init
 125                     ; 48 	lcd_init();							// Nastavení LDC displeje
 127  0010 cd0000        	call	_lcd_init
 129                     ; 51 }
 132  0013 81            	ret
 135                     	bsct
 136  000c               L53_minule_stisknuto:
 137  000c ff            	dc.b	255
 138  000d               L73_last_time:
 139  000d 0000          	dc.w	0
 227                     .const:	section	.text
 228  0000               L41:
 229  0000 005a          	dc.w	L14
 230  0002 0063          	dc.w	L34
 231  0004 006c          	dc.w	L54
 232  0006 0075          	dc.w	L74
 233  0008 007e          	dc.w	L15
 234  000a 0087          	dc.w	L35
 235  000c 008e          	dc.w	L55
 236  000e 0095          	dc.w	L75
 237  0010 009b          	dc.w	L16
 238  0012 00a1          	dc.w	L36
 239  0014 00a7          	dc.w	L56
 240  0016 00c2          	dc.w	L76
 241                     ; 53 void process_keypad(void){
 242                     	switch	.text
 243  0014               _process_keypad:
 245  0014 5223          	subw	sp,#35
 246       00000023      OFST:	set	35
 249                     ; 59 	uint8_t pravda = 1;
 251  0016 a601          	ld	a,#1
 252  0018 6b21          	ld	(OFST-2,sp),a
 254                     ; 62 	if(milis()-last_time > 20){ // každých 20 ms ...
 256  001a cd0000        	call	_milis
 258  001d 72b0000d      	subw	x,L73_last_time
 259  0021 a30015        	cpw	x,#21
 260  0024 2403          	jruge	L61
 261  0026 cc0114        	jp	L331
 262  0029               L61:
 263                     ; 63 		last_time = milis();
 265  0029 cd0000        	call	_milis
 267  002c bf0d          	ldw	L73_last_time,x
 268                     ; 64 		stisknuto = keypad_scan(); // ... skenujeme klávesnici
 270  002e cd0000        	call	_keypad_scan
 272  0031 6b22          	ld	(OFST-1,sp),a
 274                     ; 66 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvolnìno a pak stisknuto
 276  0033 b60c          	ld	a,L53_minule_stisknuto
 277  0035 a1ff          	cp	a,#255
 278  0037 2703          	jreq	L02
 279  0039 cc010a        	jp	L531
 280  003c               L02:
 282  003c 7b22          	ld	a,(OFST-1,sp)
 283  003e a1ff          	cp	a,#255
 284  0040 2603          	jrne	L22
 285  0042 cc010a        	jp	L531
 286  0045               L22:
 287                     ; 67 			minule_stisknuto = stisknuto;
 289  0045 7b22          	ld	a,(OFST-1,sp)
 290  0047 b70c          	ld	L53_minule_stisknuto,a
 291                     ; 69 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukládat jednotlivé èíslice
 293  0049 7b22          	ld	a,(OFST-1,sp)
 295                     ; 134 					break;
 296  004b a10c          	cp	a,#12
 297  004d 2407          	jruge	L21
 298  004f 5f            	clrw	x
 299  0050 97            	ld	xl,a
 300  0051 58            	sllw	x
 301  0052 de0000        	ldw	x,(L41,x)
 302  0055 fc            	jp	(x)
 303  0056               L21:
 304  0056 ac0a010a      	jpf	L531
 305  005a               L14:
 306                     ; 70 				case 0 :
 306                     ; 71 					click(stisknuto);
 308  005a 7b22          	ld	a,(OFST-1,sp)
 309  005c cd0117        	call	_click
 311                     ; 72 					break;
 313  005f ac0a010a      	jpf	L531
 314  0063               L34:
 315                     ; 73 				case 1 :
 315                     ; 74 					click(stisknuto);
 317  0063 7b22          	ld	a,(OFST-1,sp)
 318  0065 cd0117        	call	_click
 320                     ; 75 					break;
 322  0068 ac0a010a      	jpf	L531
 323  006c               L54:
 324                     ; 76 				case 2 :
 324                     ; 77 					click(stisknuto);
 326  006c 7b22          	ld	a,(OFST-1,sp)
 327  006e cd0117        	call	_click
 329                     ; 78 					break;
 331  0071 ac0a010a      	jpf	L531
 332  0075               L74:
 333                     ; 79 				case 3 :
 333                     ; 80 					click(stisknuto);
 335  0075 7b22          	ld	a,(OFST-1,sp)
 336  0077 cd0117        	call	_click
 338                     ; 81 					break;
 340  007a ac0a010a      	jpf	L531
 341  007e               L15:
 342                     ; 82 				case 4 :
 342                     ; 83 					click(stisknuto);
 344  007e 7b22          	ld	a,(OFST-1,sp)
 345  0080 cd0117        	call	_click
 347                     ; 84 					break;
 349  0083 ac0a010a      	jpf	L531
 350  0087               L35:
 351                     ; 85 				case 5 :
 351                     ; 86 					click(stisknuto);
 353  0087 7b22          	ld	a,(OFST-1,sp)
 354  0089 cd0117        	call	_click
 356                     ; 87 					break;
 358  008c 207c          	jra	L531
 359  008e               L55:
 360                     ; 88 				case 6 :
 360                     ; 89 					click(stisknuto);
 362  008e 7b22          	ld	a,(OFST-1,sp)
 363  0090 cd0117        	call	_click
 365                     ; 90 					break;
 367  0093 2075          	jra	L531
 368  0095               L75:
 369                     ; 91 				case 7 :
 369                     ; 92 					click(stisknuto);
 371  0095 7b22          	ld	a,(OFST-1,sp)
 372  0097 ad7e          	call	_click
 374                     ; 93 					break;
 376  0099 206f          	jra	L531
 377  009b               L16:
 378                     ; 94 				case 8 :
 378                     ; 95 					click(stisknuto);
 380  009b 7b22          	ld	a,(OFST-1,sp)
 381  009d ad78          	call	_click
 383                     ; 96 					break;
 385  009f 2069          	jra	L531
 386  00a1               L36:
 387                     ; 97 				case 9 :
 387                     ; 98 					click(stisknuto);
 389  00a1 7b22          	ld	a,(OFST-1,sp)
 390  00a3 ad72          	call	_click
 392                     ; 99 					break;
 394  00a5 2063          	jra	L531
 395  00a7               L56:
 396                     ; 100 				case 10 : //  *
 396                     ; 101 					for(i = 0; i < (sizeof(entry)-1); i++){
 398  00a7 0f23          	clr	(OFST+0,sp)
 400  00a9               L341:
 401                     ; 102 						entry[i] = 10;
 403  00a9 7b23          	ld	a,(OFST+0,sp)
 404  00ab 5f            	clrw	x
 405  00ac 97            	ld	xl,a
 406  00ad a60a          	ld	a,#10
 407  00af e706          	ld	(_entry,x),a
 408                     ; 101 					for(i = 0; i < (sizeof(entry)-1); i++){
 410  00b1 0c23          	inc	(OFST+0,sp)
 414  00b3 7b23          	ld	a,(OFST+0,sp)
 415  00b5 a104          	cp	a,#4
 416  00b7 25f0          	jrult	L341
 417                     ; 109 					pointer = 0;
 419  00b9 3f0b          	clr	_pointer
 420                     ; 110 					lcd_clear();
 422  00bb a601          	ld	a,#1
 423  00bd cd0000        	call	_lcd_command
 425                     ; 111 					break;
 427  00c0 2048          	jra	L531
 428  00c2               L76:
 429                     ; 112 				case 11 : //  #
 429                     ; 113 					lcd_gotoxy(0,1);
 431  00c2 ae0001        	ldw	x,#1
 432  00c5 cd0000        	call	_lcd_gotoxy
 434                     ; 121 					for(i = 0; i < (sizeof(entry)-1); i++){
 436  00c8 0f23          	clr	(OFST+0,sp)
 438  00ca               L151:
 439                     ; 122 						if (entry[i] != heslo[i]){
 441  00ca 7b23          	ld	a,(OFST+0,sp)
 442  00cc 5f            	clrw	x
 443  00cd 97            	ld	xl,a
 444  00ce 7b23          	ld	a,(OFST+0,sp)
 445  00d0 905f          	clrw	y
 446  00d2 9097          	ld	yl,a
 447  00d4 90e606        	ld	a,(_entry,y)
 448  00d7 e101          	cp	a,(_heslo,x)
 449  00d9 2702          	jreq	L751
 450                     ; 123 							pravda = 0;
 452  00db 0f21          	clr	(OFST-2,sp)
 454  00dd               L751:
 455                     ; 121 					for(i = 0; i < (sizeof(entry)-1); i++){
 457  00dd 0c23          	inc	(OFST+0,sp)
 461  00df 7b23          	ld	a,(OFST+0,sp)
 462  00e1 a104          	cp	a,#4
 463  00e3 25e5          	jrult	L151
 464                     ; 127 					if(pravda){
 466  00e5 0d21          	tnz	(OFST-2,sp)
 467  00e7 270e          	jreq	L161
 468                     ; 128 						sprintf(text,"eallowed");
 470  00e9 ae001f        	ldw	x,#L361
 471  00ec 89            	pushw	x
 472  00ed 96            	ldw	x,sp
 473  00ee 1c0003        	addw	x,#OFST-32
 474  00f1 cd0000        	call	_sprintf
 476  00f4 85            	popw	x
 478  00f5 200c          	jra	L561
 479  00f7               L161:
 480                     ; 131 						sprintf(text,"denied");
 482  00f7 ae0018        	ldw	x,#L761
 483  00fa 89            	pushw	x
 484  00fb 96            	ldw	x,sp
 485  00fc 1c0003        	addw	x,#OFST-32
 486  00ff cd0000        	call	_sprintf
 488  0102 85            	popw	x
 489  0103               L561:
 490                     ; 133 					lcd_puts(text);
 492  0103 96            	ldw	x,sp
 493  0104 1c0001        	addw	x,#OFST-34
 494  0107 cd0000        	call	_lcd_puts
 496                     ; 134 					break;
 498  010a               L141:
 499  010a               L531:
 500                     ; 138 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 502  010a 7b22          	ld	a,(OFST-1,sp)
 503  010c a1ff          	cp	a,#255
 504  010e 2604          	jrne	L331
 507  0110 35ff000c      	mov	L53_minule_stisknuto,#255
 508  0114               L331:
 509                     ; 140 }
 512  0114 5b23          	addw	sp,#35
 513  0116 81            	ret
 551                     ; 141 void click(uint8_t number){
 552                     	switch	.text
 553  0117               _click:
 555  0117 88            	push	a
 556       00000000      OFST:	set	0
 559                     ; 142 	lcd_gotoxy(pointer,0);
 561  0118 b60b          	ld	a,_pointer
 562  011a 5f            	clrw	x
 563  011b 95            	ld	xh,a
 564  011c cd0000        	call	_lcd_gotoxy
 566                     ; 143 	if(pointer < sizeof(entry)-1){
 568  011f b60b          	ld	a,_pointer
 569  0121 a104          	cp	a,#4
 570  0123 240f          	jruge	L112
 571                     ; 144 		lcd_putchar('*');
 573  0125 a62a          	ld	a,#42
 574  0127 cd0000        	call	_lcd_data
 576                     ; 145 		entry[pointer] = number;
 578  012a b60b          	ld	a,_pointer
 579  012c 5f            	clrw	x
 580  012d 97            	ld	xl,a
 581  012e 7b01          	ld	a,(OFST+1,sp)
 582  0130 e706          	ld	(_entry,x),a
 583                     ; 146 		pointer ++;
 585  0132 3c0b          	inc	_pointer
 586  0134               L112:
 587                     ; 148 }
 590  0134 84            	pop	a
 591  0135 81            	ret
 614                     ; 151 void kontrola(void){
 615                     	switch	.text
 616  0136               _kontrola:
 620                     ; 153 }
 623  0136 81            	ret
 658                     ; 166 void assert_failed(u8* file, u32 line)
 658                     ; 167 { 
 659                     	switch	.text
 660  0137               _assert_failed:
 664  0137               L142:
 665  0137 20fe          	jra	L142
 718                     	xdef	_main
 719                     	xdef	_pointer
 720                     	xdef	_entry
 721                     	xdef	_heslo
 722                     	xdef	_status
 723                     	xdef	_click
 724                     	xdef	_kontrola
 725                     	xdef	_process_keypad
 726                     	xdef	_init
 727                     	xref	_sprintf
 728                     	xref	_lcd_puts
 729                     	xref	_lcd_gotoxy
 730                     	xref	_lcd_init
 731                     	xref	_lcd_data
 732                     	xref	_lcd_command
 733                     	xref	_keypad_scan
 734                     	xref	_keypad_init
 735                     	xref	_init_milis
 736                     	xref	_milis
 737                     	xdef	_assert_failed
 738                     	xref	_CLK_HSIPrescalerConfig
 739                     	switch	.const
 740  0018               L761:
 741  0018 64656e696564  	dc.b	"denied",0
 742  001f               L361:
 743  001f 65616c6c6f77  	dc.b	"eallowed",0
 763                     	end
