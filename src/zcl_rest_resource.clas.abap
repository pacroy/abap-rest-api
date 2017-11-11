CLASS zcl_rest_resource DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      if_rest_resource~get REDEFINITION,
      if_rest_resource~post REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rest_resource IMPLEMENTATION.


  METHOD if_rest_resource~get.
    mo_response->create_entity( )->set_string_data( `Hello world!` ).
  ENDMETHOD.


  METHOD if_rest_resource~post.
    DATA: BEGIN OF ls_request,
            name TYPE char50,
            age  TYPE i,
            city TYPE char50,
          END OF ls_request.

    DATA(lv_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ls_request ).

    IF ls_request-name IS INITIAL.
      mo_response->set_status( cl_rest_status_code=>gc_client_error_bad_request ).
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
  ENDMETHOD.
ENDCLASS.
