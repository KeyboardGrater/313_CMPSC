.data

# Input Buffer
inputBuffer: .space 41

# BigInteger structure
.align 2
BigInt1: .space 41                          # 40 9's = fits into 2^133 in binary, convert to bytes. 2^17, (rounded up from 16.625), enough room in remainder (.625 < 1 - 1/8), so signed included already
BigInt2: .space 41

# CONSTANTS
BIGINT_SIZE = 41

# Strings
inputPromptOne: .asciiz "Please give a number that has between and including 1-40 digits: "
inputPromptTwo: .asciiz "Please give a second number that has between and including 1-40 digits: "
newLine: .asciiz "\n"

.text
.globl main
main:

    # Get user input
    li $v0, 4
    la $a0, inputPromptOne
    syscall

    li $v0, 4
    la $a0, newLine
    syscall

    # Input buffer
    li $v0, 8
    la $a0, inputBuffer
    la $a1, BIGINT_SIZE
    syscall

    # Load input buffer into BigInt1
    la $a1, inputBuffer
    la $a2, BigInt1
    jal copyInput

    # Get BigInt2
    li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 4
    la $a0, inputPromptTwo
    syscall

    li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 8
    la $a0, inputBuffer
    la $a1, BIGINT_SIZE
    syscall

    li $v0, 4
    la $a0, newLine
    syscall

    # Load input buff into BigInt2
    la $a1, inputBuffer
    la $a2, BigInt2
    jal copyInput

    # ----- FOR TESTING ----- #
    j printTesting
    backToMainFromTesting:

    # ----- FOR TESTING ----- #

    j endProgram

copyInput:
    # t0 = buffer adress, t1 = bigInt (1 or 2) address, t2 = i, t3 = current_address, t4 = loaded character
    # t5 = null character (0x00)
    move $t0, $a1                           # move buffer address to a temporary register
    move $t1, $a2                           # move BigInt (1 or 2)'s address to temporary register
    li $t2, 0                               # i = 0
    
    copyLoop:
        # Get charcter at i of buffer
        add $t3, $t0, $t2                   # source_char = buffer_address + offset. No multiplication because char is 1 byte
        lb $t4, 0($t3)                      # load source_char

        # Get to i of bigInt (1 or 2)
        add $t3, $t1, $t2                   # save_location = bigInt_address + offset
        sb  $t4, 0($t3)                     # save source_char to location in BigInt

        # Check to end string (null-terminator), or if using up all the 40 numbers, a newline, since it ends up getting tacked in on the end

        # Null-terminator checker
        li $t5, 0x00                        # Null charcter in ascii
        beq $t5, $t4, copyLoopExit

        # New line checker
        li $t5, 0x0A                        # newline (Line feed) charcter in ascii
        beq $t5, $t4, copyLoopExit

        # Else 
        addi $t2, $t2, 1

        j copyLoop

    copyLoopExit:

    jr $ra



# ----- TEST PRINTING ----- #
printTesting:
    # a1 = BigInt1_address, a2 = BigInt2_address, t0 = (0 = BigInt1, 1 = BigInt2, 2 = Done), t1 = i, t2 = holder
    # t3 = stopper, t4
    li $v0, 11
    la $a0, '\n'
    syscall

    la $a1, BigInt1
    
    li $t0, 0
    li $t1, 0
    li $t4, 2

    printTestingLoop:
        add $t2, $a1, $t1
        lb $t2, 0($t2)

        li $t3, 0x00
        beq $t2, $t3, printTestingLoopExit
        li $t3, 0x0A
        beq $t2, $t3, printTestingLoopExit

        li $v0, 11
        move $a0, $t2
        syscall
        
        addi $t1, $t1, 1
        j printTestingLoop
    printTestingLoopExit:

    addi $t0, $t0, 1
    beq $t0, $t4, printTestingJump
    la $a1, BigInt2
    li $t1, 0

    li $v0, 11
    la $a0, '\n'
    syscall

    j printTestingLoop
    

    printTestingJump:
    j backToMainFromTesting

# ----- TEST PRINTING ----- #


endProgram:
# End program
li $v0, 10
syscall