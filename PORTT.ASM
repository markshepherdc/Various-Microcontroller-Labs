* Mark Shepherd
* ENGR 385
* Title: Digital I/O to a Port





DDRT    equ $242            * Use location for 242 for DDRT
PTT     equ $240            * Use location 240 for PTT
OUTA    equ $FF4F           * Use locatio FF4F for OUTA
OUTCRLF equ $FF5B           * Use location FF5B for OUTCLR
        ORG  $4000          * Starting Address in Location $4000
        movb #$FF, DDRT     * Move max bytes into DDRT locarion
        
        
begin   movb #%01000001,PTT * A binary representation for the Green and Red Leds.
        LDAA $4E            * Loads the hexideximal represntation of 'N'
        JSR  OUTA           * Calls the OUTA subroutine to print the letter on the CRT
        LDAA $53            * Loads the hexidecimal representation of 'S' 
        JSR  OUTA           * Calls the OUTA subroutine to print the letter on the CRT            
        JSR  OUTCRLF        * Clears the screen
        JSR  DELAY2         * Calls the delay subroutine to make the Green and red Leds light for 1 minute
        
        movb #%01000010,PTT * A binary representation for the Red and Yellow Leds.
        JSR  DELAY1         * Calls the Delay1 subroutine that makrd the LED light for only 15 secs

        movb #%00001100,PTT * Binary repreentation for the Green and Red LEDs
        LDAA $45            * This Loads the hexidecimal representation of the letter 'E' so that it can be displayed on the CRT
        JSR  OUTA           * Calls the OUTA subroutine to print the letter on the CRT   
        LDAA $57            * This Loads the hexidecimal representation of the letter 'W' so that it can be displayed on the CRT
        JSR  OUTA           * Calls the OUTA subroutine to print the letter on the CRT 
        JSR  OUTCRLF        * Clears the screen
        JSR  DELAY2         * Calls the delay subroutine to make the Green and red Leds light for 1 minute

        movb #%00010100,PTT * This Loads the Yellow ond Red Leds through a binary repredentation.
        JSR DELAY1          * Calls the Delay1 subroutine that makrd the LED light for only 15 secs.
        
        jmp     begin       * Loops the previous sequence of statements back

DELAY1  lDY #150            * Multiplies the clock value calue of the loop that makes 0.1 secs by 150 to make 15 secs
LOOP2   LDX #60000          *gets loop to delay the led by 0.1 secs
LOOP1   DEX                 *Decrements X down by one.  1 Clock cycle
        BNE LOOP1           *Checks to see if X reached 0
        DEY                 *Decremnts Y by 1
        BNE LOOP2           *Checks to see if Y reached 0 Three Clock cycles
        RTS                 *REturns from the subroutine to main program after the loop in complete
        END                 *Ends Subroutine
        
DELAY2  lDY #600            * Multiplies the clock value calue of the loop that makes 0.1 secs by 600 to make 60 secs = 1 minute
LOOP4   LDX #60000          *gets loop to delay the led by 0.1 secs
LOOP3   DEX                 *Decrements X down by one.  1 Clock cycle
        BNE LOOP3           *Checks to see if Y is at 0
        DEY                 *Decrements Y down by one.
        BNE LOOP4           *Checks to see if X is at 0Three Clock cycles
        RTS                 *REturns from the subroutine to main program after the loop in complete
        END                 *Ends Subroutine