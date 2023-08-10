## Line numbers

Line numbers are compulsory

## Data types

All numbers are floats

All strings are static and cannot be manipulated. They start and end with `"`

## Variables

Variables are created when the first time they are assigned a value in the `LET` statement and a couple of other places

## REM

The `REM` statement allows you to add comments to your programs. Everything on the line is ignored

## LET

The `LET` command allows you to assign a value to a variable

```basic
10 LET n = 42
```

The assigns the value 42 to the variable `n`

```basic
10 LET n = 42
20 LET m = n * 15
```

Once assigned variables can be used to assign values to other variables. The right hand side of the `=` can be an arbitrarily complex expression using all the usual mathematical operators, `+`, `-`, `/`, `*`, `^`, `(` and `)`. There are also some functions

The `LET` statement is the **only place** expressions can be used!

## PRINT

`PRINT` allows you to display numbers, variables and strings

```basic
10 LET a = 3 * 4
20 PRINT 3 "times" 4 "is" a
```

Each element of the `PRINT` statement will have a space between it and a new line at the end. To omit the new line just put a `;` at the end

If the number has no fractional part then the number will be displayed without the fractional part

## END

Any line that has / is `END` will cause the program to halt there and then

## GOTO

The `GOTO` statement allows the program to jump to another line and continue running from there. The target line number must be a valid line number

```basic
10 PRINT "This is the first line"
20 GOTO 40
30 PRINT "You will never see this line"
40 PRINT "This is the last line"
```

## GOSUB ... RETURN

The `GOSUB` statement allows the program to jump to another line and continue running from there, just like `GOTO`. But when `RETURN` is encountered the program will jump back to the after the `GOSUB` statement and continue running from there

```basic
10 PRINT "Before the first GOSUB"
20 GOSUB 70
30 PRINT "After the first GOSUB and before the second"
40 GOSUB 70
50 PRINT "After the second GOSUB"
60 END
70 PRINT "In the GOSUB"
80 RETURN
```

## IF

The `IF` statement allows you to go to another line if some condition is met

```basic
10 LET a = 2
20 IF a < 2 THEN 50
30 PRINT "a is less than 2"
40 END
50 PRINT "a is not less than 2"
60 END
```

The usual comparison operators are available, `<`, `>`, `<=`, `>=`, `=` and `<>` and either a number or variable can be on either side. Again no expressions

You can replace the `THEN` with `GOTO` to make it clearer

A final variant is this

```basic
10 LET a = 3
20 IF a < 3 GOSUB 100
30 PRINT "Carry on"
40 END
100 PRINT "a is less than 3, do something special"
110 RETURN
```

## FOR ... NEXT

Allowing the program to loop

```basic
10 FOR n = 1 TO 10
20 PRINT n
30 NEXT n
```

Note that this is one of the few times that you do not need to declare a variable with the `LET` statement. The above program will print the numbers `1` to `10`

By adding `STEP` you can increment the variable by a value other that `1`

```basic
10 FOR n = 1 TO 10 STEP 2
20 PRINT n
30 NEXT n
```

Which will print out `1`, `3`, `5`, `7`, `9`. If you want to count backwards then you can use

```basic
10 FOR n = 10 TO 1 STEP -2
20 PRINT n
30 NEXT n
```

This will output `10`, `8`, `6`, `4`, `2`

`FOR` will check that the *start*, *end* and *step* values make sense if they are numbers. Any of them could be variables and if so the program is unable to check. This program will run until it crashes!

```basic
10 LET s = -1
20 FOR n = 1 TO 10 STEP s
30 PRINT n
40 NEXT n
50 PRINT "You will never see this printed"
```

## WHILE ... WEND

```basic
10 LET n = 1
20 WHILE n <= 10
30 PRINT n
40 LET n = n + 1
50 WEND
```

The code between the `WHILE` and the `WEND` will be run repeatedly until the condition of the `WHILE` fails

As the condition is tested first the code inside might never be executed

## REPEAT ... UNTIL

```basic
10 LET n = 1
20 REPEAT
30 PRINT n
40 LET n = n + 1
50 UNTIL n > 10
```
The code between the `REPEAT` and the `UNTIL` will be run repeatedly until the condition of the `UNTIL` becomes true

As the condition is tested after the code is run the code will be run at least once


## INPUT

Getting input, a number, from the user. The only other time you do not need to declare a variable with `LET`

```basic
10 PRINT "Enter a number to double"
20 INPUT n
30 LET a = n * 2
40 PRINT a
```
The program will halt at the `INPUT` and wait for the user to input a valid number which it will assign to `n` and the program will carry on

To make things slightly less verbose `INPUT` can take a string prompt

```basic
10 INPUT "Enter a number to double" n
20 LET a = n * 2
30 PRINT a
```
