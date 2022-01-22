//																													Inkludov�n�
#include "stm8s.h"		
#include "milis.h"
#include "keypad.h"
#include "stm8_hd44780.h"
#include "stdio.h"

//#include "swspi.h"

//																													deklrace
#define LOCKED			10
#define UNLOCKED 		20
#define LOCKED_B		11
#define UNLOCKED_B	21

//																													funkce
void init(void);
void process_keypad(void);
void kontrola(void);

//																													Prom�nn�
uint8_t status = LOCKED;
uint8_t heslo[5] = {7, 5, 1, 1, 9};
uint8_t entry[5] = {10, 10, 10, 10};
uint8_t pointer = 0;


//---------------------------------------------------------- Hlavn� funkce
void main(void){
	init();

  while (1){
		process_keypad();			// Aktualizuje stisk kl�vesy
	}
}



//---------------------------------------------------------- Funkce
//------------------------- Inicializace
void init(void){
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z intern�ho RC oscil�toru
	
	init_milis();						// Dekralace vnit�n�ho �asu v STM 
	keypad_init();					// Deklarace nastaven� pin� na kl�vesnici
	lcd_init();							// Nastaven� LDC displeje
	
	//GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);
}
//------------------------- Funkce pro stisk kl�vesy
void process_keypad(void){
	static uint8_t minule_stisknuto=0xFF;	// posledn� stav kl�vesnice (zde "volno")
	static uint16_t last_time=0; 					// posledn� �as kontroly stisku
	uint8_t stisknuto;										// aktu�ln� stisknut�kl�vesnice
	char x;
	//lcd_putchar(x);

	if(milis()-last_time > 20){ // ka�d�ch 20 ms ...
		last_time = milis();
		stisknuto = keypad_scan(); // ... skenujeme kl�vesnici
		
		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvoln�no a pak stisknuto
			minule_stisknuto = stisknuto;
			
			
			
			
			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukl�dat jednotliv� ��slice
				case 0 :
					break;
				case 1 :
					break;
				case 2 :
					break;
				case 3 :
					break;
				case 4 :
					break;
				case 5 :
					break;
				case 6 :
					break;
				case 7 :
					break;
				case 8 :
					break;
				case 9 :
					break;
				case 10 : //  *
					break;
				case 11 : //  #
					lcd_gotoxy(0,0);
					
					break;
			}
		}
		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
	}
}

void kontrola(void){
	
}

//---------------------------------------------------------- Void
// pod t�mto koment��em nic nem��te 
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
