.data

askInput: .asciiz "Enter N and N^2 (both positive):\n" # String called "askInput" declared
errorMessage: .asciiz "The input is erroneous." # String called "errorMessage" declared
space: .asciiz " " 		# String called "space" declared
nextSqs: .asciiz "Next 3 squares are:"

.text

main:
	li $v0, 4 		# Load 4 into $v0 to call syscall - print string
	la $a0, askInput 	# String to print for syscall
	syscall			# Print askInput
	
	li $v0, 5 		# Load 5 into $v0 to call syscall - read integer
	syscall 		# Get integer
	move $t0, $v0 		# Put first integer in $t0
	
	li $v0, 5 		# Load 5 into $v0 to call syscall - read integer
	syscall 		# Get integer
	move $t1, $v0 		# Put second integer in $t1
	
	blt $t0, $zero, error 	# If $t0 is less than 0, branch to error
	blt $t1, $zero, error 	# If $t1 is less than 0, branch to error
	move $a1, $t0 		# Move $t0 to $a1 (N)
	move $a2, $t1 		# Move $t1 to $a2 (N^2)
	addi $a3, $zero, 1 	# Declare $a0 with value 1 (i)
	
	li $v0, 4 		# Load 4 into $v0 to call syscall - print string
	la $a0, nextSqs 	# To print nextSqs using syscall
	syscall 		# Print nextSqs
		
	
loop: 				# Requires iterator count to be in $a3
      				# Requires N to be in $a1 and N^2 to be in $a2
      bgt $a3, 3, end 		# If $a3(i) is greater than 3, branch to end
     
      li $v0, 4 		# Load 4 into $v0 to call syscall - print string
      la $a0, space 		# To print space using syscall
      syscall 			# Print space
      
      jal nextsq 		# Jump to nextsq to get square
      
      move $t1, $v0 		# Put contents of $v0(The next sqaure) into $t1
      
      
      li $v0, 1 		# Load 1 into $v0 to call syscall - print integer
      la $a0, ($t1) 		# Number to print for syscall
      syscall 			# Print number
      
      move $a2, $t1 		# Move contents of $t1 to $a2
      
      addi $a3, $a3, 1 		# Add 1 to $a2
      addi $a1, $a1, 1 		# Add 1 to $a1
      
      j loop 			# Return to loop and restart
      
      

nextsq: # Requires N to be in $a1 and N^2 to be in $a2
	# Return value is passed in $v0 
	# N^2 + N + (N + 1)
	add $t0, $a1, $a2 # N^2 + N
	addi $t1, $a1, 1 # N + 1
	add $t3, $t1, $t0 # N^2 + N + (N + 1)
	move $v0, $t3 # Move result of equation into $v0
	jr $ra # Jump back to caller

error:
	li $v0, 4 # Load 4 int0 $v0 to call syscall - print string
	la $a0 errorMessage # String to print for syscall
	syscall # Print errorMessage
	
end:	
	li $v0, 10 # Load 10 into $v0 to call syscall - exit
	syscall # Exit program
