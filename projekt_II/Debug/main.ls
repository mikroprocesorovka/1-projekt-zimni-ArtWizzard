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
 198  0002 007a          	dc.w	L34
 199  0004 0085          	dc.w	L54
 200  0006 0090          	dc.w	L74
 201  0008 009b          	dc.w	L15
 202  000a 00a6          	dc.w	L35
 203  000c 00b1          	dc.w	L55
 204  000e 00bc          	dc.w	L75
 205  0010 00c7          	dc.w	L16
 206  0012 00d2          	dc.w	L36
 207  0014 00dd          	dc.w	L56
 208  0016 00e8          	dc.w	L76
 209                     ; 39 void process_keypad(void){
 210                     	switch	.text
 211  001f               _process_keypad:
 213  001f 89            	pushw	x
 214       00000002      OFST:	set	2
 217                     ; 45 	char x = 'A';
 219  0020 a641          	ld	a,#65
 220  0022 6b01          	ld	(OFST-1,sp),a
 222                     ; 47 	if(milis()-last_time > 20){ // každých 20 ms ...
 224  0024 cd0000        	call	_milis
 226  0027 72b00001      	subw	x,L73_last_time
 227  002b a30015        	cpw	x,#21
 228  002e 2403          	jruge	L61
 229  0030 cc00fb        	jp	L321
 230  0033               L61:
 231                     ; 48 		last_time = milis();
 233  0033 cd0000        	call	_milis
 235  0036 bf01          	ldw	L73_last_time,x
 236                     ; 49 		stisknuto = keypad_scan(); // ... skenujeme klávesnici
 238  0038 cd0000        	call	_keypad_scan
 240  003b 6b02          	ld	(OFST+0,sp),a
 242                     ; 51 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvolnìno a pak stisknuto
 244  003d b600          	ld	a,L53_minule_stisknuto
 245  003f a1ff          	cp	a,#255
 246  0041 2703          	jreq	L02
 247  0043 cc00f1        	jp	L521
 248  0046               L02:
 250  0046 7b02          	ld	a,(OFST+0,sp)
 251  0048 a1ff          	cp	a,#255
 252  004a 2603          	jrne	L22
 253  004c cc00f1        	jp	L521
 254  004f               L22:
 255                     ; 52 			minule_stisknuto = stisknuto;
 257  004f 7b02          	ld	a,(OFST+0,sp)
 258  0051 b700          	ld	L53_minule_stisknuto,a
 259                     ; 54 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukládat jednotlivé èíslice
 261  0053 7b02          	ld	a,(OFST+0,sp)
 263                     ; 94 					break;
 264  0055 a10c          	cp	a,#12
 265  0057 2407          	jruge	L21
 266  0059 5f            	clrw	x
 267  005a 97            	ld	xl,a
 268  005b 58            	sllw	x
 269  005c de0000        	ldw	x,(L41,x)
 270  005f fc            	jp	(x)
 271  0060               L21:
 272  0060 acf100f1      	jpf	L521
 273  0064               L14:
 274                     ; 55 				case 0 :
 274                     ; 56 					lcd_gotoxy(0,1);
 276  0064 ae0001        	ldw	x,#1
 277  0067 cd0000        	call	_lcd_gotoxy
 279                     ; 57 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 281  006a 4b20          	push	#32
 282  006c ae500a        	ldw	x,#20490
 283  006f cd0000        	call	_GPIO_WriteReverse
 285  0072 84            	pop	a
 286                     ; 60 					lcd_putchar(x);
 288  0073 7b01          	ld	a,(OFST-1,sp)
 289  0075 cd0000        	call	_lcd_data
 291                     ; 61 					break;
 293  0078 2077          	jra	L521
 294  007a               L34:
 295                     ; 62 				case 1 :
 295                     ; 63 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 297  007a 4b20          	push	#32
 298  007c ae500a        	ldw	x,#20490
 299  007f cd0000        	call	_GPIO_WriteReverse
 301  0082 84            	pop	a
 302                     ; 64 					break;
 304  0083 206c          	jra	L521
 305  0085               L54:
 306                     ; 65 				case 2 :
 306                     ; 66 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 308  0085 4b20          	push	#32
 309  0087 ae500a        	ldw	x,#20490
 310  008a cd0000        	call	_GPIO_WriteReverse
 312  008d 84            	pop	a
 313                     ; 67 					break;
 315  008e 2061          	jra	L521
 316  0090               L74:
 317                     ; 68 				case 3 :
 317                     ; 69 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 319  0090 4b20          	push	#32
 320  0092 ae500a        	ldw	x,#20490
 321  0095 cd0000        	call	_GPIO_WriteReverse
 323  0098 84            	pop	a
 324                     ; 70 					break;
 326  0099 2056          	jra	L521
 327  009b               L15:
 328                     ; 71 				case 4 :
 328                     ; 72 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 330  009b 4b20          	push	#32
 331  009d ae500a        	ldw	x,#20490
 332  00a0 cd0000        	call	_GPIO_WriteReverse
 334  00a3 84            	pop	a
 335                     ; 73 					break;
 337  00a4 204b          	jra	L521
 338  00a6               L35:
 339                     ; 74 				case 5 :
 339                     ; 75 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 341  00a6 4b20          	push	#32
 342  00a8 ae500a        	ldw	x,#20490
 343  00ab cd0000        	call	_GPIO_WriteReverse
 345  00ae 84            	pop	a
 346                     ; 76 					break;
 348  00af 2040          	jra	L521
 349  00b1               L55:
 350                     ; 77 				case 6 :
 350                     ; 78 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 352  00b1 4b20          	push	#32
 353  00b3 ae500a        	ldw	x,#20490
 354  00b6 cd0000        	call	_GPIO_WriteReverse
 356  00b9 84            	pop	a
 357                     ; 79 					break;
 359  00ba 2035          	jra	L521
 360  00bc               L75:
 361                     ; 80 				case 7 :
 361                     ; 81 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 363  00bc 4b20          	push	#32
 364  00be ae500a        	ldw	x,#20490
 365  00c1 cd0000        	call	_GPIO_WriteReverse
 367  00c4 84            	pop	a
 368                     ; 82 					break;
 370  00c5 202a          	jra	L521
 371  00c7               L16:
 372                     ; 83 				case 8 :
 372                     ; 84 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 374  00c7 4b20          	push	#32
 375  00c9 ae500a        	ldw	x,#20490
 376  00cc cd0000        	call	_GPIO_WriteReverse
 378  00cf 84            	pop	a
 379                     ; 85 					break;
 381  00d0 201f          	jra	L521
 382  00d2               L36:
 383                     ; 86 				case 9 :
 383                     ; 87 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 385  00d2 4b20          	push	#32
 386  00d4 ae500a        	ldw	x,#20490
 387  00d7 cd0000        	call	_GPIO_WriteReverse
 389  00da 84            	pop	a
 390                     ; 88 					break;
 392  00db 2014          	jra	L521
 393  00dd               L56:
 394                     ; 89 				case 10 : //  *
 394                     ; 90 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 396  00dd 4b20          	push	#32
 397  00df ae500a        	ldw	x,#20490
 398  00e2 cd0000        	call	_GPIO_WriteReverse
 400  00e5 84            	pop	a
 401                     ; 91 					break;
 403  00e6 2009          	jra	L521
 404  00e8               L76:
 405                     ; 92 				case 11 : //  #
 405                     ; 93 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 407  00e8 4b20          	push	#32
 408  00ea ae500a        	ldw	x,#20490
 409  00ed cd0000        	call	_GPIO_WriteReverse
 411  00f0 84            	pop	a
 412                     ; 94 					break;
 414  00f1               L131:
 415  00f1               L521:
 416                     ; 98 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 418  00f1 7b02          	ld	a,(OFST+0,sp)
 419  00f3 a1ff          	cp	a,#255
 420  00f5 2604          	jrne	L321
 423  00f7 35ff0000      	mov	L53_minule_stisknuto,#255
 424  00fb               L321:
 425                     ; 100 }
 428  00fb 85            	popw	x
 429  00fc 81            	ret
 464                     ; 114 void assert_failed(u8* file, u32 line)
 464                     ; 115 { 
 465                     	switch	.text
 466  00fd               _assert_failed:
 470  00fd               L351:
 471  00fd 20fe          	jra	L351
 484                     	xdef	_main
 485                     	xdef	_process_keypad
 486                     	xdef	_init
 487                     	xref	_lcd_gotoxy
 488                     	xref	_lcd_init
 489                     	xref	_lcd_data
 490                     	xref	_keypad_scan
 491                     	xref	_keypad_init
 492                     	xref	_init_milis
 493                     	xref	_milis
 494                     	xdef	_assert_failed
 495                     	xref	_GPIO_WriteReverse
 496                     	xref	_GPIO_Init
 497                     	xref	_CLK_HSIPrescalerConfig
 516                     	end
