INTERFACE zif_similarty_algorithm
  PUBLIC .
  TYPES:ty_similarty_result TYPE p DECIMALS 3 LENGTH 4.

  TYPES:BEGIN OF ty_result,
          word TYPE string,
          dist TYPE ty_similarty_result,
        END OF ty_result,
        ty_results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.
  METHODS:
    distance
      IMPORTING
        iv_word1           TYPE clike
        iv_word2           TYPE clike
      RETURNING
        VALUE(rv_distance) TYPE ty_similarty_result.
ENDINTERFACE.
