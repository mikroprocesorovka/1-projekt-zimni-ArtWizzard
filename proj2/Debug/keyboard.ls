   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.1 - 30 Jun 2020
   3                     ; Generator (Limited) V4.4.12 - 02 Jul 2020
  44                     ; 12 void swspi_init(void){
  46                     	switch	.text
  47  0000               _swspi_init:
  51                     ; 13 GPIO_Init(CS_GPIO,CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
  53  0000 4bf0          	push	#240
  54  0002 4b10          	push	#16
  55  0004 ae5005        	ldw	x,#20485
  56  0007 cd0000        	call	_GPIO_Init
  58  000a 85            	popw	x
  59                     ; 14 GPIO_Init(CLK_GPIO,CLK_PIN,GPIO_MODE_OUT_PP_LOW_FAST);
  61  000b 4be0          	push	#224
  62  000d 4b08          	push	#8
  63  000f ae5005        	ldw	x,#20485
  64  0012 cd0000        	call	_GPIO_Init
  66  0015 85            	popw	x
  67                     ; 15 GPIO_Init(DIN_GPIO,DIN_PIN,GPIO_MODE_OUT_PP_LOW_FAST);
  69  0016 4be0          	push	#224
  70  0018 4b20          	push	#32
  71  001a ae5005        	ldw	x,#20485
  72  001d cd0000        	call	_GPIO_Init
  74  0020 85            	popw	x
  75                     ; 16 }
  78  0021 81            	ret
  91                     	xdef	_swspi_init
  92                     	xref	_GPIO_Init
 111                     	end
