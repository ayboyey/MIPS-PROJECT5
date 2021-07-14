.text
		j	main			# Jump 

		.data
msg1:		.asciiz " the array size \n"
msg2:		.asciiz "Insert the array elements\n"
msg3:		.asciiz "The sorted array is : \n"
msg4:		.asciiz "\n"

		.text
		.globl	main
main: 
		la	$a0, msg1		# Print of msg1
		li	$v0, 4			
		syscall				

		li	$v0, 5			
		syscall			        # put it in $v0
		move	$s2, $v0		
		sll	$s0, $v0, 2		
		sub	$sp, $sp, $s0		
						
						
		la	$a0, msg2		
		li	$v0, 4			# Print of msg2
		syscall				

		move	$s1, $zero		# i=0
for:	bge	$s1, $s2, exit			# if i>=n go to exit_for_get
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $t0, $sp		# $t1=$sp+i*4
		li	$v0, 5			# Get one element from array
		syscall				
		sw	$v0, 0($t1)		
						#  the address $t1
		la	$a0, msg4
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for
exit:	move	$a0, $sp		
		move	$a1, $s2		
		jal	isort			
						 
						 
		la	$a0, msg3		
		li	$v0, 4
		syscall

		move	$s1, $zero		
for_print:	bge	$s1, $s2, exit_print	
		sll	$t0, $s1, 2		
		add	$t1, $sp, $t0		
		lw	$a0, 0($t1)		
		li	$v0, 1			
		syscall				

		la	$a0, msg4
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for_print
exit_print:	add	$sp, $sp, $s0		# elimination of the stack frame 
              
		li	$v0, 10			# EXIT
		syscall			#
		
		
# selection_sort
isort:		addi	$sp, $sp, -20		# save values on stack
		sw	$ra, 0($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		#  address of the array
		move	$s1, $zero		# i=0

		subi	$s2, $a1, 1		# lenght -1
isort_for:	bge 	$s1, $s2, isort_exit	# if i >= length-1 -> exit loop
		
		move	$a0, $s0		# base address
		move	$a1, $s1		# i
		move	$a2, $s2		# length - 1
		
		jal	mini
		move	$s3, $v0		# return value of mini
		
		move	$a0, $s0		# array
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap

		addi	$s1, $s1, 1		# i += 1
		j	isort_for		# go back to the beginning of the loop
		
isort_exit:	lw	$ra, 0($sp)		# restore values from stack
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		
		jr	$ra			# return


# index_minimum routine
mini:		move	$t0, $a0		
		move	$t1, $a1		
		move	$t2, $a2		
		
		sll	$t3, $t1, 2		# first * 4
		add	$t3, $t3, $t0		# index = base array + first * 4		
		lw	$t4, 0($t3)		# min = v[first]
		
		addi	$t5, $t1, 1		# i = 0
mini_for:	bgt	$t5, $t2, mini_end	# go to the  min_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = base array + i * 4		
		lw	$t7, 0($t6)		# v[index]

		bge	$t7, $t4, mini_if_exit	# skip the if when v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# i += 1
		j	mini_for

mini_end:	move 	$v0, $t1		# return mini
		jr	$ra


# swap routine
swap:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra


























