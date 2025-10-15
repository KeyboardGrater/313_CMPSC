.data
# variables

aMatrix: .word 1, 2, 3                      # int aMatrix [row1][column1] = {{1, 2, 3},{4, 5, 6}};
         .word 4, 5, 6

bMatrix: .word 7, 8                         #int bMatrix [row2][column2] = {{7,8},{9,10},{11,12}};
         .word 9, 10
         .word 11, 12

row1: .word 2                               # # define row1 2
column1: .word 3                            # # define column1 3
row2: .word 3                               # # define row2 3
column2: .word 2                            # # define column2 2

prod

# strings
notPossibleMessage: .asciiz "The number of rows in matrix 1 is not equal to the number of columns in matrix 2, thus matrix multiplication cannot be performed"
newLine: .asciiz "\n"

.text

.globl main

main:

# Check if row1 and column2 are the same size.


la $a0, row1            
lw $t0, 0($a0)

la $a0, column2
lw $t1, 0($a0)

bne $t0, $t1, Row1NotEqualColumn2
# else

# load the first array
la $a0, aMatrix                             # load matrix 1 into function
la $a1, bMatrix                             # load matrix 2 into function

# Since row1 == column2 (otherwise it would have branched earlier), only has to use one address register for row1 and column2
lw $a2, column1                             # load 
lw $a3, row2

# Save row1, to stack
lw $t0, row1                                # load the value for row 1 into temp variable
subu $sp, $sp, 8                            # get stack ready (size: return address + row1)
sw $ra, 4($sp)                              # save return address to stack
sw $t0, 0($sp)                              # save t0 (row 1 size) to top of stack

# CLEARING t0, and t1 for easy test and analysis
move $t0, $zero
move $t1, $zero

# call function
jal matrixMultiplication 



j endProgram


Row1NotEqualColumn2:
li $v0, 4
la $a0, notPossibleMessage
syscall

j endProgram

# --- No longer in main ---

# a0 = matrix1 address, a1 = matrix2 address, a2 = column1, a3 = row2, t0 = row1, t1 = column2
matrixMultiplication:
    # load the arguments (really just load stack (row1), then duplicate for column2)
    lw $t0, 0($sp)

    # create a local column2 variable
    move $t1, $t0









# Include some way of return


# End program
endProgram:

li $v0, 10
syscall