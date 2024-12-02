*&---------------------------------------------------------------------*
*& Report zabap_did_you_mean_demo
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_did_you_mean_demo.

DATA:
  lt_dict         TYPE string_table,
  lt_result       TYPE string_table,
  lv_result       TYPE string,
  lo_did_you_mean TYPE REF TO zcl_did_you_mean.

START-OF-SELECTION.
  lt_dict = VALUE #(
    ( |email| )
    ( |fail| )
    ( |eval| )
  ).
  lo_did_you_mean = zcl_did_you_mean=>create( it_dict = lt_dict ).
  lt_result = lo_did_you_mean->correct( input = 'meail' ).

  LOOP AT lt_result INTO lv_result.
    WRITE / |Did you mean? { lv_result }|."'email'
  ENDLOOP.
