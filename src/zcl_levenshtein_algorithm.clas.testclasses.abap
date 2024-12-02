CLASS ltc_levenshtein_algorithm DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PUBLIC SECTION.
    METHODS:
      run_tests FOR TESTING.
  PRIVATE SECTION.

    TYPES: BEGIN OF ty_test_case,
             word1           TYPE string,
             word2           TYPE string,
             expected_result TYPE i,
           END OF ty_test_case.

ENDCLASS.

CLASS ltc_levenshtein_algorithm IMPLEMENTATION.

  METHOD run_tests.
    DATA: lt_test_cases TYPE TABLE OF ty_test_case,
          lo_alg        TYPE REF TO zif_distance_algorithm,
          lv_result     TYPE i.
    " Test case verilerini oluşturuyoruz
    lt_test_cases = VALUE #(
                         ( word1 = 'kitap'       word2 = 'kittap'      expected_result = 1 )
                         ( word1 = 'apple'      word2 = 'applle'       expected_result = 1 )
                         ( word1 = 'hello'      word2 = 'helo'         expected_result = 1 )
                         ( word1 = 'dog'        word2 = 'dig'          expected_result = 1 )
                         ( word1 = 'intention'  word2 = 'execution'     expected_result = 5 )
                         ( word1 = 'night'      word2 = 'nacht'         expected_result = 2 )
                         ( word1 = 'abcdef'     word2 = 'abdfce'        expected_result = 4 )
                         ( word1 = 'flaw'       word2 = 'lawn'          expected_result = 2 )
                         ( word1 = 'kitten'     word2 = 'sitting'       expected_result = 3 )
                         ( word1 = 'sunday'     word2 = 'saturday'      expected_result = 3 )
                         ( word1 = 'programming' word2 = 'programer'     expected_result = 4 )
                         ( word1 = 'lemon'      word2 = 'melon'         expected_result = 2 )
                         ( word1 = 'word'       word2 = 'world'         expected_result = 1 )
                         ( word1 = 'fluff'      word2 = 'buff'          expected_result = 2 )
                         ( word1 = 'fast'       word2 = 'vast'          expected_result = 1 )
                         ( word1 = 'toned'      word2 = 'stone'         expected_result = 2 )
                         ( word1 = 'java'       word2 = 'javascript'    expected_result = 6 )
                         ( word1 = 'abcd'       word2 = 'abcf'          expected_result = 1 )
                         ( word1 = 'hello'      word2 = 'hella'         expected_result = 1 )
                         ( word1 = 'book'       word2 = 'back'          expected_result = 2 )
                         ( word1 = 'red'        word2 = 'green'         expected_result = 3 )
                         ( word1 = 'short'      word2 = 'long'          expected_result = 4 ) ).


    " Algoritma nesnesini oluşturuyoruz
    CREATE OBJECT lo_alg TYPE zcl_levenshtein_algorithm.

    LOOP AT lt_test_cases INTO DATA(ls_test_case).
      " Levenshtein mesafesini hesaplıyoruz
      lv_result = lo_alg->distance( iv_word1 = ls_test_case-word1
                                    iv_word2 = ls_test_case-word2 ).
      cl_abap_unit_assert=>assert_equals(
        EXPORTING
          act                  = lv_result
          exp                  = ls_test_case-expected_result
          msg                  = |For: { ls_test_case-word1 } { ls_test_case-word2 }|
      ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
