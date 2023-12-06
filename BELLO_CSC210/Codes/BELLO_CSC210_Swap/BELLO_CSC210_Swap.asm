.data
A: .space 44
newline: .asciiz "\n"
space: .asciiz " "

.text
.globl main

main:
    li $t9, 0  # Initialize counter variable to control the flow

    # Initialize and fill array A with Fibonacci numbers
    li $s0, 0
    li $s1, 1
    li $s2, 0

FibLoop:
    sw $s0, A($s2)
    add $t0, $s0, $s1
    move $s0, $s1
    move $s1, $t0
    addi $s2, $s2, 4
    bne $s2, 40, FibLoop

    # Print array A after filling with Fibonacci numbers
    j PrintArray

PrintArray:
    li $s2, 0
    li $s3, 44

PrintLoop:
    bge $s2, $s3, PrintExit
    lw $t1, A($s2)
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $s2, $s2, 4
    j PrintLoop

PrintExit:
    li $v0, 4
    la $a0, newline
    syscall
    addi $t9, $t9, 1  # Increment counter variable

    # Based on counter variable, jump to appropriate label
    beq $t9, 1, InsertWord
    beq $t9, 2, ShiftUp
    beq $t9, 3, SwapElements
    bge $t9, 4, Exit  # Add this line to exit the loop when $t9 >= 4


InsertWord:
    li $s4, 44
    li $t2, 100
    li $t3, 3
    sll $t3, $t3, 2
    add $t3, $t3, 4

InsertLoop:
    bge $s4, $t3, InsertExit
    sub $t4, $s4, 4
    lw $t5, A($t4)
    sw $t5, A($s4)
    sub $s4, $s4, 4
    j InsertLoop

InsertExit:
    sw $t2, A($t3)
    j PrintArray

ShiftUp:
    li $t6, 0
    li $s5, 40
    lw $t6, A+40

ShiftUpLoop:
    beq $s5, 0, ShiftUpExit
    sub $t7, $s5, 4
    lw $t8, A($t7)
    sw $t8, A($s5)
    sub $s5, $s5, 4
    j ShiftUpLoop

ShiftUpExit:
    sw $t6, A
    j PrintArray

# Code to swap elements at index 4 and 5
SwapElements:
    li $t9, 16  # 4 * 4 = 16
    li $s6, 20  # 5 * 4 = 20

    lw $t4, A($t9)  # Load value at index 4 into $t4
    lw $t5, A($s6)  # Load value at index 5 into $t5
    sw $t4, A($s6)  # Store value at index 4 into index 5
    sw $t5, A($t9)  # Store value at index 5 into index 4

    addi $t9, $t9, 1  # Increment counter variable
    j PrintArray  # Print array A after swapping

Exit:
    li $v0, 10
    syscall
