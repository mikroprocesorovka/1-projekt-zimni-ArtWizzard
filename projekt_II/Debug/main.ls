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
  73                     ; 49 void main(void){
  75                     	switch	.text
  76  0000               _main:
  80                     ; 50 	init();
  82  0000 ad07          	call	_init
  84  0002               L12:
  85                     ; 53 		process_keypad();			// Aktualizuje stisk kl�vesy
  87  0002 cd00af        	call	_process_keypad
  89                     ; 54 		RGB_manager();				// Signalizace na RGB diodě
  91  0005 ad29          	call	_RGB_manager
  94  0007 20f9          	jra	L12
 123                     ; 63 void init(void){
 124                     	switch	.text
 125  0009               _init:
 129                     ; 64 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z intern�ho RC oscil�toru
 131  0009 4f            	clr	a
 132  000a cd0000        	call	_CLK_HSIPrescalerConfig
 134                     ; 66 	GPIO_Init(GPIOC,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);
 136  000d 4bc0          	push	#192
 137  000f 4b04          	push	#4
 138  0011 ae500a        	ldw	x,#20490
 139  0014 cd0000        	call	_GPIO_Init
 141  0017 85            	popw	x
 142                     ; 67 	GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);
 144  0018 4bc0          	push	#192
 145  001a 4b08          	push	#8
 146  001c ae500a        	ldw	x,#20490
 147  001f cd0000        	call	_GPIO_Init
 149  0022 85            	popw	x
 150                     ; 70 	init_milis();						// Dekralace vnit�n�ho �asu v STM 
 152  0023 cd0000        	call	_init_milis
 154                     ; 71 	keypad_init();					// Deklarace nastaven� pin� na kl�vesnici
 156  0026 cd0000        	call	_keypad_init
 158                     ; 72 	lcd_init();							// Nastaven� LDC displeje
 160  0029 cd0000        	call	_lcd_init
 162                     ; 73 	init_pwm(); 						// nastavit a spustit timer
 164  002c cd0202        	call	_init_pwm
 166                     ; 76 }
 169  002f 81            	ret
 196                     ; 78 void RGB_manager(void){
 197                     	switch	.text
 198  0030               _RGB_manager:
 202                     ; 80 	G_LOW;
 204  0030 4b04          	push	#4
 205  0032 ae500a        	ldw	x,#20490
 206  0035 cd0000        	call	_GPIO_WriteLow
 208  0038 84            	pop	a
 209                     ; 81 	B_LOW;
 211  0039 4b08          	push	#8
 212  003b ae500a        	ldw	x,#20490
 213  003e cd0000        	call	_GPIO_WriteLow
 215  0041 84            	pop	a
 216                     ; 82 	if (status == UNLOCKED){
 218  0042 b600          	ld	a,_status
 219  0044 a10c          	cp	a,#12
 220  0046 260b          	jrne	L54
 221                     ; 83 		G_HIGH;
 223  0048 4b04          	push	#4
 224  004a ae500a        	ldw	x,#20490
 225  004d cd0000        	call	_GPIO_WriteHigh
 227  0050 84            	pop	a
 229  0051 201f          	jra	L74
 230  0053               L54:
 231                     ; 84 	}else if (status == LOCKED){
 233  0053 b600          	ld	a,_status
 234  0055 a10b          	cp	a,#11
 235  0057 260b          	jrne	L15
 236                     ; 85 		B_HIGH;
 238  0059 4b08          	push	#8
 239  005b ae500a        	ldw	x,#20490
 240  005e cd0000        	call	_GPIO_WriteHigh
 242  0061 84            	pop	a
 244  0062 200e          	jra	L74
 245  0064               L15:
 246                     ; 86 	}else if (status == LOCKED_B || status == UNLOCKED_B){
 248  0064 b600          	ld	a,_status
 249  0066 a115          	cp	a,#21
 250  0068 2706          	jreq	L75
 252  006a b600          	ld	a,_status
 253  006c a116          	cp	a,#22
 254  006e 2602          	jrne	L74
 255  0070               L75:
 256                     ; 88 		process_pwm_change(); //LED na pinu D4
 258  0070 ad01          	call	_process_pwm_change
 260  0072               L74:
 261                     ; 90 }
 264  0072 81            	ret
 267                     	bsct
 268  0013               L16_pulse:
 269  0013 000a          	dc.w	10
 270  0015               L36_last_time:
 271  0015 0000          	dc.w	0
 272  0017               L56_zmena:
 273  0017 32            	dc.b	50
 325                     ; 93 void process_pwm_change(void){
 326                     	switch	.text
 327  0073               _process_pwm_change:
 329  0073 89            	pushw	x
 330       00000002      OFST:	set	2
 333                     ; 98   if(milis() - last_time >= CHANGE_POSITION_TIME){
 335  0074 cd0000        	call	_milis
 337  0077 72b00015      	subw	x,L36_last_time
 338  007b a30032        	cpw	x,#50
 339  007e 252d          	jrult	L511
 340                     ; 99 		last_time = milis();
 342  0080 cd0000        	call	_milis
 344  0083 bf15          	ldw	L36_last_time,x
 345                     ; 100 		pulse = pulse + zmena;
 347  0085 5f            	clrw	x
 348  0086 b617          	ld	a,L56_zmena
 349  0088 2a01          	jrpl	L41
 350  008a 53            	cplw	x
 351  008b               L41:
 352  008b 97            	ld	xl,a
 353  008c 1f01          	ldw	(OFST-1,sp),x
 355  008e be13          	ldw	x,L16_pulse
 356  0090 72fb01        	addw	x,(OFST-1,sp)
 357  0093 bf13          	ldw	L16_pulse,x
 358                     ; 101 		if(pulse>499 || pulse<50){
 360  0095 be13          	ldw	x,L16_pulse
 361  0097 a301f4        	cpw	x,#500
 362  009a 2407          	jruge	L121
 364  009c be13          	ldw	x,L16_pulse
 365  009e a30032        	cpw	x,#50
 366  00a1 2405          	jruge	L711
 367  00a3               L121:
 368                     ; 102 			zmena = zmena*(-1);
 370  00a3 b617          	ld	a,L56_zmena
 371  00a5 40            	neg	a
 372  00a6 b717          	ld	L56_zmena,a
 373  00a8               L711:
 374                     ; 104 		TIM2_SetCompare1(pulse);
 376  00a8 be13          	ldw	x,L16_pulse
 377  00aa cd0000        	call	_TIM2_SetCompare1
 379  00ad               L511:
 380                     ; 106 }
 383  00ad 85            	popw	x
 384  00ae 81            	ret
 387                     	bsct
 388  0018               L321_minule_stisknuto:
 389  0018 ff            	dc.b	255
 390  0019               L521_last_time:
 391  0019 0000          	dc.w	0
 457                     .const:	section	.text
 458  0000               L22:
 459  0000 00ec          	dc.w	L721
 460  0002 00f2          	dc.w	L131
 461  0004 00f8          	dc.w	L331
 462  0006 00fe          	dc.w	L531
 463  0008 0104          	dc.w	L731
 464  000a 010a          	dc.w	L141
 465  000c 0110          	dc.w	L341
 466  000e 0116          	dc.w	L541
 467  0010 011c          	dc.w	L741
 468  0012 0122          	dc.w	L151
 469  0014 0128          	dc.w	L351
 470  0016 0143          	dc.w	L551
 471                     ; 109 void process_keypad(void){
 472                     	switch	.text
 473  00af               _process_keypad:
 475  00af 89            	pushw	x
 476       00000002      OFST:	set	2
 479                     ; 115 	if(milis()-last_time > 20){ // ka�d�ch 20 ms ...
 481  00b0 cd0000        	call	_milis
 483  00b3 72b00019      	subw	x,L521_last_time
 484  00b7 a30015        	cpw	x,#21
 485  00ba 2403          	jruge	L42
 486  00bc cc014f        	jp	L112
 487  00bf               L42:
 488                     ; 116 		last_time = milis();
 490  00bf cd0000        	call	_milis
 492  00c2 bf19          	ldw	L521_last_time,x
 493                     ; 117 		stisknuto = keypad_scan(); // ... skenujeme kl�vesnici
 495  00c4 cd0000        	call	_keypad_scan
 497  00c7 6b02          	ld	(OFST+0,sp),a
 499                     ; 119 		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvoln�no a pak stisknuto
 501  00c9 b618          	ld	a,L321_minule_stisknuto
 502  00cb a1ff          	cp	a,#255
 503  00cd 2702          	jreq	L62
 504  00cf 2074          	jp	L312
 505  00d1               L62:
 507  00d1 7b02          	ld	a,(OFST+0,sp)
 508  00d3 a1ff          	cp	a,#255
 509  00d5 2602          	jrne	L03
 510  00d7 206c          	jp	L312
 511  00d9               L03:
 512                     ; 120 			minule_stisknuto = stisknuto;
 514  00d9 7b02          	ld	a,(OFST+0,sp)
 515  00db b718          	ld	L321_minule_stisknuto,a
 516                     ; 122 			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukl�dat jednotliv� ��slice
 518  00dd 7b02          	ld	a,(OFST+0,sp)
 520                     ; 162 					break;
 521  00df a10c          	cp	a,#12
 522  00e1 2407          	jruge	L02
 523  00e3 5f            	clrw	x
 524  00e4 97            	ld	xl,a
 525  00e5 58            	sllw	x
 526  00e6 de0000        	ldw	x,(L22,x)
 527  00e9 fc            	jp	(x)
 528  00ea               L02:
 529  00ea 2059          	jra	L312
 530  00ec               L721:
 531                     ; 123 				case 0 :
 531                     ; 124 					click(stisknuto);
 533  00ec 7b02          	ld	a,(OFST+0,sp)
 534  00ee ad61          	call	_click
 536                     ; 125 					break;
 538  00f0 2053          	jra	L312
 539  00f2               L131:
 540                     ; 126 				case 1 :
 540                     ; 127 					click(stisknuto);
 542  00f2 7b02          	ld	a,(OFST+0,sp)
 543  00f4 ad5b          	call	_click
 545                     ; 128 					break;
 547  00f6 204d          	jra	L312
 548  00f8               L331:
 549                     ; 129 				case 2 :
 549                     ; 130 					click(stisknuto);
 551  00f8 7b02          	ld	a,(OFST+0,sp)
 552  00fa ad55          	call	_click
 554                     ; 131 					break;
 556  00fc 2047          	jra	L312
 557  00fe               L531:
 558                     ; 132 				case 3 :
 558                     ; 133 					click(stisknuto);
 560  00fe 7b02          	ld	a,(OFST+0,sp)
 561  0100 ad4f          	call	_click
 563                     ; 134 					break;
 565  0102 2041          	jra	L312
 566  0104               L731:
 567                     ; 135 				case 4 :
 567                     ; 136 					click(stisknuto);
 569  0104 7b02          	ld	a,(OFST+0,sp)
 570  0106 ad49          	call	_click
 572                     ; 137 					break;
 574  0108 203b          	jra	L312
 575  010a               L141:
 576                     ; 138 				case 5 :
 576                     ; 139 					click(stisknuto);
 578  010a 7b02          	ld	a,(OFST+0,sp)
 579  010c ad43          	call	_click
 581                     ; 140 					break;
 583  010e 2035          	jra	L312
 584  0110               L341:
 585                     ; 141 				case 6 :
 585                     ; 142 					click(stisknuto);
 587  0110 7b02          	ld	a,(OFST+0,sp)
 588  0112 ad3d          	call	_click
 590                     ; 143 					break;
 592  0114 202f          	jra	L312
 593  0116               L541:
 594                     ; 144 				case 7 :
 594                     ; 145 					click(stisknuto);
 596  0116 7b02          	ld	a,(OFST+0,sp)
 597  0118 ad37          	call	_click
 599                     ; 146 					break;
 601  011a 2029          	jra	L312
 602  011c               L741:
 603                     ; 147 				case 8 :
 603                     ; 148 					click(stisknuto);
 605  011c 7b02          	ld	a,(OFST+0,sp)
 606  011e ad31          	call	_click
 608                     ; 149 					break;
 610  0120 2023          	jra	L312
 611  0122               L151:
 612                     ; 150 				case 9 :
 612                     ; 151 					click(stisknuto);
 614  0122 7b02          	ld	a,(OFST+0,sp)
 615  0124 ad2b          	call	_click
 617                     ; 152 					break;
 619  0126 201d          	jra	L312
 620  0128               L351:
 621                     ; 153 				case 10 : //  *
 621                     ; 154 					for(i = 0; i < (sizeof(entry)-1); i++){
 623  0128 0f01          	clr	(OFST-1,sp)
 625  012a               L122:
 626                     ; 155 						entry[i] = 10;
 628  012a 7b01          	ld	a,(OFST-1,sp)
 629  012c 5f            	clrw	x
 630  012d 97            	ld	xl,a
 631  012e a60a          	ld	a,#10
 632  0130 e70b          	ld	(_entry,x),a
 633                     ; 154 					for(i = 0; i < (sizeof(entry)-1); i++){
 635  0132 0c01          	inc	(OFST-1,sp)
 639  0134 7b01          	ld	a,(OFST-1,sp)
 640  0136 a104          	cp	a,#4
 641  0138 25f0          	jrult	L122
 642                     ; 157 					pointer = 0;
 644  013a 3f10          	clr	_pointer
 645                     ; 158 					lcd_clear();
 647  013c a601          	ld	a,#1
 648  013e cd0000        	call	_lcd_command
 650                     ; 159 					break;
 652  0141 2002          	jra	L312
 653  0143               L551:
 654                     ; 160 				case 11 : //  #
 654                     ; 161 					kontrola();
 656  0143 ad2b          	call	_kontrola
 658                     ; 162 					break;
 660  0145               L712:
 661  0145               L312:
 662                     ; 166 		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
 664  0145 7b02          	ld	a,(OFST+0,sp)
 665  0147 a1ff          	cp	a,#255
 666  0149 2604          	jrne	L112
 669  014b 35ff0018      	mov	L321_minule_stisknuto,#255
 670  014f               L112:
 671                     ; 168 }
 674  014f 85            	popw	x
 675  0150 81            	ret
 713                     ; 169 void click(uint8_t number){
 714                     	switch	.text
 715  0151               _click:
 717  0151 88            	push	a
 718       00000000      OFST:	set	0
 721                     ; 170 	lcd_gotoxy(pointer,0);
 723  0152 b610          	ld	a,_pointer
 724  0154 5f            	clrw	x
 725  0155 95            	ld	xh,a
 726  0156 cd0000        	call	_lcd_gotoxy
 728                     ; 171 	if(pointer < sizeof(entry)-1){
 730  0159 b610          	ld	a,_pointer
 731  015b a104          	cp	a,#4
 732  015d 240f          	jruge	L742
 733                     ; 172 		lcd_putchar('*');
 735  015f a62a          	ld	a,#42
 736  0161 cd0000        	call	_lcd_data
 738                     ; 173 		entry[pointer] = number;
 740  0164 b610          	ld	a,_pointer
 741  0166 5f            	clrw	x
 742  0167 97            	ld	xl,a
 743  0168 7b01          	ld	a,(OFST+1,sp)
 744  016a e70b          	ld	(_entry,x),a
 745                     ; 174 		pointer ++;
 747  016c 3c10          	inc	_pointer
 748  016e               L742:
 749                     ; 176 }
 752  016e 84            	pop	a
 753  016f 81            	ret
 815                     ; 179 void kontrola(void){
 816                     	switch	.text
 817  0170               _kontrola:
 819  0170 5222          	subw	sp,#34
 820       00000022      OFST:	set	34
 823                     ; 180 	uint8_t pravda = 1;
 825  0172 a601          	ld	a,#1
 826  0174 6b21          	ld	(OFST-1,sp),a
 828                     ; 183 	lcd_gotoxy(0,1);
 830  0176 ae0001        	ldw	x,#1
 831  0179 cd0000        	call	_lcd_gotoxy
 833                     ; 185 	if(status / 10 == 1){
 835  017c b600          	ld	a,_status
 836  017e 5f            	clrw	x
 837  017f 97            	ld	xl,a
 838  0180 a60a          	ld	a,#10
 839  0182 cd0000        	call	c_sdivx
 841  0185 a30001        	cpw	x,#1
 842  0188 261f          	jrne	L772
 843                     ; 186 		for(i = 0; i < (sizeof(entry)-1); i++){
 845  018a 0f22          	clr	(OFST+0,sp)
 847  018c               L103:
 848                     ; 187 			if (entry[i] != heslo[i]){
 850  018c 7b22          	ld	a,(OFST+0,sp)
 851  018e 5f            	clrw	x
 852  018f 97            	ld	xl,a
 853  0190 7b22          	ld	a,(OFST+0,sp)
 854  0192 905f          	clrw	y
 855  0194 9097          	ld	yl,a
 856  0196 90e60b        	ld	a,(_entry,y)
 857  0199 e101          	cp	a,(_heslo,x)
 858  019b 2702          	jreq	L703
 859                     ; 188 				pravda = 0;
 861  019d 0f21          	clr	(OFST-1,sp)
 863  019f               L703:
 864                     ; 186 		for(i = 0; i < (sizeof(entry)-1); i++){
 866  019f 0c22          	inc	(OFST+0,sp)
 870  01a1 7b22          	ld	a,(OFST+0,sp)
 871  01a3 a104          	cp	a,#4
 872  01a5 25e5          	jrult	L103
 874  01a7 201d          	jra	L113
 875  01a9               L772:
 876                     ; 192 		for(i = 0; i < (sizeof(entry)-1); i++){
 878  01a9 0f22          	clr	(OFST+0,sp)
 880  01ab               L313:
 881                     ; 193 			if (entry[i] != security_pass[i]){
 883  01ab 7b22          	ld	a,(OFST+0,sp)
 884  01ad 5f            	clrw	x
 885  01ae 97            	ld	xl,a
 886  01af 7b22          	ld	a,(OFST+0,sp)
 887  01b1 905f          	clrw	y
 888  01b3 9097          	ld	yl,a
 889  01b5 90e60b        	ld	a,(_entry,y)
 890  01b8 e106          	cp	a,(_security_pass,x)
 891  01ba 2702          	jreq	L123
 892                     ; 194 				pravda = 0;
 894  01bc 0f21          	clr	(OFST-1,sp)
 896  01be               L123:
 897                     ; 192 		for(i = 0; i < (sizeof(entry)-1); i++){
 899  01be 0c22          	inc	(OFST+0,sp)
 903  01c0 7b22          	ld	a,(OFST+0,sp)
 904  01c2 a104          	cp	a,#4
 905  01c4 25e5          	jrult	L313
 906  01c6               L113:
 907                     ; 199 	if(pravda){
 909  01c6 0d21          	tnz	(OFST-1,sp)
 910  01c8 2716          	jreq	L323
 911                     ; 200 		sprintf(text,"allowed");
 913  01ca ae001f        	ldw	x,#L523
 914  01cd 89            	pushw	x
 915  01ce 96            	ldw	x,sp
 916  01cf 1c0003        	addw	x,#OFST-31
 917  01d2 cd0000        	call	_sprintf
 919  01d5 85            	popw	x
 920                     ; 201 		status = UNLOCKED;
 922  01d6 350c0000      	mov	_status,#12
 923                     ; 202 		attemp = 1;
 925  01da 35010012      	mov	_attemp,#1
 927  01de 200e          	jra	L723
 928  01e0               L323:
 929                     ; 205 		sprintf(text,"denied");
 931  01e0 ae0018        	ldw	x,#L133
 932  01e3 89            	pushw	x
 933  01e4 96            	ldw	x,sp
 934  01e5 1c0003        	addw	x,#OFST-31
 935  01e8 cd0000        	call	_sprintf
 937  01eb 85            	popw	x
 938                     ; 206 		attemp ++;
 940  01ec 3c12          	inc	_attemp
 941  01ee               L723:
 942                     ; 208 	lcd_puts(text);
 944  01ee 96            	ldw	x,sp
 945  01ef 1c0001        	addw	x,#OFST-33
 946  01f2 cd0000        	call	_lcd_puts
 948                     ; 210 	if (attemp > max_attemps){
 950  01f5 b612          	ld	a,_attemp
 951  01f7 b111          	cp	a,_max_attemps
 952  01f9 2304          	jrule	L333
 953                     ; 211 		status = UNLOCKED_B;
 955  01fb 35160000      	mov	_status,#22
 956  01ff               L333:
 957                     ; 213 }
 960  01ff 5b22          	addw	sp,#34
 961  0201 81            	ret
 989                     ; 215 void init_pwm(void){
 990                     	switch	.text
 991  0202               _init_pwm:
 995                     ; 217 GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
 997  0202 4be0          	push	#224
 998  0204 4b10          	push	#16
 999  0206 ae500f        	ldw	x,#20495
1000  0209 cd0000        	call	_GPIO_Init
1002  020c 85            	popw	x
1003                     ; 219 TIM2_TimeBaseInit(TIM2_PRESCALER_16,1000-1);
1005  020d ae03e7        	ldw	x,#999
1006  0210 89            	pushw	x
1007  0211 a604          	ld	a,#4
1008  0213 cd0000        	call	_TIM2_TimeBaseInit
1010  0216 85            	popw	x
1011                     ; 221 TIM2_OC1Init( 	// inicializujeme kan�l 1 (TM2_CH1)
1011                     ; 222 	TIM2_OCMODE_PWM1, 				// re�im PWM1
1011                     ; 223 	TIM2_OUTPUTSTATE_ENABLE,	// V�stup povolen (TIMer ovl�d� pin)
1011                     ; 224 	DEFAULT_PULSE,		// v�choz� hodnota ���ky pulzu je 1.5ms
1011                     ; 225 	TIM2_OCPOLARITY_HIGH			// Z�t� rozsv�c�me hodnotou HIGH 
1011                     ; 226 	);
1013  0217 4b00          	push	#0
1014  0219 ae000a        	ldw	x,#10
1015  021c 89            	pushw	x
1016  021d ae6011        	ldw	x,#24593
1017  0220 cd0000        	call	_TIM2_OC1Init
1019  0223 5b03          	addw	sp,#3
1020                     ; 229 TIM2_OC1PreloadConfig(ENABLE);
1022  0225 a601          	ld	a,#1
1023  0227 cd0000        	call	_TIM2_OC1PreloadConfig
1025                     ; 231 TIM2_Cmd(ENABLE);
1027  022a a601          	ld	a,#1
1028  022c cd0000        	call	_TIM2_Cmd
1030                     ; 232 }
1033  022f 81            	ret
1068                     ; 245 void assert_failed(u8* file, u32 line)
1068                     ; 246 { 
1069                     	switch	.text
1070  0230               _assert_failed:
1074  0230               L363:
1075  0230 20fe          	jra	L363
1156                     	xdef	_main
1157                     	xdef	_attemp
1158                     	xdef	_max_attemps
1159                     	xdef	_pointer
1160                     	xdef	_entry
1161                     	xdef	_security_pass
1162                     	xdef	_heslo
1163                     	xdef	_status
1164                     	xdef	_process_pwm_change
1165                     	xdef	_init_pwm
1166                     	xdef	_RGB_manager
1167                     	xdef	_click
1168                     	xdef	_kontrola
1169                     	xdef	_process_keypad
1170                     	xdef	_init
1171                     	xref	_sprintf
1172                     	xref	_lcd_puts
1173                     	xref	_lcd_gotoxy
1174                     	xref	_lcd_init
1175                     	xref	_lcd_data
1176                     	xref	_lcd_command
1177                     	xref	_keypad_scan
1178                     	xref	_keypad_init
1179                     	xref	_init_milis
1180                     	xref	_milis
1181                     	xdef	_assert_failed
1182                     	xref	_TIM2_SetCompare1
1183                     	xref	_TIM2_OC1PreloadConfig
1184                     	xref	_TIM2_Cmd
1185                     	xref	_TIM2_OC1Init
1186                     	xref	_TIM2_TimeBaseInit
1187                     	xref	_GPIO_WriteLow
1188                     	xref	_GPIO_WriteHigh
1189                     	xref	_GPIO_Init
1190                     	xref	_CLK_HSIPrescalerConfig
1191                     	switch	.const
1192  0018               L133:
1193  0018 64656e696564  	dc.b	"denied",0
1194  001f               L523:
1195  001f 616c6c6f7765  	dc.b	"allowed",0
1196                     	xref.b	c_x
1216                     	xref	c_sdivx
1217                     	end
