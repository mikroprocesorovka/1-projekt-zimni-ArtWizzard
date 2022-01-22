   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  45                     ; 17 void main(void){
  47                     	switch	.text
  48  0000               _main:
  52                     ; 18 	init();
  54  0000 ad04          	call	_init
  56  0002               L12:
  57                     ; 21 		process_keypad();			// Aktualizuje stisk klávesy
  59  0002 ad1b          	call	_process_keypad
  62  0004 20fc          	jra	L12
  90                     ; 29 void init(void){
  91                     	switch	.text
  92  0006               _init:
  96                     ; 30 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z interního RC oscilátoru
  98  0006 4f            	clr	a
  99  0007 cd0000        	call	_CLK_HSIPrescalerConfig
 101                     ; 32 	init_milis();						// Dekralace vnitøního èasu v STM 
 103  000a cd0000        	call	_init_milis
 105                     ; 33 	keypad_init();					// Deklarace nastavení pinù na klávesnici
 107  000d cd0000        	call	_keypad_init
 109                     ; 34 	lcd_init();
 111  0010 cd0000        	call	_lcd_init
 113                     ; 36 	GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);
 115  0013 4bc0          	push	#192
 116  0015 4b20          	push	#32
 117  0017 ae500a        	ldw	x,#20490
 118  001a cd0000        	call	_GPIO_Init
 120  001d 85            	popw	x
 121                     ; 37 }
 124  001e 81            	ret
 127                     	bsct
 128  0000               L53_minule_stisknuto:
 129  0000 ff            	dc.b	255
 130  0001               L73_last_time:
 131  0001 0000          	dc.w	0
 195                     .const:	section	.text
 196  0000               L41:
 197  0000 0064          	dc.w	L14
 198  0002 007b          	dc.w	L34
 199  0004 008f          	dc.w	L54
 200  0006 009a          	dc.w	L74
 201  0008 00a5          	dc.w	L15
 202  000a 00b0          	dc.w	L35
 203  000c 00bb          	dc.w	L55
 204  000e 00c6          	dc.w	L75
 205  0010 00d1          	dc.w	L16
 206  0012 00dc          	dc.w	L36
 207  0014 00e7          	dc.w	L56
 208  0016 00f2          	dc.w	L76
 209                     ; 39 void process_keypad(void){
 210                     	switch	.text
 211  001f               _process_keypad:
 213  001f 89            	pushw	x
 214       00000002      OFST:	set	2
 217                     ; 43 	char x = '*';
 219  0020 a62a          	ld	a,#42
 220  0022 6b01          	ld	(OFST-1,sp),a
 222                     ; 45 	if(milis()-last_time > 20){ // každých 20 ms ...
 224  0024 cd0000        	call	_milis
 226  0027 72b00001      	subw	x,L73_last_time
 227  002b a30015        	cpw	x,#21
 228  002e 2403          	jruge	L61
 229  0030 cc0105        	jp	L321
 230  0033               L61:
 231                     ; 46 		last_time = milis();
 233  0033 cd0000        	call	_milis
 235  0036 bf01          	ldw	L73_last_time,x
 236                     ; 47 		stisknuto = keypad_scan(); // ... skenujeme klávesnici
 238  0038 cd0000        	call	_keypad_scan
 240  003b 6b02          	ld	(OFST+0,sp),a
 242                     ; 49 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvolnìno a pak stisknuto
 244  003d b600          	ld	a,L53_minule_stisknuto
 245  003f a1ff          	cp	a,#255
 246  0041 2703          	jreq	L02
 247  0043 cc00fb        	jp	L521
 248  0046               L02:
 250  0046 7b02          	ld	a,(OFST+0,sp)
 251  0048 a1ff          	cp	a,#255
 252  004a 2603          	jrne	L22
 253  004c cc00fb        	jp	L521
 254  004f               L22:
 255                     ; 50 			minule_stisknuto = stisknuto;
 257  004f 7b02          	ld	a,(OFST+0,sp)
 258  0051 b700          	ld	L53_minule_stisknuto,a
 259                     ; 52 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukládat jednotlivé èíslice
 261  0053 7b02          	ld	a,(OFST+0,sp)
 263                     ; 92 					break;
 264  0055 a10c          	cp	a,#12
 265  0057 2407          	jruge	L21
 266  0059 5f            	clrw	x
 267  005a 97            	ld	xl,a
 268  005b 58            	sllw	x
 269  005c de0000        	ldw	x,(L41,x)
 270  005f fc            	jp	(x)
 271  0060               L21:
 272  0060 acfb00fb      	jpf	L521
 273  0064               L14:
 274                     ; 53 				case 0 :
 274                     ; 54 					lcd_gotoxy(0,1);
 276  0064 ae0001        	ldw	x,#1
 277  0067 cd0000        	call	_lcd_gotoxy
 279                     ; 55 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 281  006a 4b20          	push	#32
 282  006c ae500a        	ldw	x,#20490
 283  006f cd0000        	call	_GPIO_WriteReverse
 285  0072 84            	pop	a
 286                     ; 56 					lcd_putchar(x);
 288  0073 7b01          	ld	a,(OFST-1,sp)
 289  0075 cd0000        	call	_lcd_data
 291                     ; 57 					break;
 293  0078 cc00fb        	jra	L521
 294  007b               L34:
 295                     ; 58 				case 1 :
 295                     ; 59 					lcd_gotoxy(0,0);
 297  007b 5f            	clrw	x
 298  007c cd0000        	call	_lcd_gotoxy
 300                     ; 60 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 302  007f 4b20          	push	#32
 303  0081 ae500a        	ldw	x,#20490
 304  0084 cd0000        	call	_GPIO_WriteReverse
 306  0087 84            	pop	a
 307                     ; 61 					lcd_putchar(x);
 309  0088 7b01          	ld	a,(OFST-1,sp)
 310  008a cd0000        	call	_lcd_data
 312                     ; 62 					break;
 314  008d 206c          	jra	L521
 315  008f               L54:
 316                     ; 63 				case 2 :
 316                     ; 64 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 318  008f 4b20          	push	#32
 319  0091 ae500a        	ldw	x,#20490
 320  0094 cd0000        	call	_GPIO_WriteReverse
 322  0097 84            	pop	a
 323                     ; 65 					break;
 325  0098 2061          	jra	L521
 326  009a               L74:
 327                     ; 66 				case 3 :
 327                     ; 67 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 329  009a 4b20          	push	#32
 330  009c ae500a        	ldw	x,#20490
 331  009f cd0000        	call	_GPIO_WriteReverse
 333  00a2 84            	pop	a
 334                     ; 68 					break;
 336  00a3 2056          	jra	L521
 337  00a5               L15:
 338                     ; 69 				case 4 :
 338                     ; 70 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 340  00a5 4b20          	push	#32
 341  00a7 ae500a        	ldw	x,#20490
 342  00aa cd0000        	call	_GPIO_WriteReverse
 344  00ad 84            	pop	a
 345                     ; 71 					break;
 347  00ae 204b          	jra	L521
 348  00b0               L35:
 349                     ; 72 				case 5 :
 349                     ; 73 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 351  00b0 4b20          	push	#32
 352  00b2 ae500a        	ldw	x,#20490
 353  00b5 cd0000        	call	_GPIO_WriteReverse
 355  00b8 84            	pop	a
 356                     ; 74 					break;
 358  00b9 2040          	jra	L521
 359  00bb               L55:
 360                     ; 75 				case 6 :
 360                     ; 76 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 362  00bb 4b20          	push	#32
 363  00bd ae500a        	ldw	x,#20490
 364  00c0 cd0000        	call	_GPIO_WriteReverse
 366  00c3 84            	pop	a
 367                     ; 77 					break;
 369  00c4 2035          	jra	L521
 370  00c6               L75:
 371                     ; 78 				case 7 :
 371                     ; 79 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 373  00c6 4b20          	push	#32
 374  00c8 ae500a        	ldw	x,#20490
 375  00cb cd0000        	call	_GPIO_WriteReverse
 377  00ce 84            	pop	a
 378                     ; 80 					break;
 380  00cf 202a          	jra	L521
 381  00d1               L16:
 382                     ; 81 				case 8 :
 382                     ; 82 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 384  00d1 4b20          	push	#32
 385  00d3 ae500a        	ldw	x,#20490
 386  00d6 cd0000        	call	_GPIO_WriteReverse
 388  00d9 84            	pop	a
 389                     ; 83 					break;
 391  00da 201f          	jra	L521
 392  00dc               L36:
 393                     ; 84 				case 9 :
 393                     ; 85 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 395  00dc 4b20          	push	#32
 396  00de ae500a        	ldw	x,#20490
 397  00e1 cd0000        	call	_GPIO_WriteReverse
 399  00e4 84            	pop	a
 400                     ; 86 					break;
 402  00e5 2014          	jra	L521
 403  00e7               L56:
 404                     ; 87 				case 10 : //  *
 404                     ; 88 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 406  00e7 4b20          	push	#32
 407  00e9 ae500a        	ldw	x,#20490
 408  00ec cd0000        	call	_GPIO_WriteReverse
 410  00ef 84            	pop	a
 411                     ; 89 					break;
 413  00f0 2009          	jra	L521
 414  00f2               L76:
 415                     ; 90 				case 11 : //  #
 415                     ; 91 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 417  00f2 4b20          	push	#32
 418  00f4 ae500a        	ldw	x,#20490
 419  00f7 cd0000        	call	_GPIO_WriteReverse
 421  00fa 84            	pop	a
 422                     ; 92 					break;
 424  00fb               L131:
 425  00fb               L521:
 426                     ; 96 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 428  00fb 7b02          	ld	a,(OFST+0,sp)
 429  00fd a1ff          	cp	a,#255
 430  00ff 2604          	jrne	L321
 433  0101 35ff0000      	mov	L53_minule_stisknuto,#255
 434  0105               L321:
 435                     ; 98 }
 438  0105 85            	popw	x
 439  0106 81            	ret
 474                     ; 112 void assert_failed(u8* file, u32 line)
 474                     ; 113 { 
 475                     	switch	.text
 476  0107               _assert_failed:
 480  0107               L351:
 481  0107 20fe          	jra	L351
 494                     	xdef	_main
 495                     	xdef	_process_keypad
 496                     	xdef	_init
 497                     	xref	_lcd_gotoxy
 498                     	xref	_lcd_init
 499                     	xref	_lcd_data
 500                     	xref	_keypad_scan
 501                     	xref	_keypad_init
 502                     	xref	_init_milis
 503                     	xref	_milis
 504                     	xdef	_assert_failed
 505                     	xref	_GPIO_WriteReverse
 506                     	xref	_GPIO_Init
 507                     	xref	_CLK_HSIPrescalerConfig
 526                     	end
