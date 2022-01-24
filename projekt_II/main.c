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
#define TIME_DELAY		1000 // 1 s

#define CHANGE_POSITION_TIME 50 // ka�d�ch 50 ms zm�na
#define DEFAULT_PULSE 10

#define C_P				GPIOC
//#define R_HIGH			GPIO_WriteHigh(C_P,GPIO_PIN_1)
//#define R_LOW			GPIO_WriteLow(C_P,GPIO_PIN_1)
#define	G_HIGH			GPIO_WriteHigh(C_P,GPIO_PIN_2)
#define G_LOW			GPIO_WriteLow(C_P,GPIO_PIN_2)
#define B_HIGH			GPIO_WriteHigh(C_P,GPIO_PIN_3)
#define B_LOW 			GPIO_WriteLow(C_P,GPIO_PIN_3)

//																													funkce
void init(void);
void process_keypad(void);
void kontrola(void);
void click(uint8_t);
void RGB_manager(void);
void init_pwm(void); 
void process_pwm_change(void);
void clear(void);

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
		//RGB_manager();				// Signalizace na RGB diodě
		if (status == UNLOCKED_B || status == LOCKED_B){
			process_pwm_change(); //LED na pinu D4
		}
	}
}



//---------------------------------------------------------- Funkce
//------------------------- Inicializace
void init(void){
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);	 					// 16MHz z intern�ho RC oscil�toru
	//GPIO_Init(GPIOC,GPIO_PIN_1,GPIO_MODE_OUT_PP_LOW_SLOW);				// Porty pro RGB diodu
	GPIO_Init(GPIOC,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);
	GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);

	
	init_milis();						// Dekralace vnit�n�ho �asu v STM 
	keypad_init();					// Deklarace nastaven� pin� na kl�vesnici
	lcd_init();							// Nastaven� LDC displeje
	init_pwm(); 						// nastavit a spustit timer
	RGB_manager();					// Zobraz� prvn� re�im na RGB
	
	//GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);
}
//------------------------- Funkce RGB
void RGB_manager(void){
	//R_LOW;
	G_LOW;
	B_LOW;
	if (status == UNLOCKED){
		G_HIGH;
	}else if (status == LOCKED){
		B_HIGH;
	}
}

//------------------------- PWM RED
void process_pwm_change(void){
	static uint16_t pulse = DEFAULT_PULSE; 
	static uint16_t last_time = 0;  
	static int8_t zmena = 50;

  if(milis() - last_time >= CHANGE_POSITION_TIME){
		last_time = milis();
		pulse = pulse + zmena;
		if(pulse>499 || pulse<50){
			zmena = zmena*(-1);
		} 	
		TIM2_SetCompare1(pulse);
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
					clear();
					break;
				case 11 : //  #
					kontrola();
					break;
			}
			
		}
		if(stisknuto == 0xFF){minule_stisknuto=0xFF;}
	}
}

void clear(void){
	uint8_t i;
	for(i = 0; i < (sizeof(entry)-1); i++){
		entry[i] = 10;
	}
	pointer = 0;
	lcd_clear();
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
	uint8_t temp;
	uint8_t i;
	char text[32];
	lcd_gotoxy(0,1);
	
	if(status / 10 == 1){ 							//  normální
		for(i = 0; i < (sizeof(entry)-1); i++){
			if (entry[i] != heslo[i]){
				pravda = 0;
			}
		}
	} else { 										//  blokování
		for(i = 0; i < (sizeof(entry)-1); i++){
			if (entry[i] != security_pass[i]){
				pravda = 0;
			}
		}
	}

	//  Kontrola správnosti
	if(pravda){
		sprintf(text,"allowed");
/*
		if (status == LOCKED){		// Změny normal a odblokování
			status = UNLOCKED;
		} else{
			status = LOCKED;
		}
*/
		switch(status){
			case UNLOCKED:
				status = LOCKED;
				break;
			case LOCKED:	
				status = UNLOCKED;
				break;
			case UNLOCKED_B:
				status = UNLOCKED;
				break;
			case LOCKED_B:
				status = LOCKED;
				break;
		}
		
		attemp = 1;
	}
	else{
		sprintf(text,"denied");
		attemp ++;
	}
	lcd_puts(text);

	//  Přesah špatných pokusů
	if (attemp > max_attemps){		//  Změna na blokování
		switch(status){
			case UNLOCKED:
				status = UNLOCKED_B;
				break;
			case LOCKED:
				status = LOCKED_B;
				break;
		}
		RGB_manager();
		clear();
		return;
	}
	
	RGB_manager();
	delay_ms(1000);	// pauza pro přebliknkutí
	clear();
}

void init_pwm(void){
// nastav�me piny PD4 jako v�stup 
GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST);
// Inicializujeme �asovou z�kladnu s clockem do �sova�e na 1MHz (T=1us), P�ete�en� = 1 000 000 / 1000 = 1 ms
TIM2_TimeBaseInit(TIM2_PRESCALER_16,1000-1);

TIM2_OC1Init( 	// inicializujeme kan�l 1 (TM2_CH1)
	TIM2_OCMODE_PWM1, 				// re�im PWM1
	TIM2_OUTPUTSTATE_ENABLE,	// V�stup povolen (TIMer ovl�d� pin)
	DEFAULT_PULSE,		// v�choz� hodnota ���ky pulzu je 1.5ms
	TIM2_OCPOLARITY_HIGH			// Z�t� rozsv�c�me hodnotou HIGH 
	);
	
// aktivuji na pou�it�ch kan�lech preload (zaji��uje zm�nu st��dy bez ne��douc�ch efekt�)
TIM2_OC1PreloadConfig(ENABLE);
// spust�me timer	
TIM2_Cmd(ENABLE);
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
