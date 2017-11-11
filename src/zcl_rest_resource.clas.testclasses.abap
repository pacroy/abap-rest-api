*"* use this source file for your ABAP unit test classes
CLASS ltcl_base DEFINITION DEFERRED.
CLASS zcl_rest_resource DEFINITION LOCAL FRIENDS ltcl_base.
CLASS ltcl_base DEFINITION ABSTRACT FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS:
      constructor.
  PROTECTED SECTION.
    DATA: mo_cut TYPE REF TO zcl_rest_resource.
ENDCLASS.


CLASS ltcl_base IMPLEMENTATION.

  METHOD constructor.
    mo_cut = NEW #( ).
    mo_cut->mo_request = NEW cl_rest_request( ).
    mo_cut->mo_response = NEW cl_rest_response( ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_get DEFINITION FINAL INHERITING FROM ltcl_base FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      happy_path FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_get IMPLEMENTATION.

  METHOD happy_path.
    mo_cut->if_rest_resource~get( ).

    cl_abap_unit_assert=>assert_equals(
      exp = `Hello world!`
      act = mo_cut->mo_response->get_entity( )->get_string_data( )
    ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_post DEFINITION FINAL INHERITING FROM ltcl_base FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      happy_path FOR TESTING RAISING cx_static_check,
      unhappy_path FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_post IMPLEMENTATION.

  METHOD happy_path.
    mo_cut->mo_request->get_entity( )->set_string_data( `{"name": "John","age": 32,"city": "Bangkok"}` ).

    mo_cut->if_rest_resource~post( NEW cl_rest_entity( ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = cl_rest_status_code=>gc_success_created
      act = mo_cut->mo_response->get_status( )
    ).
  ENDMETHOD.

  METHOD unhappy_path.
    TRY.
        mo_cut->if_rest_resource~post( NEW cl_rest_entity( ) ).
        cl_abap_unit_assert=>fail( `CX_REST_RESOURCE_EXCEPTION not raised` ).
      CATCH cx_rest_resource_exception INTO DATA(lx_rest_resource).
        cl_abap_unit_assert=>assert_equals(
          exp = cl_rest_status_code=>gc_client_error_bad_request
          act = mo_cut->mo_response->get_status( )
        ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
