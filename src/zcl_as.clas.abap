class ZCL_AS definition
  public
  create public .

public section.

  types:
    tyt_string type table of string .

  class-methods EXECUTE
    importing
      !CMD type CLIKE
    exporting
      !RSL type TYT_STRING
    returning
      value(SRC) type SYSUBRC .
  protected section.
private section.

  types:
    begin of tys_kernel_version
               , key(21) type c
               , data(69) type c
               , end of tys_kernel_version .
  types:
    tyt_kernel_version type standard table of tys_kernel_version .

  class-data KERNEL_VERSION type TYT_KERNEL_VERSION .

  class-methods GET_KERNEL_VERSION .
ENDCLASS.



CLASS ZCL_AS IMPLEMENTATION.


  method execute.
    data: lv_cmd type char2048
          , lt_rsl  type table of char2048.

    lv_cmd = cmd.
    call 'SYSTEM' id 'COMMAND' field lv_cmd
                  id 'TAB'     field lt_rsl.
    src = sy-subrc.
    loop at lt_rsl assigning field-symbol(<ls_rsl>).
      append conv string( <ls_rsl> ) to rsl.
    endloop.
  endmethod.


  method get_kernel_version.
    if kernel_version is initial.
      call 'SAPCORE' id 'ID'
                  field 'VERSION'
                     id 'TABLE' field kernel_version.
    endif.
  endmethod.
ENDCLASS.
