*Mark Shepherd
*ENGR 385
*Lab 5: Programming
*2/8/2012






pstart  equ     $4000      *starting variable at memory location 4000
outa    equ     $ff4f      *print variable


        org     pstart     *starting loaction of program
        Fcc 'abcdefghijklmnop0123456789abcdefABCDEFabcdefghijk'
        
*-----------------------------------------------------------------------
        
        ORG $4100       *Location 4100
        
        ldx #$4000      *point x to 4000
        ldaa #49        *loads 49 into a as a counter
*-----------------------------------------------------------------------------------
main    inx             *increment x
	deca            *decrement a by  1
	beq     done
        ldab    0,x     *this is the pointer towards x
        cmpb    #$30    *If less than $30, ignore and continue looping
        blt     main

        cmpb    #$39      *If less than or equal to $39 go to conNum to convert to a number
        ble     conNum

        cmpb    #$41    *If less than 41 continue to loop
        blt     main

        cmpb    #$46   *IF less than or equal to 46, convert to a letter
        ble     conLet
        bra     main    *otherwise return to the loop
*--------------------------------------------------------------------------------------
conNum  subb   #$30     *subtract $30 to convert
        stab   0,x      *store value in the x position
        bra    main     *return to the loop

*-------------------------------------------------------------------------------------
conLet  subb   #$31     *subtract $31 to convert
        stab    0,x     *store value in x postion
        bra     main    *return to the main
*--------------------------------------------------------------------------------------
done     swi
        
        