/*!****************************************************************************
 * @file
 * linker_script_ch32v103x6_nodebug.ld
 *
 * @brief
 * Default linker script for CH32V103x6 application code.
 *
 * @note
 * THIS LINKER CONFIGURATION DOES NOT PROVISION A DEBUGGER IVT
 *
 * The script provides options for customisation through the linker command
 * line. The following symbols need to be passed using the "defsym" option
 * **before** including the linker script (i.e. before "-T ..."):
 * 
 * - __boot_size: Bootloader space, reserved at the start of FLASH, in bytes.
 * This value must be an integer multiple of 64 (= IVT size), or 0. The default
 * value is 0.
 *
 * - __min_heap_size: Minimum size to be reserved for heap (dynamically allo-
 * cateable space), in bytes. This value must be an integer multiple of 4, or 
 * 0. The default value is 0.
 *
 * - __stack_size: Space to be reserved for the stack, in bytes. This value
 * must be an integer multiple of 4. The default value is 2K.
 * 
 * Example:
 *                    add_link_options(
 *                      -Wl,--defsym=__boot_size=1024
 *                      -T ${LINKER_FILE}
 *                      ...
 *                    )
 *
 * @date  30.03.2023
 * @date  02.10.2023  Added unused glue_7/glue_7t selectors
 * @date  20.02.2025  Added heap/stack space reservation; configuration options
 ******************************************************************************/

/* Entry Point assignment                                                     */
ENTRY( _start )

/* Reserved bootloader space at the start of FLASH                            */
__boot_size = DEFINED(__boot_size) ? __boot_size : 0;
ASSERT((ALIGN(__boot_size, 64)-__boot_size) == 0, "__boot_size must be multiple of 64")

/* Reserved space for heap                                                    */
__min_heap_size = DEFINED(__min_heap_size) ? __min_heap_size : 0;
ASSERT((ALIGN(__min_heap_size, 4)-__min_heap_size) == 0, "__min_heap_size must be multiple of 4")

/* Reserved space for stack                                                   */
__stack_size = DEFINED(__stack_size) ? __stack_size : 2K;
ASSERT((ALIGN(__stack_size, 4)-__stack_size) == 0, "__stack_size must be multiple of 4")

/* Memories definition                                                        */
MEMORY
{
  FLASH     (rx)  : ORIGIN = 0x00000000 + __boot_size, 
                    LENGTH = 32K - __boot_size
  RAM       (xrw) : ORIGIN = 0x20000000, 
                    LENGTH = 10K
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
  
  /* Stack allocation at end of RAM                       */
  PROVIDE(_estack = ORIGIN(RAM) + LENGTH(RAM));
  PROVIDE(_sstack = _estack - __stack_size);
  ASSERT(_sstack > _ebss, "Insufficient space for stack allocation")

  /* Heap allocation between bss and stack                */
  PROVIDE(_sheap = _ebss);
  PROVIDE(_eheap = _sstack);
  ASSERT((_eheap - _sheap) >= __min_heap_size, "Insufficient space for heap allocation")
}
