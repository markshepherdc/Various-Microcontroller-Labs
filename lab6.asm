*Mark Shepherd
*Engr 385
*Lab 6
*Interrupts
*Febuary 24, 2012





outa    equ $ff4f           *varable stored in that location to print
out2bsp equ $ff58           
out1bsp equ $ff55
outlhlf equ $ff49
outrhlf equ $ff4c
xad     equ $4004
gate    equ $4000
IX      equ $4002
outstrg equ $ff5e
line   equ $4006

        org $4010         

str     fcc  "Line Number " *Command to create the sting label linee number
        db      04
        
        org $4100           *Start memory location $4100        
*-----------------------------------------------------------------------------------------------------------------------------------        
        lds #$4050          *Creates stack at locatio $4050
        ldaa #0             *Looads the number 0 is A
        staa line           *Stores 0 into the line variable
        ldx  #irqint        *Set up int Vector
        stx  $3ff2          *Set up int Vector
        movb #$40,$001E     *Interupt control
        cli                 *Clears interrupt
        ldy #$FC00          *Loads #$FC00 to Y
        sty IX              *Stores Location to IX

        clr  gate           *Glears gate
again   ldaa gate           *Checks gate

        beq  again          



        


        
*Need to clear I-plug in CC ro allow any int to happen

*-----------------------------------------------------------------------------------------------------------------------------------
        
        clr gate           *Clears gate
        jsr lheadin        *GOes to Lines Headin Subroutine
 	psha             *pushes value of A out of stack
	ldaa    #$3A    *loads hex version of colon
        jsr     outa    *prints colon
        ldaa    #$20    *loads space
        jsr     outa    *prints space
        pula            *pulls value of A out of stack
        ldaa #16           *Loads a cpunter of 16 into A

lp1     psha               *Beginning of loop and pushes 16 in stack
        JSr ChkupBy        *Subroutine up and lower bytes.
        pula               *Pullls counter of 16 out of stack
        iny                * Increments the memory locations.
        deca	           *Decrements A
        bne lp1            *Loop again if 16 locations werent checked*C
	pshx               * pushes value of y into stack
	pshy               * pushes value of x into stack
        JSr Delay          *Calls Delay Subroutine for 2seconds
	puly               *  pulls value of y into stack
	pulx          	   *  pulls value of x into stack
        cpy #$FD00         *Compares memory location to $FD00
        beq sto            *If it is, then the program quits
        bra again          *If not it loops back to the beginiing
sto	swi         *Software interrupt
*-----------------------------------------------------------------------------------------------------------------------------------

IRQint  inc gate            *interupts subroutine
        RTI
        
*---------------------------------------------------------------------------------------------------------------------------------
LHeadin
        ldx #str            *Loads the Line number string into X
        jsr outstrg         *Sunroutine to print X
        ldaa line           *Prints the line number
        cmpa #10
        bge convers          *converts from hex if A >= 10
        
        
        
        psha                *Pushes value of A into stack
        jsr outlhlf         *Prints left side of Line Number
        pula                *Pulls A out of stack
        jsr outrhlf         *Prints right side of Line Number
        inc line            *Increment Line number by one for the next time it is called
        rts
convers
        adda  #$6           *converts to decimal
	 psha               *Pushes value of A into stack
        jsr outlhlf         *Prints left side of Line Number
        pula                *Pulls A out of stack
        jsr outrhlf         *Prints right side of Line Number
        inc line            *Increment Line number by one for the next time it is called
        rts

*-----------------------------------------------------------------------------------------------------------------------------------

ChkupBy ldab 0,y            *Points toward memory address in Y
        andb #$0F
        cmpb #$5            *Compares bit to 5
        beq pAdBy           *Calls subroutine to print the bytes and Memory Location with 5
        ldab 0,y            *Points toward memory address in Y
        andb #$F0
        cmpb #$50           *Compares bit to 5
        beq pAdBy           *Calls subroutine to print the bytes and Memory Location with 5
        RTs                 *Return to program




*-----------------------------------------------------------------------------------------------------------------------------------
pAdBy  
        sty xad             *Stores Memory Address to xad
        ldx #xad            *Loads it into X
        jsr out2bsp         *Subroutine to print the memory location
        RTs                 *Rwturns to the previous program

*-------------------------------------------------------------------------------------------------------------------------------------
Delay	lDY #20            * Multiplies the clock value calue of the loop that makes 0.1 secs by 150 to make 15 secs
LOOP2   LDX #60000          *gets loop to delay the led by 0.1 secs
LOOP1   DEX                 *Decrements X down by one.  1 Clock cycle
        BNE LOOP1           *Checks to see if X reached 0
        DEY                 *Decremnts Y by 1
        BNE LOOP2           *Checks to see if Y reached 0 Three Clock cycles
        RTS                 *REturns from the subroutine to main program after the loop in complete
        END                 *Ends Subroutine

*------------------------------------------------------------------------------------------------------------------------------------        

    END