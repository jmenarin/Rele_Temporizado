 /*______________________________________________________________________________________________________
  Software desenvolvido para o Rele Temporizado
	
	O produto é um Temporizado com ajustes.
	Principais caracteristicas:
	1- Temporização de 1,2,3,4,6,8,10,12 horas
	2- Disparo no Zero Crossing
	
	
Desenvolvedor: João Menarin 6943  
							 Izaú Araújo  4247  // Data: 08/11/2021.    

*/
/*********************************************************************************************************************************************************************************************************************
 Inclusão dos arquivos externos para chamada do compilador
*********************************************************************************************************************************************************************************************************************/
#include "stm8s.h"
#include "typedef_gpio_STM8001_Reles.h"
#include "stm8s_flash.h"

/*********************************************************************************************************************************************************************************************************************
 Declaração e Inicialização das Variaveis Globais
*********************************************************************************************************************************************************************************************************************/
extern volatile unsigned int cnt; 					       // Variável está no stm8s_it.c
unsigned int Escuridade = 0;								       // Utilizada na função LerLDR para armazenar a leitura A/D do LDR      
unsigned int Lux = 600;       										 // Ponto de atuação do LDR - Variável de apoio							
unsigned int a,b,c,d,e,f,top,down =0;							 // Variaveis para contagem de tempo no programa (a= analisa frequencia, b e c = verifica dia e verifica noite, top e down analisa frequencia) 
unsigned int AjusteTrimpot = 0;										 // Utilizada na Função LerTrimpot para armazenar o valor do trimpot
unsigned int Tempo_rele_liga,Tempo_rele_desliga=0; //Armazena os tempos de atracamento e desatracamento do rele
unsigned int var_ligar = 0;                        //Utilizada para ajustar o tempo para disparar no 0
unsigned int Tempo_espera = 0;                     //Utilizada para ajustar o tempo para desligar no 0
unsigned int Tempo = 0; 													 //Função para armazenar o valor do tempo de acordo com o valor do trimpot

/*********************************************************************************************************************************************************************************************************************
	Protótipos das Funções
*********************************************************************************************************************************************************************************************************************/
void VerificaNoite(void);					//Verifica se esta de noite
void VerificaDia(void);						//Verifica se esta de dia
void LerTrimpot(void);						//Le a porta do trimpot
void LerLDR(void);								//Lê a porta do LDR
void Desliga(void);								//Desliga a carga no zero da senoide
void Delay_500us(unsigned int x); //Utilizada para contar tempo
void Espera_zero0(void);					//Espera passar por zero 	
void Espera_zero1(void);					//Espera passar por zero 
void Liga(void);									//Liga a carga no zero da senoide
void Analisa_frequencia(void);		//Verifica se é 50Hz ou 60Hz

/***************************************************************************************************************************
	Inicialização e configuração da CPU dos Pinos e do Delay
*********************************************************************************************************************************************************************************************************************/

/* not connected pins as output low state (the best EMC immunity)
(PA2, PB0, PB1, PB2, PB3, PB6, PB7, PC1, PC2, PC7, PD0, PD2, PD4, PD7, PE5, PF4) */
#define CONFIG_UNUSED_PINS_STM8S001                                                          \
{                                                                                            \
  GPIOA->DDR |= GPIO_PIN_2;                                                                  \
  GPIOB->DDR |= GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_2 | GPIO_PIN_3 | GPIO_PIN_6 | GPIO_PIN_7; \
  GPIOC->DDR |= GPIO_PIN_1 | GPIO_PIN_2 | GPIO_PIN_7;                                        \
  GPIOD->DDR |= GPIO_PIN_0 | GPIO_PIN_2 | GPIO_PIN_4 | GPIO_PIN_7;                           \
  GPIOE->DDR |= GPIO_PIN_5;                                                                  \
  GPIOF->DDR |= GPIO_PIN_4;                                                                  \
}

main(){
	
	//CPU inicia em 2MHz 
		//CPU foi alterada para trabalhar de 16 MHZ para 2MHz para diminuir o consumo do micro
		//Configuração de sugestão ST
		CLK_HSIPrescalerConfig (CLK_PRESCALER_HSIDIV8);	// Primeiro determina-se o clock como "High Speedy (HS)" o que dá 16MHz e divide-se por 8 (16/8 = 2MHz)
		
		// Inicialização Timer4 - 8 bits
		
		TIM4_TimeBaseInit(TIM4_PRESCALER_8,24);	   // Configuração do Time base, ver no excel
		TIM4_ClearFlag(TIM4_FLAG_UPDATE); 				// Clear TIM4 update flag 
		TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);		// Enable update interrupt
		TIM4_Cmd(ENABLE);   											// Habilita TIM4 
		enableInterrupts();                       // Habilita Interrupções	

				
			
//***************************************************************************************************	
//***************************************************************************************************	
    CONFIG_UNUSED_PINS_STM8S001;
/* Inicializações Portas  **************************************************************************/
/* -- Pin 1 --------------------------------------------------------------- */
//  GPIO_Init(GPIOA, GPIO_PIN_1, GPIO_MODE_IN_PP_LOW_FAST); //PD6/AIN6/UART1_RX
 GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT); //PA1
/*** -- Pin 5 --------------------------------------------------------------- */
 //GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //PB5/I2C_SDA/[TIM1_BKIN]
 GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_IN_FL_NO_IT); //PA3/TIM2_CH3/[SPI_NSS]/[UART1_TX]
/*** -- Pin 6 --------------------------------------------------------------- */
 GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //PB4/I2C_SCL/[ADC_ETR]
/*** -- Pin 7 --------------------------------------------------------------- */
 GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //PC5/SPI_SCK/[TIM2_CH1]
// GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //PC4/CLK_CCO/TIM1_CH4/[AIN2]/[TIM1_CH2N]
//  GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT); //PC3/TIM1_CH3/[TLI]/[TIM1_CH1N]
/*** -- Pin 8 --------------------------------------------------------------- */
//  GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT); //PD5/AIN5/UART1_TX
 GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_IN_FL_NO_IT); //PD3/AIN4/TIM2_CH2/ADC_ETR
//  GPIO_Init(GPIOD, GPIO_PIN_1, GPIO_MODE_IN_PU_NO_IT); //PD1/SWIM
//  GPIO_Init(GPIOC, GPIO_PIN_6, GPIO_MODE_IN_PU_NO_IT); //PC6/SPI_MOSI/[TIM1_CH1]
/* ------------------------------------------------------------------------ */
	


/*********************************************************************************************************************************************************************************************************************
 Rotina de Estabilização do Produto
*********************************************************************************************************************************************************************************************************************/

	Rele = 0;            								//Inicia o Produto com a carga no Zero
	Analisa_frequencia();								//Verifica se a Rede esta em 50Hz ou 60Hz
	Delay_500us(10000); 								//Delay de 1 segundo
	

	
  while(1){ 													// Laço infinito (Infinit Loop)
	
	
	LerLDR();														//Função para ler o LDR e armazenar o valor na variavel Escuridade
	LerLDR();														//Função para ler o LDR e armazenar o valor na variavel Escuridade
	if(Escuridade > Lux){								//Se Escuridade for maior que Lux, chamar a função VerificaNoite, senão, zera a variavel "b"
		VerificaNoite();
		}else{ 
			b = 0;
		}
	if(b >= 40){ 												//Se verificou o LDR por 4 segundos e confirmou que é noite, liga o rele e le o trimpot
		Liga();
		LerTrimpot();											//Le o trimpot e armazena o valor na variavel "Tempo"
			

	while(Escuridade > Lux){						//Enquanto Escuridade for maior que LUX, fica preso dentro desse loop
		switch (Tempo){							
			case 1:													//Tempo de 1 hora.
				for(f = 0; f < 1; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 1 = 1 hora.
						VerificaDia();						//Verifica se ficou claro
							if(e>= 40){							//Se ficou claro por 4 segundos,
								f = 12;								//Altera o valor de f para sair do laço for
								break;								//Sai da rotina
							}						
					}
				}							
				Desliga();										//Desliga o Rele e sai da rotina
				break;

			case 2:	
				for(f = 0; f < 2; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 2 = 2 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
								f = 12;								//Altera o valor de f para sair do laço for
								break;								//Sai da rotina		
						}				
					}
				}
				Desliga();										//Desliga o Rele e sai da rotina
				break;
				
			case 3:													//Tempo de 3 horas.
				for(f = 0; f < 3; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 3 = 3 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
							f = 12;									//Altera o valor de f para sair do laço for
							break;									//Sai da rotina	
						}					
					}
				}
				Desliga();										//Desliga o Rele e sai da rotina
				break;
				
			case 4:													//Tempo de 4 horas.
				for(f = 0; f < 4; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	////35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 4 = 4 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
							f = 12;									//Altera o valor de f para sair do laço for
							break;									//Sai da rotina
						}						
					}
				}
				Desliga();										//Desliga o Rele e sai da rotina
				break;

			case 6:													//Tempo de 6 horas.
				for(f = 0; f < 6; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	///35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 6 = 6 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
							f = 12;									//Altera o valor de f para sair do laço for
							break;									//Sai da rotina
						}															
					}
				}
				Desliga();										//Desliga o Rele e sai da rotina
				break;

			case 8:													//Tempo de 8 horas.
				for(f = 0; f < 8; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 8 = 8 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
							f = 12;									//Altera o valor de f para sair do laço for
							break;									//Sai da rotina
						}						
					}
				}
				Desliga();										//Desliga o Rele e sai da rotina
				break;

			case 10:										 		//Tempo de 10 horas.
				for(f = 0; f < 10; f++){			//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 10 = 10 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
							f = 12;									//Altera o valor de f para sair do laço for
							break;									//Sai da rotina		
						}			 	
					}
				}
				Desliga();								 		//Desliga o Rele e sai da rotina
				break;
				
			case 12:										 		//Tempo de 12 horas.
				for(f = 0; f < 12; f++){			//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 12 = 12 horas.
						VerificaDia();						//Verifica se ficou claro
						if(e>= 40){								//Se ficou claro por 4 segundos,
							f = 12;									//Altera o valor de f para sair do laço for
							break;									//Sai da rotina
						}					
					}
				}
				Desliga();					 			 		//Desliga o Rele e sai da rotina
				break;
			}
		}
	}
}


		
	
   }	

/*********************************************************************************************************************************
 Função LerLDR 
****************************************************************************************************************************/
	void LerLDR(void){           // Definição da função "EsperaZero"
		ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE,ADC1_CHANNEL_6,	ADC1_ALIGN_RIGHT); // Inicialização ADC1 - 8 bits
		ADC1_Cmd(ENABLE);       // Habilita o ADC1
		ADC1_StartConversion(); // Inicia a coversão
	
		if(ADC1_GetFlagStatus(ADC1_FLAG_EOC)){ Escuridade = ADC1_GetConversionValue(); } // Proteção BUG de conversão AD da ST
	
		return;
	}


	void LerTrimpot(void){           // Definição da função "EsperaZero"
		ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE,ADC1_CHANNEL_5,	ADC1_ALIGN_RIGHT); // Inicialização ADC1 - 8 bits
		ADC1_Cmd(ENABLE);       // Habilita o ADC1
		ADC1_StartConversion(); // Inicia a coversão
	
		if(ADC1_GetFlagStatus(ADC1_FLAG_EOC)){ AjusteTrimpot = ADC1_GetConversionValue(); } // Proteção BUG de conversão AD da ST
	
	
	
		if(AjusteTrimpot < 58)								         { Tempo = 1;}	//1 hora
		if(AjusteTrimpot >= 58 && AjusteTrimpot < 365) { Tempo = 2;}	//2 horas
		if(AjusteTrimpot >= 365 && AjusteTrimpot < 560){ Tempo = 3;}	//3 horas
		if(AjusteTrimpot >= 560 && AjusteTrimpot < 670){ Tempo = 4;}	//4 horas
		if(AjusteTrimpot >= 670 && AjusteTrimpot < 755){ Tempo = 6;}	//6 horas
		if(AjusteTrimpot >= 755 && AjusteTrimpot < 828){ Tempo = 8;}	//8 horas
		if(AjusteTrimpot >= 828 && AjusteTrimpot < 950){ Tempo = 10;}	//10 horas
		if(AjusteTrimpot >= 950)                			 { Tempo = 12;}	//12 horas
	
		return;
	}
/************************************************************************************************************************
Função VerificaNoite.
Se ficar escuro, essa função analisa por 3 segundos, depois dos 3 segundos se permanecer escuro, ele retorna "b" com o valor de 30. Se no meio desse tempo ficar claro, ele sai dessa função.
Esse tempo é para evitar que o Rele seja acionado por mudanças rapidas no ambiente
****************************************************************************************************************/
	void VerificaNoite(void){    
		b = 0;
    for(c=0; c<40 ; c++){      	//Para cada incremento do i gasta-se 100ms o que da um tempo total de 4s
			LerLDR();								 	//Le o valor do LDR
			if(Escuridade>Lux){    	 	//Lux corresponde entre 10 e 15 Lux, se o nível de luminosidade estiver abaixo desse valor. 
				Delay_500us(1000);   		//Conta um tempo de 100ms.
				b++;                 		//Incrementa a variável b.
			}else{break;}   			    //Se Escuridade for menor que Lux, sai da função for
		}
	return;
}

/************************************************************************************************************************
Função VerificaDia.
Se ficar claro, essa função analisa por 3 segundos, depois dos 3 segundos se permanecer claro, ele retorna "b" com o valor de 30. Se no meio desse tempo ficar escuro, ele sai dessa função.
É usado a logica (Lux - 70) pois ele precisa desligar sempre com lux maior do que quando ele ligou
Esse tempo é para evitar que o Rele seja acionado por mudanças rapidas no ambiente
****************************************************************************************************************/

	void VerificaDia(void){
		e = 0;
		Delay_500us(1000); 				 		 //Delay de 100ms
    for(c=0; c<40 ; c++){    			 //Para cada incremento do c gasta-se 100ms o que da um tempo total de 4s
			LerLDR();							 			 //Le o valor do LDR
				if(Escuridade < Lux - 90){ //Se Escuridade for menor que Lux - 90
				Delay_500us(1000); 				 //Delay de 100ms
				e++; 											 //Incrementa 1 em b
		}else{break;} 								 //Se Escuridade for maior que Lux - 70, sai da função for
		}
	return;
}
//***************//********************************//
  /*Funções EsperaZero0 e EsperaZero1
	Sincronizador Zero Crossing-Graduação por Tensão Elétrica
	Essa função espera o zero da senoide da tensão de entrada no momento da descida do nivel alto para o baixo.
	_____________________________________________________________________________________________________*/
  void Espera_zero0(void){ //Definição da função "EsperaZero0"
    do{cnt=1;while(cnt);  //Delay 500us
    } while(Zero!=1); //0
  }

  void Espera_zero1(void){ //Definição da função "EsperaZero1"
    do{cnt=1;while(cnt);  //Delay 500us
    } while(Zero!=0);   //1
    Espera_zero0();
  }



/*_____________________________________________________________________________________________________
  Função Delay_500us
	Essa função espera 
______________________________________________________________________________________________________*/
  void Delay_500us(unsigned int x){
	  unsigned int y=0,z=0,l=0;
	  if(x<256){
		  cnt=x; while(cnt);
		} else{ do{x=x-255;
	            z++;
	          }while(x>=255);
	          for(l=z; l>0; l--){
	    	      cnt=255;
				      while(cnt);
	          }
	          cnt=x;while(cnt);
	    }
    return;
  }
	
	

/*_____________________________________________________________________________________________________
  Função Liga
	Essa função é utilizada para ligar a carga sempre no Zero da senoide. Sempre que o produto for energizado, a primeira vez que for ligar a carga, pode ser que não ligara no Zero, pois o tempo é fixo e o tempo de atracamento de cada rele é diferente. A partir da primeira vez que ele ligar, o tempo começara a se autocorrigir de acordo com o rele.
	O tempo sempre sera corrigido de 100us em 100us até disparar no 0 e não precisar mais se corrigir.
	Quando a carga é ligada, o valor da Carga e do Zero ficam defasados 180º
______________________________________________________________________________________________________*/
	void Liga(void){
		unsigned int Tempo_liga = 1;
		
		if(var_ligar + Tempo_rele_liga <= (top - a)){	//Se var_ligar + Tempo_rele_liga for menor ou igual a top - l
			Tempo_rele_liga = Tempo_rele_liga--; 				//Decrementa 1 da variavel para ajustar
		}	else{
				Tempo_rele_liga = Tempo_rele_liga++; 				//Mantem o mesmo valor
		  }
		
		if(Zero==0){ 																	//Se Zero for igual a 0
			Espera_zero0();															//Espera passar por 0
			cnt = top - Tempo_rele_liga; while(cnt); 		//Delay para despara a carga no 0
			var_ligar = top - Tempo_rele_liga; 					//Carrega a variavel var_ligar, para verificar se disparou no 0 ou não
			Rele = 1; 																	//Liga a Carga
			while(Carga==Zero){ 												//Enquanto Carga for igual a Zero
				Tempo_liga++; 														//Incrementa 1 na variavel Tempo_Liga
				cnt=1 ;while(cnt);												//Delay de 100us
			}
		}	else{ 																			//Se Zero for igaul a 1
				Espera_zero1();														//Espera passar por 0
				cnt = top - Tempo_rele_liga; while(cnt); 	//Delay para despara a carga no 0
				var_ligar = top - Tempo_rele_liga;				//Carrega a variavel var_ligar, para verificar se disparou no 0 ou não
				Rele = 1; 																//Liga a Carga
				while(Carga==Zero){												//Enquanto Carga for igual a Zero
					Tempo_liga++;														//Incrementa 1 na variavel Tempo_Liga
					cnt=1 ;while(cnt);											//Delay de 100us
				}
			}
		Tempo_rele_liga = Tempo_liga; 								//Armazena o tempo que o tempo que o rele demorou para atracar
  }


/*_____________________________________________________________________________________________________
  Função Desliga
	Essa função é utilizada para desligar a carga sempre no Zero da senoide. Sempre que o produto for energizado, a primeira vez que for desligar a carga, pode ser que não desligara no Zero, pois o tempo é fixo e o tempo de desatracamento de cada rele é diferente. A partir da primeira vez que ele desligar, o tempo começara a se autocorrigir de acordo com o rele.
	O tempo sempre sera corrigido de 100us em 100us até desligar no 0 e não precisar mais se corrigir.
	O produto sempre vai se desligar enquanto a Carga estiver em 0
______________________________________________________________________________________________________*/
	void Desliga(void){
		unsigned int var_desligar1 = 0;
		unsigned int var_desligar2 = 0;

		
		if((Tempo_espera+Tempo_rele_desliga)<=(top - a)){ //Se Tempo_espera + Tempo_rele_desliga for menor ou igual que top - a
			Tempo_rele_desliga = Tempo_rele_desliga--; 			//Decrementa 1 da variavel
		}	else{ 																					//Se Tempo_espera + Tempo_rele_desliga não for menor ou igual que top - a
				Tempo_rele_desliga = Tempo_rele_desliga; 			//Mantem o mesmo valor da variavel
			} 
	
		if(Zero==0){																			//Se Zero for igual a 0
			Espera_zero0();																	//Espera passar por 0
			cnt = top - Tempo_rele_desliga;while(cnt); 			//Delay para despara a carga no 0
			Tempo_espera = top - Tempo_rele_desliga; 				//Carrega a variavel Tempo_espera, para verificar se disparou no 0 ou não
			Rele = 0; 																			//Desliga a carga
			while(Carga==0 && var_desligar2 == 0){ 					//Enquanto Carga e var_desligar2 for igual a 0
				var_desligar1++; 															//Incrementa 1 a variavel
				cnt=1 ;while(cnt); 														//Delay de 100us
			}
			while(Carga==1 && var_desligar1 != 0){ 					//Enquanto Carga for igual a 1 e var_desligar for diferente de 0
				var_desligar2++; 															//Incrementa 1 a variavel
				cnt=1 ;while(cnt);														//Delay de 100us
			}
		}	else{ 																					//Se Zero for igual a 1
				Espera_zero1();																//Espera passar por 0
				cnt = top - Tempo_rele_desliga;while(cnt);		//Delay para despara a carga no 0
				Tempo_espera = top - Tempo_rele_desliga;			//Carrega a variavel Tempo_espera, para verificar se disparou no 0 ou não
				Rele = 0; 																		//Desliga a carga
				while(Carga==0 && var_desligar2 == 0){				//Enquanto Carga e var_desligar2 for igual a 0
					var_desligar1++;														//Incrementa 1 a variavel
					cnt=1 ;while(cnt);													//Delay de 100us
				}
				while(Carga==1 && var_desligar1 != 1){				//Enquanto Carga for igual a 1 e var_desligar for diferente de 0
					var_desligar2++;														//Incrementa 1 a variavel
					cnt=1 ;while(cnt);													//Delay de 100us
				}
			}
		Tempo_rele_desliga = (var_desligar1 + var_desligar2); //Soma as duas variaveis para ver o tempo que a carga demorou para desatracar
	}

/*_____________________________________________________________________________________________________
  Função Analisa_Frequencia
	Essa função Verifica se a rede esta em 50Hz ou 60Hz.
______________________________________________________________________________________________________*/
  void Analisa_frequencia(void){
    top=0;down=0;
		if (Zero==0){								//Se o "Zero" estiver em 0
		  Espera_zero0();				    //Espera passar por 0
		  while(Zero==1){ 					//Enquanto estiver na borda de cima
				top++;									//Incrementa 1 em top
				cnt=1 ;while(cnt);			//Delay de 100us
			}
			while(Zero==0){						//Enquanto estiver na borda de baixo
				down++;									//Incrementa 1 em down
				cnt=1 ;while(cnt);			//Delay de 100us
			}
		}else{ 											//Se o "Zero" estiver em 1
			Espera_zero1();						//Espera passar por 0
			while(Zero==1){						//Enquanto estiver na borda de cima
			top++;										//Incrementa 1 em top
			cnt=1 ;while(cnt);				//Delay de 100us
			}
			while(Zero==0){						//Enquanto estiver na borda de baixo
			 down++;									//Incrementa 1 em down
			 cnt=1 ;while(cnt);				//Delay de 100us
			}
		 }
    
    if((top + down) >= 175){ 		//Se top + down for maior que 175, significa que esta em 50Hz
			Tempo_rele_liga = 50; 		//Armazena esse valor para ligar o a carga perto do 0 na primeira vez
			Tempo_rele_desliga = 50;	//Armazena esse valor para desligar o a carga perto do 0 na primeira vez
			a = 2; 										//Variavel para compensar alguns erros de leituras do micro
		}else{ 
			Tempo_rele_liga = 50;			//Armazena esse valor para ligar o a carga perto do 0 na primeira vez
			Tempo_rele_desliga = 45;	//Armazena esse valor para desligar o a carga perto do 0 na primeira vez
			a = 1; 										//Variavel para compensar alguns erros de leituras do micro
		 }
  }