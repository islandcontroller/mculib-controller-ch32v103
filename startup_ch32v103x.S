.include "Core/startup_riscv.s"
.include "startup_debug.s"

/******************************************************************************
 * _vector_base
 * Interrupt Vector Table (Vector Mode)
 *
 * In order to use this IVT, startup has to  configure mtvec[1:0] = 0b01.
 ******************************************************************************/
.section  .isr_vector,"ax",@progbits
.balign 4
.globl  _vector_base
_vector_base:
  .option push
  .option norvc
  /* Internal interrupts                                                      */
  j     _start                        /* Reset Handler                        */
  .word 0
  j     NMI_Handler                   /* NMI Handler                          */
  j     HardFault_Handler             /* Hard Fault Handler                   */
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  j     SysTick_Handler               /* SysTick Handler                      */
  .word 0
  j     SW_handler                    /* SW Handler                           */
  .word 0
  /* External Interrupts                                                      */
  j     WWDG_IRQHandler               /* Window Watchdog                      */
  j     PVD_IRQHandler                /* PVD through EXTI Line detect         */
  j     TAMPER_IRQHandler             /* TAMPER                               */
  j     RTC_IRQHandler                /* RTC                                  */
  j     FLASH_IRQHandler              /* Flash                                */
  j     RCC_IRQHandler                /* RCC                                  */
  j     EXTI0_IRQHandler              /* EXTI Line 0                          */
  j     EXTI1_IRQHandler              /* EXTI Line 1                          */
  j     EXTI2_IRQHandler              /* EXTI Line 2                          */
  j     EXTI3_IRQHandler              /* EXTI Line 3                          */
  j     EXTI4_IRQHandler              /* EXTI Line 4                          */
  j     DMA1_Channel1_IRQHandler      /* DMA1 Channel 1                       */
  j     DMA1_Channel2_IRQHandler      /* DMA1 Channel 2                       */
  j     DMA1_Channel3_IRQHandler      /* DMA1 Channel 3                       */
  j     DMA1_Channel4_IRQHandler      /* DMA1 Channel 4                       */
  j     DMA1_Channel5_IRQHandler      /* DMA1 Channel 5                       */
  j     DMA1_Channel6_IRQHandler      /* DMA1 Channel 6                       */
  j     DMA1_Channel7_IRQHandler      /* DMA1 Channel 7                       */
  j     ADC1_2_IRQHandler             /* ADC1_2                               */
  .word 0
  .word 0
  .word 0
  .word 0
  j     EXTI9_5_IRQHandler            /* EXTI Line 9..5                       */
  j     TIM1_BRK_IRQHandler           /* TIM1 Break                           */
  j     TIM1_UP_IRQHandler            /* TIM1 Update                          */
  j     TIM1_TRG_COM_IRQHandler       /* TIM1 Trigger and Commutation         */
  j     TIM1_CC_IRQHandler            /* TIM1 Capture Compare                 */
  j     TIM2_IRQHandler               /* TIM2                                 */
  j     TIM3_IRQHandler               /* TIM3                                 */
  j     TIM4_IRQHandler               /* TIM4                                 */
  j     I2C1_EV_IRQHandler            /* I2C1 Event                           */
  j     I2C1_ER_IRQHandler            /* I2C1 Error                           */
  j     I2C2_EV_IRQHandler            /* I2C2 Event                           */
  j     I2C2_ER_IRQHandler            /* I2C2 Error                           */
  j     SPI1_IRQHandler               /* SPI1                                 */
  j     SPI2_IRQHandler               /* SPI2                                 */
  j     USART1_IRQHandler             /* USART1                               */
  j     USART2_IRQHandler             /* USART2                               */
  j     USART3_IRQHandler             /* USART3                               */
  j     EXTI15_10_IRQHandler          /* EXTI Line 15..10                     */
  j     RTCAlarm_IRQHandler           /* RTC Alarm through EXTI Line          */
  j     USBWakeUp_IRQHandler          /* USB Wakeup from suspend              */
  j     USBHD_IRQHandler              /* USBHD                                */
  .option pop

/* Weak definitions of interrupt handlers in .text                            */
.section  .text.vector_handler, "ax", @progbits
.weak NMI_Handler
.weak HardFault_Handler
.weak SysTick_Handler
.weak SW_handler
.weak WWDG_IRQHandler
.weak PVD_IRQHandler
.weak TAMPER_IRQHandler
.weak RTC_IRQHandler
.weak FLASH_IRQHandler
.weak RCC_IRQHandler
.weak EXTI0_IRQHandler
.weak EXTI1_IRQHandler
.weak EXTI2_IRQHandler
.weak EXTI3_IRQHandler
.weak EXTI4_IRQHandler
.weak DMA1_Channel1_IRQHandler
.weak DMA1_Channel2_IRQHandler
.weak DMA1_Channel3_IRQHandler
.weak DMA1_Channel4_IRQHandler
.weak DMA1_Channel5_IRQHandler
.weak DMA1_Channel6_IRQHandler
.weak DMA1_Channel7_IRQHandler
.weak ADC1_2_IRQHandler
.weak EXTI9_5_IRQHandler
.weak TIM1_BRK_IRQHandler
.weak TIM1_UP_IRQHandler
.weak TIM1_TRG_COM_IRQHandler
.weak TIM1_CC_IRQHandler
.weak TIM2_IRQHandler
.weak TIM3_IRQHandler
.weak TIM4_IRQHandler
.weak I2C1_EV_IRQHandler
.weak I2C1_ER_IRQHandler
.weak I2C2_EV_IRQHandler
.weak I2C2_ER_IRQHandler
.weak SPI1_IRQHandler
.weak SPI2_IRQHandler
.weak USART1_IRQHandler
.weak USART2_IRQHandler
.weak USART3_IRQHandler
.weak EXTI15_10_IRQHandler
.weak RTCAlarm_IRQHandler
.weak USBWakeUp_IRQHandler
.weak USBHD_IRQHandler

/* Default to generic handler if not implemented                              */
.set NMI_Handler, Default_Handler
.set HardFault_Handler, Default_Handler
.set SysTick_Handler, Default_Handler
.set SW_handler, Default_Handler
.set WWDG_IRQHandler, Default_Handler
.set PVD_IRQHandler, Default_Handler
.set TAMPER_IRQHandler, Default_Handler
.set RTC_IRQHandler, Default_Handler
.set FLASH_IRQHandler, Default_Handler
.set RCC_IRQHandler, Default_Handler
.set EXTI0_IRQHandler, Default_Handler
.set EXTI1_IRQHandler, Default_Handler
.set EXTI2_IRQHandler, Default_Handler
.set EXTI3_IRQHandler, Default_Handler
.set EXTI4_IRQHandler, Default_Handler
.set DMA1_Channel1_IRQHandler, Default_Handler
.set DMA1_Channel2_IRQHandler, Default_Handler
.set DMA1_Channel3_IRQHandler, Default_Handler
.set DMA1_Channel4_IRQHandler, Default_Handler
.set DMA1_Channel5_IRQHandler, Default_Handler
.set DMA1_Channel6_IRQHandler, Default_Handler
.set DMA1_Channel7_IRQHandler, Default_Handler
.set ADC1_2_IRQHandler, Default_Handler
.set EXTI9_5_IRQHandler, Default_Handler
.set TIM1_BRK_IRQHandler, Default_Handler
.set TIM1_UP_IRQHandler, Default_Handler
.set TIM1_TRG_COM_IRQHandler, Default_Handler
.set TIM1_CC_IRQHandler, Default_Handler
.set TIM2_IRQHandler, Default_Handler
.set TIM3_IRQHandler, Default_Handler
.set TIM4_IRQHandler, Default_Handler
.set I2C1_EV_IRQHandler, Default_Handler
.set I2C1_ER_IRQHandler, Default_Handler
.set I2C2_EV_IRQHandler, Default_Handler
.set I2C2_ER_IRQHandler, Default_Handler
.set SPI1_IRQHandler, Default_Handler
.set SPI2_IRQHandler, Default_Handler
.set USART1_IRQHandler, Default_Handler
.set USART2_IRQHandler, Default_Handler
.set USART3_IRQHandler, Default_Handler
.set EXTI15_10_IRQHandler, Default_Handler
.set RTCAlarm_IRQHandler, Default_Handler
.set USBWakeUp_IRQHandler, Default_Handler
.set USBHD_IRQHandler, Default_Handler


/******************************************************************************
 * Default_Handler
 * Default interrupt handler for unimplemented interrupts
 ******************************************************************************/
.section  .text.Default_Handler
.balign 4
.globl  Default_Handler
Default_Handler:
  j     Default_Handler

