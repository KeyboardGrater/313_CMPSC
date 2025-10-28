.data
# CONSTANTS
BIG_INT_MAX_SIZE = 40
RETURN_VALUES_MAX_SIZE = 41

# Data and variables
BigInt1: .word 0                            # data type
         .space BIG_INT_MAX_SIZE            # length of it

BigInt2: .word 0
         .space BIG_INT_MAX_SIZE                  

Summation: .word 0
           .space RETURN_VALUES_MAX_SIZE    # for overflow reasons

Result: .word 0
        .space RETURN_VALUES_MAX_SIZE

# Strings
inputPromptOne: .asciiz "Please enter the first number 1 - 40 digits:"
inputPromptTwo: .asciiz "Please enter the second number 1 - 40 digits: "
summationMessage: .asciiz "Sumation: "
resultMessage: .asciiz "Result: "
newLine: .asciiz "\n"

buffer: .space 41                           # buffer for input

.text
.globl main
main:
    # Get user input
    
    # Get the first number
    li $v0, 4                           
    la $a0, inputPromptOne
    syscall

    # Get first number (in the form of a string)
    li $v0, 8
    la $a0, buffer
    la $a1, BIG_INT_MAX_SIZE
    syscall

    # Call conversion function
    la $a1, buffer
    la $a2, BigInt1
    jal string_conversion_to_int

    # Get the second number
    li $v0, 4
    la $a0, inputPromptTwo
    syscall

    # Get second number (in the form of a string)
    li $v0, 8
    la $a0, buffer
    la $a1, BIG_INT_MAX_SIZE
    syscall

    # Call conversion function for a second time
    la $a1, buffer
    la $a2, BigInt2
    jal string_conversion_to_int

    # Addition of the two BigInt structs
    la $a1, BigInt1
    la $a2, BigInt2
    la $a3, Summation
    jal bigint_add

    # Print Additon
    li $v0, 4
    la $a0, summationMessage
    syscall

    la $a1, Summation
    jal print_BigInt    

    j endProgram


string_conversion_to_int:
    # t0 = i,
    # s0 = struct_addr

    addi $sp, $sp, -8
    sw $ra 0($sp)                                # save return address to stack
    sw $s0, 4($sp)

    move $t0, $a1                                # while it is the address of the string, since a string is an arr of char, it is also pointing at the first index of the char array. And since we are only going up by one, then add on in each iteration to register
    move $s0, $a2

    # Find the end of the buffer string
    find_buffer_end:
        # move $t3, $a1, $t0
        lb $t3, 0($t0)
        
        beq $t3, 0x0A, found_buffer_end      # exit loop if t3 == 'NULL' 
        beq $t3, 0x00, found_buffer_end      # exit loop if t3 == '\n'
        
        addi $t0, $t0, 1
        j find_buffer_end

    found_buffer_end:
        addi $t0, $t0, -1                   # move one over, i.e. back to the actual last digit 

        # Convert the digits into rever order
        addi $t1, $s0, 4
        li $t2, 0

    conversion_loop:
        blt $t0, $a1, conversion_finished
        lb $t3, 0($t0)

        # Convert to the ascii equivalent
        addi $t3, $t3, -48                  # from chart to digit
        sb $t3, 0($t1)
        addi $t1, $t1, 1
        addi $t2, $t2, 1

        addi $t0, $t0, -1
        j conversion_loop

    conversion_finished:
        sw $t2, 0($s0)                      # Store the length within the struct

        lw $s0, 4($sp)
        lw $ra, 0($sp)
        addi $sp, $sp, 8

    jr $ra

# Addition
bigint_add:
    # a1 = BigInt1_addr, a2 = BigInt2_addr, a3 = Summation_addr
    # t0, t1, t2, t3, t4, t5 = carry_flag , t6 =  , t7

    # Save the return address
    addi $sp, $sp, -4
    sw $ra 0($sp)   

    # Load the length of the structs
    lw $t3, 0($a1)                          # BigInt1_size
    lw $t4, 0($a2)                          # BigInt2_size

    # Create pointers
    addi $t1, $a1, 4                        # num1
    addi $t2, $a2, 4                        # num2
    addi $t0, $a3, 4                        # summation

    li $t5, 0                               # car
    li $t6, 0                               # i

    # Find the max length
    move $t7, $t3
    bge $t3, $t4, addition_loop
    move $t7, $t4

    addition_loop:
        li $t8, 0
        li $t9, 0

        # Get digit from BigInt1 
        bge $t6, $t3, skip_num_1         # when BigInt_2_size < BigInt_2_size
        add $s0, $t1, $t6
        lb $t8, 0($s0)

        skip_num_1:
        # Get a digit from BigInt2
        bge $t6, $t4, skip_num_2
        add $s0, $t2, $t6
        lb $t9, 0($s0)

        skip_num_2:
        
        # Add the digits and then carray
        add $s0, $t8, $t9                   # s0 = t8 + t9
        add $s0, $s0, $t5                   # s0 = s0 (t8 +t9) + t5
        
        # Calculate the new carry and digit
        li $t5, 0
        blt $s0, 10 , dont_carry            # if s0 < 10, then no carry needed
        
        # else (Carry)
        addi $s0, $s0, -10                  # otherwise, subtract 10
        li $t5, 1                           # load that carried one

        dont_carry:
        
        # Store the result digit
        add $s1, $t0, $t6
        sb $s0, 0($s1)

        addi $t6, $t6, 1
        blt $t6, $t7, addition_loop

        # Add the carry to the left spot
        beq $t5, 0, addition_loop_exit
        add $s1, $t0, $t6
        sb $t5, 0($s1)
        addi $t6, $t6, 1
    
    addition_loop_exit:
        # Store the length in struct
        sw $t6, 0($a3)

        lw $ra, 0($sp)
        addi $sp, $sp, 4

    jr $ra

print_BigInt:
    # a1 = BigInt_addr

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Load the length of the struct into a temporary register
    lw $t1, 0($a1)

    # pointers
    addi $t0, $a1, 4
    addi $t1, $t1, -1                       # start from the last index

    bigInt_print_loop:
        bltz $t1, bigInt_print_loop_exit
        add $t2, $t0, $t1
        lb $t3, 0($t2)
        # addi $t3, $t3, 48                 # convert to ascii, I dont think I need it. The simulator (Qt spim) might be causing this to not be nessicary.

        # Print the digit
        li $v0, 1
        move $a0, $t3
        syscall

        addi $t1, $t1, -1
        j bigInt_print_loop
    bigInt_print_loop_exit:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


endProgram:
# End program
li $v0, 10
syscall
