# Notes

2. Remove unreferenced labels from assembler
3. Remove unnecessary `nop`
  1. A `nop` with an unreferenced label can be removed
  2. A `nop` with a referenced label can be merged into the next row if that has an unreferenced label

# Implement

1. Strings
2. Arrays
3. Functions

# Outstanding

## DATA
holds a list of values which are assigned sequentially using the READ command.

## READ
reads a value from a DATA statement and assigns it to a variable. An internal pointer keeps track of the last DATA element that was read and moves it one position forward with each READ. Most dialects allow multiple variables as parameters, reading several values in a single operation.

## RESTORE
resets the internal pointer to the first DATA statement, allowing the program to begin READing from the first value. Many dialects allow an optional line number or ordinal value to allow the pointer to be reset to a selected location.

## DIM
Sets up an array.

## TAB
used with PRINT to set the position where the next character will be shown on the screen or printed on paper. AT is an alternative form.

## SPC
prints out a number of space characters. Similar in concept to TAB but moves by a number of additional spaces from the current column rather than moving to a specified column.

## Mathematical functions

|Name|Comment|
|---|---|
|ATN|Arctangent (result in radians)|
|EXP|Exponential function|
|LOG|Natural logarithm|
