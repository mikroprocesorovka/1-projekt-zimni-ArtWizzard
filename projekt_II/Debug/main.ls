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
  23  0005 09            	dc.b	9
  24  0006               _entry:
  25  0006 0a            	dc.b	10
  26  0007 0a            	dc.b	10
  27  0008 0a            	dc.b	10
  28  0009 0a            	dc.b	10
  29  000a 00            	ds.b	1
  30  000b               _pointer:
  31  000b 00            	dc.b	0
  62                     ; 29 void main(void){
  64                     	switch	.text
  65  0000               _main:
  69                     ; 30 	init();
  71  0000 ad04          	call	_init
  73  0002               L12:
  74                     ; 33 		process_keypad();			// Aktualizuje stisk klávesy
  76  0002 ad10          	call	_process_keypad
  79  0004 20fc          	jra	L12
 106                     ; 41 void init(void){
 107                     	switch	.text
 108  0006               _init:
 112                     ; 42 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z interního RC oscilátoru
 114  0006 4f            	clr	a
 115  0007 cd0000        	call	_CLK_HSIPrescalerConfig
 117                     ; 44 	init_milis();						// Dekralace vnitøního èasu v STM 
 119  000a cd0000        	call	_init_milis
 121                     ; 45 	keypad_init();					// Deklarace nastavení pinù na klávesnici
 123  000d cd0000        	call	_keypad_init
 125                     ; 46 	lcd_init();							// Nastavení LDC displeje
 127  0010 cd0000        	call	_lcd_init
 129                     ; 49 }
 132  0013 81            	ret
 135                     	bsct
 136  000c               L53_minule_stisknuto:
 137  000c ff            	dc.b	255
 138  000d               L73_last_time:
 139  000d 0000          	dc.w	0
 192                     ; 51 void process_keypad(void){
 193                     	switch	.text
 194  0014               _process_keypad:
 196  0014 88            	push	a
 197       00000001      OFST:	set	1
 200                     ; 58 	if(milis()-last_time > 20){ // každých 20 ms ...
 202  0015 cd0000        	call	_milis
 204  0018 72b0000d      	subw	x,L73_last_time
 205  001c a30015        	cpw	x,#21
 206  001f 2546          	jrult	L711
 207                     ; 59 		last_time = milis();
 209  0021 cd0000        	call	_milis
 211  0024 bf0d          	ldw	L73_last_time,x
 212                     ; 60 		stisknuto = keypad_scan(); // ... skenujeme klávesnici
 214  0026 cd0000        	call	_keypad_scan
 216  0029 6b01          	ld	(OFST+0,sp),a
 218                     ; 62 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvolnìno a pak stisknuto
 220  002b b60c          	ld	a,L53_minule_stisknuto
 221  002d a1ff          	cp	a,#255
 222  002f 262c          	jrne	L121
 224  0031 7b01          	ld	a,(OFST+0,sp)
 225  0033 a1ff          	cp	a,#255
 226  0035 2726          	jreq	L121
 227                     ; 63 			minule_stisknuto = stisknuto;
 229  0037 7b01          	ld	a,(OFST+0,sp)
 230  0039 b70c          	ld	L53_minule_stisknuto,a
 231                     ; 68 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukládat jednotlivé èíslice
 233  003b 7b01          	ld	a,(OFST+0,sp)
 234  003d a10b          	cp	a,#11
 235  003f 261c          	jrne	L121
 238  0041 2016          	jra	L76
 239  0043               L14:
 240                     ; 69 				case 0 :
 240                     ; 70 					break;
 242  0043 2018          	jra	L121
 243  0045               L34:
 244                     ; 71 				case 1 :
 244                     ; 72 					break;
 246  0045 2016          	jra	L121
 247  0047               L54:
 248                     ; 73 				case 2 :
 248                     ; 74 					break;
 250  0047 2014          	jra	L121
 251  0049               L74:
 252                     ; 75 				case 3 :
 252                     ; 76 					break;
 254  0049 2012          	jra	L121
 255  004b               L15:
 256                     ; 77 				case 4 :
 256                     ; 78 					break;
 258  004b 2010          	jra	L121
 259  004d               L35:
 260                     ; 79 				case 5 :
 260                     ; 80 					break;
 262  004d 200e          	jra	L121
 263  004f               L55:
 264                     ; 81 				case 6 :
 264                     ; 82 					break;
 266  004f 200c          	jra	L121
 267  0051               L75:
 268                     ; 83 				case 7 :
 268                     ; 84 					break;
 270  0051 200a          	jra	L121
 271  0053               L16:
 272                     ; 85 				case 8 :
 272                     ; 86 					break;
 274  0053 2008          	jra	L121
 275  0055               L36:
 276                     ; 87 				case 9 :
 276                     ; 88 					break;
 278  0055 2006          	jra	L121
 279  0057               L56:
 280                     ; 89 				case 10 : //  *
 280                     ; 90 					break;
 282  0057 2004          	jra	L121
 283  0059               L76:
 284                     ; 91 				case 11 : //  #
 284                     ; 92 					lcd_gotoxy(0,0);
 286  0059 5f            	clrw	x
 287  005a cd0000        	call	_lcd_gotoxy
 289                     ; 94 					break;
 291  005d               L121:
 292                     ; 97 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 294  005d 7b01          	ld	a,(OFST+0,sp)
 295  005f a1ff          	cp	a,#255
 296  0061 2604          	jrne	L711
 299  0063 35ff000c      	mov	L53_minule_stisknuto,#255
 300  0067               L711:
 301                     ; 99 }
 304  0067 84            	pop	a
 305  0068 81            	ret
 328                     ; 101 void kontrola(void){
 329                     	switch	.text
 330  0069               _kontrola:
 334                     ; 103 }
 337  0069 81            	ret
 372                     ; 116 void assert_failed(u8* file, u32 line)
 372                     ; 117 { 
 373                     	switch	.text
 374  006a               _assert_failed:
 378  006a               L751:
 379  006a 20fe          	jra	L751
 432                     	xdef	_main
 433                     	xdef	_pointer
 434                     	xdef	_entry
 435                     	xdef	_heslo
 436                     	xdef	_status
 437                     	xdef	_kontrola
 438                     	xdef	_process_keypad
 439                     	xdef	_init
 440                     	xref	_lcd_gotoxy
 441                     	xref	_lcd_init
 442                     	xref	_keypad_scan
 443                     	xref	_keypad_init
 444                     	xref	_init_milis
 445                     	xref	_milis
 446                     	xdef	_assert_failed
 447                     	xref	_CLK_HSIPrescalerConfig
 466                     	end
