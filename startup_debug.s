/******************************************************************************
 * _dbgstart
 * Debugger IVT (Core-internal interrupts only)
 *
 * This table is used when the debugger is running (WCH-Link V2.8) and uses
 * "Table of Instructions" format - i.e. instructions at each interrupt vector.
 * Hence, all interrupts will fall through to the final ebreak.
 ******************************************************************************/
.section  .init,"ax",@progbits
.balign 4
.globl  _dbg_vector
_dbg_vector:
  .option push
  .option norvc
  /* Internal interrupts                                                      */
  j     _start                        /* Reset Handler                        */
  nop
  nop                                 /* NMI Handler                          */
  nop                                 /* Hard Fault Handler                   */
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop                                 /* SysTick Handler                      */
  nop
  ebreak                              /* SW Handler                           */
  .option pop
