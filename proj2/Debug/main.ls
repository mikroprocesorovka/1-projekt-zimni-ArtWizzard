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
  59  0002 ad18          	call	_process_keypad
  62  0004 20fc          	jra	L12
  89                     ; 29 void init(void){
  90                     	switch	.text
  91  0006               _init:
  95                     ; 30 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z interního RC oscilátoru
  97  0006 4f            	clr	a
  98  0007 cd0000        	call	_CLK_HSIPrescalerConfig
 100                     ; 32 	init_milis();						// Dekralace vnitøního èasu v STM 
 102  000a cd0000        	call	_init_milis
 104                     ; 33 	keypad_init();					// Deklarace nastavení pinù na klávesnici
 106  000d cd0000        	call	_keypad_init
 108                     ; 35 	GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);
 110  0010 4bc0          	push	#192
 111  0012 4b20          	push	#32
 112  0014 ae500a        	ldw	x,#20490
 113  0017 cd0000        	call	_GPIO_Init
 115  001a 85            	popw	x
 116                     ; 36 }
 119  001b 81            	ret
 122                     	bsct
 123  0000               L53_minule_stisknuto:
 124  0000 ff            	dc.b	255
 125  0001               L73_last_time:
 126  0001 0000          	dc.w	0
 179                     .const:	section	.text
 180  0000               L41:
 181  0000 005c          	dc.w	L14
 182  0002 0067          	dc.w	L34
 183  0004 0072          	dc.w	L54
 184  0006 007d          	dc.w	L74
 185  0008 0088          	dc.w	L15
 186  000a 0093          	dc.w	L35
 187  000c 009e          	dc.w	L55
 188  000e 00a9          	dc.w	L75
 189  0010 00b4          	dc.w	L16
 190  0012 00bf          	dc.w	L36
 191  0014 00ca          	dc.w	L56
 192  0016 00d5          	dc.w	L76
 193                     ; 38 void process_keypad(void){
 194                     	switch	.text
 195  001c               _process_keypad:
 197  001c 88            	push	a
 198       00000001      OFST:	set	1
 201                     ; 43 	if(milis()-last_time > 20){ // každých 20 ms ...
 203  001d cd0000        	call	_milis
 205  0020 72b00001      	subw	x,L73_last_time
 206  0024 a30015        	cpw	x,#21
 207  0027 2403          	jruge	L61
 208  0029 cc00e8        	jp	L711
 209  002c               L61:
 210                     ; 44 		last_time = milis();
 212  002c cd0000        	call	_milis
 214  002f bf01          	ldw	L73_last_time,x
 215                     ; 45 		stisknuto = keypad_scan(); // ... skenujeme klávesnici
 217  0031 cd0000        	call	_keypad_scan
 219  0034 6b01          	ld	(OFST+0,sp),a
 221                     ; 46 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvolnìno a pak stisknuto
 223  0036 b600          	ld	a,L53_minule_stisknuto
 224  0038 a1ff          	cp	a,#255
 225  003a 2703          	jreq	L02
 226  003c cc00de        	jp	L121
 227  003f               L02:
 229  003f 7b01          	ld	a,(OFST+0,sp)
 230  0041 a1ff          	cp	a,#255
 231  0043 2603          	jrne	L22
 232  0045 cc00de        	jp	L121
 233  0048               L22:
 234                     ; 47 			minule_stisknuto = stisknuto;
 236  0048 7b01          	ld	a,(OFST+0,sp)
 237  004a b700          	ld	L53_minule_stisknuto,a
 238                     ; 49 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukládat jednotlivé èíslice
 240  004c 7b01          	ld	a,(OFST+0,sp)
 242                     ; 85 					break;
 243  004e a10c          	cp	a,#12
 244  0050 2407          	jruge	L21
 245  0052 5f            	clrw	x
 246  0053 97            	ld	xl,a
 247  0054 58            	sllw	x
 248  0055 de0000        	ldw	x,(L41,x)
 249  0058 fc            	jp	(x)
 250  0059               L21:
 251  0059 cc00de        	jra	L121
 252  005c               L14:
 253                     ; 50 				case 0 :
 253                     ; 51 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 255  005c 4b20          	push	#32
 256  005e ae500a        	ldw	x,#20490
 257  0061 cd0000        	call	_GPIO_WriteReverse
 259  0064 84            	pop	a
 260                     ; 52 					break;
 262  0065 2077          	jra	L121
 263  0067               L34:
 264                     ; 53 				case 1 :
 264                     ; 54 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 266  0067 4b20          	push	#32
 267  0069 ae500a        	ldw	x,#20490
 268  006c cd0000        	call	_GPIO_WriteReverse
 270  006f 84            	pop	a
 271                     ; 55 					break;
 273  0070 206c          	jra	L121
 274  0072               L54:
 275                     ; 56 				case 2 :
 275                     ; 57 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 277  0072 4b20          	push	#32
 278  0074 ae500a        	ldw	x,#20490
 279  0077 cd0000        	call	_GPIO_WriteReverse
 281  007a 84            	pop	a
 282                     ; 58 					break;
 284  007b 2061          	jra	L121
 285  007d               L74:
 286                     ; 59 				case 3 :
 286                     ; 60 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 288  007d 4b20          	push	#32
 289  007f ae500a        	ldw	x,#20490
 290  0082 cd0000        	call	_GPIO_WriteReverse
 292  0085 84            	pop	a
 293                     ; 61 					break;
 295  0086 2056          	jra	L121
 296  0088               L15:
 297                     ; 62 				case 4 :
 297                     ; 63 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 299  0088 4b20          	push	#32
 300  008a ae500a        	ldw	x,#20490
 301  008d cd0000        	call	_GPIO_WriteReverse
 303  0090 84            	pop	a
 304                     ; 64 					break;
 306  0091 204b          	jra	L121
 307  0093               L35:
 308                     ; 65 				case 5 :
 308                     ; 66 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 310  0093 4b20          	push	#32
 311  0095 ae500a        	ldw	x,#20490
 312  0098 cd0000        	call	_GPIO_WriteReverse
 314  009b 84            	pop	a
 315                     ; 67 					break;
 317  009c 2040          	jra	L121
 318  009e               L55:
 319                     ; 68 				case 6 :
 319                     ; 69 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 321  009e 4b20          	push	#32
 322  00a0 ae500a        	ldw	x,#20490
 323  00a3 cd0000        	call	_GPIO_WriteReverse
 325  00a6 84            	pop	a
 326                     ; 70 					break;
 328  00a7 2035          	jra	L121
 329  00a9               L75:
 330                     ; 71 				case 7 :
 330                     ; 72 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 332  00a9 4b20          	push	#32
 333  00ab ae500a        	ldw	x,#20490
 334  00ae cd0000        	call	_GPIO_WriteReverse
 336  00b1 84            	pop	a
 337                     ; 73 					break;
 339  00b2 202a          	jra	L121
 340  00b4               L16:
 341                     ; 74 				case 8 :
 341                     ; 75 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 343  00b4 4b20          	push	#32
 344  00b6 ae500a        	ldw	x,#20490
 345  00b9 cd0000        	call	_GPIO_WriteReverse
 347  00bc 84            	pop	a
 348                     ; 76 					break;
 350  00bd 201f          	jra	L121
 351  00bf               L36:
 352                     ; 77 				case 9 :
 352                     ; 78 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 354  00bf 4b20          	push	#32
 355  00c1 ae500a        	ldw	x,#20490
 356  00c4 cd0000        	call	_GPIO_WriteReverse
 358  00c7 84            	pop	a
 359                     ; 79 					break;
 361  00c8 2014          	jra	L121
 362  00ca               L56:
 363                     ; 80 				case 10 : //  *
 363                     ; 81 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 365  00ca 4b20          	push	#32
 366  00cc ae500a        	ldw	x,#20490
 367  00cf cd0000        	call	_GPIO_WriteReverse
 369  00d2 84            	pop	a
 370                     ; 82 					break;
 372  00d3 2009          	jra	L121
 373  00d5               L76:
 374                     ; 83 				case 11 : //  #
 374                     ; 84 					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
 376  00d5 4b20          	push	#32
 377  00d7 ae500a        	ldw	x,#20490
 378  00da cd0000        	call	_GPIO_WriteReverse
 380  00dd 84            	pop	a
 381                     ; 85 					break;
 383  00de               L521:
 384  00de               L121:
 385                     ; 89 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 387  00de 7b01          	ld	a,(OFST+0,sp)
 388  00e0 a1ff          	cp	a,#255
 389  00e2 2604          	jrne	L711
 392  00e4 35ff0000      	mov	L53_minule_stisknuto,#255
 393  00e8               L711:
 394                     ; 91 }
 397  00e8 84            	pop	a
 398  00e9 81            	ret
 433                     ; 105 void assert_failed(u8* file, u32 line)
 433                     ; 106 { 
 434                     	switch	.text
 435  00ea               _assert_failed:
 439  00ea               L741:
 440  00ea 20fe          	jra	L741
 453                     	xdef	_main
 454                     	xdef	_process_keypad
 455                     	xdef	_init
 456                     	xref	_keypad_scan
 457                     	xref	_keypad_init
 458                     	xref	_init_milis
 459                     	xref	_milis
 460                     	xdef	_assert_failed
 461                     	xref	_GPIO_WriteReverse
 462                     	xref	_GPIO_Init
 463                     	xref	_CLK_HSIPrescalerConfig
 482                     	end
