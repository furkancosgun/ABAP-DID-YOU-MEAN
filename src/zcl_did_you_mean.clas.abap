CLASS zcl_did_you_mean DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      class_constructor.
    CLASS-METHODS:
      create
        IMPORTING
          it_dict                TYPE string_table
        RETURNING
          VALUE(ro_did_you_mean) TYPE REF TO zcl_did_you_mean.
    METHODS:
      correct
        IMPORTING
          input                  TYPE clike
        RETURNING
          VALUE(rt_did_you_mean) TYPE string_table.
  PRIVATE SECTION.
    METHODS:
      constructor
        IMPORTING
          it_dict TYPE string_table.
    METHODS:
      normalize
        IMPORTING
          value                TYPE clike
        RETURNING
          VALUE(rv_normalized) TYPE string.

    CLASS-DATA:
      mo_word_distance_algo  TYPE REF TO zif_distance_algorithm,
      mo_word_similarty_algo TYPE REF TO zif_similarty_algorithm.

    DATA:mt_dict TYPE string_table.
ENDCLASS.



CLASS zcl_did_you_mean IMPLEMENTATION.


  METHOD:class_constructor.
    mo_word_distance_algo = NEW zcl_levenshtein_algorithm( ).
    mo_word_similarty_algo = NEW zcl_jaro_winkler_algorithm( ).
  ENDMETHOD.


  METHOD:constructor.
    DATA:lv_word TYPE string.
    LOOP AT it_dict INTO lv_word WHERE table_line IS NOT INITIAL.
      APPEND me->normalize( value = lv_word ) TO me->mt_dict.
    ENDLOOP.
  ENDMETHOD.


  METHOD:correct.
    DATA:
      lv_normalized_input TYPE string,
      lv_word             TYPE string,
      lt_result           TYPE zif_similarty_algorithm=>ty_results,
      ls_result           LIKE LINE OF lt_result,
      lv_length           TYPE i,
      lv_threshold        TYPE zif_similarty_algorithm=>ty_similarty_result.

    FIELD-SYMBOLS:<fs_result>       TYPE zif_similarty_algorithm=>ty_result,
                  <fs_did_you_mean> TYPE string.

    lv_normalized_input = me->normalize( input ).
    lv_threshold = COND #( WHEN strlen( lv_normalized_input ) GT 3 THEN '0.8' ELSE '0.7' ).

    LOOP AT mt_dict INTO lv_word.
      APPEND INITIAL LINE TO lt_result ASSIGNING <fs_result>.
      <fs_result>-word = lv_word.
      <fs_result>-dist = mo_word_similarty_algo->distance(
        EXPORTING
            iv_word1 = lv_normalized_input
            iv_word2 = <fs_result>-word
      ).
    ENDLOOP.

    DELETE lt_result WHERE dist LT lv_threshold.

    CHECK lt_result IS NOT INITIAL.

    SORT lt_result STABLE BY dist DESCENDING.

    "Calculate by threshold
    lv_threshold = ceil( strlen( lv_normalized_input ) * '0.25' ).
    LOOP AT lt_result INTO ls_result.
      CHECK mo_word_distance_algo->distance(
        EXPORTING
          iv_word1    = ls_result-word
          iv_word2    = lv_normalized_input
      ) LE lv_threshold.

      APPEND INITIAL LINE TO rt_did_you_mean ASSIGNING <fs_did_you_mean>.
      <fs_did_you_mean> = ls_result-word.
    ENDLOOP.

    "If no result
    CHECK rt_did_you_mean IS INITIAL.

    "Calculate by length
    LOOP AT lt_result INTO ls_result.
      lv_length = COND #( WHEN strlen( lv_normalized_input )
                            LT strlen( ls_result-word      )
                          THEN strlen( lv_normalized_input )
                          ELSE strlen( ls_result-word      ) ).

      CHECK mo_word_distance_algo->distance(
        EXPORTING
          iv_word1    = ls_result-word
          iv_word2    = lv_normalized_input
      ) LE lv_length.

      APPEND INITIAL LINE TO rt_did_you_mean ASSIGNING <fs_did_you_mean>.
      <fs_did_you_mean> = ls_result-word.
    ENDLOOP.
  ENDMETHOD.


  METHOD:create.
    CREATE OBJECT ro_did_you_mean
      EXPORTING
        it_dict = it_dict.
  ENDMETHOD.


  METHOD:normalize.
    rv_normalized = to_lower( condense( value ) ).
  ENDMETHOD.
ENDCLASS.
