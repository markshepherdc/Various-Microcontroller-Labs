*Mark Shepherd
*Lab 10: Analog to Digital Converter

*This program is used as an explafication of an analog to digital converter. 
*The  board takes an analog signal from a device that sets the voltage 
*and outputs that voltage on the LCD screen on the board


*FILES INCLUDES
#include "DP256reg.asm"
#include "LCD_Driv.asm"
#include "Keypad.asm"

*VARIABLES USED
rem1           equ     $4010
rem2          equ       $4012
*------------------------------------------------------
    
        org $8000       *Starting location of Program
        jsr LCD_INIT    *Starts LCD Up
        
        *Starts the coverter up
        lds #$1500
        ldx #$1000
        jsr openA0
*--------------------------------------------------------
    
loopBck

        ldaa #$80
        jsr lcd_out
        ldaa #$80
        jsr lcd_cmd
    

    
        movb    #$80,ATD0CTL5
*----------------------------------------------------------------------       
        Loads members of locations and them together
        ldd     $0090
        addd    $0092
        addd    $0094
        addd    $0096

*Handles the First Number and the Decimal
        ldx     #205
        idiv 
        std     rem1 Store remainder variable
        ldab #$30
        abx             
        stx rem2
        ldaa rem2+1     *1st Number
        jsr lcd_out     *Prints it
        ldaa #$2E       *Decimal symbol
        jsr lcd_out     *prints it
        
        
*Handles the Decond Digit on Lcd screen
        ldd rem1
        ldy #10
        emul
        ldx #205
        idiv
        std rem1
        ldab #$30
        abx
        stx rem2    
        ldaa rem2+1       *loads second digit
        jsr lcd_out       *Prints Second digit
        
*Handles the Last Digit        
        ldd     rem1
        ldy     #10
        emul
        ldx     #205
        idiv
        std     rem2
        ldab #$30
        abx
        stx     rem2
        ldaa    rem2+1      *Loads second Digit
        jsr     lcd_out     *Prints it
        lbra     loopBck    *Continually loops to check signal
        
*Sets the registers up for the A/D Conversion
openA0  
        movb #$C0, ATD0CTL2
        pshx
        pshy
        jsr Delay
        pulx
        puly
        movb #$20,ATD0CTL3
        movb #$60, ATD0CTL4
        rts
*------------------------------------------------------------------------        
*0.05 Second Delay
DELAY  lDY #1            * Multiplies the clock value calue of the loop that makes 0.1 secs by 150 to make 15 secs
LOOP2   LDX #30000          *gets loop to delay the led by 0.1 secs
LOOP1   DEX                 *Decrements X down by one.  1 Clock cycle
        BNE LOOP1           *Checks to see if X reached 0
        DEY                 *Decremnts Y by 1
        BNE LOOP2           *Checks to see if Y reached 0 Three Clock cycles
        RTS                 *REturns from the subroutine to main program after the loop in complete
        END                 *Ends Subroutine
        
        