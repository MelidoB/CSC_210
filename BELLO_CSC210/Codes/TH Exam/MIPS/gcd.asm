.data
a: .word 56
b: .word 98
avg_time1: .word 0
avg_msg1: .asciiz "Average time for GCD of 56 and 98 for N=10: "
avg_time2: .word 0
avg_msg2: .asciiz "Average time for GCD of 56 and 98 for N=100: "
avg_time3: .word 0
avg_msg3: .asciiz "Average time for GCD of 56 and 98 for N=1000: "
avg_time4: .word 0
avg_msg4: .asciiz "Average time for GCD of 56 and 98 for N=10000: "
n_values: .word 10, 100, 1000, 10000

.text

# Macros
.macro print_result(message, result_addr)
    li $v0, 4
    la $a0, message
    syscall
    li $v0, 1
    lw $a0, result_addr
    syscall
.end_macro

.macro run_and_measure(clear_macro, array, size, result_addr, message)
    li $t6, 0 # Initialize time counter
    li $t7, 10 # Time unit per function call

    lw $a0, 0($array) # Load a value
    lw $a1, 0($b_values) # Load b value
    li $t5, 1000 # Number of iterations

run_and_measure_loop_gcd:
    jal gcd
    addi $t6, $t6, $t7 # Increment time counter
    addi $t5, $t5, -1
    bnez $t5, run_and_measure_loop_gcd

    sw $t6, 0($result_addr) # Store total time
    print_result($message, $result_addr)
.end_macro


# GCD function
gcd:
    beq $a1, $zero, end_gcd

    move $t0, $a0
    move $t1, $a1
    div $t0, $t1
    mfhi $a0
    move $a1, $t1
    jal gcd

end_gcd:
    move $v0, $a0
    jr $ra

# Main program
.globl main
main: 
    la $t0, n_values
    lw $a0, a
    lw $a1, b

    run_and_measure(clear_macro, n_values, 4, avg_time1, avg_msg1)
    move $s1, $zero # Reset accumulator for total time

    run_and_measure(clear_macro, n_values, 4, avg_time2, avg_msg2)
    move $s1, $zero # Reset accumulator for total time

    run_and_measure(clear_macro, n_values, 4, avg_time3, avg_msg3)
    move $s1, $zero # Reset accumulator for total time

    run_and_measure(clear_macro, n_values, 4, avg_time4, avg_msg4)

    # Exit
    li $v0, 10
    syscall
