   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  44                     ; 4 void keypad_init(void){
  46                     	switch	.text
  47  0000               _keypad_init:
  51                     ; 6 GPIO_Init(RDK1_GPIO,RDK1_PIN,GPIO_MODE_IN_PU_NO_IT);
  53  0000 4b40          	push	#64
  54  0002 4b01          	push	#1
  55  0004 ae5014        	ldw	x,#20500
  56  0007 cd0000        	call	_GPIO_Init
  58  000a 85            	popw	x
  59                     ; 7 GPIO_Init(RDK2_GPIO,RDK2_PIN,GPIO_MODE_IN_PU_NO_IT);
  61  000b 4b40          	push	#64
  62  000d 4b08          	push	#8
  63  000f ae5019        	ldw	x,#20505
  64  0012 cd0000        	call	_GPIO_Init
  66  0015 85            	popw	x
  67                     ; 8 GPIO_Init(RDK3_GPIO,RDK3_PIN,GPIO_MODE_IN_PU_NO_IT);
  69  0016 4b40          	push	#64
  70  0018 4b01          	push	#1
  71  001a ae5019        	ldw	x,#20505
  72  001d cd0000        	call	_GPIO_Init
  74  0020 85            	popw	x
  75                     ; 9 GPIO_Init(RDK4_GPIO,RDK4_PIN,GPIO_MODE_IN_PU_NO_IT);
  77  0021 4b40          	push	#64
  78  0023 4b08          	push	#8
  79  0025 ae5014        	ldw	x,#20500
  80  0028 cd0000        	call	_GPIO_Init
  82  002b 85            	popw	x
  83                     ; 11 GPIO_Init(SLP1_GPIO, SLP1_PIN, GPIO_MODE_OUT_OD_HIZ_SLOW);
  85  002c 4b90          	push	#144
  86  002e 4b20          	push	#32
  87  0030 ae5019        	ldw	x,#20505
  88  0033 cd0000        	call	_GPIO_Init
  90  0036 85            	popw	x
  91                     ; 12 GPIO_Init(SLP2_GPIO, SLP2_PIN, GPIO_MODE_OUT_OD_HIZ_SLOW);
  93  0037 4b90          	push	#144
  94  0039 4b40          	push	#64
  95  003b ae5019        	ldw	x,#20505
  96  003e cd0000        	call	_GPIO_Init
  98  0041 85            	popw	x
  99                     ; 13 GPIO_Init(SLP3_GPIO, SLP3_PIN, GPIO_MODE_OUT_OD_HIZ_SLOW);
 101  0042 4b90          	push	#144
 102  0044 4b80          	push	#128
 103  0046 ae5019        	ldw	x,#20505
 104  0049 cd0000        	call	_GPIO_Init
 106  004c 85            	popw	x
 107                     ; 14 }
 110  004d 81            	ret
 147                     ; 17 uint8_t keypad_scan(void){
 148                     	switch	.text
 149  004e               _keypad_scan:
 151  004e 88            	push	a
 152       00000001      OFST:	set	1
 155                     ; 18 uint8_t tmp=0xFF; // výchozí návratová hodnota ("nic nestisknuto")
 157  004f a6ff          	ld	a,#255
 158  0051 6b01          	ld	(OFST+0,sp),a
 160                     ; 20 AKT_SLP1; // aktivuje první sloupec
 162  0053 4b20          	push	#32
 163  0055 ae5019        	ldw	x,#20505
 164  0058 cd0000        	call	_GPIO_WriteLow
 166  005b 84            	pop	a
 167                     ; 21 if(STAV_RDK1){tmp=1;} // ète stav prvního øádku...
 169  005c 4b01          	push	#1
 170  005e ae5014        	ldw	x,#20500
 171  0061 cd0000        	call	_GPIO_ReadInputPin
 173  0064 5b01          	addw	sp,#1
 174  0066 4d            	tnz	a
 175  0067 2604          	jrne	L73
 178  0069 a601          	ld	a,#1
 179  006b 6b01          	ld	(OFST+0,sp),a
 181  006d               L73:
 182                     ; 22 if(STAV_RDK2){tmp=4;}
 184  006d 4b08          	push	#8
 185  006f ae5019        	ldw	x,#20505
 186  0072 cd0000        	call	_GPIO_ReadInputPin
 188  0075 5b01          	addw	sp,#1
 189  0077 4d            	tnz	a
 190  0078 2604          	jrne	L14
 193  007a a604          	ld	a,#4
 194  007c 6b01          	ld	(OFST+0,sp),a
 196  007e               L14:
 197                     ; 23 if(STAV_RDK3){tmp=7;}
 199  007e 4b01          	push	#1
 200  0080 ae5019        	ldw	x,#20505
 201  0083 cd0000        	call	_GPIO_ReadInputPin
 203  0086 5b01          	addw	sp,#1
 204  0088 4d            	tnz	a
 205  0089 2604          	jrne	L34
 208  008b a607          	ld	a,#7
 209  008d 6b01          	ld	(OFST+0,sp),a
 211  008f               L34:
 212                     ; 24 if(STAV_RDK4){tmp=10;}
 214  008f 4b08          	push	#8
 215  0091 ae5014        	ldw	x,#20500
 216  0094 cd0000        	call	_GPIO_ReadInputPin
 218  0097 5b01          	addw	sp,#1
 219  0099 4d            	tnz	a
 220  009a 2604          	jrne	L54
 223  009c a60a          	ld	a,#10
 224  009e 6b01          	ld	(OFST+0,sp),a
 226  00a0               L54:
 227                     ; 25 DEAKT_SLP1; // deaktivuje první sloupec
 229  00a0 4b20          	push	#32
 230  00a2 ae5019        	ldw	x,#20505
 231  00a5 cd0000        	call	_GPIO_WriteHigh
 233  00a8 84            	pop	a
 234                     ; 27 AKT_SLP2;
 236  00a9 4b40          	push	#64
 237  00ab ae5019        	ldw	x,#20505
 238  00ae cd0000        	call	_GPIO_WriteLow
 240  00b1 84            	pop	a
 241                     ; 28 if(STAV_RDK1){tmp=2;}
 243  00b2 4b01          	push	#1
 244  00b4 ae5014        	ldw	x,#20500
 245  00b7 cd0000        	call	_GPIO_ReadInputPin
 247  00ba 5b01          	addw	sp,#1
 248  00bc 4d            	tnz	a
 249  00bd 2604          	jrne	L74
 252  00bf a602          	ld	a,#2
 253  00c1 6b01          	ld	(OFST+0,sp),a
 255  00c3               L74:
 256                     ; 29 if(STAV_RDK2){tmp=5;}
 258  00c3 4b08          	push	#8
 259  00c5 ae5019        	ldw	x,#20505
 260  00c8 cd0000        	call	_GPIO_ReadInputPin
 262  00cb 5b01          	addw	sp,#1
 263  00cd 4d            	tnz	a
 264  00ce 2604          	jrne	L15
 267  00d0 a605          	ld	a,#5
 268  00d2 6b01          	ld	(OFST+0,sp),a
 270  00d4               L15:
 271                     ; 30 if(STAV_RDK3){tmp=8;}
 273  00d4 4b01          	push	#1
 274  00d6 ae5019        	ldw	x,#20505
 275  00d9 cd0000        	call	_GPIO_ReadInputPin
 277  00dc 5b01          	addw	sp,#1
 278  00de 4d            	tnz	a
 279  00df 2604          	jrne	L35
 282  00e1 a608          	ld	a,#8
 283  00e3 6b01          	ld	(OFST+0,sp),a
 285  00e5               L35:
 286                     ; 31 if(STAV_RDK4){tmp=0;}
 288  00e5 4b08          	push	#8
 289  00e7 ae5014        	ldw	x,#20500
 290  00ea cd0000        	call	_GPIO_ReadInputPin
 292  00ed 5b01          	addw	sp,#1
 293  00ef 4d            	tnz	a
 294  00f0 2602          	jrne	L55
 297  00f2 0f01          	clr	(OFST+0,sp)
 299  00f4               L55:
 300                     ; 32 DEAKT_SLP2;
 302  00f4 4b40          	push	#64
 303  00f6 ae5019        	ldw	x,#20505
 304  00f9 cd0000        	call	_GPIO_WriteHigh
 306  00fc 84            	pop	a
 307                     ; 34 AKT_SLP3;
 309  00fd 4b80          	push	#128
 310  00ff ae5019        	ldw	x,#20505
 311  0102 cd0000        	call	_GPIO_WriteLow
 313  0105 84            	pop	a
 314                     ; 35 if(STAV_RDK1){tmp=3;}
 316  0106 4b01          	push	#1
 317  0108 ae5014        	ldw	x,#20500
 318  010b cd0000        	call	_GPIO_ReadInputPin
 320  010e 5b01          	addw	sp,#1
 321  0110 4d            	tnz	a
 322  0111 2604          	jrne	L75
 325  0113 a603          	ld	a,#3
 326  0115 6b01          	ld	(OFST+0,sp),a
 328  0117               L75:
 329                     ; 36 if(STAV_RDK2){tmp=6;}
 331  0117 4b08          	push	#8
 332  0119 ae5019        	ldw	x,#20505
 333  011c cd0000        	call	_GPIO_ReadInputPin
 335  011f 5b01          	addw	sp,#1
 336  0121 4d            	tnz	a
 337  0122 2604          	jrne	L16
 340  0124 a606          	ld	a,#6
 341  0126 6b01          	ld	(OFST+0,sp),a
 343  0128               L16:
 344                     ; 37 if(STAV_RDK3){tmp=9;}
 346  0128 4b01          	push	#1
 347  012a ae5019        	ldw	x,#20505
 348  012d cd0000        	call	_GPIO_ReadInputPin
 350  0130 5b01          	addw	sp,#1
 351  0132 4d            	tnz	a
 352  0133 2604          	jrne	L36
 355  0135 a609          	ld	a,#9
 356  0137 6b01          	ld	(OFST+0,sp),a
 358  0139               L36:
 359                     ; 38 if(STAV_RDK4){tmp=11;}
 361  0139 4b08          	push	#8
 362  013b ae5014        	ldw	x,#20500
 363  013e cd0000        	call	_GPIO_ReadInputPin
 365  0141 5b01          	addw	sp,#1
 366  0143 4d            	tnz	a
 367  0144 2604          	jrne	L56
 370  0146 a60b          	ld	a,#11
 371  0148 6b01          	ld	(OFST+0,sp),a
 373  014a               L56:
 374                     ; 39 DEAKT_SLP3;
 376  014a 4b80          	push	#128
 377  014c ae5019        	ldw	x,#20505
 378  014f cd0000        	call	_GPIO_WriteHigh
 380  0152 84            	pop	a
 381                     ; 40 return tmp; // vrací stisknutou klávesu (resp. 0xFF pokud nic stisknuto není)
 383  0153 7b01          	ld	a,(OFST+0,sp)
 386  0155 5b01          	addw	sp,#1
 387  0157 81            	ret
 400                     	xdef	_keypad_scan
 401                     	xdef	_keypad_init
 402                     	xref	_GPIO_ReadInputPin
 403                     	xref	_GPIO_WriteLow
 404                     	xref	_GPIO_WriteHigh
 405                     	xref	_GPIO_Init
 424                     	end
