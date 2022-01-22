   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  45                     ; 9 void main(void){
  47                     	switch	.text
  48  0000               _main:
  52                     ; 10 CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // 16MHz z interního RC oscilátoru
  54  0000 4f            	clr	a
  55  0001 cd0000        	call	_CLK_HSIPrescalerConfig
  57                     ; 11 init_milis(); 
  59  0004 cd0000        	call	_init_milis
  61  0007               L12:
  63  0007 20fe          	jra	L12
  98                     ; 29 void assert_failed(u8* file, u32 line)
  98                     ; 30 { 
  99                     	switch	.text
 100  0009               _assert_failed:
 104  0009               L34:
 105  0009 20fe          	jra	L34
 118                     	xdef	_main
 119                     	xref	_init_milis
 120                     	xdef	_assert_failed
 121                     	xref	_CLK_HSIPrescalerConfig
 140                     	end
