.data
    prompt: .asciz "Enter a number between 0 and 255: "
    high_prompt: .asciz "Your guess is too high.\n"
    low_prompt: .asciz "Your guess is too low.\n"
    correct_prompt: .asciz "Your guess is correct!\n"
    tries_prompt_p1: .asciz "It took you "
    tries_prompt_p2: .asciz " tries to guess the number.\n"

.text
    ; generate a random number
        ; get current time tick
        swi 0x6d
        ; store that number in r2
        mov r2, r0
        ; strip off everything but the least important 8 bits
        and r2, r2, #0xff

    ; set the number of tries to 0 (store in r3)
    mov r3, #0

    ; loop until the user guesses the number correctly
    loop:
        ; output the prompt
        mov r0, #1
        ldr r1, =prompt
        swi 0x69

        ; read the user's guess
        mov r0, #0
        swi 0x6c

        ; increment number of tries by 1
        add r3, r3, #1

        ; compare the guess to the random number stored in r2
        cmp r0, r2
        ; if r0 is greater than r2, go to high.
        bgt high
        ; if r0 is less than r2, go to low.
        blt low
        ; otherwise, the guess is correct. go to correct.
        b correct

        ; if the guess is too high
        high:
            ; output the high prompt
            mov r0, #1
            ldr r1, =high_prompt
            swi 0x69
            ; go to beginning of loop
            b loop

        ; if the guess is too low
        low:
            ; output the low prompt
            mov r0, #1
            ldr r1, =low_prompt
            swi 0x69
            ; go to beginning of loop
            b loop

        ; if the guess is correct
        correct:
            ; output the correct prompt
            mov r0, #1
            ldr r1, =correct_prompt
            swi 0x69

            ; output tries prompt (part 1)
            mov r0, #1
            ldr r1, =tries_prompt_p1
            swi 0x69

            ; number of tries (stored in r3)
            mov r0, #1
            mov r1, r3
            swi 0x6b

            ; and tries prompt (part 2)
            mov r0, #1
            ldr r1, =tries_prompt_p2
            swi 0x69

    ; exit the program
    swi 0x11