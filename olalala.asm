#include "DP256reg.asm"
#include "LCD_Driv.asm"
#include "Keypad.asm"

var     equ $4900
    
        ORG  $4000          * Starting Address in Location $4000
        movb #$FF, DDRT     * Move max bytes into DDRT locarion and configures it for                  output
        JSR Initkey
        JSR LCD_INIT
        
;--------------------------------------------------
press   JSR GETKEY

        cmpa #$31
        beq  RED
        cmpa #$35
        beq  Green
        cmpa #$41
        beq  Statement
        clra
        bra  press
;-----------------------------------------------------

RED     clra
	JSR  LCD_INIT
	movb #%00000001,PTT * A binary representation for the Green and Red
        JSR  press
           
Blue    clra
	JSR  LCD_INIT
	movb #%01000000,PTT
        JSR  Press

Statement
        clra

        ;movb  #%00000000,PTT
                		  ; Output the title 'Hello' to the LCD display
        LDAA  #$80                ; DDRAM address Line 1-LEFT
        JSR   LCD_CMD
        LDX   #TITLE              ; Output title on line 1
        JSR   OUTSTRG
        JSR   press

MLOOP
        LDAA  #$94                ; DDRAM address Line 3-LEFT
        JSR   LCD_CMD

*---------------------------------------------        
OUTSTRG
        LDAA  0,X
        CMPA  #$04                ; Done yet?
        BEQ   RTN
        JSR   LCD_OUT
        INX
        BRA   OUTSTRG

RTN     RTS

TITLE   FCC   'Nice' *Loads the ____ string
	FCB   $04

        end
        