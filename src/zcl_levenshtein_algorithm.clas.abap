CLASS zcl_levenshtein_algorithm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:BEGIN OF ty_matrix,
            row TYPE i,
            col TYPE i,
            val TYPE i,
          END OF ty_matrix,
          ty_matrix_tab TYPE HASHED TABLE OF ty_matrix WITH UNIQUE KEY row col.
    INTERFACES: zif_distance_algorithm. " Interface for the 'Did You Mean' algorithm


ENDCLASS.



CLASS ZCL_LEVENSHTEIN_ALGORITHM IMPLEMENTATION.


  METHOD zif_distance_algorithm~distance.
    FIELD-SYMBOLS:<fs_matrix> TYPE ty_matrix.

    DATA:
      lv_word1_len TYPE i,
      lv_word2_len TYPE i.

    DATA:
      lt_matrix TYPE ty_matrix_tab,
      lv_row    TYPE i,
      lv_col    TYPE i,
      lv_cost   TYPE i,
      lv_val    TYPE i.

    DATA:
      lv_word1_chr TYPE c,
      lv_word2_chr TYPE c.


    lv_word1_len = strlen( iv_word1 ) + 1.
    lv_word2_len = strlen( iv_word2 ) + 1.

    CHECK lv_word1_len GT 0
      AND lv_word2_len GT 0.

    DO lv_word2_len TIMES.
      INSERT VALUE #( row = 1 col = sy-index val = sy-index - 1 ) INTO TABLE lt_matrix.
    ENDDO.
    DO lv_word1_len TIMES.
      INSERT VALUE #( row = sy-index col = 1 val = sy-index - 1 ) INTO TABLE lt_matrix.
    ENDDO.


    DO lv_word1_len TIMES.
      CHECK sy-index GT 1.

      lv_row      = sy-index.

      lv_word1_chr = substring( val = iv_word1 off = lv_row - 2 len = 1 ).

      DO lv_word2_len TIMES.
        CHECK sy-index GT 1.

        lv_col      = sy-index.

        lv_word2_chr = substring( val = iv_word2 off = lv_col - 2 len = 1 ).

        IF lv_word1_chr NE lv_word2_chr.
          lv_cost = 1.
        ELSE.
          lv_cost = 0.
        ENDIF.

        lv_val = nmin( val1 = lt_matrix[ row = lv_row - 1 col = lv_col     ]-val + 1 "Insert
                       val2 = lt_matrix[ row = lv_row     col = lv_col - 1 ]-val + 1 "Remove
                       val3 = lt_matrix[ row = lv_row - 1 col = lv_col - 1 ]-val + lv_cost ). "Replace

        INSERT VALUE #( row = lv_row col = lv_col val = lv_val ) INTO TABLE lt_matrix.
      ENDDO.
    ENDDO.

    rv_distance = VALUE #( lt_matrix[ row = lv_word1_len col = lv_word2_len ]-val OPTIONAL ).
  ENDMETHOD.
ENDCLASS.
