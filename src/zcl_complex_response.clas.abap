CLASS zcl_complex_response DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_phone_number,
             type   TYPE char50,
             number TYPE char50,
           END OF ts_phone_number,
           tt_phone_number TYPE STANDARD TABLE OF ts_phone_number.

    DATA: name  TYPE char50,
          age   TYPE i,
          city  TYPE char50,
          telno TYPE tt_phone_number.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_complex_response IMPLEMENTATION.
ENDCLASS.
