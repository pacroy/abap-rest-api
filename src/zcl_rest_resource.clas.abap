CLASS zcl_rest_resource DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: c_class_name TYPE seoclsname VALUE 'ZCL_REST_RESOURCE'.

    CLASS-METHODS:
      class_constructor.

    METHODS:
      constructor.

    METHODS:
      if_rest_resource~get REDEFINITION,
      if_rest_resource~post REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA runtime TYPE REF TO if_abap_runtime.
    METHODS record_metric
      IMPORTING
        i_method   TYPE string
        i_response TYPE i.
ENDCLASS.



CLASS ZCL_REST_RESOURCE IMPLEMENTATION.


  METHOD class_constructor.
    zcl_log=>create(
      i_log_object = 'ZREST_SIMPLE2'
      i_log_object_desc = 'Simple REST API'
      i_log_subobject = 'ZCL_REST_RESOURCE'
      i_log_subobject_desc = 'Simple REST Resource' ).
*    lcl_log=>create(
*      i_log_object = 'ZREST_SIMPLE2'
*      i_log_object_desc = 'Simple REST API'
*      i_log_subobject = 'ZCL_REST_RESOURCE'
*      i_log_subobject_desc = 'Simple REST Resource' ).
  ENDMETHOD.


  METHOD constructor.
    super->constructor( ).
    me->runtime = cl_abap_runtime=>create_hr_timer( ).
  ENDMETHOD.


  METHOD if_rest_resource~get.
    me->runtime->get_runtime( ).
    mo_response->create_entity( )->set_string_data( `Hello world!` ).

    zcl_log=>i( |Body={ mo_response->get_entity( )->get_string_data( ) }| ).
    zcl_log=>save( ).
*    lcl_log=>i( |Body={ mo_response->get_entity( )->get_string_data( ) }| ).
*    lcl_log=>save( ).

    record_metric( i_method = mo_request->get_method( ) i_response = cl_rest_status_code=>gc_success_ok ).
  ENDMETHOD.


  METHOD if_rest_resource~post.
    me->runtime->get_runtime( ).

    DATA: BEGIN OF ls_request,
            name TYPE char50,
            age  TYPE i,
            city TYPE char50,
          END OF ls_request.

    DATA(lv_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ls_request ).

    IF ls_request-name IS INITIAL.
      mo_response->set_status( cl_rest_status_code=>gc_client_error_bad_request ).
      record_metric( i_method = mo_request->get_method( ) i_response = mo_response->get_status( ) ).
      RAISE EXCEPTION TYPE cx_rest_resource_exception
        EXPORTING
          status_code    = cl_rest_status_code=>gc_client_error_bad_request
          request_method = if_rest_request=>gc_method_post.
    ENDIF.

    DATA(lo_response) = NEW zcl_complex_response( ).
    lo_response->name = ls_request-name.
    lo_response->age = ls_request-age.
    lo_response->city = ls_request-city.
    lo_response->telno = VALUE #(
        ( type = 'Home' number = '023217999' )
        ( type = 'Work' number = '027561000' )
        ( type = 'Cell' number = '0891234567' )
      ).

    DATA(lo_entity) = mo_response->create_entity( ).
    lo_entity->set_content_type( if_rest_media_type=>gc_appl_json ).
    lo_entity->set_string_data( /ui2/cl_json=>serialize( lo_response ) ).
    mo_response->set_status( cl_rest_status_code=>gc_success_created ).

    record_metric( i_method = mo_request->get_method( ) i_response = mo_response->get_status( ) ).
  ENDMETHOD.


  METHOD record_metric.

    TRY.
        zcl_prometheus=>set_instance_name_from_request( me->mo_request ).
        zcl_prometheus=>write_multiple( VALUE #(
          ( key = |hello_count\{method="{ i_method }",status="{ i_response }"\}| value = '1' command = zif_prometheus=>c_command-increment )
          ( key = |hello_duration\{method="{ i_method }",status="{ i_response }"\}| value = me->runtime->get_runtime( ) ) ) ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
