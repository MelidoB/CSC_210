.data
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10   # Sample array
size: .word 10                              # Size of the array
time1: .word 0                              # Time taken by index-based approach
time2: .word 0                              # Time taken by pointer-based approach
msg1: .asciiz "Time taken by index-based approach: "
msg2: .asciiz "Time taken by pointer-based approach: "

.text

# Time measurement macro
.macro time(%reg_addr)
    li $v0, 30
    syscall
    lw $t4, %reg_addr
    add $t4, $zero, $a0
    sw $t4, %reg_addr
.end_macro

# Macro to clear array using index-based approach
.macro clear_array_index(%array, %size)
    la $t5, %array                 # Load address of array
    lw $t6, %size                 # Load size of array
    move $t0, $zero               # i = 0
loop1: sll $t1, $t0, 2            # $t1 = i * 4
    add $t2, $t5, $t1             # $t2 = address of array[i]
    sw $zero, 0($t2)              # array[i] = 0
    addi $t0, $t0, 1              # i = i + 1
    slt $t3, $t0, $t6             # $t3 = (i < size)
    bne $t3, $zero, loop1         # if (i < size) go to loop1
.end_macro

# Macro to clear array using pointer-based approach
.macro clear_array_pointer(%array, %size)
    la $t5, %array                # Load address of array
    lw $t6, %size                 # Load size of array
    move $t0, $t5                # p = address of array[0]
    sll $t1, $t6, 2              # $t1 = size * 4
    add $t2, $t5, $t1            # $t2 = address of array[size]
loop2: sw $zero, 0($t0)          # Memory[p] = 0
    addi $t0, $t0, 4             # p = p + 4
    slt $t3, $t0, $t2            # $t3 = (p<&array[size])
    bne $t3, $zero, loop2        # if (p<&array[size]) go to loop2
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

main:
    # Clear array using index-based approach and measure time
    time(time1)
    clear_array_index(array, size)
    time(time1)
    
    # Print time taken by index-based approach
    print_result(msg1, time1)
    
    # Clear array using pointer-based approach and measure time
    time(time2)
    clear_array_pointer(array, size)
    time(time2)
    
    # Print time taken by pointer-based approach
    print_result(msg2, time2)
    
    # Exit
    li $v0, 10
    syscall
