//																													Inkludov�n�
#include "stm8s.h"		
#include "milis.h"
#include "keypad.h"
#include "stm8_hd44780.h"
#include "stdio.h"

//#include "swspi.h"

//																													deklrace
#define LOCKED			11
#define UNLOCKED 		12
#define LOCKED_B		21
#define UNLOCKED_B		22

#define COLOR_PORT		GPIOC
#define R_HIGH			GPIO_WriteHigh(GPIOC,GPIO_PIN_1)
#define R_LOW			GPIO_WriteLow(GPIOC,GPIO_PIN_1)
#define	G_HIGH			GPIO_WriteHigh(GPIOC,GPIO_PIN_2)
#define G_LOW			GPIO_WriteLow(GPIOC,GPIO_PIN_2)
#define B_HIGH			GPIO_WriteHigh(GPIOC,GPIO_PIN_3)
#define B_LOW 			GPIO_WriteLow(GPIOC,GPIO_PIN_3)

//																													funkce
void init(void);
void process_keypad(void);
void kontrola(void);
void click(uint8_t);
void RGB_manager(void);

//																													Prom�nn�
uint8_t status = LOCKED;
uint8_t heslo[5] = {7, 5, 1, 1};
uint8_t security_pass[5] = {1, 2, 3, 4};
uint8_t entry[5] = {10, 10, 10, 10};
uint8_t pointer = 0;
uint8_t max_attemps = 3;	// celkem pokusů
uint8_t attemp = 1;



//---------------------------------------------------------- Hlavn� funkce
void main(void){
	init();

  while (1){
		process_keypad();			// Aktualizuje stisk kl�vesy
		RGB_manager();				// Signalizace na RGB diodě
	}
}



//---------------------------------------------------------- Funkce
//------------------------- Inicializace
void init(void){
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z intern�ho RC oscil�toru
	GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_HIGH_SLOW);				// Porty pro RGB diodu
	GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_HIGH_SLOW);
	GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_HIGH_SLOW);

	
	init_milis();						// Dekralace vnit�n�ho �asu v STM 
	keypad_init();					// Deklarace nastaven� pin� na kl�vesnici
	lcd_init();							// Nastaven� LDC displeje
	
	//GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);
}
//------------------------- Funkce RGB
void RGB_manager(void){
	if (status == UNLOCKED){
		R_LOW;
		G_HIGH;
		B_LOW;
	}else if (status == LOCKED){
		R_LOW;
		G_LOW;
		B_HIGH;
	}else{
		R_HIGH;
		G_LOW;
		B_LOW;
	}
}

//------------------------- Funkce pro stisk kl�vesy
void process_keypad(void){
	static uint8_t minule_stisknuto=0xFF;	// posledn� stav kl�vesnice (zde "volno")
	static uint16_t last_time=0; 					// posledn� �as kontroly stisku
	uint8_t stisknuto;										// aktu�ln� stisknut�kl�vesnice
	uint8_t i;

	if(milis()-last_time > 20){ // ka�d�ch 20 ms ...
		last_time = milis();
		stisknuto = keypad_scan(); // ... skenujeme kl�vesnici
		
		if(minule_stisknuto == 0xFF && stisknuto != 0xFF){ // uvoln�no a pak stisknuto
			minule_stisknuto = stisknuto;
			
			switch(stisknuto) {			// Switcher pro stisk					//  program bude ukl�dat jednotliv� ��slice
				case 0 :
					click(stisknuto);
					break;
				case 1 :
					click(stisknuto);
					break;
				case 2 :
					click(stisknuto);
					break;
				case 3 :
					click(stisknuto);
					break;
				case 4 :
					click(stisknuto);
					break;
				case 5 :
					click(stisknuto);
					break;
				case 6 :
					click(stisknuto);
					break;
				case 7 :
					click(stisknuto);
					break;
				case 8 :
					click(stisknuto);
					break;
				case 9 :
					click(stisknuto);
					break;
				case 10 : //  *
					for(i = 0; i < (sizeof(entry)-1); i++){
						entry[i] = 10;
					}
					pointer = 0;
					lcd_clear();
					break;
				case 11 : //  #
					kontrola();
					break;
			}
			
		}
		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
	}
}
void click(uint8_t number){
	lcd_gotoxy(pointer,0);
	if(pointer < sizeof(entry)-1){
		lcd_putchar('*');
		entry[pointer] = number;
		pointer ++;
	}
}


void kontrola(void){
	uint8_t pravda = 1;
	uint8_t i;
	char text[32];
	lcd_gotoxy(0,1);
	
	if(status / 10 == 1){
		for(i = 0; i < (sizeof(entry)-1); i++){
			if (entry[i] != heslo[i]){
				pravda = 0;
			}
		}
	} else {
		for(i = 0; i < (sizeof(entry)-1); i++){
			if (entry[i] != security_pass[i]){
				pravda = 0;
			}
		}
	}

	if(pravda){
		sprintf(text,"allowed");
		//status = UNLOCKED;
		attemp = 1;
	}
	else{
		sprintf(text,"denied");
		attemp ++;
	}
	lcd_puts(text);

	if (attemp > max_attemps){
		status = UNLOCKED_B;
	}
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
