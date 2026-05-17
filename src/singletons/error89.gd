extends Node


## A custom error enumerator. `OK` is the only member that is shared with the
## built in `Error` enumerator. Everything else is greater or equal to 89.
enum Code {
    ## No error
    OK = Error.OK,
    ## A string or byte array does not end with the expected delimiter
    DOES_NOT_END_WITH_DELIMITER = 89,
    ## A directory does not exist in the file system
    DIRECTORY_DOES_NOT_EXIST = 90,
    ## An array which was not expected to be empty was empty
    EMPTY_ARRAY = 91,
    ## A String which was not expected to be empty was empty
    EMPTY_STRING = 92,
    ## A file does not exist in the file system
    FILE_DOES_NOT_EXIST = 93,
    ## Index is less than zero
    INDEX_IS_LESS_THAN_ZERO = 94,
    ## The opening of an input file for data ingestion had an error
    INPUT_FILE_OPEN_ERROR = 95,
    ## No file pointers were found, but were expected
    NO_FILE_POINTERS = 96,
    ## No files were assigned as input files, but were expected
    NO_LOADED_FILES = 97,
    ## No output directory has been assigned
    NO_OUTPUT_DIRECTORY = 98,
    ## The opening of an output file for data exportation had an error
    OUTPUT_FILE_OPEN_ERROR = 99,
    ## An error happened when opening a file or directory in the file system
    PATH_OPEN_ERROR = 100,
    ## An error occurred when storing data to an output file during exportation
    SAVING_TO_OUTPUT_FILE_ERROR = 101,
    ## The source of a comparison is empty
    SOURCE_IS_EMPTY = 102,
    ## The source of a comparison is smaller than what it is being compared to
    SOURCE_IS_SMALLER = 103,
    ## The "thing" or the "what" that is being searched for was cut short during
    ## discovery from its source.
    WHAT_CUT_SHORT = 104,
    ## The "thing" or the "what" that is being searched for was not found
    WHAT_NOT_FOUND = 105,
    ## The "thing" or the "what" that is being searched for is empty
    WHAT_IS_EMPTY = 106,
}
