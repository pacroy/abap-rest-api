CLASS zcl_rest_handler DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_http_handler
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: if_rest_application~get_root_handler REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_REST_HANDLER IMPLEMENTATION.


  METHOD if_rest_application~get_root_handler.
    DATA(lo_router) = NEW cl_rest_router( ).
    lo_router->attach( iv_template = '/hello' iv_handler_class = zcl_rest_resource=>c_class_name ).
    lo_router->attach( iv_template = '/hello/metrics' iv_handler_class = zcl_prometheus_rest_resource=>c_class_name ).

    ro_root_handler = lo_router.
  ENDMETHOD.
ENDCLASS.
