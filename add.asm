*MARK SHEPHERD
*ENGR 385
*LAB #4
*-------------------------------------------------------------------------------
pstart   equ     $4000      *stores variable in specific meomry loacation
outa     equ     $ff4f      *stores variable in specific meomry loacation
num1     equ     $4800      *stores variable in specific meomry loacation
num2     equ     $4802      *stores variable in specific meomry loacation
opr      equ     $4906      *stores variable in specific meomry loacation   
answe    equ     $4804      *stores variable in specific meomry loacation
ans      equ     $4016      *stores variable in specific meomry loacation
remain   equ     $4810      *stores variable in specific meomry loacation
rans     equ     $4818      *stores variable in specific meomry loacation
lans     equ     $4820      *stores variable in specific meomry loacation
outlhlf  equ     $FF49      *stores variable in specific meomry loacation
outrhlf  equ     $FF4C      *stores variable in specific meomry loacation
return   equ     $ff5B      *stores variable in specific meomry loacation
*-------------------------------------------------------------------------------
#include "KEYPAD.ASM"

        org     pstart
init    jsr     initkey

*-------------------------------------------------------------------------------
main    jsr     numb1   *Hass the value of the first number imput on keyboard
        jsr     space   *ASCII used to represent a space within the output
        jsr     oprAdd  *get, display, and store operator
        jsr     space   *ASCII used to represent a space within the output
        bra     main    *loops back to the main
        end
*------------------------------------------------------------------------------
numb1   JSR     getkey  *gets user input for 1st number
        jsr     outa    *prints first number
        suba    #$30
        staa    num1    *storee the first number to varaible
        RTS             *returns to the main

*-------------------------------------------------------------------------------
numb2   JSR     getkey  *gets user input for 2nd number
        jsr     outa    *prints 2nd number
        suba    #$30
        staa    num2    *store second number to a veriable 
        RTS             *returns to subroutine prior to this one
        
*------------------------------------------------------------------------------
space   ldaa    #$20    *loads hex version of space
        jsr     outa    *prints space
        rts             *returns to previous sub routine
*------------------------------------------------------------------------------
equal                   
        ldaa    #$3D    *Loads hex version of equal sign
        jsr     outa    *prints equal sign
        rts             *return to previous subroutine
*------------------------------------------------------------------------------
negative ldaa    #$2D   *loads '-' symbol
         jsr     outa   *prints
         rts            *return to previous subroutine
*-------------------------------------------------------------------------------
conv    LDX     #10     *loads 10 into X
        clra            *clears accumalator A
        ldab    answe   *loads answer into B
        idiv            *divides
        stab     lans   *Stores the left answer into variable into b
        xgdx
        stab    rans    *Stores right answer into variable into b
        rts             *returns to previous subroutine
*------------------------------------------------------------------------------

oprAdd  jsr     getkey  *gets key from the keypat

        cmpa    #$41    *checks to see if it is A= +
        beq     add     *if so go to the "add" subroutine

        cmpa    #$42    *checks to see if it is B = -
        beq     sub     *If so go to the "sub" subroutine

        cmpa    #$43    *checks to see if is C = *
        lbeq     mult   *If so go to the "mul" subroutine

        cmpa    #$44    *checks to see if it is D = /
        lbeq     div    *If so go to tge "div" subroutine
        rts
*------------------------------------------------------------------------
add
        ldaa    #$2b    *loads up the '+' sighn
        jsr     outa    *prints the '+' sign
        jsr     space   *prints space

        jsr     numb2   *get and print second sumber
        adda    num1    *adds the first number to the second number
        staa    answe   *stores sum in variab;e
        jsr     space   *prints space
        jsr     equal   *prints equal
        jsr     space   *prints space

        ldaa    answe   *loads up the answer back in a
        daa             *decimal adjust A for BCD
        cmpa    #9      *Compare the sum to 9
        ble     pll     *if it is less than or equal to 9, go to the ble sub routine
        psha
        JSR     outlhlf
        pula
        JSR     outrhlf
        jmp     main    *return to main
pll                    
        adda    #$30
        jsr     outa    *prints answer
        jmp     main    *returns to the main    
        rts             *return to main
*-----------------------------------------------------------------------------
sub     ldaa    #$2D    *loads up the '-' sign
        jsr     outa    *prints '-' sign
        jsr     space   *space


        jsr     numb2   *gets 2nd nuber and prints it
        ldaa    num1    *loads up variable of the first number
        suba    num2    *loads up the variable of the second number
        staa    answe   *stores the answer to answe variable
        jsr     space   *space
        jsr     equal   *equal sign
        jsr     space   *space
        ldaa    answe   *loads anwer
        daa             *decimal adjusts number
        ldaa    num1    *loads first number up
        cmpa    num2    *compares the 1sts number to the second
        ble     crr     *if the first number is less than the se
        jsr     conv    *convert
        jsr     outa   *prints A
        ldaa    lans    *loads answer
        adda    #$30    *convert answer 
        jsr     outa    *print answer
        jsr     space   *space
        jmp     main    *go to the main
crr
        jsr     negative    *prints negative sign
        ldaa    num2        *loads second number
        suba    num1        * loads 1st number
        staa    answe       *stares answer after subtracted
        daa                 *decimal adjusts
        jsr     conv        *convert
        jsr     outa        *print value
        ldaa    lans        *loads answer
        adda    #$30        *convert it
        jsr     outa        *print it
        jsr     space       *pace
        jmp     main        *returns to main

*------------------------------------------------------------------------------
mult    ldaa    #$2A    *loads up the multiplication symbol
        jsr     outa    *prints multiplication symbol
        jsr     space   *space
        
        jsr     numb2   *gets, loads , and print second bumber
        ldaa    num1    * loads first number int a
        ldab    num2    * loads 2nd into b
        mul             * multiply the 2 numbers
        stab     answe  * store answer
        ldaa    answe   *load answe


        jsr     outa    *print
        jsr     conv    *convert
        
        jsr     space   *space
        jsr     equal   *equal sign
        jsr     space   *space
        
        ldaa    rans    *load right side anser
        adda    #$30    *convert
        jsr     outa    *print
        ldaa    lans    *loads left side
        adda    #$30    *convert
        jsr     outa    *print
        jsr     space   *space

        jmp     main    *main
*-------------------------------------------------------------------------------
div      ldaa    #$2F   *loads division sign
         jsr     outa   *prints division sign
         jsr     space  *space
         jsr     numb2  *inmput second sumber
         clra
         ldab     num2   *load 2nd number to B
         xgdx
         clra
         ldab     num1   *loads 1st to B
         
         idiv           *divides
         stx     answe-1  *store answer to memory location right bt answe
         stab    remain *stores remainder
         jsr     conv   *covert
         
        jsr      space  *space
        jsr      equal  *equal sign
        jsr      space  *space
        
        ldaa     rans   *loads right answer
        adda     #$30   *convert
        jsr      outa   *print
        ldaa     lans   *load left answer
        adda     #$30   *convert
        jsr      outa   *print
        jsr      space  *space
        jmp      main   *return to main
        
*-------------------------------------------------------------------------------