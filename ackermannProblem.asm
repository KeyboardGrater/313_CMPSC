.data
# Variables

# Strings
mPrompt: .asciiz "m-value: "
nPrompt: .asciiz "n-value: "
newLine: .asciiz "\n"

.text

.globl main

# t0 = m, t1 = n
main:
# Get user input

# Get m-value
li $v0, 4
la $a0, mPrompt
syscall

li $v0, 5
syscall
move $t0, $v0

# Get n-value
li $v0, 4
la $a0, nPrompt 
syscall

li $v0, 5
syscall
move $t1, $v0

move $a1, $t0
move $a2, $t1

jal Ackermann

move $a0, $v0
li $v0, 1
syscall

# End program
li $v0, 10
syscall


# s0 = m, s1 = n
Ackermann:
    # Save return address to stack
    subu $sp, $sp, 12
    sw $ra, 8($sp)                          # save the return address
    sw $a1, 4($sp)                          # save m
    sw $a2, 0($sp)                          # save n

    beqz $a1, mEqualsZero                   # if (m == 0) {return n + 1};

    beqz $a2, nEqualsZero                   # if (n == 0) {return Ackermann(m - 1, 1);}

    # else { return Ackermann(m - 1, Ackermann(m, n - 1)); }

    
    # Make sure to save the m and n
    lw $t0, 4($sp)                          # m
    lw $t1, 0($sp)                          # n
    
    # Inside function call
    # m stays the same, decrement n
    move $a2, $t1                           
    subu $a2, $a2, 1                        # n - 1
    jal Ackermann                           # return (m, above_line)

    # Outer Ackermann call [ Ackermann(m - 1, Inner)]
    move $a2, $v0                           # retreive and store return value of inner ackerman function.
    lw $a1, 4($sp)                          # get old m
    subu $a1, $a1, 1                        # m - 1
    jal Ackermann                           # return Ackermann(m - 1, Inner)

    j goThroughStack

mEqualsZero:
    addi $v0, $a2, 1
    j goThroughStack

nEqualsZero:
    li $a2, 1                               # n = 1;
    subu $a1, $a1, 1                        # m - 1
    jal Ackermann
    
goThroughStack:
    lw $ra 8($sp)
    addi $sp, $sp, 12
    jr $ra

# m = 2, n = 1 -> 5
# m = 3, n = 1 -> 13
# m = 0, n = 0 -> 1
# m = 1, n = 0 -> 1
