.data
# Variables


# Strings
inputPrompt: .asciiz "Please input a number: "
newLine: .asciiz "\n"
outputMessage: .asciiz "The number is "
trueMessage: .asciiz "Prime."
falseMessage: .asciiz "not Prime."

.text

.globl main

j main

# t0 = true/false (return statement), t1 = n, t2 = 1
isPrime:
li $v0, 0                                        # bool returnStatement = false;
move $t1, $a1
li $t2, 1                                        # int t2 = 1


# Check if number is less than or equal to one
# if (n <= 1) {break}; => !(n <= 1) => n > 1
ble $t1, $t2, returnFalse


addi $t2, $t2, 1
mul $t3, $t2, $t2

# t0 = false, t1 = n, t2 = i (2), t3 = i * i -or- remainder
loop:
bgt $t3, $t1, exitLoop
    div $t1, $t2
    mfhi $t3
    beqz $t3, returnFalse

    mul $t3, $t2, $t2
    addi $t2, $t2, 1
j loop
exitLoop:

addi $v0, $v0, 1
jr $ra

returnFalse:
    jr $ra


main:

# $t0 = input

# Get user input
li $v0, 4
la $a0, inputPrompt
syscall

li $v0, 5
syscall

move $a1, $v0
jal isPrime
move $t0, $v0

# print output, if number is a prime or not
li $v0, 4
la $a0, outputMessage
syscall

beqz $t0, primeFalse
# else
li $v0, 4
la $a0 trueMessage
syscall
j endOfOutput

primeFalse:
li $v0, 4
la $a0, falseMessage
syscall

endOfOutput:

# End program
li $v0, 10
syscall


#Test:
# -1 -> Not Prime
# 0 -> Not Prime
# 1 -> Not Prime
# 2 -> Prime
# 3 -> Prime
# 4 -> Not Prime
# 5 -> Prime
# 9 -> Not Prime
# 100 -> Not Prime
# -100 -> Not Prime


