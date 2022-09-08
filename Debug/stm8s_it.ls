   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  14                     	bsct
  15  0000               _cnt:
  16  0000 0000          	dc.w	0
  46                     ; 50 INTERRUPT_HANDLER(NonHandledInterrupt, 25)
  46                     ; 51 {
  47                     	switch	.text
  48  0000               f_NonHandledInterrupt:
  52                     ; 55 }
  55  0000 80            	iret
  77                     ; 63 INTERRUPT_HANDLER_TRAP(TRAP_IRQHandler)
  77                     ; 64 {
  78                     	switch	.text
  79  0001               f_TRAP_IRQHandler:
  83                     ; 68 }
  86  0001 80            	iret
 108                     ; 75 INTERRUPT_HANDLER(TLI_IRQHandler, 0)
 108                     ; 76 
 108                     ; 77 {
 109                     	switch	.text
 110  0002               f_TLI_IRQHandler:
 114                     ; 81 }
 117  0002 80            	iret
 139                     ; 88 INTERRUPT_HANDLER(AWU_IRQHandler, 1)
 139                     ; 89 {
 140                     	switch	.text
 141  0003               f_AWU_IRQHandler:
 145                     ; 93 }
 148  0003 80            	iret
 170                     ; 100 INTERRUPT_HANDLER(CLK_IRQHandler, 2)
 170                     ; 101 {
 171                     	switch	.text
 172  0004               f_CLK_IRQHandler:
 176                     ; 105 }
 179  0004 80            	iret
 202                     ; 112 INTERRUPT_HANDLER(EXTI_PORTA_IRQHandler, 3)
 202                     ; 113 {
 203                     	switch	.text
 204  0005               f_EXTI_PORTA_IRQHandler:
 208                     ; 117 }
 211  0005 80            	iret
 234                     ; 124 INTERRUPT_HANDLER(EXTI_PORTB_IRQHandler, 4)
 234                     ; 125 {
 235                     	switch	.text
 236  0006               f_EXTI_PORTB_IRQHandler:
 240                     ; 129 }
 243  0006 80            	iret
 266                     ; 136 INTERRUPT_HANDLER(EXTI_PORTC_IRQHandler, 5)
 266                     ; 137 {
 267                     	switch	.text
 268  0007               f_EXTI_PORTC_IRQHandler:
 272                     ; 141 }
 275  0007 80            	iret
 298                     ; 148 INTERRUPT_HANDLER(EXTI_PORTD_IRQHandler, 6)
 298                     ; 149 {
 299                     	switch	.text
 300  0008               f_EXTI_PORTD_IRQHandler:
 304                     ; 153 }
 307  0008 80            	iret
 330                     ; 160 INTERRUPT_HANDLER(EXTI_PORTE_IRQHandler, 7)
 330                     ; 161 {
 331                     	switch	.text
 332  0009               f_EXTI_PORTE_IRQHandler:
 336                     ; 165 }
 339  0009 80            	iret
 361                     ; 212 INTERRUPT_HANDLER(SPI_IRQHandler, 10)
 361                     ; 213 {
 362                     	switch	.text
 363  000a               f_SPI_IRQHandler:
 367                     ; 217 }
 370  000a 80            	iret
 393                     ; 224 INTERRUPT_HANDLER(TIM1_UPD_OVF_TRG_BRK_IRQHandler, 11)
 393                     ; 225 {
 394                     	switch	.text
 395  000b               f_TIM1_UPD_OVF_TRG_BRK_IRQHandler:
 399                     ; 229 }
 402  000b 80            	iret
 425                     ; 236 INTERRUPT_HANDLER(TIM1_CAP_COM_IRQHandler, 12)
 425                     ; 237 {
 426                     	switch	.text
 427  000c               f_TIM1_CAP_COM_IRQHandler:
 431                     ; 241 }
 434  000c 80            	iret
 457                     ; 274  INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
 457                     ; 275  {
 458                     	switch	.text
 459  000d               f_TIM2_UPD_OVF_BRK_IRQHandler:
 463                     ; 279  }
 466  000d 80            	iret
 489                     ; 286  INTERRUPT_HANDLER(TIM2_CAP_COM_IRQHandler, 14)
 489                     ; 287  {
 490                     	switch	.text
 491  000e               f_TIM2_CAP_COM_IRQHandler:
 495                     ; 291  }
 498  000e 80            	iret
 521                     ; 328  INTERRUPT_HANDLER(UART1_TX_IRQHandler, 17)
 521                     ; 329  {
 522                     	switch	.text
 523  000f               f_UART1_TX_IRQHandler:
 527                     ; 333  }
 530  000f 80            	iret
 553                     ; 340  INTERRUPT_HANDLER(UART1_RX_IRQHandler, 18)
 553                     ; 341  {
 554                     	switch	.text
 555  0010               f_UART1_RX_IRQHandler:
 559                     ; 345  }
 562  0010 80            	iret
 584                     ; 353 INTERRUPT_HANDLER(I2C_IRQHandler, 19)
 584                     ; 354 {
 585                     	switch	.text
 586  0011               f_I2C_IRQHandler:
 590                     ; 358 }
 593  0011 80            	iret
 615                     ; 432  INTERRUPT_HANDLER(ADC1_IRQHandler, 22)
 615                     ; 433  {
 616                     	switch	.text
 617  0012               f_ADC1_IRQHandler:
 621                     ; 437  }
 624  0012 80            	iret
 649                     ; 458  INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
 649                     ; 459  {
 650                     	switch	.text
 651  0013               f_TIM4_UPD_OVF_IRQHandler:
 653  0013 8a            	push	cc
 654  0014 84            	pop	a
 655  0015 a4bf          	and	a,#191
 656  0017 88            	push	a
 657  0018 86            	pop	cc
 658  0019 3b0002        	push	c_x+2
 659  001c be00          	ldw	x,c_x
 660  001e 89            	pushw	x
 661  001f 3b0002        	push	c_y+2
 662  0022 be00          	ldw	x,c_y
 663  0024 89            	pushw	x
 666                     ; 463 	TIM4_ClearITPendingBit(TIM4_IT_UPDATE);  //limpa o flag de interrupção 
 668  0025 a601          	ld	a,#1
 669  0027 cd0000        	call	_TIM4_ClearITPendingBit
 671                     ; 465 	if (cnt > 0)
 673  002a be00          	ldw	x,_cnt
 674  002c 2707          	jreq	L152
 675                     ; 466 	{--cnt;}
 677  002e be00          	ldw	x,_cnt
 678  0030 1d0001        	subw	x,#1
 679  0033 bf00          	ldw	_cnt,x
 680  0035               L152:
 681                     ; 468  }
 684  0035 85            	popw	x
 685  0036 bf00          	ldw	c_y,x
 686  0038 320002        	pop	c_y+2
 687  003b 85            	popw	x
 688  003c bf00          	ldw	c_x,x
 689  003e 320002        	pop	c_x+2
 690  0041 80            	iret
 713                     ; 476 INTERRUPT_HANDLER(EEPROM_EEC_IRQHandler, 24)
 713                     ; 477 {
 714                     	switch	.text
 715  0042               f_EEPROM_EEC_IRQHandler:
 719                     ; 481 }
 722  0042 80            	iret
 745                     	xdef	_cnt
 746                     	xdef	f_EEPROM_EEC_IRQHandler
 747                     	xdef	f_TIM4_UPD_OVF_IRQHandler
 748                     	xdef	f_ADC1_IRQHandler
 749                     	xdef	f_I2C_IRQHandler
 750                     	xdef	f_UART1_RX_IRQHandler
 751                     	xdef	f_UART1_TX_IRQHandler
 752                     	xdef	f_TIM2_CAP_COM_IRQHandler
 753                     	xdef	f_TIM2_UPD_OVF_BRK_IRQHandler
 754                     	xdef	f_TIM1_UPD_OVF_TRG_BRK_IRQHandler
 755                     	xdef	f_TIM1_CAP_COM_IRQHandler
 756                     	xdef	f_SPI_IRQHandler
 757                     	xdef	f_EXTI_PORTE_IRQHandler
 758                     	xdef	f_EXTI_PORTD_IRQHandler
 759                     	xdef	f_EXTI_PORTC_IRQHandler
 760                     	xdef	f_EXTI_PORTB_IRQHandler
 761                     	xdef	f_EXTI_PORTA_IRQHandler
 762                     	xdef	f_CLK_IRQHandler
 763                     	xdef	f_AWU_IRQHandler
 764                     	xdef	f_TLI_IRQHandler
 765                     	xdef	f_TRAP_IRQHandler
 766                     	xdef	f_NonHandledInterrupt
 767                     	xref	_TIM4_ClearITPendingBit
 768                     	xref.b	c_x
 769                     	xref.b	c_y
 788                     	end
