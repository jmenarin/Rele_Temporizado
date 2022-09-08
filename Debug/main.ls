   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
3015                     	bsct
3016  0000               _Escuridade:
3017  0000 0000          	dc.w	0
3018  0002               _Lux:
3019  0002 0258          	dc.w	600
3020  0004               _down:
3021  0004 0000          	dc.w	0
3022  0006               _AjusteTrimpot:
3023  0006 0000          	dc.w	0
3024  0008               _Tempo_rele_desliga:
3025  0008 0000          	dc.w	0
3026  000a               _var_ligar:
3027  000a 0000          	dc.w	0
3028  000c               _Tempo_espera:
3029  000c 0000          	dc.w	0
3030  000e               _Tempo:
3031  000e 0000          	dc.w	0
3083                     .const:	section	.text
3084  0000               L6:
3085  0000 00008b74      	dc.l	35700
3086                     ; 64 main(){
3087                     	scross	off
3088                     	switch	.text
3089  0000               _main:
3093                     ; 69 		CLK_HSIPrescalerConfig (CLK_PRESCALER_HSIDIV8);	// Primeiro determina-se o clock como "High Speedy (HS)" o que dá 16MHz e divide-se por 8 (16/8 = 2MHz)
3095  0000 a618          	ld	a,#24
3096  0002 cd0000        	call	_CLK_HSIPrescalerConfig
3098                     ; 73 		TIM4_TimeBaseInit(TIM4_PRESCALER_8,24);	   // Configuração do Time base, ver no excel
3100  0005 ae0318        	ldw	x,#792
3101  0008 cd0000        	call	_TIM4_TimeBaseInit
3103                     ; 74 		TIM4_ClearFlag(TIM4_FLAG_UPDATE); 				// Clear TIM4 update flag 
3105  000b a601          	ld	a,#1
3106  000d cd0000        	call	_TIM4_ClearFlag
3108                     ; 75 		TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);		// Enable update interrupt
3110  0010 ae0101        	ldw	x,#257
3111  0013 cd0000        	call	_TIM4_ITConfig
3113                     ; 76 		TIM4_Cmd(ENABLE);   											// Habilita TIM4 
3115  0016 a601          	ld	a,#1
3116  0018 cd0000        	call	_TIM4_Cmd
3118                     ; 77 		enableInterrupts();                       // Habilita Interrupções	
3121  001b 9a            rim
3123                     ; 83     CONFIG_UNUSED_PINS_STM8S001;
3126  001c 72145002      	bset	20482,#2
3129  0020 c65007        	ld	a,20487
3130  0023 aacf          	or	a,#207
3131  0025 c75007        	ld	20487,a
3134  0028 c6500c        	ld	a,20492
3135  002b aa86          	or	a,#134
3136  002d c7500c        	ld	20492,a
3139  0030 c65011        	ld	a,20497
3140  0033 aa95          	or	a,#149
3141  0035 c75011        	ld	20497,a
3144  0038 721a5016      	bset	20502,#5
3147  003c 7218501b      	bset	20507,#4
3148                     ; 87  GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_FL_NO_IT); //PA1
3151  0040 4b00          	push	#0
3152  0042 4b40          	push	#64
3153  0044 ae500f        	ldw	x,#20495
3154  0047 cd0000        	call	_GPIO_Init
3156  004a 85            	popw	x
3157                     ; 90  GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_IN_FL_NO_IT); //PA3/TIM2_CH3/[SPI_NSS]/[UART1_TX]
3159  004b 4b00          	push	#0
3160  004d 4b20          	push	#32
3161  004f ae5005        	ldw	x,#20485
3162  0052 cd0000        	call	_GPIO_Init
3164  0055 85            	popw	x
3165                     ; 92  GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); //PB4/I2C_SCL/[ADC_ETR]
3167  0056 4b00          	push	#0
3168  0058 4b10          	push	#16
3169  005a ae5005        	ldw	x,#20485
3170  005d cd0000        	call	_GPIO_Init
3172  0060 85            	popw	x
3173                     ; 94  GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); //PC5/SPI_SCK/[TIM2_CH1]
3175  0061 4be0          	push	#224
3176  0063 4b20          	push	#32
3177  0065 ae500a        	ldw	x,#20490
3178  0068 cd0000        	call	_GPIO_Init
3180  006b 85            	popw	x
3181                     ; 99  GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_IN_FL_NO_IT); //PD3/AIN4/TIM2_CH2/ADC_ETR
3183  006c 4b00          	push	#0
3184  006e 4b20          	push	#32
3185  0070 ae500f        	ldw	x,#20495
3186  0073 cd0000        	call	_GPIO_Init
3188  0076 85            	popw	x
3189                     ; 110 	Rele = 0;            								//Inicia o Produto com a carga no Zero
3191  0077 721b500a      	bres	_PCODR,#5
3192                     ; 111 	Analisa_frequencia();								//Verifica se a Rede esta em 50Hz ou 60Hz
3194  007b cd0627        	call	_Analisa_frequencia
3196                     ; 112 	Delay_500us(10000); 								//Delay de 1 segundo
3198  007e ae2710        	ldw	x,#10000
3199  0081 cd0433        	call	_Delay_500us
3201  0084               L7412:
3202                     ; 119 	LerLDR();														//Função para ler o LDR e armazenar o valor na variavel Escuridade
3204  0084 cd02eb        	call	_LerLDR
3206                     ; 120 	LerLDR();														//Função para ler o LDR e armazenar o valor na variavel Escuridade
3208  0087 cd02eb        	call	_LerLDR
3210                     ; 121 	if(Escuridade > Lux){								//Se Escuridade for maior que Lux, chamar a função VerificaNoite, senão, zera a variavel "b"
3212  008a be00          	ldw	x,_Escuridade
3213  008c b302          	cpw	x,_Lux
3214  008e 2305          	jrule	L3512
3215                     ; 122 		VerificaNoite();
3217  0090 cd03b3        	call	_VerificaNoite
3220  0093 2003          	jra	L5512
3221  0095               L3512:
3222                     ; 124 			b = 0;
3224  0095 5f            	clrw	x
3225  0096 bf0c          	ldw	_b,x
3226  0098               L5512:
3227                     ; 126 	if(b >= 40){ 												//Se verificou o LDR por 4 segundos e confirmou que é noite, liga o rele e le o trimpot
3229  0098 be0c          	ldw	x,_b
3230  009a a30028        	cpw	x,#40
3231  009d 25e5          	jrult	L7412
3232                     ; 127 		Liga();
3234  009f cd0480        	call	_Liga
3236                     ; 128 		LerTrimpot();											//Le o trimpot e armazena o valor na variavel "Tempo"
3238  00a2 cd030a        	call	_LerTrimpot
3241  00a5 acde02de      	jpf	L3612
3242  00a9               L1612:
3243                     ; 132 		switch (Tempo){							
3245  00a9 be0e          	ldw	x,_Tempo
3247                     ; 235 				break;
3248  00ab 5a            	decw	x
3249  00ac 2733          	jreq	L1112
3250  00ae 5a            	decw	x
3251  00af 276e          	jreq	L3112
3252  00b1 5a            	decw	x
3253  00b2 2603          	jrne	L01
3254  00b4 cc0160        	jp	L5112
3255  00b7               L01:
3256  00b7 5a            	decw	x
3257  00b8 2603          	jrne	L21
3258  00ba cc01a1        	jp	L7112
3259  00bd               L21:
3260  00bd 1d0002        	subw	x,#2
3261  00c0 2603          	jrne	L41
3262  00c2 cc01e2        	jp	L1212
3263  00c5               L41:
3264  00c5 1d0002        	subw	x,#2
3265  00c8 2603          	jrne	L61
3266  00ca cc0223        	jp	L3212
3267  00cd               L61:
3268  00cd 1d0002        	subw	x,#2
3269  00d0 2603          	jrne	L02
3270  00d2 cc0262        	jp	L5212
3271  00d5               L02:
3272  00d5 1d0002        	subw	x,#2
3273  00d8 2603          	jrne	L22
3274  00da cc02a1        	jp	L7212
3275  00dd               L22:
3276  00dd acde02de      	jpf	L3612
3277  00e1               L1112:
3278                     ; 133 			case 1:													//Tempo de 1 hora.
3278                     ; 134 				for(f = 0; f < 1; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3280  00e1 5f            	clrw	x
3281  00e2 bf04          	ldw	_f,x
3282  00e4               L3712:
3283                     ; 135 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 1 = 1 hora.
3285  00e4 5f            	clrw	x
3286  00e5 bf08          	ldw	_d,x
3287  00e7               L1022:
3288                     ; 136 						VerificaDia();						//Verifica se ficou claro
3290  00e7 cd03dd        	call	_VerificaDia
3292                     ; 137 							if(e>= 40){							//Se ficou claro por 4 segundos,
3294  00ea be06          	ldw	x,_e
3295  00ec a30028        	cpw	x,#40
3296  00ef 2507          	jrult	L7022
3297                     ; 138 								f = 12;								//Altera o valor de f para sair do laço for
3299  00f1 ae000c        	ldw	x,#12
3300  00f4 bf04          	ldw	_f,x
3301                     ; 139 								break;								//Sai da rotina
3303  00f6 2015          	jra	L5022
3304  00f8               L7022:
3305                     ; 135 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 1 = 1 hora.
3307  00f8 be08          	ldw	x,_d
3308  00fa 1c0001        	addw	x,#1
3309  00fd bf08          	ldw	_d,x
3312  00ff 9c            	rvf
3313  0100 be08          	ldw	x,_d
3314  0102 cd0000        	call	c_uitolx
3316  0105 ae0000        	ldw	x,#L6
3317  0108 cd0000        	call	c_lcmp
3319  010b 2fda          	jrslt	L1022
3320  010d               L5022:
3321                     ; 134 				for(f = 0; f < 1; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3323  010d be04          	ldw	x,_f
3324  010f 1c0001        	addw	x,#1
3325  0112 bf04          	ldw	_f,x
3328  0114 be04          	ldw	x,_f
3329  0116 27cc          	jreq	L3712
3330                     ; 143 				Desliga();										//Desliga o Rele e sai da rotina
3332  0118 cd053f        	call	_Desliga
3334                     ; 144 				break;
3336  011b acde02de      	jpf	L3612
3337  011f               L3112:
3338                     ; 146 			case 2:	
3338                     ; 147 				for(f = 0; f < 2; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3340  011f 5f            	clrw	x
3341  0120 bf04          	ldw	_f,x
3342  0122               L1122:
3343                     ; 148 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 2 = 2 horas.
3345  0122 5f            	clrw	x
3346  0123 bf08          	ldw	_d,x
3347  0125               L7122:
3348                     ; 149 						VerificaDia();						//Verifica se ficou claro
3350  0125 cd03dd        	call	_VerificaDia
3352                     ; 150 						if(e>= 40){								//Se ficou claro por 4 segundos,
3354  0128 be06          	ldw	x,_e
3355  012a a30028        	cpw	x,#40
3356  012d 2507          	jrult	L5222
3357                     ; 151 								f = 12;								//Altera o valor de f para sair do laço for
3359  012f ae000c        	ldw	x,#12
3360  0132 bf04          	ldw	_f,x
3361                     ; 152 								break;								//Sai da rotina		
3363  0134 2015          	jra	L3222
3364  0136               L5222:
3365                     ; 148 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 2 = 2 horas.
3367  0136 be08          	ldw	x,_d
3368  0138 1c0001        	addw	x,#1
3369  013b bf08          	ldw	_d,x
3372  013d 9c            	rvf
3373  013e be08          	ldw	x,_d
3374  0140 cd0000        	call	c_uitolx
3376  0143 ae0000        	ldw	x,#L6
3377  0146 cd0000        	call	c_lcmp
3379  0149 2fda          	jrslt	L7122
3380  014b               L3222:
3381                     ; 147 				for(f = 0; f < 2; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3383  014b be04          	ldw	x,_f
3384  014d 1c0001        	addw	x,#1
3385  0150 bf04          	ldw	_f,x
3388  0152 be04          	ldw	x,_f
3389  0154 a30002        	cpw	x,#2
3390  0157 25c9          	jrult	L1122
3391                     ; 156 				Desliga();										//Desliga o Rele e sai da rotina
3393  0159 cd053f        	call	_Desliga
3395                     ; 157 				break;
3397  015c acde02de      	jpf	L3612
3398  0160               L5112:
3399                     ; 159 			case 3:													//Tempo de 3 horas.
3399                     ; 160 				for(f = 0; f < 3; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3401  0160 5f            	clrw	x
3402  0161 bf04          	ldw	_f,x
3403  0163               L7222:
3404                     ; 161 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 3 = 3 horas.
3406  0163 5f            	clrw	x
3407  0164 bf08          	ldw	_d,x
3408  0166               L5322:
3409                     ; 162 						VerificaDia();						//Verifica se ficou claro
3411  0166 cd03dd        	call	_VerificaDia
3413                     ; 163 						if(e>= 40){								//Se ficou claro por 4 segundos,
3415  0169 be06          	ldw	x,_e
3416  016b a30028        	cpw	x,#40
3417  016e 2507          	jrult	L3422
3418                     ; 164 							f = 12;									//Altera o valor de f para sair do laço for
3420  0170 ae000c        	ldw	x,#12
3421  0173 bf04          	ldw	_f,x
3422                     ; 165 							break;									//Sai da rotina	
3424  0175 2015          	jra	L1422
3425  0177               L3422:
3426                     ; 161 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 3 = 3 horas.
3428  0177 be08          	ldw	x,_d
3429  0179 1c0001        	addw	x,#1
3430  017c bf08          	ldw	_d,x
3433  017e 9c            	rvf
3434  017f be08          	ldw	x,_d
3435  0181 cd0000        	call	c_uitolx
3437  0184 ae0000        	ldw	x,#L6
3438  0187 cd0000        	call	c_lcmp
3440  018a 2fda          	jrslt	L5322
3441  018c               L1422:
3442                     ; 160 				for(f = 0; f < 3; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3444  018c be04          	ldw	x,_f
3445  018e 1c0001        	addw	x,#1
3446  0191 bf04          	ldw	_f,x
3449  0193 be04          	ldw	x,_f
3450  0195 a30003        	cpw	x,#3
3451  0198 25c9          	jrult	L7222
3452                     ; 169 				Desliga();										//Desliga o Rele e sai da rotina
3454  019a cd053f        	call	_Desliga
3456                     ; 170 				break;
3458  019d acde02de      	jpf	L3612
3459  01a1               L7112:
3460                     ; 172 			case 4:													//Tempo de 4 horas.
3460                     ; 173 				for(f = 0; f < 4; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3462  01a1 5f            	clrw	x
3463  01a2 bf04          	ldw	_f,x
3464  01a4               L5422:
3465                     ; 174 					for(d = 0; d < 35700; d++){	////35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 4 = 4 horas.
3467  01a4 5f            	clrw	x
3468  01a5 bf08          	ldw	_d,x
3469  01a7               L3522:
3470                     ; 175 						VerificaDia();						//Verifica se ficou claro
3472  01a7 cd03dd        	call	_VerificaDia
3474                     ; 176 						if(e>= 40){								//Se ficou claro por 4 segundos,
3476  01aa be06          	ldw	x,_e
3477  01ac a30028        	cpw	x,#40
3478  01af 2507          	jrult	L1622
3479                     ; 177 							f = 12;									//Altera o valor de f para sair do laço for
3481  01b1 ae000c        	ldw	x,#12
3482  01b4 bf04          	ldw	_f,x
3483                     ; 178 							break;									//Sai da rotina
3485  01b6 2015          	jra	L7522
3486  01b8               L1622:
3487                     ; 174 					for(d = 0; d < 35700; d++){	////35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 4 = 4 horas.
3489  01b8 be08          	ldw	x,_d
3490  01ba 1c0001        	addw	x,#1
3491  01bd bf08          	ldw	_d,x
3494  01bf 9c            	rvf
3495  01c0 be08          	ldw	x,_d
3496  01c2 cd0000        	call	c_uitolx
3498  01c5 ae0000        	ldw	x,#L6
3499  01c8 cd0000        	call	c_lcmp
3501  01cb 2fda          	jrslt	L3522
3502  01cd               L7522:
3503                     ; 173 				for(f = 0; f < 4; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3505  01cd be04          	ldw	x,_f
3506  01cf 1c0001        	addw	x,#1
3507  01d2 bf04          	ldw	_f,x
3510  01d4 be04          	ldw	x,_f
3511  01d6 a30004        	cpw	x,#4
3512  01d9 25c9          	jrult	L5422
3513                     ; 182 				Desliga();										//Desliga o Rele e sai da rotina
3515  01db cd053f        	call	_Desliga
3517                     ; 183 				break;
3519  01de acde02de      	jpf	L3612
3520  01e2               L1212:
3521                     ; 185 			case 6:													//Tempo de 6 horas.
3521                     ; 186 				for(f = 0; f < 6; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3523  01e2 5f            	clrw	x
3524  01e3 bf04          	ldw	_f,x
3525  01e5               L3622:
3526                     ; 187 					for(d = 0; d < 35700; d++){	///35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 6 = 6 horas.
3528  01e5 5f            	clrw	x
3529  01e6 bf08          	ldw	_d,x
3530  01e8               L1722:
3531                     ; 188 						VerificaDia();						//Verifica se ficou claro
3533  01e8 cd03dd        	call	_VerificaDia
3535                     ; 189 						if(e>= 40){								//Se ficou claro por 4 segundos,
3537  01eb be06          	ldw	x,_e
3538  01ed a30028        	cpw	x,#40
3539  01f0 2507          	jrult	L7722
3540                     ; 190 							f = 12;									//Altera o valor de f para sair do laço for
3542  01f2 ae000c        	ldw	x,#12
3543  01f5 bf04          	ldw	_f,x
3544                     ; 191 							break;									//Sai da rotina
3546  01f7 2015          	jra	L5722
3547  01f9               L7722:
3548                     ; 187 					for(d = 0; d < 35700; d++){	///35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 6 = 6 horas.
3550  01f9 be08          	ldw	x,_d
3551  01fb 1c0001        	addw	x,#1
3552  01fe bf08          	ldw	_d,x
3555  0200 9c            	rvf
3556  0201 be08          	ldw	x,_d
3557  0203 cd0000        	call	c_uitolx
3559  0206 ae0000        	ldw	x,#L6
3560  0209 cd0000        	call	c_lcmp
3562  020c 2fda          	jrslt	L1722
3563  020e               L5722:
3564                     ; 186 				for(f = 0; f < 6; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3566  020e be04          	ldw	x,_f
3567  0210 1c0001        	addw	x,#1
3568  0213 bf04          	ldw	_f,x
3571  0215 be04          	ldw	x,_f
3572  0217 a30006        	cpw	x,#6
3573  021a 25c9          	jrult	L3622
3574                     ; 195 				Desliga();										//Desliga o Rele e sai da rotina
3576  021c cd053f        	call	_Desliga
3578                     ; 196 				break;
3580  021f acde02de      	jpf	L3612
3581  0223               L3212:
3582                     ; 198 			case 8:													//Tempo de 8 horas.
3582                     ; 199 				for(f = 0; f < 8; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3584  0223 5f            	clrw	x
3585  0224 bf04          	ldw	_f,x
3586  0226               L1032:
3587                     ; 200 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 8 = 8 horas.
3589  0226 5f            	clrw	x
3590  0227 bf08          	ldw	_d,x
3591  0229               L7032:
3592                     ; 201 						VerificaDia();						//Verifica se ficou claro
3594  0229 cd03dd        	call	_VerificaDia
3596                     ; 202 						if(e>= 40){								//Se ficou claro por 4 segundos,
3598  022c be06          	ldw	x,_e
3599  022e a30028        	cpw	x,#40
3600  0231 2507          	jrult	L5132
3601                     ; 203 							f = 12;									//Altera o valor de f para sair do laço for
3603  0233 ae000c        	ldw	x,#12
3604  0236 bf04          	ldw	_f,x
3605                     ; 204 							break;									//Sai da rotina
3607  0238 2015          	jra	L3132
3608  023a               L5132:
3609                     ; 200 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 8 = 8 horas.
3611  023a be08          	ldw	x,_d
3612  023c 1c0001        	addw	x,#1
3613  023f bf08          	ldw	_d,x
3616  0241 9c            	rvf
3617  0242 be08          	ldw	x,_d
3618  0244 cd0000        	call	c_uitolx
3620  0247 ae0000        	ldw	x,#L6
3621  024a cd0000        	call	c_lcmp
3623  024d 2fda          	jrslt	L7032
3624  024f               L3132:
3625                     ; 199 				for(f = 0; f < 8; f++){				//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3627  024f be04          	ldw	x,_f
3628  0251 1c0001        	addw	x,#1
3629  0254 bf04          	ldw	_f,x
3632  0256 be04          	ldw	x,_f
3633  0258 a30008        	cpw	x,#8
3634  025b 25c9          	jrult	L1032
3635                     ; 208 				Desliga();										//Desliga o Rele e sai da rotina
3637  025d cd053f        	call	_Desliga
3639                     ; 209 				break;
3641  0260 207c          	jra	L3612
3642  0262               L5212:
3643                     ; 211 			case 10:										 		//Tempo de 10 horas.
3643                     ; 212 				for(f = 0; f < 10; f++){			//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3645  0262 5f            	clrw	x
3646  0263 bf04          	ldw	_f,x
3647  0265               L7132:
3648                     ; 213 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 10 = 10 horas.
3650  0265 5f            	clrw	x
3651  0266 bf08          	ldw	_d,x
3652  0268               L5232:
3653                     ; 214 						VerificaDia();						//Verifica se ficou claro
3655  0268 cd03dd        	call	_VerificaDia
3657                     ; 215 						if(e>= 40){								//Se ficou claro por 4 segundos,
3659  026b be06          	ldw	x,_e
3660  026d a30028        	cpw	x,#40
3661  0270 2507          	jrult	L3332
3662                     ; 216 							f = 12;									//Altera o valor de f para sair do laço for
3664  0272 ae000c        	ldw	x,#12
3665  0275 bf04          	ldw	_f,x
3666                     ; 217 							break;									//Sai da rotina		
3668  0277 2015          	jra	L1332
3669  0279               L3332:
3670                     ; 213 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 10 = 10 horas.
3672  0279 be08          	ldw	x,_d
3673  027b 1c0001        	addw	x,#1
3674  027e bf08          	ldw	_d,x
3677  0280 9c            	rvf
3678  0281 be08          	ldw	x,_d
3679  0283 cd0000        	call	c_uitolx
3681  0286 ae0000        	ldw	x,#L6
3682  0289 cd0000        	call	c_lcmp
3684  028c 2fda          	jrslt	L5232
3685  028e               L1332:
3686                     ; 212 				for(f = 0; f < 10; f++){			//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3688  028e be04          	ldw	x,_f
3689  0290 1c0001        	addw	x,#1
3690  0293 bf04          	ldw	_f,x
3693  0295 be04          	ldw	x,_f
3694  0297 a3000a        	cpw	x,#10
3695  029a 25c9          	jrult	L7132
3696                     ; 221 				Desliga();								 		//Desliga o Rele e sai da rotina
3698  029c cd053f        	call	_Desliga
3700                     ; 222 				break;
3702  029f 203d          	jra	L3612
3703  02a1               L7212:
3704                     ; 224 			case 12:										 		//Tempo de 12 horas.
3704                     ; 225 				for(f = 0; f < 12; f++){			//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3706  02a1 5f            	clrw	x
3707  02a2 bf04          	ldw	_f,x
3708  02a4               L5332:
3709                     ; 226 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 12 = 12 horas.
3711  02a4 5f            	clrw	x
3712  02a5 bf08          	ldw	_d,x
3713  02a7               L3432:
3714                     ; 227 						VerificaDia();						//Verifica se ficou claro
3716  02a7 cd03dd        	call	_VerificaDia
3718                     ; 228 						if(e>= 40){								//Se ficou claro por 4 segundos,
3720  02aa be06          	ldw	x,_e
3721  02ac a30028        	cpw	x,#40
3722  02af 2507          	jrult	L1532
3723                     ; 229 							f = 12;									//Altera o valor de f para sair do laço for
3725  02b1 ae000c        	ldw	x,#12
3726  02b4 bf04          	ldw	_f,x
3727                     ; 230 							break;									//Sai da rotina
3729  02b6 2015          	jra	L7432
3730  02b8               L1532:
3731                     ; 226 					for(d = 0; d < 35700; d++){	//35700 * 0,1s =  3570 segundos.  3570/60 = 60 minutos. 60/60 = 1 hora * 12 = 12 horas.
3733  02b8 be08          	ldw	x,_d
3734  02ba 1c0001        	addw	x,#1
3735  02bd bf08          	ldw	_d,x
3738  02bf 9c            	rvf
3739  02c0 be08          	ldw	x,_d
3740  02c2 cd0000        	call	c_uitolx
3742  02c5 ae0000        	ldw	x,#L6
3743  02c8 cd0000        	call	c_lcmp
3745  02cb 2fda          	jrslt	L3432
3746  02cd               L7432:
3747                     ; 225 				for(f = 0; f < 12; f++){			//O valor de "f" indica as horas,ou seja, quantas vezes vai repetir o for da linha de baixo
3749  02cd be04          	ldw	x,_f
3750  02cf 1c0001        	addw	x,#1
3751  02d2 bf04          	ldw	_f,x
3754  02d4 be04          	ldw	x,_f
3755  02d6 a3000c        	cpw	x,#12
3756  02d9 25c9          	jrult	L5332
3757                     ; 234 				Desliga();					 			 		//Desliga o Rele e sai da rotina
3759  02db cd053f        	call	_Desliga
3761                     ; 235 				break;
3763  02de               L1712:
3764  02de               L3612:
3765                     ; 131 	while(Escuridade > Lux){						//Enquanto Escuridade for maior que LUX, fica preso dentro desse loop
3767  02de be00          	ldw	x,_Escuridade
3768  02e0 b302          	cpw	x,_Lux
3769  02e2 2303          	jrule	L42
3770  02e4 cc00a9        	jp	L1612
3771  02e7               L42:
3772  02e7 ac840084      	jpf	L7412
3801                     ; 249 	void LerLDR(void){           // Definição da função "EsperaZero"
3802                     	switch	.text
3803  02eb               _LerLDR:
3807                     ; 250 		ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE,ADC1_CHANNEL_6,	ADC1_ALIGN_RIGHT); // Inicialização ADC1 - 8 bits
3809  02eb 4b08          	push	#8
3810  02ed ae0006        	ldw	x,#6
3811  02f0 cd0000        	call	_ADC1_ConversionConfig
3813  02f3 84            	pop	a
3814                     ; 251 		ADC1_Cmd(ENABLE);       // Habilita o ADC1
3816  02f4 a601          	ld	a,#1
3817  02f6 cd0000        	call	_ADC1_Cmd
3819                     ; 252 		ADC1_StartConversion(); // Inicia a coversão
3821  02f9 cd0000        	call	_ADC1_StartConversion
3823                     ; 254 		if(ADC1_GetFlagStatus(ADC1_FLAG_EOC)){ Escuridade = ADC1_GetConversionValue(); } // Proteção BUG de conversão AD da ST
3825  02fc a680          	ld	a,#128
3826  02fe cd0000        	call	_ADC1_GetFlagStatus
3828  0301 4d            	tnz	a
3829  0302 2705          	jreq	L3632
3832  0304 cd0000        	call	_ADC1_GetConversionValue
3834  0307 bf00          	ldw	_Escuridade,x
3835  0309               L3632:
3836                     ; 256 		return;
3839  0309 81            	ret
3869                     ; 260 	void LerTrimpot(void){           // Definição da função "EsperaZero"
3870                     	switch	.text
3871  030a               _LerTrimpot:
3875                     ; 261 		ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE,ADC1_CHANNEL_5,	ADC1_ALIGN_RIGHT); // Inicialização ADC1 - 8 bits
3877  030a 4b08          	push	#8
3878  030c ae0005        	ldw	x,#5
3879  030f cd0000        	call	_ADC1_ConversionConfig
3881  0312 84            	pop	a
3882                     ; 262 		ADC1_Cmd(ENABLE);       // Habilita o ADC1
3884  0313 a601          	ld	a,#1
3885  0315 cd0000        	call	_ADC1_Cmd
3887                     ; 263 		ADC1_StartConversion(); // Inicia a coversão
3889  0318 cd0000        	call	_ADC1_StartConversion
3891                     ; 265 		if(ADC1_GetFlagStatus(ADC1_FLAG_EOC)){ AjusteTrimpot = ADC1_GetConversionValue(); } // Proteção BUG de conversão AD da ST
3893  031b a680          	ld	a,#128
3894  031d cd0000        	call	_ADC1_GetFlagStatus
3896  0320 4d            	tnz	a
3897  0321 2705          	jreq	L5732
3900  0323 cd0000        	call	_ADC1_GetConversionValue
3902  0326 bf06          	ldw	_AjusteTrimpot,x
3903  0328               L5732:
3904                     ; 269 		if(AjusteTrimpot < 58)								         { Tempo = 1;}	//1 hora
3906  0328 be06          	ldw	x,_AjusteTrimpot
3907  032a a3003a        	cpw	x,#58
3908  032d 2405          	jruge	L7732
3911  032f ae0001        	ldw	x,#1
3912  0332 bf0e          	ldw	_Tempo,x
3913  0334               L7732:
3914                     ; 270 		if(AjusteTrimpot >= 58 && AjusteTrimpot < 365) { Tempo = 2;}	//2 horas
3916  0334 be06          	ldw	x,_AjusteTrimpot
3917  0336 a3003a        	cpw	x,#58
3918  0339 250c          	jrult	L1042
3920  033b be06          	ldw	x,_AjusteTrimpot
3921  033d a3016d        	cpw	x,#365
3922  0340 2405          	jruge	L1042
3925  0342 ae0002        	ldw	x,#2
3926  0345 bf0e          	ldw	_Tempo,x
3927  0347               L1042:
3928                     ; 271 		if(AjusteTrimpot >= 365 && AjusteTrimpot < 560){ Tempo = 3;}	//3 horas
3930  0347 be06          	ldw	x,_AjusteTrimpot
3931  0349 a3016d        	cpw	x,#365
3932  034c 250c          	jrult	L3042
3934  034e be06          	ldw	x,_AjusteTrimpot
3935  0350 a30230        	cpw	x,#560
3936  0353 2405          	jruge	L3042
3939  0355 ae0003        	ldw	x,#3
3940  0358 bf0e          	ldw	_Tempo,x
3941  035a               L3042:
3942                     ; 272 		if(AjusteTrimpot >= 560 && AjusteTrimpot < 670){ Tempo = 4;}	//4 horas
3944  035a be06          	ldw	x,_AjusteTrimpot
3945  035c a30230        	cpw	x,#560
3946  035f 250c          	jrult	L5042
3948  0361 be06          	ldw	x,_AjusteTrimpot
3949  0363 a3029e        	cpw	x,#670
3950  0366 2405          	jruge	L5042
3953  0368 ae0004        	ldw	x,#4
3954  036b bf0e          	ldw	_Tempo,x
3955  036d               L5042:
3956                     ; 273 		if(AjusteTrimpot >= 670 && AjusteTrimpot < 755){ Tempo = 6;}	//6 horas
3958  036d be06          	ldw	x,_AjusteTrimpot
3959  036f a3029e        	cpw	x,#670
3960  0372 250c          	jrult	L7042
3962  0374 be06          	ldw	x,_AjusteTrimpot
3963  0376 a302f3        	cpw	x,#755
3964  0379 2405          	jruge	L7042
3967  037b ae0006        	ldw	x,#6
3968  037e bf0e          	ldw	_Tempo,x
3969  0380               L7042:
3970                     ; 274 		if(AjusteTrimpot >= 755 && AjusteTrimpot < 828){ Tempo = 8;}	//8 horas
3972  0380 be06          	ldw	x,_AjusteTrimpot
3973  0382 a302f3        	cpw	x,#755
3974  0385 250c          	jrult	L1142
3976  0387 be06          	ldw	x,_AjusteTrimpot
3977  0389 a3033c        	cpw	x,#828
3978  038c 2405          	jruge	L1142
3981  038e ae0008        	ldw	x,#8
3982  0391 bf0e          	ldw	_Tempo,x
3983  0393               L1142:
3984                     ; 275 		if(AjusteTrimpot >= 828 && AjusteTrimpot < 950){ Tempo = 10;}	//10 horas
3986  0393 be06          	ldw	x,_AjusteTrimpot
3987  0395 a3033c        	cpw	x,#828
3988  0398 250c          	jrult	L3142
3990  039a be06          	ldw	x,_AjusteTrimpot
3991  039c a303b6        	cpw	x,#950
3992  039f 2405          	jruge	L3142
3995  03a1 ae000a        	ldw	x,#10
3996  03a4 bf0e          	ldw	_Tempo,x
3997  03a6               L3142:
3998                     ; 276 		if(AjusteTrimpot >= 950)                			 { Tempo = 12;}	//12 horas
4000  03a6 be06          	ldw	x,_AjusteTrimpot
4001  03a8 a303b6        	cpw	x,#950
4002  03ab 2505          	jrult	L5142
4005  03ad ae000c        	ldw	x,#12
4006  03b0 bf0e          	ldw	_Tempo,x
4007  03b2               L5142:
4008                     ; 278 		return;
4011  03b2 81            	ret
4040                     ; 285 	void VerificaNoite(void){    
4041                     	switch	.text
4042  03b3               _VerificaNoite:
4046                     ; 286 		b = 0;
4048  03b3 5f            	clrw	x
4049  03b4 bf0c          	ldw	_b,x
4050                     ; 287     for(c=0; c<40 ; c++){      	//Para cada incremento do i gasta-se 100ms o que da um tempo total de 4s
4052  03b6 5f            	clrw	x
4053  03b7 bf0a          	ldw	_c,x
4054  03b9               L7242:
4055                     ; 288 			LerLDR();								 	//Le o valor do LDR
4057  03b9 cd02eb        	call	_LerLDR
4059                     ; 289 			if(Escuridade>Lux){    	 	//Lux corresponde entre 10 e 15 Lux, se o nível de luminosidade estiver abaixo desse valor. 
4061  03bc be00          	ldw	x,_Escuridade
4062  03be b302          	cpw	x,_Lux
4063  03c0 231a          	jrule	L3342
4064                     ; 290 				Delay_500us(1000);   		//Conta um tempo de 100ms.
4066  03c2 ae03e8        	ldw	x,#1000
4067  03c5 ad6c          	call	_Delay_500us
4069                     ; 291 				b++;                 		//Incrementa a variável b.
4071  03c7 be0c          	ldw	x,_b
4072  03c9 1c0001        	addw	x,#1
4073  03cc bf0c          	ldw	_b,x
4075                     ; 287     for(c=0; c<40 ; c++){      	//Para cada incremento do i gasta-se 100ms o que da um tempo total de 4s
4077  03ce be0a          	ldw	x,_c
4078  03d0 1c0001        	addw	x,#1
4079  03d3 bf0a          	ldw	_c,x
4082  03d5 be0a          	ldw	x,_c
4083  03d7 a30028        	cpw	x,#40
4084  03da 25dd          	jrult	L7242
4085  03dc               L3342:
4086                     ; 294 	return;
4089  03dc 81            	ret
4118                     ; 304 	void VerificaDia(void){
4119                     	switch	.text
4120  03dd               _VerificaDia:
4124                     ; 305 		e = 0;
4126  03dd 5f            	clrw	x
4127  03de bf06          	ldw	_e,x
4128                     ; 306 		Delay_500us(1000); 				 		 //Delay de 100ms
4130  03e0 ae03e8        	ldw	x,#1000
4131  03e3 ad4e          	call	_Delay_500us
4133                     ; 307     for(c=0; c<40 ; c++){    			 //Para cada incremento do c gasta-se 100ms o que da um tempo total de 4s
4135  03e5 5f            	clrw	x
4136  03e6 bf0a          	ldw	_c,x
4137  03e8               L1542:
4138                     ; 308 			LerLDR();							 			 //Le o valor do LDR
4140  03e8 cd02eb        	call	_LerLDR
4142                     ; 309 				if(Escuridade < Lux - 90){ //Se Escuridade for menor que Lux - 90
4144  03eb be02          	ldw	x,_Lux
4145  03ed 1d005a        	subw	x,#90
4146  03f0 b300          	cpw	x,_Escuridade
4147  03f2 231a          	jrule	L5542
4148                     ; 310 				Delay_500us(1000); 				 //Delay de 100ms
4150  03f4 ae03e8        	ldw	x,#1000
4151  03f7 ad3a          	call	_Delay_500us
4153                     ; 311 				e++; 											 //Incrementa 1 em b
4155  03f9 be06          	ldw	x,_e
4156  03fb 1c0001        	addw	x,#1
4157  03fe bf06          	ldw	_e,x
4159                     ; 307     for(c=0; c<40 ; c++){    			 //Para cada incremento do c gasta-se 100ms o que da um tempo total de 4s
4161  0400 be0a          	ldw	x,_c
4162  0402 1c0001        	addw	x,#1
4163  0405 bf0a          	ldw	_c,x
4166  0407 be0a          	ldw	x,_c
4167  0409 a30028        	cpw	x,#40
4168  040c 25da          	jrult	L1542
4169  040e               L5542:
4170                     ; 314 	return;
4173  040e 81            	ret
4198                     ; 321   void Espera_zero0(void){ //Definição da função "EsperaZero0"
4199                     	switch	.text
4200  040f               _Espera_zero0:
4204  040f               L3742:
4205                     ; 322     do{cnt=1;while(cnt);  //Delay 500us
4207  040f ae0001        	ldw	x,#1
4208  0412 bf00          	ldw	_cnt,x
4210  0414               L5052:
4213  0414 be00          	ldw	x,_cnt
4214  0416 26fc          	jrne	L5052
4215                     ; 323     } while(Zero!=1); //0
4217  0418 c65006        	ld	a,_PBIDR
4218  041b a510          	bcp	a,#16
4219  041d 27f0          	jreq	L3742
4220                     ; 324   }
4223  041f 81            	ret
4249                     ; 326   void Espera_zero1(void){ //Definição da função "EsperaZero1"
4250                     	switch	.text
4251  0420               _Espera_zero1:
4255  0420               L1252:
4256                     ; 327     do{cnt=1;while(cnt);  //Delay 500us
4258  0420 ae0001        	ldw	x,#1
4259  0423 bf00          	ldw	_cnt,x
4261  0425               L3352:
4264  0425 be00          	ldw	x,_cnt
4265  0427 26fc          	jrne	L3352
4266                     ; 328     } while(Zero!=0);   //1
4268  0429 c65006        	ld	a,_PBIDR
4269  042c a510          	bcp	a,#16
4270  042e 26f0          	jrne	L1252
4271                     ; 329     Espera_zero0();
4273  0430 addd          	call	_Espera_zero0
4275                     ; 330   }
4278  0432 81            	ret
4340                     ; 338   void Delay_500us(unsigned int x){
4341                     	switch	.text
4342  0433               _Delay_500us:
4344  0433 89            	pushw	x
4345  0434 5204          	subw	sp,#4
4346       00000004      OFST:	set	4
4349                     ; 339 	  unsigned int y=0,z=0,l=0;
4353  0436 5f            	clrw	x
4354  0437 1f03          	ldw	(OFST-1,sp),x
4358                     ; 340 	  if(x<256){
4360  0439 1e05          	ldw	x,(OFST+1,sp)
4361  043b a30100        	cpw	x,#256
4362  043e 240b          	jruge	L5062
4363                     ; 341 		  cnt=x; while(cnt);
4365  0440 1e05          	ldw	x,(OFST+1,sp)
4366  0442 bf00          	ldw	_cnt,x
4368  0444               L7752:
4371  0444 be00          	ldw	x,_cnt
4372  0446 26fc          	jrne	L7752
4374  0448               L3062:
4375                     ; 351     return;
4378  0448 5b06          	addw	sp,#6
4379  044a 81            	ret
4380  044b               L5062:
4381                     ; 342 		} else{ do{x=x-255;
4383  044b 1e05          	ldw	x,(OFST+1,sp)
4384  044d 1d00ff        	subw	x,#255
4385  0450 1f05          	ldw	(OFST+1,sp),x
4386                     ; 343 	            z++;
4388  0452 1e03          	ldw	x,(OFST-1,sp)
4389  0454 1c0001        	addw	x,#1
4390  0457 1f03          	ldw	(OFST-1,sp),x
4392                     ; 344 	          }while(x>=255);
4394  0459 1e05          	ldw	x,(OFST+1,sp)
4395  045b a300ff        	cpw	x,#255
4396  045e 24eb          	jruge	L5062
4397                     ; 345 	          for(l=z; l>0; l--){
4401  0460 2010          	jra	L7162
4402  0462               L3162:
4403                     ; 346 	    	      cnt=255;
4405  0462 ae00ff        	ldw	x,#255
4406  0465 bf00          	ldw	_cnt,x
4408  0467               L7262:
4409                     ; 347 				      while(cnt);
4411  0467 be00          	ldw	x,_cnt
4412  0469 26fc          	jrne	L7262
4413                     ; 345 	          for(l=z; l>0; l--){
4415  046b 1e03          	ldw	x,(OFST-1,sp)
4416  046d 1d0001        	subw	x,#1
4417  0470 1f03          	ldw	(OFST-1,sp),x
4419  0472               L7162:
4422  0472 1e03          	ldw	x,(OFST-1,sp)
4423  0474 26ec          	jrne	L3162
4424                     ; 349 	          cnt=x;while(cnt);
4426  0476 1e05          	ldw	x,(OFST+1,sp)
4427  0478 bf00          	ldw	_cnt,x
4429  047a               L7362:
4432  047a be00          	ldw	x,_cnt
4433  047c 26fc          	jrne	L7362
4434  047e 20c8          	jra	L3062
4477                     ; 362 	void Liga(void){
4478                     	switch	.text
4479  0480               _Liga:
4481  0480 89            	pushw	x
4482       00000002      OFST:	set	2
4485                     ; 363 		unsigned int Tempo_liga = 1;
4487  0481 ae0001        	ldw	x,#1
4488  0484 1f01          	ldw	(OFST-1,sp),x
4490                     ; 365 		if(var_ligar + Tempo_rele_liga <= (top - a)){	//Se var_ligar + Tempo_rele_liga for menor ou igual a top - l
4492  0486 be0a          	ldw	x,_var_ligar
4493  0488 72bb0000      	addw	x,_Tempo_rele_liga
4494  048c 90be02        	ldw	y,_top
4495  048f 72b2000e      	subw	y,_a
4496  0493 90bf00        	ldw	c_y,y
4497  0496 b300          	cpw	x,c_y
4498  0498 220e          	jrugt	L1662
4499                     ; 366 			Tempo_rele_liga = Tempo_rele_liga--; 				//Decrementa 1 da variavel para ajustar
4501  049a be00          	ldw	x,_Tempo_rele_liga
4502  049c 1d0001        	subw	x,#1
4503  049f bf00          	ldw	_Tempo_rele_liga,x
4504  04a1 1c0001        	addw	x,#1
4505  04a4 bf00          	ldw	_Tempo_rele_liga,x
4507  04a6 200c          	jra	L3662
4508  04a8               L1662:
4509                     ; 368 				Tempo_rele_liga = Tempo_rele_liga++; 				//Mantem o mesmo valor
4511  04a8 be00          	ldw	x,_Tempo_rele_liga
4512  04aa 1c0001        	addw	x,#1
4513  04ad bf00          	ldw	_Tempo_rele_liga,x
4514  04af 1d0001        	subw	x,#1
4515  04b2 bf00          	ldw	_Tempo_rele_liga,x
4516  04b4               L3662:
4517                     ; 371 		if(Zero==0){ 																	//Se Zero for igual a 0
4519  04b4 c65006        	ld	a,_PBIDR
4520  04b7 a510          	bcp	a,#16
4521  04b9 2644          	jrne	L5662
4522                     ; 372 			Espera_zero0();															//Espera passar por 0
4524  04bb cd040f        	call	_Espera_zero0
4526                     ; 373 			cnt = top - Tempo_rele_liga; while(cnt); 		//Delay para despara a carga no 0
4528  04be be02          	ldw	x,_top
4529  04c0 72b00000      	subw	x,_Tempo_rele_liga
4530  04c4 bf00          	ldw	_cnt,x
4532  04c6               L3762:
4535  04c6 be00          	ldw	x,_cnt
4536  04c8 26fc          	jrne	L3762
4537                     ; 374 			var_ligar = top - Tempo_rele_liga; 					//Carrega a variavel var_ligar, para verificar se disparou no 0 ou não
4539  04ca be02          	ldw	x,_top
4540  04cc 72b00000      	subw	x,_Tempo_rele_liga
4541  04d0 bf0a          	ldw	_var_ligar,x
4542                     ; 375 			Rele = 1; 																	//Liga a Carga
4544  04d2 721a500a      	bset	_PCODR,#5
4546  04d6 2010          	jra	L3072
4547  04d8               L7762:
4548                     ; 377 				Tempo_liga++; 														//Incrementa 1 na variavel Tempo_Liga
4550  04d8 1e01          	ldw	x,(OFST-1,sp)
4551  04da 1c0001        	addw	x,#1
4552  04dd 1f01          	ldw	(OFST-1,sp),x
4554                     ; 378 				cnt=1 ;while(cnt);												//Delay de 100us
4556  04df ae0001        	ldw	x,#1
4557  04e2 bf00          	ldw	_cnt,x
4559  04e4               L3172:
4562  04e4 be00          	ldw	x,_cnt
4563  04e6 26fc          	jrne	L3172
4564  04e8               L3072:
4565                     ; 376 			while(Carga==Zero){ 												//Enquanto Carga for igual a Zero
4567  04e8 720b500607    	btjf	_PBIDR,#5,L64
4568  04ed 72085006e6    	btjt	_PBIDR,#4,L7762
4569  04f2 2005          	jra	L7172
4570  04f4               L64:
4571  04f4 72095006df    	btjf	_PBIDR,#4,L7762
4572  04f9               L7172:
4573                     ; 390 		Tempo_rele_liga = Tempo_liga; 								//Armazena o tempo que o tempo que o rele demorou para atracar
4575  04f9 1e01          	ldw	x,(OFST-1,sp)
4576  04fb bf00          	ldw	_Tempo_rele_liga,x
4577                     ; 391   }
4580  04fd 85            	popw	x
4581  04fe 81            	ret
4582  04ff               L5662:
4583                     ; 381 				Espera_zero1();														//Espera passar por 0
4585  04ff cd0420        	call	_Espera_zero1
4587                     ; 382 				cnt = top - Tempo_rele_liga; while(cnt); 	//Delay para despara a carga no 0
4589  0502 be02          	ldw	x,_top
4590  0504 72b00000      	subw	x,_Tempo_rele_liga
4591  0508 bf00          	ldw	_cnt,x
4593  050a               L5272:
4596  050a be00          	ldw	x,_cnt
4597  050c 26fc          	jrne	L5272
4598                     ; 383 				var_ligar = top - Tempo_rele_liga;				//Carrega a variavel var_ligar, para verificar se disparou no 0 ou não
4600  050e be02          	ldw	x,_top
4601  0510 72b00000      	subw	x,_Tempo_rele_liga
4602  0514 bf0a          	ldw	_var_ligar,x
4603                     ; 384 				Rele = 1; 																//Liga a Carga
4605  0516 721a500a      	bset	_PCODR,#5
4607  051a 2010          	jra	L5372
4608  051c               L1372:
4609                     ; 386 					Tempo_liga++;														//Incrementa 1 na variavel Tempo_Liga
4611  051c 1e01          	ldw	x,(OFST-1,sp)
4612  051e 1c0001        	addw	x,#1
4613  0521 1f01          	ldw	(OFST-1,sp),x
4615                     ; 387 					cnt=1 ;while(cnt);											//Delay de 100us
4617  0523 ae0001        	ldw	x,#1
4618  0526 bf00          	ldw	_cnt,x
4620  0528               L5472:
4623  0528 be00          	ldw	x,_cnt
4624  052a 26fc          	jrne	L5472
4625  052c               L5372:
4626                     ; 385 				while(Carga==Zero){												//Enquanto Carga for igual a Zero
4628  052c 720b500607    	btjf	_PBIDR,#5,L25
4629  0531 72085006e6    	btjt	_PBIDR,#4,L1372
4630  0536 20c1          	jra	L7172
4631  0538               L25:
4632  0538 72095006df    	btjf	_PBIDR,#4,L1372
4633  053d 20ba          	jra	L7172
4685                     ; 400 	void Desliga(void){
4686                     	switch	.text
4687  053f               _Desliga:
4689  053f 5204          	subw	sp,#4
4690       00000004      OFST:	set	4
4693                     ; 401 		unsigned int var_desligar1 = 0;
4695  0541 5f            	clrw	x
4696  0542 1f01          	ldw	(OFST-3,sp),x
4698                     ; 402 		unsigned int var_desligar2 = 0;
4700  0544 5f            	clrw	x
4701  0545 1f03          	ldw	(OFST-1,sp),x
4703                     ; 405 		if((Tempo_espera+Tempo_rele_desliga)<=(top - a)){ //Se Tempo_espera + Tempo_rele_desliga for menor ou igual que top - a
4705  0547 be0c          	ldw	x,_Tempo_espera
4706  0549 72bb0008      	addw	x,_Tempo_rele_desliga
4707  054d 90be02        	ldw	y,_top
4708  0550 72b2000e      	subw	y,_a
4709  0554 90bf00        	ldw	c_y,y
4710  0557 b300          	cpw	x,c_y
4711  0559 220c          	jrugt	L3772
4712                     ; 406 			Tempo_rele_desliga = Tempo_rele_desliga--; 			//Decrementa 1 da variavel
4714  055b be08          	ldw	x,_Tempo_rele_desliga
4715  055d 1d0001        	subw	x,#1
4716  0560 bf08          	ldw	_Tempo_rele_desliga,x
4717  0562 1c0001        	addw	x,#1
4718  0565 bf08          	ldw	_Tempo_rele_desliga,x
4720  0567               L3772:
4721                     ; 408 				Tempo_rele_desliga = Tempo_rele_desliga; 			//Mantem o mesmo valor da variavel
4723                     ; 411 		if(Zero==0){																			//Se Zero for igual a 0
4725  0567 c65006        	ld	a,_PBIDR
4726  056a a510          	bcp	a,#16
4727  056c 2657          	jrne	L7772
4728                     ; 412 			Espera_zero0();																	//Espera passar por 0
4730  056e cd040f        	call	_Espera_zero0
4732                     ; 413 			cnt = top - Tempo_rele_desliga;while(cnt); 			//Delay para despara a carga no 0
4734  0571 be02          	ldw	x,_top
4735  0573 72b00008      	subw	x,_Tempo_rele_desliga
4736  0577 bf00          	ldw	_cnt,x
4738  0579               L5003:
4741  0579 be00          	ldw	x,_cnt
4742  057b 26fc          	jrne	L5003
4743                     ; 414 			Tempo_espera = top - Tempo_rele_desliga; 				//Carrega a variavel Tempo_espera, para verificar se disparou no 0 ou não
4745  057d be02          	ldw	x,_top
4746  057f 72b00008      	subw	x,_Tempo_rele_desliga
4747  0583 bf0c          	ldw	_Tempo_espera,x
4748                     ; 415 			Rele = 0; 																			//Desliga a carga
4750  0585 721b500a      	bres	_PCODR,#5
4752  0589 2010          	jra	L5103
4753  058b               L1103:
4754                     ; 417 				var_desligar1++; 															//Incrementa 1 a variavel
4756  058b 1e01          	ldw	x,(OFST-3,sp)
4757  058d 1c0001        	addw	x,#1
4758  0590 1f01          	ldw	(OFST-3,sp),x
4760                     ; 418 				cnt=1 ;while(cnt); 														//Delay de 100us
4762  0592 ae0001        	ldw	x,#1
4763  0595 bf00          	ldw	_cnt,x
4765  0597               L5203:
4768  0597 be00          	ldw	x,_cnt
4769  0599 26fc          	jrne	L5203
4770  059b               L5103:
4771                     ; 416 			while(Carga==0 && var_desligar2 == 0){ 					//Enquanto Carga e var_desligar2 for igual a 0
4773  059b c65006        	ld	a,_PBIDR
4774  059e a520          	bcp	a,#32
4775  05a0 2616          	jrne	L5303
4777  05a2 1e03          	ldw	x,(OFST-1,sp)
4778  05a4 27e5          	jreq	L1103
4779  05a6 2010          	jra	L5303
4780  05a8               L3303:
4781                     ; 421 				var_desligar2++; 															//Incrementa 1 a variavel
4783  05a8 1e03          	ldw	x,(OFST-1,sp)
4784  05aa 1c0001        	addw	x,#1
4785  05ad 1f03          	ldw	(OFST-1,sp),x
4787                     ; 422 				cnt=1 ;while(cnt);														//Delay de 100us
4789  05af ae0001        	ldw	x,#1
4790  05b2 bf00          	ldw	_cnt,x
4792  05b4               L5403:
4795  05b4 be00          	ldw	x,_cnt
4796  05b6 26fc          	jrne	L5403
4797  05b8               L5303:
4798                     ; 420 			while(Carga==1 && var_desligar1 != 0){ 					//Enquanto Carga for igual a 1 e var_desligar for diferente de 0
4800  05b8 c65006        	ld	a,_PBIDR
4801  05bb a520          	bcp	a,#32
4802  05bd 275e          	jreq	L3503
4804  05bf 1e01          	ldw	x,(OFST-3,sp)
4805  05c1 26e5          	jrne	L3303
4806  05c3 2058          	jra	L3503
4807  05c5               L7772:
4808                     ; 425 				Espera_zero1();																//Espera passar por 0
4810  05c5 cd0420        	call	_Espera_zero1
4812                     ; 426 				cnt = top - Tempo_rele_desliga;while(cnt);		//Delay para despara a carga no 0
4814  05c8 be02          	ldw	x,_top
4815  05ca 72b00008      	subw	x,_Tempo_rele_desliga
4816  05ce bf00          	ldw	_cnt,x
4818  05d0               L1603:
4821  05d0 be00          	ldw	x,_cnt
4822  05d2 26fc          	jrne	L1603
4823                     ; 427 				Tempo_espera = top - Tempo_rele_desliga;			//Carrega a variavel Tempo_espera, para verificar se disparou no 0 ou não
4825  05d4 be02          	ldw	x,_top
4826  05d6 72b00008      	subw	x,_Tempo_rele_desliga
4827  05da bf0c          	ldw	_Tempo_espera,x
4828                     ; 428 				Rele = 0; 																		//Desliga a carga
4830  05dc 721b500a      	bres	_PCODR,#5
4832  05e0 2010          	jra	L1703
4833  05e2               L5603:
4834                     ; 430 					var_desligar1++;														//Incrementa 1 a variavel
4836  05e2 1e01          	ldw	x,(OFST-3,sp)
4837  05e4 1c0001        	addw	x,#1
4838  05e7 1f01          	ldw	(OFST-3,sp),x
4840                     ; 431 					cnt=1 ;while(cnt);													//Delay de 100us
4842  05e9 ae0001        	ldw	x,#1
4843  05ec bf00          	ldw	_cnt,x
4845  05ee               L1013:
4848  05ee be00          	ldw	x,_cnt
4849  05f0 26fc          	jrne	L1013
4850  05f2               L1703:
4851                     ; 429 				while(Carga==0 && var_desligar2 == 0){				//Enquanto Carga e var_desligar2 for igual a 0
4853  05f2 c65006        	ld	a,_PBIDR
4854  05f5 a520          	bcp	a,#32
4855  05f7 2616          	jrne	L1113
4857  05f9 1e03          	ldw	x,(OFST-1,sp)
4858  05fb 27e5          	jreq	L5603
4859  05fd 2010          	jra	L1113
4860  05ff               L7013:
4861                     ; 434 					var_desligar2++;														//Incrementa 1 a variavel
4863  05ff 1e03          	ldw	x,(OFST-1,sp)
4864  0601 1c0001        	addw	x,#1
4865  0604 1f03          	ldw	(OFST-1,sp),x
4867                     ; 435 					cnt=1 ;while(cnt);													//Delay de 100us
4869  0606 ae0001        	ldw	x,#1
4870  0609 bf00          	ldw	_cnt,x
4872  060b               L1213:
4875  060b be00          	ldw	x,_cnt
4876  060d 26fc          	jrne	L1213
4877  060f               L1113:
4878                     ; 433 				while(Carga==1 && var_desligar1 != 1){				//Enquanto Carga for igual a 1 e var_desligar for diferente de 0
4880  060f c65006        	ld	a,_PBIDR
4881  0612 a520          	bcp	a,#32
4882  0614 2707          	jreq	L3503
4884  0616 1e01          	ldw	x,(OFST-3,sp)
4885  0618 a30001        	cpw	x,#1
4886  061b 26e2          	jrne	L7013
4887  061d               L3503:
4888                     ; 438 		Tempo_rele_desliga = (var_desligar1 + var_desligar2); //Soma as duas variaveis para ver o tempo que a carga demorou para desatracar
4890  061d 1e01          	ldw	x,(OFST-3,sp)
4891  061f 72fb03        	addw	x,(OFST-1,sp)
4892  0622 bf08          	ldw	_Tempo_rele_desliga,x
4893                     ; 439 	}
4896  0624 5b04          	addw	sp,#4
4897  0626 81            	ret
4929                     ; 445   void Analisa_frequencia(void){
4930                     	switch	.text
4931  0627               _Analisa_frequencia:
4935                     ; 446     top=0;down=0;
4937  0627 5f            	clrw	x
4938  0628 bf02          	ldw	_top,x
4941  062a 5f            	clrw	x
4942  062b bf04          	ldw	_down,x
4943                     ; 447 		if (Zero==0){								//Se o "Zero" estiver em 0
4945  062d c65006        	ld	a,_PBIDR
4946  0630 a510          	bcp	a,#16
4947  0632 2651          	jrne	L7313
4948                     ; 448 		  Espera_zero0();				    //Espera passar por 0
4950  0634 cd040f        	call	_Espera_zero0
4953  0637 2010          	jra	L3413
4954  0639               L1413:
4955                     ; 450 				top++;									//Incrementa 1 em top
4957  0639 be02          	ldw	x,_top
4958  063b 1c0001        	addw	x,#1
4959  063e bf02          	ldw	_top,x
4960                     ; 451 				cnt=1 ;while(cnt);			//Delay de 100us
4962  0640 ae0001        	ldw	x,#1
4963  0643 bf00          	ldw	_cnt,x
4965  0645               L3513:
4968  0645 be00          	ldw	x,_cnt
4969  0647 26fc          	jrne	L3513
4970  0649               L3413:
4971                     ; 449 		  while(Zero==1){ 					//Enquanto estiver na borda de cima
4973  0649 c65006        	ld	a,_PBIDR
4974  064c a510          	bcp	a,#16
4975  064e 26e9          	jrne	L1413
4977  0650 2010          	jra	L1613
4978  0652               L7513:
4979                     ; 454 				down++;									//Incrementa 1 em down
4981  0652 be04          	ldw	x,_down
4982  0654 1c0001        	addw	x,#1
4983  0657 bf04          	ldw	_down,x
4984                     ; 455 				cnt=1 ;while(cnt);			//Delay de 100us
4986  0659 ae0001        	ldw	x,#1
4987  065c bf00          	ldw	_cnt,x
4989  065e               L1713:
4992  065e be00          	ldw	x,_cnt
4993  0660 26fc          	jrne	L1713
4994  0662               L1613:
4995                     ; 453 			while(Zero==0){						//Enquanto estiver na borda de baixo
4997  0662 c65006        	ld	a,_PBIDR
4998  0665 a510          	bcp	a,#16
4999  0667 27e9          	jreq	L7513
5001  0669               L5713:
5002                     ; 469     if((top + down) >= 175){ 		//Se top + down for maior que 175, significa que esta em 50Hz
5004  0669 be02          	ldw	x,_top
5005  066b 72bb0004      	addw	x,_down
5006  066f a300af        	cpw	x,#175
5007  0672 2548          	jrult	L3323
5008                     ; 470 			Tempo_rele_liga = 50; 		//Armazena esse valor para ligar o a carga perto do 0 na primeira vez
5010  0674 ae0032        	ldw	x,#50
5011  0677 bf00          	ldw	_Tempo_rele_liga,x
5012                     ; 471 			Tempo_rele_desliga = 50;	//Armazena esse valor para desligar o a carga perto do 0 na primeira vez
5014  0679 ae0032        	ldw	x,#50
5015  067c bf08          	ldw	_Tempo_rele_desliga,x
5016                     ; 472 			a = 2; 										//Variavel para compensar alguns erros de leituras do micro
5018  067e ae0002        	ldw	x,#2
5019  0681 bf0e          	ldw	_a,x
5021  0683 2046          	jra	L5323
5022  0685               L7313:
5023                     ; 458 			Espera_zero1();						//Espera passar por 0
5025  0685 cd0420        	call	_Espera_zero1
5028  0688 2010          	jra	L1023
5029  068a               L7713:
5030                     ; 460 			top++;										//Incrementa 1 em top
5032  068a be02          	ldw	x,_top
5033  068c 1c0001        	addw	x,#1
5034  068f bf02          	ldw	_top,x
5035                     ; 461 			cnt=1 ;while(cnt);				//Delay de 100us
5037  0691 ae0001        	ldw	x,#1
5038  0694 bf00          	ldw	_cnt,x
5040  0696               L1123:
5043  0696 be00          	ldw	x,_cnt
5044  0698 26fc          	jrne	L1123
5045  069a               L1023:
5046                     ; 459 			while(Zero==1){						//Enquanto estiver na borda de cima
5048  069a c65006        	ld	a,_PBIDR
5049  069d a510          	bcp	a,#16
5050  069f 26e9          	jrne	L7713
5052  06a1 2010          	jra	L7123
5053  06a3               L5123:
5054                     ; 464 			 down++;									//Incrementa 1 em down
5056  06a3 be04          	ldw	x,_down
5057  06a5 1c0001        	addw	x,#1
5058  06a8 bf04          	ldw	_down,x
5059                     ; 465 			 cnt=1 ;while(cnt);				//Delay de 100us
5061  06aa ae0001        	ldw	x,#1
5062  06ad bf00          	ldw	_cnt,x
5064  06af               L7223:
5067  06af be00          	ldw	x,_cnt
5068  06b1 26fc          	jrne	L7223
5069  06b3               L7123:
5070                     ; 463 			while(Zero==0){						//Enquanto estiver na borda de baixo
5072  06b3 c65006        	ld	a,_PBIDR
5073  06b6 a510          	bcp	a,#16
5074  06b8 27e9          	jreq	L5123
5075  06ba 20ad          	jra	L5713
5076  06bc               L3323:
5077                     ; 474 			Tempo_rele_liga = 50;			//Armazena esse valor para ligar o a carga perto do 0 na primeira vez
5079  06bc ae0032        	ldw	x,#50
5080  06bf bf00          	ldw	_Tempo_rele_liga,x
5081                     ; 475 			Tempo_rele_desliga = 45;	//Armazena esse valor para desligar o a carga perto do 0 na primeira vez
5083  06c1 ae002d        	ldw	x,#45
5084  06c4 bf08          	ldw	_Tempo_rele_desliga,x
5085                     ; 476 			a = 1; 										//Variavel para compensar alguns erros de leituras do micro
5087  06c6 ae0001        	ldw	x,#1
5088  06c9 bf0e          	ldw	_a,x
5089  06cb               L5323:
5090                     ; 478   }
5093  06cb 81            	ret
5252                     	xdef	_main
5253                     	xdef	_Analisa_frequencia
5254                     	xdef	_Liga
5255                     	xdef	_Espera_zero1
5256                     	xdef	_Espera_zero0
5257                     	xdef	_Delay_500us
5258                     	xdef	_Desliga
5259                     	xdef	_LerLDR
5260                     	xdef	_LerTrimpot
5261                     	xdef	_VerificaDia
5262                     	xdef	_VerificaNoite
5263                     	xdef	_Tempo
5264                     	xdef	_Tempo_espera
5265                     	xdef	_var_ligar
5266                     	xdef	_Tempo_rele_desliga
5267                     	switch	.ubsct
5268  0000               _Tempo_rele_liga:
5269  0000 0000          	ds.b	2
5270                     	xdef	_Tempo_rele_liga
5271                     	xdef	_AjusteTrimpot
5272                     	xdef	_down
5273  0002               _top:
5274  0002 0000          	ds.b	2
5275                     	xdef	_top
5276  0004               _f:
5277  0004 0000          	ds.b	2
5278                     	xdef	_f
5279  0006               _e:
5280  0006 0000          	ds.b	2
5281                     	xdef	_e
5282  0008               _d:
5283  0008 0000          	ds.b	2
5284                     	xdef	_d
5285  000a               _c:
5286  000a 0000          	ds.b	2
5287                     	xdef	_c
5288  000c               _b:
5289  000c 0000          	ds.b	2
5290                     	xdef	_b
5291  000e               _a:
5292  000e 0000          	ds.b	2
5293                     	xdef	_a
5294                     	xdef	_Lux
5295                     	xdef	_Escuridade
5296                     	xref.b	_cnt
5297                     	xref	_TIM4_ClearFlag
5298                     	xref	_TIM4_ITConfig
5299                     	xref	_TIM4_Cmd
5300                     	xref	_TIM4_TimeBaseInit
5301                     	xref	_GPIO_Init
5302                     	xref	_CLK_HSIPrescalerConfig
5303                     	xref	_ADC1_GetFlagStatus
5304                     	xref	_ADC1_GetConversionValue
5305                     	xref	_ADC1_StartConversion
5306                     	xref	_ADC1_ConversionConfig
5307                     	xref	_ADC1_Cmd
5308                     	xref.b	c_y
5328                     	xref	c_lcmp
5329                     	xref	c_uitolx
5330                     	end
