.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10   # Sample array
size: .word 10                               # Size of the array
avg_time1: .word 0                           # Average time for index-based approach
avg_time2: .word 0                           # Average time for pointer-based approach
avg_msg1: .asciiz "Average time for index-based approach: "
avg_msg2: .asciiz "Average time for pointer-based approach: "

.text

# Time measurement macro
.macro time(%reg)
    li $v0, 30
    syscall
    sub %reg, $a0, %reg
.end_macro

# Macro to clear array using index-based approach
.macro clear_array_index
    move $t0, $zero                 # i = 0
loop1: 
    sll $t1, $t0, 2                 # $t1 = i * 4
    add $t2, $a0, $t1               # $t2 = address of array[i]
    sw $zero, 0($t2)                # array[i] = 0
    addi $t0, $t0, 1                # i = i + 1
    slt $t3, $t0, $a1               # $t3 = (i < size)
    bne $t3, $zero, loop1           # if (i < size) go to loop1
.end_macro

# Macro to clear array using pointer-based approach
.macro clear_array_pointer
    move $t0, $a0                   # p = address of array[0]
    sll $t1, $a1, 2                 # $t1 = size * 4
    add $t2, $a0, $t1               # $t2 = address of array[size]
loop2: 
    sw $zero, 0($t0)                # Memory[p] = 0
    addi $t0, $t0, 4                # p = p + 4
    slt $t3, $t0, $t2               # $t3 = (p<&array[size])
    bne $t3, $zero, loop2           # if (p<&array[size]) go to loop2
.end_macro

# Macro to print results
.macro print_result(%message, %value_addr)
    li $v0, 4
    la $a0, %message
    syscall
    li $v0, 1
    lw $a0, %value_addr
    syscall
.end_macro

# Macro to run and measure average time of each clearing method
.macro run_and_measure(%clear_macro, %array, %size, %result_addr, %message)
    li $t8, 10000                 # Number of iterations
    li $t9, 10000                 # Load constant 10,000 for division
    move $s0, $zero               # Initialize accumulator for total time
repeat_clear:
    time($s1)                    # Start time
    la $a0, %array                # Load address of array
    lw $a1, %size                 # Load size of array
    %clear_macro                 # Call the provided clear macro
    time($s1)                    # End time
    
    add $s0, $s0, $s1            # Accumulate time taken
    
    addi $t8, $t8, -1            # Decrement iteration count
    bnez $t8, repeat_clear       # If not done, repeat
    
    div $s0, $t9                 # Compute average time
    mflo $s1                     # Get result of division
    sw $s1, %result_addr         # Store average time
    
    print_result(%message, %result_addr)  # Print result
.end_macro

main:
    # Run and measure index-based approach 10,000 times
    run_and_measure(clear_array_index, array, size, avg_time1, avg_msg1)
    
    # Run and measure pointer-based approach 10,000 times
    run_and_measure(clear_array_pointer, array, size, avg_time2, avg_msg2)
    
    # Exit
    li $v0, 10
    syscall
