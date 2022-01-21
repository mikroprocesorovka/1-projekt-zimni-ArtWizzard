//																													Inkludování
#include "stm8s.h"		
#include "milis.h"
#include "keypad.h"
#include "stm8_hd44780.h"
//#include "swspi.h"

//																													deklrace

//																													funkce
void init(void);
void process_keypad(void);

//																													Promìnné

//---------------------------------------------------------- Hlavní funkce
void main(void){
	init();

  while (1){
		process_keypad();			// Aktualizuje stisk klávesy
	}
}



//---------------------------------------------------------- Funkce
//------------------------- Inicializace
void init(void){
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z interního RC oscilátoru
	
	init_milis();						// Dekralace vnitøního èasu v STM 
	keypad_init();					// Deklarace nastavení pinù na klávesnici
	
	GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);
}
//------------------------- Funkce pro stisk klávesy
void process_keypad(void){
	static uint8_t minule_stisknuto=0xFF;	// poslední stav klávesnice (zde "volno")
	static uint16_t last_time=0; 					// poslední èas kontroly stisku
	uint8_t stisknuto;										// aktuálnì stisknutáklávesnice

	if(milis()-last_time > 20){ // každých 20 ms ...
		last_time = milis();
		stisknuto = keypad_scan(); // ... skenujeme klávesnici
		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvolnìno a pak stisknuto
			minule_stisknuto = stisknuto;
			
			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukládat jednotlivé èíslice
				case 0 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 1 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 2 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 3 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 4 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 5 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 6 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 7 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 8 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 9 :
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 10 : //  *
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
				case 11 : //  #
					GPIO_WriteReverse(GPIOC,GPIO_PIN_5);
					break;
					
			}
		}
		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
	}
}


//---------------------------------------------------------- Void
// pod tímto komentáøem nic nemìòte 
#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval : None
  */
void assert_failed(u8* file, u32 line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif
