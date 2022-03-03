# mculib-controller-ch32v103

## Setup Notes

* Clone into `<project root>\Controller\CH32V103\` with `--recursive` tag
* Template files
  * Exclude `Template` folder from builds
  * Copy template files into parent `Controller` folder and modify to suit system needs
* GNU RISC-V Cross Assembler
  * Add include directory
    ```
    "${workspace_loc:/${ProjName}/Controller/CH32V103}"
    ```
* GNU RISC-V Cross C Compiler
  * Add include directories
    ```
    "${workspace_loc:/${ProjName}/Controller}"
    "${workspace_loc:/${ProjName}/Controller/CH32V103}"
    "${workspace_loc:/${ProjName}/Controller/CH32V103/Core}"
    "${workspace_loc:/${ProjName}/Controller/CH32V103/Peripheral/inc}"
    ```
* GNU RISC-V Cross C Linker
  * Set linkerscript location:
    ```
    "${workspace_loc:/${ProjName}/Controller/CH32V103/linker_script_ch32v103x8.ld}"
    ```
    (or `...x6.ld` for devices with small memory)
  * Select options:
    ```
    -nostartfiles
    -Xlinker --gc-sections
    --specs=nano.specs
    --specs=nosys.specs
    ```