#push and pop from array with stack

.data
array: .word 1, 2, 3, 4, 5 # Initialize original array with 5 elements
array_len: .word 5 # Length of the array
new_array: .space 20 # Space for new array to store popped elements
.text
.globl main
main:
# Load the address of the original array and its length
la $t0, array
lw $t1, array_len
# Loop to push each array element onto the stack
li $t2, 0 # Initialize loop counter
push_loop:
beq $t2, $t1, end_push_loop # If loop counter equals array length, exit loop
lw $t3, 0($t0) # Load array element into $t3
# Push $t3 onto the stack
subu $sp, $sp, 4 # Decrease stack pointer
sw $t3, 0($sp) # Store $t3 value onto stack
addi $t0, $t0, 4 # Move to the next array element
addi $t2, $t2, 1 # Increment loop counter
j push_loop
end_push_loop:
# Reset loop counter and load the address of the new array
li $t2, 0
la $t4, new_array
# Loop to pop each element off the stack into new_array
pop_loop:
beq $t2, $t1, end_program # If loop counter equals array length, exit loop
# Pop from the stack to $t3
lw $t3, 0($sp) # Load value from stack to $t3
addu $sp, $sp, 4 # Increase stack pointer
# Store popped element into new_array
sw $t3, 0($t4)
addi $t4, $t4, 4 # Move to the next position in new_array
addi $t2, $t2, 1 # Increment loop counter
j pop_loop
end_program:
# Exit
li $v0, 10
syscall