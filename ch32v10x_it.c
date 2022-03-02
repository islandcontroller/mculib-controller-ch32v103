/*!****************************************************************************
 * @file
 * ch32v10x_it.c
 *
 * @brief
 * Application-defined interrupt handler definitions
 *
 * @date  11.02.2022
 * @date  17.02.2022  Added SysTick dummy handler
 ******************************************************************************/

/*- Header files -------------------------------------------------------------*/
#include "ch32v10x.h"


/*!****************************************************************************
 * @brief
 * Hard fault handler
 *
 * @date  11.02.2022
 ******************************************************************************/
void HardFault_Handler(void)
{
  while (1)
  {
  }
}

/*!****************************************************************************
 * @brief
 * SysTick interrupt handler
 *
 * @date  17.02.2022
 ******************************************************************************/
void SysTick_Handler(void)
{
}
