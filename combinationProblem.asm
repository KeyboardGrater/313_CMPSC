.data
# variables

# strings
nInputMessage: .asciiz "n = "
rInputMessage: .asciiz "r = "
outputMessage: .asciiz "The number of combinations is "
newLine: .asciiz "\n"


.text

.globl main

main:
# Get user input

# Get n
li $v0, 4
la $a0, nInputMessage
syscall

li $v0, 5
syscall
move $a1, $v0

# Get r
li $v0, 4
la $a0, rInputMessage
syscall

li $v0, 5
syscall
move $a2, $v0

jal combination

# collect return value
move $a1, $v0

li $v0, 4
la $a0, outputMessage
syscall

li $v0, 1
move $a0, $a1
syscall

j endProgram


# a1 = n, a2 = r
combination:
    # Save return register to stack
    subu $sp, $sp, 16
    sw $ra, 12($sp)                          # save return address
    sw $a1, 8($sp)                          # save n
    sw $a2, 4($sp)                          # save r

    # if (n < r) {return 0;}    
    blt $a1, $a2, RGreaterThanN

    # if (r == 0) {return 1};
    beqz $a2, REqaulZero_Or_REqualN

    # else if (r == n) {return 1};
    beq $a1, $a2, REqaulZero_Or_REqualN

    # else {return combination(n - 1, r - 1) + combination(n - 1, r);}

    # first function call, combination(n - 1, r - 1)
    subu $a1, $a1, 1                        # n - 1
    subu $a2, $a2, 1                        # r - 1
    jal combination                         # return combination(above_n_minus_1, above_r_minus_1)
    
    sw $v0, 0($sp)                          # save the first half's return value    

    # second half of function call, combination(n - 1, r)
    lw $a1, 8($sp)                          # load old n
    lw $a2, 4($sp)                          # load old r
    subu $a1, $a1, 1                        # n - 1
    jal combination                         # return combination(above_n_minus_1, old_n)

    lw $t0, 0($sp)                          # load the first half's value

    add $v0, $t0, $v0                       # returnValue = t0 (first return value) + returnValue(second return value)

    j popStack

RGreaterThanN:
    li $v0, 0                               # load 0 into return statment 
    j popStack                              # return said return statement

REqaulZero_Or_REqualN:
    li $v0, 1                               # load 1 into return statment
    j popStack                              # return said return statment

popStack:
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# End program
endProgram: 

li $v0, 10
syscall

# Test
# n = 5, r = 2 -> 10
# n = 4, r = 2 -> 6
# n = 3, r = 1 -> 3
# n = 2, r = 1 -> 2
# n = 1, r = 1 -> 1
# n = 12, r = 6 -> 924
# n = 0, r = 0 -> 1
# n = 0, r = 1 -> 0
# n = -1, r = 4 -> 0
# n = 10, r = -2 -> Error
# n = 10, r = 0 -> 1