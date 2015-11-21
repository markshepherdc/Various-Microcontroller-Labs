

* Key-LCD.asm  - Simple program to input two characters from the keyboard
* using Keypad.asm, to add them, and then to ouput the sum to
* the LCD display using the LCD_Driver.asm program. 
* And Finally clears the screen for a new equation
* Ex.
* 1st: 2+
*2nd : 2+4=6
*3ed: 3+ 
outa     equ     $ff4f      *stores variable in specific meomry loacation
num1     equ     $4800      *stores variable in specific meomry loacation
num2     equ     $4802      *stores variable in specific meomry loacation
opr      equ     $4906      *stores variable in specific meomry loacation
answe    equ     $4804      *stores variable in specific meomry loacation
rans     equ     $4818      *stores variable in specific meomry loacation
lans     equ     $4820      *stores variable in specific meomry loacation
outlhlf  equ     $FF49      *stores variable in specific meomry loacation
outrhlf  equ     $FF4C      *stores variable in specific meomry loacation
*_-----------------------------------------------------------------------------
#include "DP256reg.asm"  *Creates acess to everything in file
#include "LCD_Driv.asm"  *Creates acess to everything in file
#include "Keypad.asm"    *Creates acess to everything in file

        ORG        $4000   *Program locatopn is at $4000

* Initialize the keypad interface and the LCD display
Restart JSR        INITKEY          *Clears Keys for Use
        JSR        LCD_INIT         *Clears screen for use


* Output the title 'Hello' to the LCD display
        LDAA        #$80                ; DDRAM address Line 1-LEFT
        JSR        LCD_CMD
        LDX        #TITLE                ; Output title on line 1
        JSR        OUTSTRG              :Prints the ADDITIOn

MLOOP
        LDAA        #$94                ; DDRAM address Line 3-LEFT
        JSR        LCD_CMD

*-------------------------------------------------------------------------------
main    jsr     numb1   *Hass the value of the first number imput on keyboard
        jsr     space   *ASCII used to represent a space within the output
        jsr     add  *get, display, and store operator
        jsr     space   *ASCII used to represent a space within the output
        clra            *Clears A to be on the safe side
        bra     main    *loops back to the main
        end
*-------------------------------------------------------------------------------
numb1   JSR     getkey  *gets user input for 1st number
        staa    num1    *storee the first number to varaible
        jsr  CLRLCD     *Clears LCD for new equation
        ldaa    num1   *Puts num1 back in A
        jsr     LCD_OUT    *CONVERTS THE CHARACTER IN A*prints first number
	    suba    #$30          *converts character in A
        RTS             *returns to the main
*-------------------------------------------------------------------------------
numb2   JSR     getkey  *gets user input for 1st number
        jsr     LCD_OUT    *prints first number
        suba    #$30    *CONVERTS THE CHARACTER IN A
        staa    num2    *storee the first number to varaible
        RTS             *returns to the main
*--------------------------------------------------------------------------------
space   ldaa    #$20    *loads hex version of space
        jsr     LCD_OUT   *prints space
        rts             *returns to previous sub routine
*_--------------------------------------------------------------------------------
equal
        ldaa    #$3D    *Loads hex version of equal sign
        jsr     LCD_OUT    *prints equal sign
        rts             *return to previous subroutine
*--------------------------------------------------------------------------------
add
        ldaa    #$2b    *loads up the '+' sighn
        jsr     LCD_OUT    *prints the '+' sign
        jsr     space   *prints space

        jsr     numb2   *get and print second sumber
        adda    num1    *adds the first number to the second number
        staa    answe   *stores sum in variab;e
        jsr     space   *prints space
        jsr     equal   *prints equal
        jsr     space   *prints space

        ldaa    answe   *loads up the answer back in a
        daa             *decimal adjust A for BCD
        jsr     LCD_OUT   *prints answer
        rts             *return to main
*----------------------------------------------------------------------------------------

CLRLCD        JSR        LCD_INIT


* Output the title 'Hello' to the LCD display
	LDAA        #$80                ; DDRAM address Line 1-LEFT
        JSR        LCD_CMD
        LDX        #TITLE                ; Output title on line 1
        JSR        OUTSTRG

*MLOOP
        LDAA        #$94                ; DDRAM address Line 3-LEFT
        JSR        LCD_CMD
        rts



* Subroutine to output string to LCD (X is ptr).  Done
* when EOF character ($04) is encountered.
OUTSTRG
        LDAA        0,X
        CMPA        #$04                ; Done yet?
        BEQ        RTN
        JSR        LCD_OUT
        INX
        BRA        OUTSTRG

RTN     RTS

*-----------------------------------------------------------------------
TITLE   FCC        'Addition' *Loads the addition string
        FCB        $04
        
        
        