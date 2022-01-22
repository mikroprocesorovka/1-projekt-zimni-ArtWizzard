   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  15                     	bsct
  16  0000               _status:
  17  0000 0b            	dc.b	11
  18  0001               _heslo:
  19  0001 07            	dc.b	7
  20  0002 05            	dc.b	5
  21  0003 01            	dc.b	1
  22  0004 01            	dc.b	1
  23  0005 00            	ds.b	1
  24  0006               _security_pass:
  25  0006 01            	dc.b	1
  26  0007 02            	dc.b	2
  27  0008 03            	dc.b	3
  28  0009 04            	dc.b	4
  29  000a 00            	ds.b	1
  30  000b               _entry:
  31  000b 0a            	dc.b	10
  32  000c 0a            	dc.b	10
  33  000d 0a            	dc.b	10
  34  000e 0a            	dc.b	10
  35  000f 00            	ds.b	1
  36  0010               _pointer:
  37  0010 00            	dc.b	0
  38  0011               _max_attemps:
  39  0011 03            	dc.b	3
  40  0012               _attemp:
  41  0012 01            	dc.b	1
  73                     ; 43 void main(void){
  75                     	switch	.text
  76  0000               _main:
  80                     ; 44 	init();
  82  0000 ad07          	call	_init
  84  0002               L12:
  85                     ; 47 		process_keypad();			// Aktualizuje stisk kl�vesy
  87  0002 cd009a        	call	_process_keypad
  89                     ; 48 		RGB_manager();				// Signalizace na RGB diodě
  91  0005 ad31          	call	_RGB_manager
  94  0007 20f9          	jra	L12
 122                     ; 56 void init(void){
 123                     	switch	.text
 124  0009               _init:
 128                     ; 57 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z intern�ho RC oscil�toru
 130  0009 4f            	clr	a
 131  000a cd0000        	call	_CLK_HSIPrescalerConfig
 133                     ; 58 	GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_HIGH_SLOW);				// Porty pro RGB diodu
 135  000d 4bd0          	push	#208
 136  000f 4b02          	push	#2
 137  0011 ae500a        	ldw	x,#20490
 138  0014 cd0000        	call	_GPIO_Init
 140  0017 85            	popw	x
 141                     ; 59 	GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_HIGH_SLOW);
 143  0018 4bd0          	push	#208
 144  001a 4b02          	push	#2
 145  001c ae500a        	ldw	x,#20490
 146  001f cd0000        	call	_GPIO_Init
 148  0022 85            	popw	x
 149                     ; 60 	GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_HIGH_SLOW);
 151  0023 4bd0          	push	#208
 152  0025 4b02          	push	#2
 153  0027 ae500a        	ldw	x,#20490
 154  002a cd0000        	call	_GPIO_Init
 156  002d 85            	popw	x
 157                     ; 63 	init_milis();						// Dekralace vnit�n�ho �asu v STM 
 159  002e cd0000        	call	_init_milis
 161                     ; 64 	keypad_init();					// Deklarace nastaven� pin� na kl�vesnici
 163  0031 cd0000        	call	_keypad_init
 165                     ; 65 	lcd_init();							// Nastaven� LDC displeje
 167  0034 cd0000        	call	_lcd_init
 169                     ; 68 }
 172  0037 81            	ret
 198                     ; 70 void RGB_manager(void){
 199                     	switch	.text
 200  0038               _RGB_manager:
 204                     ; 71 	if (status == UNLOCKED){
 206  0038 b600          	ld	a,_status
 207  003a a10c          	cp	a,#12
 208  003c 261d          	jrne	L54
 209                     ; 72 		R_LOW;
 211  003e 4b02          	push	#2
 212  0040 ae500a        	ldw	x,#20490
 213  0043 cd0000        	call	_GPIO_WriteLow
 215  0046 84            	pop	a
 216                     ; 73 		G_HIGH;
 218  0047 4b04          	push	#4
 219  0049 ae500a        	ldw	x,#20490
 220  004c cd0000        	call	_GPIO_WriteHigh
 222  004f 84            	pop	a
 223                     ; 74 		B_LOW;
 225  0050 4b08          	push	#8
 226  0052 ae500a        	ldw	x,#20490
 227  0055 cd0000        	call	_GPIO_WriteLow
 229  0058 84            	pop	a
 231  0059 203e          	jra	L74
 232  005b               L54:
 233                     ; 75 	}else if (status == LOCKED){
 235  005b b600          	ld	a,_status
 236  005d a10b          	cp	a,#11
 237  005f 261d          	jrne	L15
 238                     ; 76 		R_LOW;
 240  0061 4b02          	push	#2
 241  0063 ae500a        	ldw	x,#20490
 242  0066 cd0000        	call	_GPIO_WriteLow
 244  0069 84            	pop	a
 245                     ; 77 		G_LOW;
 247  006a 4b04          	push	#4
 248  006c ae500a        	ldw	x,#20490
 249  006f cd0000        	call	_GPIO_WriteLow
 251  0072 84            	pop	a
 252                     ; 78 		B_HIGH;
 254  0073 4b08          	push	#8
 255  0075 ae500a        	ldw	x,#20490
 256  0078 cd0000        	call	_GPIO_WriteHigh
 258  007b 84            	pop	a
 260  007c 201b          	jra	L74
 261  007e               L15:
 262                     ; 80 		R_HIGH;
 264  007e 4b02          	push	#2
 265  0080 ae500a        	ldw	x,#20490
 266  0083 cd0000        	call	_GPIO_WriteHigh
 268  0086 84            	pop	a
 269                     ; 81 		G_LOW;
 271  0087 4b04          	push	#4
 272  0089 ae500a        	ldw	x,#20490
 273  008c cd0000        	call	_GPIO_WriteLow
 275  008f 84            	pop	a
 276                     ; 82 		B_LOW;
 278  0090 4b08          	push	#8
 279  0092 ae500a        	ldw	x,#20490
 280  0095 cd0000        	call	_GPIO_WriteLow
 282  0098 84            	pop	a
 283  0099               L74:
 284                     ; 84 }
 287  0099 81            	ret
 290                     	bsct
 291  0013               L55_minule_stisknuto:
 292  0013 ff            	dc.b	255
 293  0014               L75_last_time:
 294  0014 0000          	dc.w	0
 360                     .const:	section	.text
 361  0000               L61:
 362  0000 00d7          	dc.w	L16
 363  0002 00dd          	dc.w	L36
 364  0004 00e3          	dc.w	L56
 365  0006 00e9          	dc.w	L76
 366  0008 00ef          	dc.w	L17
 367  000a 00f5          	dc.w	L37
 368  000c 00fb          	dc.w	L57
 369  000e 0101          	dc.w	L77
 370  0010 0107          	dc.w	L101
 371  0012 010d          	dc.w	L301
 372  0014 0113          	dc.w	L501
 373  0016 012e          	dc.w	L701
 374                     ; 87 void process_keypad(void){
 375                     	switch	.text
 376  009a               _process_keypad:
 378  009a 89            	pushw	x
 379       00000002      OFST:	set	2
 382                     ; 93 	if(milis()-last_time > 20){ // ka�d�ch 20 ms ...
 384  009b cd0000        	call	_milis
 386  009e 72b00014      	subw	x,L75_last_time
 387  00a2 a30015        	cpw	x,#21
 388  00a5 2403          	jruge	L02
 389  00a7 cc013a        	jp	L341
 390  00aa               L02:
 391                     ; 94 		last_time = milis();
 393  00aa cd0000        	call	_milis
 395  00ad bf14          	ldw	L75_last_time,x
 396                     ; 95 		stisknuto = keypad_scan(); // ... skenujeme kl�vesnici
 398  00af cd0000        	call	_keypad_scan
 400  00b2 6b02          	ld	(OFST+0,sp),a
 402                     ; 97 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvoln�no a pak stisknuto
 404  00b4 b613          	ld	a,L55_minule_stisknuto
 405  00b6 a1ff          	cp	a,#255
 406  00b8 2702          	jreq	L22
 407  00ba 2074          	jp	L541
 408  00bc               L22:
 410  00bc 7b02          	ld	a,(OFST+0,sp)
 411  00be a1ff          	cp	a,#255
 412  00c0 2602          	jrne	L42
 413  00c2 206c          	jp	L541
 414  00c4               L42:
 415                     ; 98 			minule_stisknuto = stisknuto;
 417  00c4 7b02          	ld	a,(OFST+0,sp)
 418  00c6 b713          	ld	L55_minule_stisknuto,a
 419                     ; 100 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukl�dat jednotliv� ��slice
 421  00c8 7b02          	ld	a,(OFST+0,sp)
 423                     ; 140 					break;
 424  00ca a10c          	cp	a,#12
 425  00cc 2407          	jruge	L41
 426  00ce 5f            	clrw	x
 427  00cf 97            	ld	xl,a
 428  00d0 58            	sllw	x
 429  00d1 de0000        	ldw	x,(L61,x)
 430  00d4 fc            	jp	(x)
 431  00d5               L41:
 432  00d5 2059          	jra	L541
 433  00d7               L16:
 434                     ; 101 				case 0 :
 434                     ; 102 					click(stisknuto);
 436  00d7 7b02          	ld	a,(OFST+0,sp)
 437  00d9 ad61          	call	_click
 439                     ; 103 					break;
 441  00db 2053          	jra	L541
 442  00dd               L36:
 443                     ; 104 				case 1 :
 443                     ; 105 					click(stisknuto);
 445  00dd 7b02          	ld	a,(OFST+0,sp)
 446  00df ad5b          	call	_click
 448                     ; 106 					break;
 450  00e1 204d          	jra	L541
 451  00e3               L56:
 452                     ; 107 				case 2 :
 452                     ; 108 					click(stisknuto);
 454  00e3 7b02          	ld	a,(OFST+0,sp)
 455  00e5 ad55          	call	_click
 457                     ; 109 					break;
 459  00e7 2047          	jra	L541
 460  00e9               L76:
 461                     ; 110 				case 3 :
 461                     ; 111 					click(stisknuto);
 463  00e9 7b02          	ld	a,(OFST+0,sp)
 464  00eb ad4f          	call	_click
 466                     ; 112 					break;
 468  00ed 2041          	jra	L541
 469  00ef               L17:
 470                     ; 113 				case 4 :
 470                     ; 114 					click(stisknuto);
 472  00ef 7b02          	ld	a,(OFST+0,sp)
 473  00f1 ad49          	call	_click
 475                     ; 115 					break;
 477  00f3 203b          	jra	L541
 478  00f5               L37:
 479                     ; 116 				case 5 :
 479                     ; 117 					click(stisknuto);
 481  00f5 7b02          	ld	a,(OFST+0,sp)
 482  00f7 ad43          	call	_click
 484                     ; 118 					break;
 486  00f9 2035          	jra	L541
 487  00fb               L57:
 488                     ; 119 				case 6 :
 488                     ; 120 					click(stisknuto);
 490  00fb 7b02          	ld	a,(OFST+0,sp)
 491  00fd ad3d          	call	_click
 493                     ; 121 					break;
 495  00ff 202f          	jra	L541
 496  0101               L77:
 497                     ; 122 				case 7 :
 497                     ; 123 					click(stisknuto);
 499  0101 7b02          	ld	a,(OFST+0,sp)
 500  0103 ad37          	call	_click
 502                     ; 124 					break;
 504  0105 2029          	jra	L541
 505  0107               L101:
 506                     ; 125 				case 8 :
 506                     ; 126 					click(stisknuto);
 508  0107 7b02          	ld	a,(OFST+0,sp)
 509  0109 ad31          	call	_click
 511                     ; 127 					break;
 513  010b 2023          	jra	L541
 514  010d               L301:
 515                     ; 128 				case 9 :
 515                     ; 129 					click(stisknuto);
 517  010d 7b02          	ld	a,(OFST+0,sp)
 518  010f ad2b          	call	_click
 520                     ; 130 					break;
 522  0111 201d          	jra	L541
 523  0113               L501:
 524                     ; 131 				case 10 : //  *
 524                     ; 132 					for(i = 0; i < (sizeof(entry)-1); i++){
 526  0113 0f01          	clr	(OFST-1,sp)
 528  0115               L351:
 529                     ; 133 						entry[i] = 10;
 531  0115 7b01          	ld	a,(OFST-1,sp)
 532  0117 5f            	clrw	x
 533  0118 97            	ld	xl,a
 534  0119 a60a          	ld	a,#10
 535  011b e70b          	ld	(_entry,x),a
 536                     ; 132 					for(i = 0; i < (sizeof(entry)-1); i++){
 538  011d 0c01          	inc	(OFST-1,sp)
 542  011f 7b01          	ld	a,(OFST-1,sp)
 543  0121 a104          	cp	a,#4
 544  0123 25f0          	jrult	L351
 545                     ; 135 					pointer = 0;
 547  0125 3f10          	clr	_pointer
 548                     ; 136 					lcd_clear();
 550  0127 a601          	ld	a,#1
 551  0129 cd0000        	call	_lcd_command
 553                     ; 137 					break;
 555  012c 2002          	jra	L541
 556  012e               L701:
 557                     ; 138 				case 11 : //  #
 557                     ; 139 					kontrola();
 559  012e ad2b          	call	_kontrola
 561                     ; 140 					break;
 563  0130               L151:
 564  0130               L541:
 565                     ; 144 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 567  0130 7b02          	ld	a,(OFST+0,sp)
 568  0132 a1ff          	cp	a,#255
 569  0134 2604          	jrne	L341
 572  0136 35ff0013      	mov	L55_minule_stisknuto,#255
 573  013a               L341:
 574                     ; 146 }
 577  013a 85            	popw	x
 578  013b 81            	ret
 616                     ; 147 void click(uint8_t number){
 617                     	switch	.text
 618  013c               _click:
 620  013c 88            	push	a
 621       00000000      OFST:	set	0
 624                     ; 148 	lcd_gotoxy(pointer,0);
 626  013d b610          	ld	a,_pointer
 627  013f 5f            	clrw	x
 628  0140 95            	ld	xh,a
 629  0141 cd0000        	call	_lcd_gotoxy
 631                     ; 149 	if(pointer < sizeof(entry)-1){
 633  0144 b610          	ld	a,_pointer
 634  0146 a104          	cp	a,#4
 635  0148 240f          	jruge	L102
 636                     ; 150 		lcd_putchar('*');
 638  014a a62a          	ld	a,#42
 639  014c cd0000        	call	_lcd_data
 641                     ; 151 		entry[pointer] = number;
 643  014f b610          	ld	a,_pointer
 644  0151 5f            	clrw	x
 645  0152 97            	ld	xl,a
 646  0153 7b01          	ld	a,(OFST+1,sp)
 647  0155 e70b          	ld	(_entry,x),a
 648                     ; 152 		pointer ++;
 650  0157 3c10          	inc	_pointer
 651  0159               L102:
 652                     ; 154 }
 655  0159 84            	pop	a
 656  015a 81            	ret
 718                     ; 157 void kontrola(void){
 719                     	switch	.text
 720  015b               _kontrola:
 722  015b 5222          	subw	sp,#34
 723       00000022      OFST:	set	34
 726                     ; 158 	uint8_t pravda = 1;
 728  015d a601          	ld	a,#1
 729  015f 6b21          	ld	(OFST-1,sp),a
 731                     ; 161 	lcd_gotoxy(0,1);
 733  0161 ae0001        	ldw	x,#1
 734  0164 cd0000        	call	_lcd_gotoxy
 736                     ; 163 	if(status / 10 == 1){
 738  0167 b600          	ld	a,_status
 739  0169 5f            	clrw	x
 740  016a 97            	ld	xl,a
 741  016b a60a          	ld	a,#10
 742  016d cd0000        	call	c_sdivx
 744  0170 a30001        	cpw	x,#1
 745  0173 261f          	jrne	L132
 746                     ; 164 		for(i = 0; i < (sizeof(entry)-1); i++){
 748  0175 0f22          	clr	(OFST+0,sp)
 750  0177               L332:
 751                     ; 165 			if (entry[i] != heslo[i]){
 753  0177 7b22          	ld	a,(OFST+0,sp)
 754  0179 5f            	clrw	x
 755  017a 97            	ld	xl,a
 756  017b 7b22          	ld	a,(OFST+0,sp)
 757  017d 905f          	clrw	y
 758  017f 9097          	ld	yl,a
 759  0181 90e60b        	ld	a,(_entry,y)
 760  0184 e101          	cp	a,(_heslo,x)
 761  0186 2702          	jreq	L142
 762                     ; 166 				pravda = 0;
 764  0188 0f21          	clr	(OFST-1,sp)
 766  018a               L142:
 767                     ; 164 		for(i = 0; i < (sizeof(entry)-1); i++){
 769  018a 0c22          	inc	(OFST+0,sp)
 773  018c 7b22          	ld	a,(OFST+0,sp)
 774  018e a104          	cp	a,#4
 775  0190 25e5          	jrult	L332
 777  0192 201d          	jra	L342
 778  0194               L132:
 779                     ; 170 		for(i = 0; i < (sizeof(entry)-1); i++){
 781  0194 0f22          	clr	(OFST+0,sp)
 783  0196               L542:
 784                     ; 171 			if (entry[i] != security_pass[i]){
 786  0196 7b22          	ld	a,(OFST+0,sp)
 787  0198 5f            	clrw	x
 788  0199 97            	ld	xl,a
 789  019a 7b22          	ld	a,(OFST+0,sp)
 790  019c 905f          	clrw	y
 791  019e 9097          	ld	yl,a
 792  01a0 90e60b        	ld	a,(_entry,y)
 793  01a3 e106          	cp	a,(_security_pass,x)
 794  01a5 2702          	jreq	L352
 795                     ; 172 				pravda = 0;
 797  01a7 0f21          	clr	(OFST-1,sp)
 799  01a9               L352:
 800                     ; 170 		for(i = 0; i < (sizeof(entry)-1); i++){
 802  01a9 0c22          	inc	(OFST+0,sp)
 806  01ab 7b22          	ld	a,(OFST+0,sp)
 807  01ad a104          	cp	a,#4
 808  01af 25e5          	jrult	L542
 809  01b1               L342:
 810                     ; 177 	if(pravda){
 812  01b1 0d21          	tnz	(OFST-1,sp)
 813  01b3 2712          	jreq	L552
 814                     ; 178 		sprintf(text,"allowed");
 816  01b5 ae001f        	ldw	x,#L752
 817  01b8 89            	pushw	x
 818  01b9 96            	ldw	x,sp
 819  01ba 1c0003        	addw	x,#OFST-31
 820  01bd cd0000        	call	_sprintf
 822  01c0 85            	popw	x
 823                     ; 180 		attemp = 1;
 825  01c1 35010012      	mov	_attemp,#1
 827  01c5 200e          	jra	L162
 828  01c7               L552:
 829                     ; 183 		sprintf(text,"denied");
 831  01c7 ae0018        	ldw	x,#L362
 832  01ca 89            	pushw	x
 833  01cb 96            	ldw	x,sp
 834  01cc 1c0003        	addw	x,#OFST-31
 835  01cf cd0000        	call	_sprintf
 837  01d2 85            	popw	x
 838                     ; 184 		attemp ++;
 840  01d3 3c12          	inc	_attemp
 841  01d5               L162:
 842                     ; 186 	lcd_puts(text);
 844  01d5 96            	ldw	x,sp
 845  01d6 1c0001        	addw	x,#OFST-33
 846  01d9 cd0000        	call	_lcd_puts
 848                     ; 188 	if (attemp > max_attemps){
 850  01dc b612          	ld	a,_attemp
 851  01de b111          	cp	a,_max_attemps
 852  01e0 2304          	jrule	L562
 853                     ; 189 		status = UNLOCKED_B;
 855  01e2 35160000      	mov	_status,#22
 856  01e6               L562:
 857                     ; 191 }
 860  01e6 5b22          	addw	sp,#34
 861  01e8 81            	ret
 896                     ; 204 void assert_failed(u8* file, u32 line)
 896                     ; 205 { 
 897                     	switch	.text
 898  01e9               _assert_failed:
 902  01e9               L503:
 903  01e9 20fe          	jra	L503
 984                     	xdef	_main
 985                     	xdef	_attemp
 986                     	xdef	_max_attemps
 987                     	xdef	_pointer
 988                     	xdef	_entry
 989                     	xdef	_security_pass
 990                     	xdef	_heslo
 991                     	xdef	_status
 992                     	xdef	_RGB_manager
 993                     	xdef	_click
 994                     	xdef	_kontrola
 995                     	xdef	_process_keypad
 996                     	xdef	_init
 997                     	xref	_sprintf
 998                     	xref	_lcd_puts
 999                     	xref	_lcd_gotoxy
1000                     	xref	_lcd_init
1001                     	xref	_lcd_data
1002                     	xref	_lcd_command
1003                     	xref	_keypad_scan
1004                     	xref	_keypad_init
1005                     	xref	_init_milis
1006                     	xref	_milis
1007                     	xdef	_assert_failed
1008                     	xref	_GPIO_WriteLow
1009                     	xref	_GPIO_WriteHigh
1010                     	xref	_GPIO_Init
1011                     	xref	_CLK_HSIPrescalerConfig
1012                     	switch	.const
1013  0018               L362:
1014  0018 64656e696564  	dc.b	"denied",0
1015  001f               L752:
1016  001f 616c6c6f7765  	dc.b	"allowed",0
1017                     	xref.b	c_x
1037                     	xref	c_sdivx
1038                     	end
