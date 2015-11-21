*Mark Shpherd
*Engr 385
*Lab #9: Pulse Width Modulation

*The program is a demonstration of pulsewidth modulation using a motor

*---------------------------------------------------------------------------------
*List of variables

DutyCycle     equ     $4800      *stores variable in specific meomry loacation
initial       equ     $4802
product       equ     $4804
number7       equ     $4806
period        equ     $4008
key           equ     $4010
key2          equ     $4012
*---------------------------------------------------------------------------------
#include "DP256reg.asm"
#include "LCD_Driv.asm"
#include "Keypad.asm"
*---------------------------------------------------------------------------------
    org $4000                   *START program at $400  
	JSR        INITKEY          *Start Keypad up
    JSR        LCD_INIT         *Start LCD UP
*---------------------------------------------

*Enable concatenation
        movb #$10, PWMCTL       *00010000 to channel 0,1
        movb        #$02,PWMPOL *Set the polarity      
         movb       #$04,PWMPRCLK   *Sets the clock cycle to A
         movb        #$0,PWMCAE     *Left Allighned
         movb #$00, PWmCLK          *Sets the clock cycle to A
        movw #10000,PWMPER0         *Sets period to 10,000
        JSR  LCD_CMD
*------------------------------------------------------------        
        ldaa #$37                   *Hex value for 7
        suba #$30                   *Subtract to get deimal 7
        staa number7                *Stores decimal 7 to variable
        ldaa #$2E                   *Loads hex of period "."
        staa period                 *Stores period to variable
*------------------------------------------------------------------------------        
loopp                               *Beginging of the loop to input various duty cycles
	JSR   getkey                    *Gets input from the keypad
         staa key                   *Stores number pushed to variable before it gets destroyed with LCD_INIT
         JSR  LCD_INIT              *Clears LCD for next duty cyc;e 
         ldaa number7               *loads the number 7 and outputs it
         jsr LCD_OUT                *Print number 7
         ldaa period                *loads period "."
        jsr LCD_OUT                 *prints period "."
        ldaa key                    *loads value of the key back
        jsr LCD_OUT                 *print value to the screen
        ldaa key                    *loads key back since LCD_OUT destroys it
        suba #$30                   *subtract hex 30 for more accurate calculation
        staa key                    *stores value to key
        ldab #10                    *load value of 10 to B
        mul                         *multiple key X 10
        std  product                *stores the product to variable
        jsr getkey                  *get iput from the keypad for the second number                 
        staa key2                   *stores second number to variable
        jsr LCD_OUT                 *prints value of key 2 to screen
        ldaa key2                   *loads the second number because it is destroyed
        suba #$30                   *subtract hex #$30 for a more accurate calculation  
        staa key2                   *stores value to the second key
        ldd product                 *loads the product
        addb key2                   *add key 2 to the product
        addd #700                   *add 700 to the calculation
*The duticycle is calculated throught this by ((key1 x 10) + key2)+700 = dutycycle
*adda  product
        std DutyCycle               *stores value of the dutycycle

        movw DutyCycle,PWMdty0      sets dutycycle value in the right register
        movb #2, PWME               *Enable pwme registers
*-----------------------------------------------------------------------------        
*756 = 7.56     700 = 7.0 = neutral
        bra loopp
