CLASS zcl_jaro_winkler_algorithm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:zif_similarty_algorithm.  " Interface for the 'Did You Mean' algorithm
    TYPES:ty_hash TYPE TABLE OF i WITH EMPTY KEY. " Type definition for hash tables of integers
ENDCLASS.

CLASS zcl_jaro_winkler_algorithm IMPLEMENTATION.
  METHOD:zif_similarty_algorithm~distance.
    DATA:
      lt_hash_word1  TYPE ty_hash,    " Hash table for the first word (used to track matching positions)
      lt_hash_word2  TYPE ty_hash,    " Hash table for the second word (used to track matching positions)
      lv_len_word1   TYPE i,          " Length of the first word
      lv_len_word2   TYPE i,          " Length of the second word
      lv_max_dist    TYPE i,          " Maximum allowed distance for matching characters
      lv_match_count TYPE i,          " Number of matching characters
      lv_start       TYPE i,          " Start index for matching
      lv_end         TYPE i,          " End index for matching
      lv_i           TYPE i,          " Loop index for the first word
      lv_j           TYPE i,          " Loop index for the second word
      lv_t           TYPE i,          " Counter for transpositions
      lv_point       TYPE i.          " Index to find corresponding matches in word2

    " If both words are the same, return maximum similarity
    IF iv_word1 EQ iv_word2.
      rv_distance = 1. " Maximum similarity
      RETURN.
    ENDIF.

    " Get the length of both words
    lv_len_word1 = strlen( iv_word1 ).
    lv_len_word2 = strlen( iv_word2 ).

    CHECK lv_len_word1 IS NOT INITIAL
      AND lv_len_word2 IS NOT INITIAL.

    " Calculate the maximum distance allowed for character matching
    lv_max_dist = floor( nmax( val1 = lv_len_word1
                               val2 = lv_len_word2 ) / 2 ) - 1.

    lv_match_count = 0. " Initialize match count

    " Initialize hash tables for both words
    DO lv_len_word1 TIMES. APPEND 0 TO lt_hash_word1. ENDDO.
    DO lv_len_word2 TIMES. APPEND 0 TO lt_hash_word2. ENDDO.

    " Iterate through the first word to find matching characters within the allowed distance
    DO lv_len_word1 TIMES.
      lv_i = sy-index - 1.  " Current index for word1
      lv_start = nmax( val1 = 0
                       val2 = lv_i - lv_max_dist ). " Start index for matching range
      lv_end   = nmin( val1 = lv_len_word2
                       val2 = lv_i + lv_max_dist + 1 ). " End index for matching range
      DO lv_end - lv_start TIMES.
        lv_j = lv_start + sy-index - 1. " Current index for word2

        " If characters match and the position in word2 has not been matched before
        IF iv_word1+lv_i(1) EQ iv_word2+lv_j(1) AND lt_hash_word2[ lv_j + 1 ] EQ 0.
          lt_hash_word1[ lv_i + 1 ] = 1. " Mark this character as matched in word1
          lt_hash_word2[ lv_j + 1 ] = 1. " Mark this character as matched in word2
          ADD 1 TO lv_match_count. " Increment match count
          EXIT. " Exit the loop once a match is found
        ENDIF.
      ENDDO.
    ENDDO.

    " If no matches were found, return
    IF lv_match_count EQ 0.
      RETURN.
    ENDIF.

    " Now check for transpositions in the matched characters
    DO lv_len_word1 TIMES.
      lv_i = sy-index - 1.
      IF lt_hash_word1[ lv_i + 1 ] EQ 1.
        " Find the corresponding match in word2
        WHILE lt_hash_word2[ lv_point + 1 ] EQ 0.
          ADD 1 TO lv_point. " Move to the next unmatched position in word2
        ENDWHILE.

        " If characters don't match in the original order, count it as a transposition
        IF iv_word1+lv_i(1) NE iv_word2+lv_point(1).
          ADD 1 TO lv_t. " Increment transposition count
        ENDIF.

        ADD 1 TO lv_point. " Move to the next position in word2
      ENDIF.
    ENDDO.

    " Apply the final formula to calculate the Jaro-Winkler similarity score
    lv_t = trunc( lv_t / 2 ). " Transpositions are counted modulo 2

    rv_distance = ( lv_match_count / lv_len_word1 + lv_match_count / lv_len_word2
                + ( lv_match_count - lv_t ) / lv_match_count ) / 3. " Jaro-Winkler similarity score
  ENDMETHOD.
ENDCLASS.

