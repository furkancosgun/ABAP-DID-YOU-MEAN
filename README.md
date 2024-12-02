# ABAP Did You Mean

ABAP Did You Mean is a package for finding similar words or suggestions from a dictionary, inspired by "Did you mean?" functionality. It leverages distance and similarity algorithms for accurate suggestions.

## Features

- **Customizable Dictionary**: Easily set your word dictionary.
- **Word Normalization**: Handles case-insensitive matches with string normalization.
- **Distance & Similarity Algorithms**: Uses Levenshtein Distance and Jaro-Winkler algorithms.

## Installation
-  Install **ABAPGit** in your SAP system if it's not already installed.
-  Open the **ABAPGit** application in your system.
-  Clone the repository URL of this project into **ABAPGit**.
-  Pull the code into your system. **ABAPGit** will automatically create the necessary objects in your package.

## Usage

Here’s an example demonstrating how to use the [ZCL_DID_YOU_MEAN](src/zcl_did_you_mean.clas.abap) class:

```abap
REPORT zabap_did_you_mean_demo.

DATA:
  lt_dict         TYPE string_table,
  lt_result       TYPE string_table,
  lv_result	      TYPE string,
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
```

## Class API

### Public Methods

-   `CREATE`: Factory method to instantiate the class.
    
    -   **Parameters**:
        -   `IT_DICT`: The dictionary of words (type `STRING_TABLE`).
    -   **Returns**: Reference to `ZCL_DID_YOU_MEAN`.
-   `CORRECT`: Suggests words from the dictionary that are similar to the input.
    
    -   **Parameters**:
        -   `INPUT`: The word to correct (type `CLIKE`).
    -   **Returns**: Table of suggested words (type `STRING_TABLE`).

## Algorithms

-   **Levenshtein Distance**: Measures the difference between two strings.
-   **Jaro-Winkler Similarity**: Evaluates the similarity between two strings.

## Contributing

Feel free to submit issues or contribute to the project through pull requests.

## License

This project is open-source and available under the [MIT](LICENSE) License.

