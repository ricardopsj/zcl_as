class zcl_as definition
  public
  create public .

  public section.

    types:
      tyt_string type table of string .

    class-methods execute
      importing
        !cmd       type clike
      exporting
        !rsl       type tyt_string
      returning
        value(src) type sysubrc .

    class-methods get_user_dir
      importing
        !alias         type clike
      returning
        value(dirname) type user_dir-dirname .


  protected section.
  private section.

    types:
      begin of tys_kernel_version
                 , key(21) type c
                 , data(69) type c
                 , end of tys_kernel_version .
    types:
      tyt_kernel_version type standard table of tys_kernel_version .

    class-data kernel_version type tyt_kernel_version .

    class-methods get_kernel_version .
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


  method get_user_dir.
    select single dirname
      into dirname
      from user_dir
     where aliass eq alias.
*  dirname = dirname && dir_sep( ) && sy-sysid.
  endmethod.
ENDCLASS.
