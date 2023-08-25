# Very

This project started as a way to learn assembly on Linux. Write my own old school unstructured spaghetti basic compiler. As I worked through adding features and testing them the thought I had was "With `IF`, `GOTO` and `GOSUB` I actually have all I need". So I cut things back, no `FOR` ... `NEXT`, no `REPEAT` .., `UNTIL`, no `WHILE` ... `WEND`. Now I will be the first to admit that the programs written in this form of basic lacks readability but the goal here was to write a compiler so rather than spend time polishing unnecessary feature I could just steam ahead

Another though was that once I had this working I could implement all missing features in another form of basic that compiles into this basic before compiling to assembly ... a cunning plan indeed

## State of play

* The current basic has only one data type, floating point numbers
* You can print strings but cannot manipulate them
* The keywords are `LET`, `PRINT`, `REM`, `IF`, `GOTO`, `GOSUB`, `RETURN`, `INPUT` and `END`
* The only place expressions can appear is in a `LET` statement
* White space is important, the parser is lazy
* Outputs assembly for my custom cpu and not a real one (yet)

## Planned features

* The string data type and functions to act on them
* Arrays with the `DIM` keyword for floats and strings
* Allow expressions to be used in other places
* amd64 assembly for Linux

## The tools

White these up

## Directories

### `games`

Programs that will run under my CPU. Some have required small tweaks, some have had more extensive rewrites
