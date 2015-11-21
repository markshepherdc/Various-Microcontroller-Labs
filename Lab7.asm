*Mark Shepherd
*ENGR 385
*March 2 2011
*Lab 7: Real Time Interrupts
*----------------------------------------------------------------------------
* THe Program is a demonstration of the song, "Twinkle Twinkle, LLittle Star",
*Usint Real Time Interruptes.
*The output is through a speaker that is hooked up to PT0 with a 330 ohm resistor
*The program loads the hex value of notes to $4000
*Then Increments through the notes with a pause at the end of each note
*At the end of the sequence, the program loops through the notes again
*------------------------------------------------------------
*TABLE of NOTES
* A = #$38 ,$#28
* C= #$2E, $#1E
* D = #2C, #$1C
* E = #$2B, #$1B
* F = #$2A, #$1A
* G = #$29, $#19
*--------------------------------------------------------
#include DP256reg.asm *Gives ability to acess the subroutines in that specific filde

        org $4000 *Define bytes loaded into locarion $4000 

*     First Line   C C, G G, A A , G,    
        db $1E,$1E,$19,$19,$28,$28,$29,0
*   Second Line F F, E E, D D, C,
	db $1A,$1A,$1B,$1B,$1C,$1C,$1E,0
* Third Line G G, F F, E E, D  
	db $19,$19,$1A,$1A,$1B,$1B,$2C,0
*Forth Line  G G , F F, E E, D
	db $19,$19,$1A,$1A,$1B,$1B,$2C,0,$80
        
        org $4100 *Program location at $4000
;        lds  #$4200        *Loaads stack to 4200
        movw #RTIre, $3ff0
        movb #$80, CRGINT  *Enables interupt in PLL Register
        movb #$01, DDRT    *Configure Port 0 for Outpute
        movb #$80, CRGFLG *Keeps track of flags on interupt 
        cli                *Clears Interrupt

        
note    ldx #$4000  *Loads x at loacations $4000
loop    ldaa 0,x    *Loats current location of pointer
        staa RTICTL *Sores note in pointer location to Interrupt control register
	bmi note        *Loops if hex value of note is less than #$80
        inx         *increments to next memory  location in x
        pshx        *pushes memory loacation into stack
        jsr DELAY  *Calls subroutine to hold notee
        pulx       *pulls memory location out of stack
        pshx        *pushes memory loacation into stack
	Jsr  Delay2     +Delay routine for a slight pause
        pulx        *pulls memory location out of stack
        bra loop    *Loops for another note
        swi 
        
*----------------------------------------------------------------------------        
DELAY  lDY # 2             * Multiplies the clock value calue of the loop that makes 0.1 secs by 150 to make 15 secs

LOOP2   LDX #30000          *gets loop to delay the led by 0.05 secs
LOOP1   DEX                 *Decrements X down by one.  1 Clock cycle
        BNE LOOP1           *Checks to see if X reached 0
        DEY                 *Decremnts Y by 1
        BNE LOOP2           *Checks to see if Y reached 0 Three Clock cycles
        RTS                 *REturns from the subroutine to main program after the loop in complete
        
DELAY2  lDY #2              * Multiplies the clock value calue of the loop that makes 0.1 secs by 150 to make 15 secs
        MOVB #$0, RTICTL    * Puts halt on song
LOOP3   LDX #60000          *gets loop to delay the led by 0.1 secs
LOOP4   DEX                 *Decrements X down by one.  1 Clock cycle
        BNE LOOP4           *Checks to see if X reached 0
        DEY                 *Decremnts Y by 1
        BNE LOOP3           *Checks to see if Y reached 0 Three Clock cycles
        RTS                 *REturns from the subroutine to main program after the loop in complete
*-----------------------------------------------------------------------------        
RTIre   COM PTT             *Flip all of the bits in port T
        movb #$80, CRGFLG   *moves value of $80 inorder to reset the flag
        RTI                 *returns from interrupt
*-------------------------------------------------------------------------------
done    swi