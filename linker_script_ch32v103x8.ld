/*!****************************************************************************
 * @file
 * linker_script_ch32v103x8.ld
 *
 * @brief
 * Default linker script for CH32V103x8 application code.
 *
 * @date  02.03.2022
 * @date  23.03.2023  Added simple heap/stack size sanity checks; Added boot-
 *                    loader space
 * @date  28.03.2023  Restructured memory definitions to allow .init section
 *                    programming
 * @date  30.03.2023  Reworked offset handling for debugger IVT and bootloader
 * @date  02.10.2023  Added unused glue_7/glue_7t selectors
 ******************************************************************************/

/* Entry Point assignment                                                     */
ENTRY( _start )

/* Reserved debugger IVT space before bootloader at the start of FLASH        */
__dbg_size = 64;

/* Reserved bootloader space at the start of FLASH                            */
__boot_size = 0;

/* Stack and heap memory size definitions                                     */
__min_heap_size = 0;                /* Minimum required heap size             */
__stack_size = 2048;                /* Reserved stack size                    */ 

/* Memories definition                                                        */
MEMORY
{
  FLASH_DBG (rx)  : ORIGIN = 0x00000000,
                    LENGTH = __dbg_size
  FLASH     (rx)  : ORIGIN = 0x00000000 + MAX(__dbg_size, __boot_size), 
                    LENGTH = 64K - MAX(__dbg_size, __boot_size)
  RAM       (xrw) : ORIGIN = 0x20000000, 
                    LENGTH = 20K
}

/* Sections definition                                                        */
SECTIONS
{
  /* Debugger Init at start of FLASH                      */
  .init :
  {
    . = ALIGN(4);
    _sinit = .;
    
    KEEP(*(SORT_NONE(.init)))
    
    . = ALIGN(4);
    _einit = .;
  } >FLASH_DBG

  /* Interrupt Vector Table at start of app memory        */
  .isr_vector :
  {
    . = ALIGN(4);

    KEEP( *(.isr_vector))
    KEEP( *(.isr_vector.*))

    . = ALIGN(64);
  } >FLASH

  /* Code and read-only constants in FLASH memory         */
  .text :
  {
    . = ALIGN(4);

    *(.text)
    *(.text.*)
    *(.rodata)
    *(.rodata*)
    *(.gnu.linkonce.t.*)

    . = ALIGN(4);
  } >FLASH

  /* LibC init, constructors and destructors              */
  .fini :
  {
    KEEP(*(SORT_NONE(.fini)))
    . = ALIGN(4);
  } >FLASH
  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >FLASH
  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
    KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >FLASH
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
    KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >FLASH
  .ctors :
  {
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  } >FLASH
  .dtors :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  } >FLASH

  /* Initialised data section                             */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;

    *(.gnu.linkonce.r.*)
    *(.data .data.*)
    *(.gnu.linkonce.d.*)

    . = ALIGN(8);
    
    *(.sdata .sdata.*)
    *(.sdata2.*)
    *(.gnu.linkonce.s.*)
    
    . = ALIGN(8);
    
    *(.srodata.cst16)
    *(.srodata.cst8)
    *(.srodata.cst4)
    *(.srodata.cst2)
    *(.srodata .srodata.*)

    . = ALIGN(4);
    _edata = .;
  } >RAM AT>FLASH

  /* Initialisation data location in FLASH                */
  _sidata = LOADADDR(.data);

  /* Zero-initialised data section                        */
  .bss (NOLOAD) :
  {
    . = ALIGN(4);
    _sbss = .;

    *(.sbss*)
    *(.gnu.linkonce.sb.*)
    *(.bss .bss.*)
    *(.gnu.linkonce.b.*)

    *(COMMON*)
    
    . = ALIGN(4);
    _ebss = .;
    PROVIDE( end = . );    
    
  } >RAM
  
  /* Calculate GP for maximum coverage                    */
  __global_pointer$ = MIN(_sdata + 0x800, MAX(_sdata + 0x800, _ebss - 0x800));
  
  /* Stack/Heap collision detection                       */
  .heap (NOLOAD) :
  {
    . = ALIGN(4);
    _sheap = .;
    
    /* Calculate available heap size                      */
    __avail_heap_size = LENGTH(RAM) - __stack_size - (_sheap - ORIGIN(RAM));
    
    . = . + MAX(__min_heap_size, __avail_heap_size);
    . = ALIGN(4);
    _eheap = .;
  } >RAM
  
  /* Stack at the end of RAM                              */
  .stack (NOLOAD) :
  {
    . = ALIGN(4);
    _sstack = .;
    . = . + __stack_size;
    _estack = .;
  } >RAM
}
