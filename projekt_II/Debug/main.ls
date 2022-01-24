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
  74                     ; 50 void main(void){
  76                     	switch	.text
  77  0000               _main:
  81                     ; 51 	init();
  83  0000 ad13          	call	_init
  85  0002               L12:
  86                     ; 54 		process_keypad();			// Aktualizuje stisk kl�vesy
  88  0002 cd00ad        	call	_process_keypad
  90                     ; 56 		if (status == UNLOCKED_B || status == LOCKED_B){
  92  0005 b600          	ld	a,_status
  93  0007 a116          	cp	a,#22
  94  0009 2706          	jreq	L72
  96  000b b600          	ld	a,_status
  97  000d a115          	cp	a,#21
  98  000f 26f1          	jrne	L12
  99  0011               L72:
 100                     ; 57 			process_pwm_change(); //LED na pinu D4
 102  0011 ad5e          	call	_process_pwm_change
 104  0013 20ed          	jra	L12
 134                     ; 66 void init(void){
 135                     	switch	.text
 136  0015               _init:
 140                     ; 67 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z intern�ho RC oscil�toru
 142  0015 4f            	clr	a
 143  0016 cd0000        	call	_CLK_HSIPrescalerConfig
 145                     ; 69 	GPIO_Init(GPIOC,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);
 147  0019 4bc0          	push	#192
 148  001b 4b04          	push	#4
 149  001d ae500a        	ldw	x,#20490
 150  0020 cd0000        	call	_GPIO_Init
 152  0023 85            	popw	x
 153                     ; 70 	GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);
 155  0024 4bc0          	push	#192
 156  0026 4b08          	push	#8
 157  0028 ae500a        	ldw	x,#20490
 158  002b cd0000        	call	_GPIO_Init
 160  002e 85            	popw	x
 161                     ; 73 	init_milis();						// Dekralace vnit�n�ho �asu v STM 
 163  002f cd0000        	call	_init_milis
 165                     ; 74 	keypad_init();					// Deklarace nastaven� pin� na kl�vesnici
 167  0032 cd0000        	call	_keypad_init
 169                     ; 75 	lcd_init();							// Nastaven� LDC displeje
 171  0035 cd0000        	call	_lcd_init
 173                     ; 76 	init_pwm(); 						// nastavit a spustit timer
 175  0038 cd0249        	call	_init_pwm
 177                     ; 77 	RGB_manager();					// Zobraz� prvn� re�im na RGB
 179  003b ad01          	call	_RGB_manager
 181                     ; 80 }
 184  003d 81            	ret
 210                     ; 82 void RGB_manager(void){
 211                     	switch	.text
 212  003e               _RGB_manager:
 216                     ; 84 	G_LOW;
 218  003e 4b04          	push	#4
 219  0040 ae500a        	ldw	x,#20490
 220  0043 cd0000        	call	_GPIO_WriteLow
 222  0046 84            	pop	a
 223                     ; 85 	B_LOW;
 225  0047 4b08          	push	#8
 226  0049 ae500a        	ldw	x,#20490
 227  004c cd0000        	call	_GPIO_WriteLow
 229  004f 84            	pop	a
 230                     ; 86 	if (status == UNLOCKED){
 232  0050 b600          	ld	a,_status
 233  0052 a10c          	cp	a,#12
 234  0054 260b          	jrne	L15
 235                     ; 87 		G_HIGH;
 237  0056 4b04          	push	#4
 238  0058 ae500a        	ldw	x,#20490
 239  005b cd0000        	call	_GPIO_WriteHigh
 241  005e 84            	pop	a
 243  005f 200f          	jra	L35
 244  0061               L15:
 245                     ; 88 	}else if (status == LOCKED){
 247  0061 b600          	ld	a,_status
 248  0063 a10b          	cp	a,#11
 249  0065 2609          	jrne	L35
 250                     ; 89 		B_HIGH;
 252  0067 4b08          	push	#8
 253  0069 ae500a        	ldw	x,#20490
 254  006c cd0000        	call	_GPIO_WriteHigh
 256  006f 84            	pop	a
 257  0070               L35:
 258                     ; 91 }
 261  0070 81            	ret
 264                     	bsct
 265  0013               L75_pulse:
 266  0013 000a          	dc.w	10
 267  0015               L16_last_time:
 268  0015 0000          	dc.w	0
 269  0017               L36_zmena:
 270  0017 32            	dc.b	50
 322                     ; 94 void process_pwm_change(void){
 323                     	switch	.text
 324  0071               _process_pwm_change:
 326  0071 89            	pushw	x
 327       00000002      OFST:	set	2
 330                     ; 99   if(milis() - last_time >= CHANGE_POSITION_TIME){
 332  0072 cd0000        	call	_milis
 334  0075 72b00015      	subw	x,L16_last_time
 335  0079 a30032        	cpw	x,#50
 336  007c 252d          	jrult	L311
 337                     ; 100 		last_time = milis();
 339  007e cd0000        	call	_milis
 341  0081 bf15          	ldw	L16_last_time,x
 342                     ; 101 		pulse = pulse + zmena;
 344  0083 5f            	clrw	x
 345  0084 b617          	ld	a,L36_zmena
 346  0086 2a01          	jrpl	L41
 347  0088 53            	cplw	x
 348  0089               L41:
 349  0089 97            	ld	xl,a
 350  008a 1f01          	ldw	(OFST-1,sp),x
 352  008c be13          	ldw	x,L75_pulse
 353  008e 72fb01        	addw	x,(OFST-1,sp)
 354  0091 bf13          	ldw	L75_pulse,x
 355                     ; 102 		if(pulse>499 || pulse<50){
 357  0093 be13          	ldw	x,L75_pulse
 358  0095 a301f4        	cpw	x,#500
 359  0098 2407          	jruge	L711
 361  009a be13          	ldw	x,L75_pulse
 362  009c a30032        	cpw	x,#50
 363  009f 2405          	jruge	L511
 364  00a1               L711:
 365                     ; 103 			zmena = zmena*(-1);
 367  00a1 b617          	ld	a,L36_zmena
 368  00a3 40            	neg	a
 369  00a4 b717          	ld	L36_zmena,a
 370  00a6               L511:
 371                     ; 105 		TIM2_SetCompare1(pulse);
 373  00a6 be13          	ldw	x,L75_pulse
 374  00a8 cd0000        	call	_TIM2_SetCompare1
 376  00ab               L311:
 377                     ; 107 }
 380  00ab 85            	popw	x
 381  00ac 81            	ret
 384                     	bsct
 385  0018               L121_minule_stisknuto:
 386  0018 ff            	dc.b	255
 387  0019               L321_last_time:
 388  0019 0000          	dc.w	0
 443                     .const:	section	.text
 444  0000               L22:
 445  0000 00e7          	dc.w	L521
 446  0002 00ed          	dc.w	L721
 447  0004 00f3          	dc.w	L131
 448  0006 00f9          	dc.w	L331
 449  0008 00ff          	dc.w	L531
 450  000a 0105          	dc.w	L731
 451  000c 010b          	dc.w	L141
 452  000e 0111          	dc.w	L341
 453  0010 0117          	dc.w	L541
 454  0012 011d          	dc.w	L741
 455  0014 0123          	dc.w	L151
 456  0016 0127          	dc.w	L351
 457                     ; 110 void process_keypad(void){
 458                     	switch	.text
 459  00ad               _process_keypad:
 461  00ad 88            	push	a
 462       00000001      OFST:	set	1
 465                     ; 116 	if(milis()-last_time > 20){ // ka�d�ch 20 ms ...
 467  00ae cd0000        	call	_milis
 469  00b1 72b00019      	subw	x,L321_last_time
 470  00b5 a30015        	cpw	x,#21
 471  00b8 2402          	jruge	L42
 472  00ba 2077          	jp	L302
 473  00bc               L42:
 474                     ; 117 		last_time = milis();
 476  00bc cd0000        	call	_milis
 478  00bf bf19          	ldw	L321_last_time,x
 479                     ; 118 		stisknuto = keypad_scan(); // ... skenujeme kl�vesnici
 481  00c1 cd0000        	call	_keypad_scan
 483  00c4 6b01          	ld	(OFST+0,sp),a
 485                     ; 120 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvoln�no a pak stisknuto
 487  00c6 b618          	ld	a,L121_minule_stisknuto
 488  00c8 a1ff          	cp	a,#255
 489  00ca 2702          	jreq	L62
 490  00cc 205b          	jp	L502
 491  00ce               L62:
 493  00ce 7b01          	ld	a,(OFST+0,sp)
 494  00d0 a1ff          	cp	a,#255
 495  00d2 2755          	jreq	L502
 496                     ; 121 			minule_stisknuto = stisknuto;
 498  00d4 7b01          	ld	a,(OFST+0,sp)
 499  00d6 b718          	ld	L121_minule_stisknuto,a
 500                     ; 123 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukl�dat jednotliv� ��slice
 502  00d8 7b01          	ld	a,(OFST+0,sp)
 504                     ; 159 					break;
 505  00da a10c          	cp	a,#12
 506  00dc 2407          	jruge	L02
 507  00de 5f            	clrw	x
 508  00df 97            	ld	xl,a
 509  00e0 58            	sllw	x
 510  00e1 de0000        	ldw	x,(L22,x)
 511  00e4 fc            	jp	(x)
 512  00e5               L02:
 513  00e5 2042          	jra	L502
 514  00e7               L521:
 515                     ; 124 				case 0 :
 515                     ; 125 					click(stisknuto);
 517  00e7 7b01          	ld	a,(OFST+0,sp)
 518  00e9 ad66          	call	_click
 520                     ; 126 					break;
 522  00eb 203c          	jra	L502
 523  00ed               L721:
 524                     ; 127 				case 1 :
 524                     ; 128 					click(stisknuto);
 526  00ed 7b01          	ld	a,(OFST+0,sp)
 527  00ef ad60          	call	_click
 529                     ; 129 					break;
 531  00f1 2036          	jra	L502
 532  00f3               L131:
 533                     ; 130 				case 2 :
 533                     ; 131 					click(stisknuto);
 535  00f3 7b01          	ld	a,(OFST+0,sp)
 536  00f5 ad5a          	call	_click
 538                     ; 132 					break;
 540  00f7 2030          	jra	L502
 541  00f9               L331:
 542                     ; 133 				case 3 :
 542                     ; 134 					click(stisknuto);
 544  00f9 7b01          	ld	a,(OFST+0,sp)
 545  00fb ad54          	call	_click
 547                     ; 135 					break;
 549  00fd 202a          	jra	L502
 550  00ff               L531:
 551                     ; 136 				case 4 :
 551                     ; 137 					click(stisknuto);
 553  00ff 7b01          	ld	a,(OFST+0,sp)
 554  0101 ad4e          	call	_click
 556                     ; 138 					break;
 558  0103 2024          	jra	L502
 559  0105               L731:
 560                     ; 139 				case 5 :
 560                     ; 140 					click(stisknuto);
 562  0105 7b01          	ld	a,(OFST+0,sp)
 563  0107 ad48          	call	_click
 565                     ; 141 					break;
 567  0109 201e          	jra	L502
 568  010b               L141:
 569                     ; 142 				case 6 :
 569                     ; 143 					click(stisknuto);
 571  010b 7b01          	ld	a,(OFST+0,sp)
 572  010d ad42          	call	_click
 574                     ; 144 					break;
 576  010f 2018          	jra	L502
 577  0111               L341:
 578                     ; 145 				case 7 :
 578                     ; 146 					click(stisknuto);
 580  0111 7b01          	ld	a,(OFST+0,sp)
 581  0113 ad3c          	call	_click
 583                     ; 147 					break;
 585  0115 2012          	jra	L502
 586  0117               L541:
 587                     ; 148 				case 8 :
 587                     ; 149 					click(stisknuto);
 589  0117 7b01          	ld	a,(OFST+0,sp)
 590  0119 ad36          	call	_click
 592                     ; 150 					break;
 594  011b 200c          	jra	L502
 595  011d               L741:
 596                     ; 151 				case 9 :
 596                     ; 152 					click(stisknuto);
 598  011d 7b01          	ld	a,(OFST+0,sp)
 599  011f ad30          	call	_click
 601                     ; 153 					break;
 603  0121 2006          	jra	L502
 604  0123               L151:
 605                     ; 154 				case 10 : //  *
 605                     ; 155 					clear();
 607  0123 ad10          	call	_clear
 609                     ; 156 					break;
 611  0125 2002          	jra	L502
 612  0127               L351:
 613                     ; 157 				case 11 : //  #
 613                     ; 158 					kontrola();
 615  0127 ad47          	call	_kontrola
 617                     ; 159 					break;
 619  0129               L112:
 620  0129               L502:
 621                     ; 163 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 623  0129 7b01          	ld	a,(OFST+0,sp)
 624  012b a1ff          	cp	a,#255
 625  012d 2604          	jrne	L302
 628  012f 35ff0018      	mov	L121_minule_stisknuto,#255
 629  0133               L302:
 630                     ; 165 }
 633  0133 84            	pop	a
 634  0134 81            	ret
 671                     ; 167 void clear(void){
 672                     	switch	.text
 673  0135               _clear:
 675  0135 88            	push	a
 676       00000001      OFST:	set	1
 679                     ; 169 	for(i = 0; i < (sizeof(entry)-1); i++){
 681  0136 0f01          	clr	(OFST+0,sp)
 683  0138               L332:
 684                     ; 170 		entry[i] = 10;
 686  0138 7b01          	ld	a,(OFST+0,sp)
 687  013a 5f            	clrw	x
 688  013b 97            	ld	xl,a
 689  013c a60a          	ld	a,#10
 690  013e e70b          	ld	(_entry,x),a
 691                     ; 169 	for(i = 0; i < (sizeof(entry)-1); i++){
 693  0140 0c01          	inc	(OFST+0,sp)
 697  0142 7b01          	ld	a,(OFST+0,sp)
 698  0144 a104          	cp	a,#4
 699  0146 25f0          	jrult	L332
 700                     ; 172 	pointer = 0;
 702  0148 3f10          	clr	_pointer
 703                     ; 173 	lcd_clear();
 705  014a a601          	ld	a,#1
 706  014c cd0000        	call	_lcd_command
 708                     ; 174 }
 711  014f 84            	pop	a
 712  0150 81            	ret
 750                     ; 176 void click(uint8_t number){
 751                     	switch	.text
 752  0151               _click:
 754  0151 88            	push	a
 755       00000000      OFST:	set	0
 758                     ; 177 	lcd_gotoxy(pointer,0);
 760  0152 b610          	ld	a,_pointer
 761  0154 5f            	clrw	x
 762  0155 95            	ld	xh,a
 763  0156 cd0000        	call	_lcd_gotoxy
 765                     ; 178 	if(pointer < sizeof(entry)-1){
 767  0159 b610          	ld	a,_pointer
 768  015b a104          	cp	a,#4
 769  015d 240f          	jruge	L752
 770                     ; 179 		lcd_putchar('*');
 772  015f a62a          	ld	a,#42
 773  0161 cd0000        	call	_lcd_data
 775                     ; 180 		entry[pointer] = number;
 777  0164 b610          	ld	a,_pointer
 778  0166 5f            	clrw	x
 779  0167 97            	ld	xl,a
 780  0168 7b01          	ld	a,(OFST+1,sp)
 781  016a e70b          	ld	(_entry,x),a
 782                     ; 181 		pointer ++;
 784  016c 3c10          	inc	_pointer
 785  016e               L752:
 786                     ; 183 }
 789  016e 84            	pop	a
 790  016f 81            	ret
 855                     ; 186 void kontrola(void){
 856                     	switch	.text
 857  0170               _kontrola:
 859  0170 5222          	subw	sp,#34
 860       00000022      OFST:	set	34
 863                     ; 187 	uint8_t pravda = 1;
 865  0172 a601          	ld	a,#1
 866  0174 6b21          	ld	(OFST-1,sp),a
 868                     ; 191 	lcd_gotoxy(0,1);
 870  0176 ae0001        	ldw	x,#1
 871  0179 cd0000        	call	_lcd_gotoxy
 873                     ; 193 	if(status / 10 == 1){ 							//  normální
 875  017c b600          	ld	a,_status
 876  017e 5f            	clrw	x
 877  017f 97            	ld	xl,a
 878  0180 a60a          	ld	a,#10
 879  0182 cd0000        	call	c_sdivx
 881  0185 a30001        	cpw	x,#1
 882  0188 261f          	jrne	L323
 883                     ; 194 		for(i = 0; i < (sizeof(entry)-1); i++){
 885  018a 0f22          	clr	(OFST+0,sp)
 887  018c               L523:
 888                     ; 195 			if (entry[i] != heslo[i]){
 890  018c 7b22          	ld	a,(OFST+0,sp)
 891  018e 5f            	clrw	x
 892  018f 97            	ld	xl,a
 893  0190 7b22          	ld	a,(OFST+0,sp)
 894  0192 905f          	clrw	y
 895  0194 9097          	ld	yl,a
 896  0196 90e60b        	ld	a,(_entry,y)
 897  0199 e101          	cp	a,(_heslo,x)
 898  019b 2702          	jreq	L333
 899                     ; 196 				pravda = 0;
 901  019d 0f21          	clr	(OFST-1,sp)
 903  019f               L333:
 904                     ; 194 		for(i = 0; i < (sizeof(entry)-1); i++){
 906  019f 0c22          	inc	(OFST+0,sp)
 910  01a1 7b22          	ld	a,(OFST+0,sp)
 911  01a3 a104          	cp	a,#4
 912  01a5 25e5          	jrult	L523
 914  01a7 201d          	jra	L533
 915  01a9               L323:
 916                     ; 200 		for(i = 0; i < (sizeof(entry)-1); i++){
 918  01a9 0f22          	clr	(OFST+0,sp)
 920  01ab               L733:
 921                     ; 201 			if (entry[i] != security_pass[i]){
 923  01ab 7b22          	ld	a,(OFST+0,sp)
 924  01ad 5f            	clrw	x
 925  01ae 97            	ld	xl,a
 926  01af 7b22          	ld	a,(OFST+0,sp)
 927  01b1 905f          	clrw	y
 928  01b3 9097          	ld	yl,a
 929  01b5 90e60b        	ld	a,(_entry,y)
 930  01b8 e106          	cp	a,(_security_pass,x)
 931  01ba 2702          	jreq	L543
 932                     ; 202 				pravda = 0;
 934  01bc 0f21          	clr	(OFST-1,sp)
 936  01be               L543:
 937                     ; 200 		for(i = 0; i < (sizeof(entry)-1); i++){
 939  01be 0c22          	inc	(OFST+0,sp)
 943  01c0 7b22          	ld	a,(OFST+0,sp)
 944  01c2 a104          	cp	a,#4
 945  01c4 25e5          	jrult	L733
 946  01c6               L533:
 947                     ; 208 	if(pravda){
 949  01c6 0d21          	tnz	(OFST-1,sp)
 950  01c8 273a          	jreq	L743
 951                     ; 209 		sprintf(text,"allowed");
 953  01ca ae001f        	ldw	x,#L153
 954  01cd 89            	pushw	x
 955  01ce 96            	ldw	x,sp
 956  01cf 1c0003        	addw	x,#OFST-31
 957  01d2 cd0000        	call	_sprintf
 959  01d5 85            	popw	x
 960                     ; 217 		switch(status){
 962  01d6 b600          	ld	a,_status
 964                     ; 229 				break;
 965  01d8 a00b          	sub	a,#11
 966  01da 2712          	jreq	L362
 967  01dc 4a            	dec	a
 968  01dd 2709          	jreq	L162
 969  01df a009          	sub	a,#9
 970  01e1 2717          	jreq	L762
 971  01e3 4a            	dec	a
 972  01e4 270e          	jreq	L562
 973  01e6 2016          	jra	L553
 974  01e8               L162:
 975                     ; 218 			case UNLOCKED:
 975                     ; 219 				status = LOCKED;
 977  01e8 350b0000      	mov	_status,#11
 978                     ; 220 				break;
 980  01ec 2010          	jra	L553
 981  01ee               L362:
 982                     ; 221 			case LOCKED:	
 982                     ; 222 				status = UNLOCKED;
 984  01ee 350c0000      	mov	_status,#12
 985                     ; 223 				break;
 987  01f2 200a          	jra	L553
 988  01f4               L562:
 989                     ; 224 			case UNLOCKED_B:
 989                     ; 225 				status = UNLOCKED;
 991  01f4 350c0000      	mov	_status,#12
 992                     ; 226 				break;
 994  01f8 2004          	jra	L553
 995  01fa               L762:
 996                     ; 227 			case LOCKED_B:
 996                     ; 228 				status = LOCKED;
 998  01fa 350b0000      	mov	_status,#11
 999                     ; 229 				break;
1001  01fe               L553:
1002                     ; 232 		attemp = 1;
1004  01fe 35010012      	mov	_attemp,#1
1006  0202 200e          	jra	L753
1007  0204               L743:
1008                     ; 235 		sprintf(text,"denied");
1010  0204 ae0018        	ldw	x,#L163
1011  0207 89            	pushw	x
1012  0208 96            	ldw	x,sp
1013  0209 1c0003        	addw	x,#OFST-31
1014  020c cd0000        	call	_sprintf
1016  020f 85            	popw	x
1017                     ; 236 		attemp ++;
1019  0210 3c12          	inc	_attemp
1020  0212               L753:
1021                     ; 238 	lcd_puts(text);
1023  0212 96            	ldw	x,sp
1024  0213 1c0001        	addw	x,#OFST-33
1025  0216 cd0000        	call	_lcd_puts
1027                     ; 241 	if (attemp > max_attemps){		//  Změna na blokování
1029  0219 b612          	ld	a,_attemp
1030  021b b111          	cp	a,_max_attemps
1031  021d 231b          	jrule	L363
1032                     ; 242 		switch(status){
1034  021f b600          	ld	a,_status
1036                     ; 248 				break;
1037  0221 a00b          	sub	a,#11
1038  0223 2709          	jreq	L372
1039  0225 4a            	dec	a
1040  0226 260a          	jrne	L763
1041                     ; 243 			case UNLOCKED:
1041                     ; 244 				status = UNLOCKED_B;
1043  0228 35160000      	mov	_status,#22
1044                     ; 245 				break;
1046  022c 2004          	jra	L763
1047  022e               L372:
1048                     ; 246 			case LOCKED:
1048                     ; 247 				status = LOCKED_B;
1050  022e 35150000      	mov	_status,#21
1051                     ; 248 				break;
1053  0232               L763:
1054                     ; 250 		RGB_manager();
1056  0232 cd003e        	call	_RGB_manager
1058                     ; 251 		clear();
1060  0235 cd0135        	call	_clear
1062                     ; 252 		return;
1064  0238 200c          	jra	L63
1065  023a               L363:
1066                     ; 255 	RGB_manager();
1068  023a cd003e        	call	_RGB_manager
1070                     ; 256 	delay_ms(1000);	// pauza pro přebliknkutí
1072  023d ae03e8        	ldw	x,#1000
1073  0240 cd0000        	call	_delay_ms
1075                     ; 257 	clear();
1077  0243 cd0135        	call	_clear
1079                     ; 258 }
1080  0246               L63:
1083  0246 5b22          	addw	sp,#34
1084  0248 81            	ret
1112                     ; 260 void init_pwm(void){
1113                     	switch	.text
1114  0249               _init_pwm:
1118                     ; 262 GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
1120  0249 4be0          	push	#224
1121  024b 4b10          	push	#16
1122  024d ae500f        	ldw	x,#20495
1123  0250 cd0000        	call	_GPIO_Init
1125  0253 85            	popw	x
1126                     ; 264 TIM2_TimeBaseInit(TIM2_PRESCALER_16,1000-1);
1128  0254 ae03e7        	ldw	x,#999
1129  0257 89            	pushw	x
1130  0258 a604          	ld	a,#4
1131  025a cd0000        	call	_TIM2_TimeBaseInit
1133  025d 85            	popw	x
1134                     ; 266 TIM2_OC1Init( 	// inicializujeme kan�l 1 (TM2_CH1)
1134                     ; 267 	TIM2_OCMODE_PWM1, 				// re�im PWM1
1134                     ; 268 	TIM2_OUTPUTSTATE_ENABLE,	// V�stup povolen (TIMer ovl�d� pin)
1134                     ; 269 	DEFAULT_PULSE,		// v�choz� hodnota ���ky pulzu je 1.5ms
1134                     ; 270 	TIM2_OCPOLARITY_HIGH			// Z�t� rozsv�c�me hodnotou HIGH 
1134                     ; 271 	);
1136  025e 4b00          	push	#0
1137  0260 ae000a        	ldw	x,#10
1138  0263 89            	pushw	x
1139  0264 ae6011        	ldw	x,#24593
1140  0267 cd0000        	call	_TIM2_OC1Init
1142  026a 5b03          	addw	sp,#3
1143                     ; 274 TIM2_OC1PreloadConfig(ENABLE);
1145  026c a601          	ld	a,#1
1146  026e cd0000        	call	_TIM2_OC1PreloadConfig
1148                     ; 276 TIM2_Cmd(ENABLE);
1150  0271 a601          	ld	a,#1
1151  0273 cd0000        	call	_TIM2_Cmd
1153                     ; 277 }
1156  0276 81            	ret
1191                     ; 290 void assert_failed(u8* file, u32 line)
1191                     ; 291 { 
1192                     	switch	.text
1193  0277               _assert_failed:
1197  0277               L714:
1198  0277 20fe          	jra	L714
1279                     	xdef	_main
1280                     	xdef	_attemp
1281                     	xdef	_max_attemps
1282                     	xdef	_pointer
1283                     	xdef	_entry
1284                     	xdef	_security_pass
1285                     	xdef	_heslo
1286                     	xdef	_status
1287                     	xdef	_clear
1288                     	xdef	_process_pwm_change
1289                     	xdef	_init_pwm
1290                     	xdef	_RGB_manager
1291                     	xdef	_click
1292                     	xdef	_kontrola
1293                     	xdef	_process_keypad
1294                     	xdef	_init
1295                     	xref	_sprintf
1296                     	xref	_lcd_puts
1297                     	xref	_lcd_gotoxy
1298                     	xref	_lcd_init
1299                     	xref	_lcd_data
1300                     	xref	_lcd_command
1301                     	xref	_keypad_scan
1302                     	xref	_keypad_init
1303                     	xref	_init_milis
1304                     	xref	_delay_ms
1305                     	xref	_milis
1306                     	xdef	_assert_failed
1307                     	xref	_TIM2_SetCompare1
1308                     	xref	_TIM2_OC1PreloadConfig
1309                     	xref	_TIM2_Cmd
1310                     	xref	_TIM2_OC1Init
1311                     	xref	_TIM2_TimeBaseInit
1312                     	xref	_GPIO_WriteLow
1313                     	xref	_GPIO_WriteHigh
1314                     	xref	_GPIO_Init
1315                     	xref	_CLK_HSIPrescalerConfig
1316                     	switch	.const
1317  0018               L163:
1318  0018 64656e696564  	dc.b	"denied",0
1319  001f               L153:
1320  001f 616c6c6f7765  	dc.b	"allowed",0
1321                     	xref.b	c_x
1341                     	xref	c_sdivx
1342                     	end
