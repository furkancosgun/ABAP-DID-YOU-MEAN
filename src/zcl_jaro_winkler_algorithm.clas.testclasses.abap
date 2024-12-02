CLASS ltc_jaro_winkler_algorithm DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS:
      run_tests
        FOR TESTING.
  PRIVATE SECTION.

    TYPES: BEGIN OF ty_test_case,
             word1           TYPE string,
             word2           TYPE string,
             expected_result TYPE zif_similarty_algorithm=>ty_similarty_result,
           END OF ty_test_case.

ENDCLASS.

CLASS ltc_jaro_winkler_algorithm IMPLEMENTATION.
  METHOD:run_tests.
    DATA:
      lt_test_cases TYPE TABLE OF ty_test_case,
      lo_alg        TYPE REF TO zif_similarty_algorithm,
      lv_result     TYPE zif_similarty_algorithm=>ty_similarty_result.
    lo_alg = NEW zcl_jaro_winkler_algorithm( ).
    lt_test_cases = VALUE #(
      ( word1 = 'example'    word2 = 'example'    expected_result = '1.0' )
      ( word1 = 'example'    word2 = 'exampel'    expected_result = '0.952' )
      ( word1 = 'example'    word2 = 'abcdef'     expected_result = '0.540' )
      ( word1 = 'abcd'       word2 = 'abdc'       expected_result = '0.916' )
      ( word1 = 'example'    word2 = ''           expected_result = '0.0' )
      ( word1 = 'a'          word2 = 'b'          expected_result = '0.0' )
      ( word1 = 'night'      word2 = 'nacht'      expected_result = '0.733' )
      ( word1 = 'kitten'     word2 = 'sitting'    expected_result = '0.746' )
      ( word1 = 'abcdefghij' word2 = 'abcdfghijk' expected_result = '0.933' )
    ).
    LOOP AT lt_test_cases INTO DATA(ls_test_case).
      lv_result = lo_alg->distance(
        EXPORTING
          iv_word1    = ls_test_case-word1
          iv_word2    = ls_test_case-word2
      ).
      IF lv_result NOT BETWEEN ls_test_case-expected_result - '0.01'
                           AND ls_test_case-expected_result + '0.01'.
        cl_abap_unit_assert=>fail(
          EXPORTING
               msg = |Expected: { ls_test_case-expected_result } | &&
                     |But: { lv_result } | &&
                     |For: { ls_test_case-word1 } -> { ls_test_case-word2 }|                            " Further Description
        ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
