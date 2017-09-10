*"* use this source file for your ABAP unit test classes
CLASS ltcl_get_root_handler DEFINITION DEFERRED.
CLASS zcl_rest_handler DEFINITION LOCAL FRIENDS ltcl_get_root_handler.
CLASS ltcl_get_root_handler DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: mo_cut    TYPE REF TO zcl_rest_handler,
          mo_router TYPE REF TO cl_rest_router.

    METHODS:
      setup,
      hello_is_handled FOR TESTING RAISING cx_static_check,
      root_is_not_handled FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_get_root_handler IMPLEMENTATION.

  METHOD hello_is_handled.
    mo_router->find_match( EXPORTING iv_path = '/hello' IMPORTING es_match_info = DATA(ls_match_info) ).
    cl_abap_unit_assert=>assert_equals(
        exp = 'ZCL_REST_RESOURCE'
        act = ls_match_info-handler_class
      ).
  ENDMETHOD.

  METHOD setup.
    mo_cut = NEW #( ).
    mo_router = CAST cl_rest_router( mo_cut->get_root_handler( ) ).
  ENDMETHOD.

  METHOD root_is_not_handled.
    mo_router->find_match( EXPORTING iv_path = '/' IMPORTING es_match_info = DATA(ls_match_info) ).
    cl_abap_unit_assert=>assert_initial( ls_match_info-handler_class ).
  ENDMETHOD.

ENDCLASS.
