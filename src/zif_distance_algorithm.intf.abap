INTERFACE zif_distance_algorithm
  PUBLIC .
  METHODS:
    distance
      IMPORTING
        iv_word1           TYPE clike
        iv_word2           TYPE clike
      RETURNING
        VALUE(rv_distance) TYPE i.
ENDINTERFACE.
