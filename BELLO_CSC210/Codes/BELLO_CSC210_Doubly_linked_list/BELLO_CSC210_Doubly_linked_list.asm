.data
options:    .asciiz "Please type in one of the numbers below and press enter: \n1 - exit program \n2 - next node \n3 - previous node \n4 - insert after current node \n5 - delete current node \n6 - reset \n7 - debug \n"
insertMessage:  .asciiz "Please type a string up to 10 characters and press enter\n"
character:  .asciiz ""
empty:      .asciiz "There is no node yet\n"
doneAdding: .asciiz "\nAdding is done\n"
currentIs:  .asciiz "The current node: "
emptyLine:  .asciiz "\n"
array:      .asciiz "All elements in the string: \n"
sep:        .asciiz "\t"

.text
main:
    start:
        # Check if the linked list head is zero, if it is, then show that there's no element
        beqz $s7, noEle
        # If not zero, do 3 prints:
        # 1) "The current node is:"
        la $a0, currentIs
        jal consolePrint
        # 2) The address of the current node
        move $a0, $a3
        jal consolePrint
        # 3) A new line
        la $a0, emptyLine
        jal consolePrint

    optionMenu:
        # Use print string syscall to show menu and prompt for input
        la $a0, options
        jal consolePrint
        li $v0, 5
        syscall
        # Move user's response to the temporary register $t0
        move $t0, $v0

        # Choose what to do based on user choice
        beq $t0, 1, exit
        beq $t0, 2, next
        beq $t0, 3, previous
        beq $t0, 4, insert
        beq $t0, 5, del
        beq $t0, 6, reset
        beq $t0, 7, debug

    exit:
        # Syscall to exit the program
        li $v0, 17
        syscall

    insert:
        # Jump to the addnode procedure
        j addnode

    del:
        # Call the delnode procedure
        jal delnode
        # Jump back to the start
        j start

    next:
        # If the list is empty, just run the menu again
        beqz $s7, start
        lw $t5, 12($a3)
        bnez $t5, nextNode
        # If not at the end of the list, get the next node
        j start

    previous:
        # If the list is empty, just run the menu again
        beqz $s7, start
        # If already at the head, there's nothing else to do
        beq $s7, $a3, start
        # If there are nodes before the current node, get the previous node
        jal goBack
        # If the list is not empty and we're at the start, just run the menu again
        j start

    reset:
        # Set current to be the first node
        move $a3, $s7
        j start

    debug:
        # Call the printEverything procedure
        jal printEverything
        # Jump back to the start
        j start

    noEle:
        # Indicate that there is no element in the list and go back to the option menu
        la $a0, empty
        jal consolePrint
        j optionMenu

    addnode:
        # Instruction for adding a node
        la $a0, insertMessage
        jal consolePrint
        # Allocate space for the new node
        jal alloSpace
        move $t1, $v0 # Register $t1 now has the address to the allocated space (12 bytes)
        sw $zero, ($t1) # Initialize previous to zero
        sw $zero, 16($t1) # Initialize next to zero
        li $v0, 8
        la $a0, 4($t1) # Load the address for the new node's string
        li $a1, 10
        syscall

        # If the list is empty, this is the first node
        beqz $s7, declareFirstNode

        # Assumptions:
        #   $a3: Pointer to current node (a global variable)
        #   $t1: Pointer to the new node (a parameter to the procedure)
        #
        lw $t2, 16($a3) # Check for the next node of the current node
        beqz $t2, noNextNode

        # If there's a next node, adding starts here
        move $t0, $t2 # Moving pointers into a temporary pointer
        la $t2, 16($t1) # Load the address of the new node's string
        la $t0, -4($t0) # Load the address of the previous field of the current node
        sw $t2, ($t0) # Store the new string's address into the previous field

    noNextNode:
        # If there's no next node, adding can start from here
        lw $t2, 12($a3) # Get the address of the next field of the current node
        sw $t2, 16($t1) # Store that address in the new node's next field
        la $t0, 4($t1) # Get the address of the current string
        sw $t0, 12($a3) # Store that address into the current node's next field
        la $t2, ($a3) # Load the address of the current node's string
        sw $t2, ($t1) # Store that address into the current node's previous field
        la $a3, 4($t1) # Reset current to be the new node
        # Done adding a new node, declare that adding is done and jump back to the main
        la $a0, doneAdding
        jal consolePrint
        j start

    delnode:
        beqz $s7, start # If the list is empty, go back to the menu
        lw $t2, -4($a3) # Load the address of the previous node
        beqz $t2, delHead # If no previous node, this is a head node
        lw $t3, 12($a3) # Load the address of the next node
        beqz $t3, delTail # If no previous node, this is a tail node
        lw $t3, 12($a3) # Load the address of the next node
        sw $t2, -4($t3) # Store the address of the previous node in the next node's previous field
        lw $t2, 12($a3) # Load the address of the next node
        lw $t3, -4($a3) # Load the address of the previous node
        sw $t2, 12($t3) # Store the address of the next node in the previous node's next field
        la $a3, ($t2)

    doneDel:
        jr $ra

    delHead:
        lw $t2, 12($a3)
        sw $zero, -4($t2)
        la $s7, ($t2)
        la $a3, ($t2)
        j doneDel

    delTail:
        lw $t2, -4($a3)
        sw $zero, 12($t2)
        la $a3, ($t2)
        j doneDel

    nextNode:
        la $t5, 12($a3)
        lw $a3, ($t5)
        j start

    goBack:
        la $t5, -4($a3)
        lw $a3, ($t5)
        jr $ra

    printEverything:
        la $a0, array
        jal consolePrint
        la $t1, ($s7)
        beqz $t1, start

    printEle:
        move $a0, $t1
        jal consolePrint
        la $a0, sep
        jal consolePrint
        lw $t2, 12($t1)
        beqz $t2, start
        la $t1, ($t2)
        j printEle

    alloSpace:
        li $v0, 9
        li $a0, 20
        syscall
        jr $ra

    declareFirstNode:
        la $s7, 4($t1)
        la $a3, 4($t1)
        la $a0, doneAdding
        jal consolePrint
        j start

    consolePrint:
        li $v0, 4
        syscall
        jr $ra
