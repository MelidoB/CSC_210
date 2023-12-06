.data
a: .word 10 20 30 40 50 60 70 80 90 100        # Define an array with integer values
unsorted_message: .asciiz "The unsorted array: "  # Define a string for unsorted array message
sorted_message: .asciiz "The sorted array: "      # Define a string for sorted array message
exit_message: .asciiz "Exiting...\n"             # Define a string for exit message
comparing_message: .asciiz "\tComparing: "        # Define a string for comparing message
new_line: .asciiz "\n"                            # Define a string for a newline
space: .asciiz " "                                # Define a string for a space

.text
# print unsorted array
la $a0, unsorted_message  # Load the address of unsorted_message into $a0
li $v0, 4                # Set $v0 to 4 (print string)
syscall                  # Invoke the syscall to print the string
jal PRINT_ARRAY           # Call the PRINT_ARRAY subroutine

jal SORT_ARRAY            # Call the SORT_ARRAY subroutine

# print sorted array
la $a0, sorted_message    # Load the address of sorted_message into $a0
li $v0, 4                # Set $v0 to 4 (print string)
syscall                  # Invoke the syscall to print the string
jal PRINT_ARRAY           # Call the PRINT_ARRAY subroutine

jal EXIT                  # Call the EXIT subroutine

SORT_ARRAY:
    sw $ra, 0($sp)         # Save the return address on the stack

    li $t0, 0              # Initialize i
    li $t1, 0              # Initialize k
    li $t2, 4              # Initialize k+1
    li $t4, 56             # Initialize size
    li $t5, 0              # Initialize temp
    li $t6, 0              # Initialize a[k]
    li $t7, 0              # Initialize a[k+1]

SORT_ARRAY_OUTER_LOOP_BEGIN:
    # Check if we're still within bounds
    beq $t0, $t4, SORT_ARRAY_END

SORT_ARRAY_INNER_LOOP_BEGIN:
    beq $t1, $t4, SORT_ARRAY_OUTER_LOOP_END

    # Load a[k] and a[k+1]
    lw $t6, a($t1)         # Load a[k] into $t6
    lw $t7, a($t2)         # Load a[k+1] into $t7

    # If a[k] >= a[k+1], don't swap
    bge $t6, $t7, SORT_ARRAY_SWAP_END

SORT_ARRAY_SWAP_BEGIN:
    sw $t7, a($t1)         # Swap a[k] and a[k+1]
    sw $t6, a($t2)

SORT_ARRAY_SWAP_END:

SORT_ARRAY_INNER_LOOP_END:
    add $t1, $t1, 4        # Increment k
    add $t2, $t2, 4        # Increment k+1
    j SORT_ARRAY_INNER_LOOP_BEGIN  # Jump to the beginning of inner loop

SORT_ARRAY_OUTER_LOOP_END:
    add $t0, $t0, 4        # Increment i
    li $t1, 0              # Reset k
    li $t2, 4              # Reset k+1
    j SORT_ARRAY_OUTER_LOOP_BEGIN  # Jump to the beginning of outer loop

SORT_ARRAY_END:
    lw $ra, 0($sp)         # Restore the return address
    jr $ra                 # Return from the subroutine

PRINT_ARRAY:
    sw $ra, 0($sp)         # Save the return address on the stack
    li $t0, 60             # Initialize the byte size of the array
    li $t1, 0              # Initialize a counter

PRINT_ARRAY_LOOP_BEGIN:
    # Print an item from the array
    lw $a0, a($t1)         # Load the item into $a0
    li $v0, 1              # Set $v0 to 1 (print integer)
    syscall                # Invoke the syscall to print the integer

    # Print a space character
    la $a0, space           # Load the address of space into $a0
    li $v0, 4               # Set $v0 to 4 (print string)
    syscall                 # Invoke the syscall to print the string
    add $t1, $t1, 4         # Increment the counter

    # Loop back if not done
    beq $t0, $t1, PRINT_ARRAY_LOOP_END
    j PRINT_ARRAY_LOOP_BEGIN

PRINT_ARRAY_LOOP_END:
    la $a0, new_line        # Load the address of new_line into $a0
    li $v0, 4               # Set $v0 to 4 (print string)
    syscall                 # Invoke the syscall to print the string

    lw $ra, 0($sp)          # Restore the return address
    jr $ra                  # Return from the subroutine

EXIT:

    # Print a newline
    la $a0, new_line        # Load the address of new_line into $a0
    li $v0, 4               # Set $v0 to 4 (print string)
    syscall                 # Invoke the syscall to print the string

    # Print the exit message
    la $a0, exit_message    # Load the address of exit_message into $a0
    li $v0, 4               # Set $v0 to 4 (print string)
    syscall                 # Invoke the syscall to print the string

    # Exit the program
    li $v0, 10              # Set $v0 to 10 (exit)
    syscall                 # Invoke the syscall to exit