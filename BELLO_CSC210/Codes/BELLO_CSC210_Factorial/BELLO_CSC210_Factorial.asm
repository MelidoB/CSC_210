.data
    n: .word 5         # Initialize 'n' with 5.
    N_fact: .word 0    # Initialize 'N_fact' with 0.

.text
main:
    lw $a0, n           # Load 'n' into $a0.
    jal factorial       # Call 'factorial'.
    sw $v0, N_fact      # Store the result in 'N_fact'.

    li $v0, 10          # Load syscall code for program exit.
    syscall             # Exit the program.

factorial:
    addi $sp, $sp, -8    # Allocate space on the stack.
    sw $s0, 4($sp)       # Save $s0.
    sw $ra, 0($sp)       # Save return address.

    li $v0, 1            # Set $v0 to 1.
    beq $a0, 0, endcall  # If $a0 is 0, go to 'endcall'.

    move $s0, $a0        # Save $a0 to $s0.
    sub $a0, $a0, 1      # Decrement $a0.
    jal factorial        # Recursive call.

    mul $v0, $s0, $v0    # Multiply result by saved $s0.

endcall:
    lw $ra, 0($sp)       # Restore return address.
    lw $s0, 4($sp)       # Restore $s0.
    addi $sp, $sp, 8     # Deallocate stack space.
    jr $ra               # Return to caller.
