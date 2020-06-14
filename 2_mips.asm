	.globl main 
	.text 		
main:

	# Get input n from user and save
	li	$v0, 5		
	syscall	
	la	$t0, n
	sw 	$v0, 0($t0)		# t0 has n
	
	move	$a1, $v0
	addi	$a1, $a1, 1
	la	$a0, string		# input string
	li	$v0, 8
	syscall 
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	li	$v0, 12			# input character
	syscall 
	li	$v1, 'c'

	beq	$v0, $v1, count
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	
	li	$v0, 5		
	syscall
	la	$t0, a_int
	sw 	$v0, 0($t0)		# t0 has a_int
	
	
	move	$a1, $v0
	addi	$a1, $a1, 1
	la	$a0, a_string		# input string 
	li	$v0, 8
	syscall 
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	li	$v0, 5		
	syscall	
	la	$t0, b_int
	sw 	$v0, 0($t0)		# t0 has b_int
	
	
	move	$a1, $v0
	addi	$a1, $a1, 1
	la	$a0, b_string		# input string 
	li	$v0, 8
	syscall 
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	la	$t0, n
	lw	$t0, 0($t0)
	la	$t1, a_int 
	lw	$t1, 0($t1)
	la	$s0, string
	la	$s1, a_string
	move	$t2, $s0
	add	$t2, $t2, $t0
	move	$t3, $s1
	add	$t3, $t3, $t1
	
	
find_first_character:
	la	$s1, a_string
	beq	$s0, $t2, end
	lb	$t4, 0($s0)
	lb	$t5, 0($s1)
	addi	$s0, $s0, 1
	bne	$t4, $t5, find_first_character
	# here we have found first character
	move	$t6, $s0	# save first character
	subi	$s0, $s0, 1
loop:	
	addi	$s0, $s0, 1
	addi	$s1, $s1, 1
	beq	$s1, $t3, end
	beq	$s0, $t2, end
	lb	$t4, 0($s0)
	lb	$t5, 0($s1)
	bne	$t4, $t5, not_equal
	b 	loop
not_equal:
	move	$s0, $t6
	b	find_first_character

	
end:	
	bne	$s1, $t3, bad_end
	# we have found the string
	move	$t4, $s0
	sub	$t4, $t4, $t1		# when to print b
	la	$s1, string
	la	$s2, b_string
	la	$s3, b_int
	lw	$s3, 0($s3)
	add	$s3, $s3, $s2
	
	
#	t2 is end of string	
loop_for_print_replace:
	beq	$s1, $t2, bad_end
	beq	$s1, $t4, print_b
	lb	$a0, 0($s1)
	li	$v0, 11
	syscall	
	addi	$s1, $s1, 1
	bne	$s1, $t4, loop_for_print_replace
	la	$s0, b_string
	la	$s1, b_int
print_b:
loop_for_print_b:
	lb	$a0, 0($s2)
	li	$v0, 11
	syscall
	addi	$s2, $s2, 1
	bne	$s2, $s3, loop_for_print_b
	add	$t4, $t4, $t1
	move	$s1, $t4
	la	$t4, string
	b loop_for_print_replace
	
			
count: 	

	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	
	
	li	$v0, 5		
	syscall
	la	$t0, a_int
	sw 	$v0, 0($t0)		# t0 has a_int
	
	
	move	$a1, $v0
	addi	$a1, $a1, 1
	la	$a0, a_string		# input string 
	li	$v0, 8
	syscall 
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	
	
	la	$t0, n
	lw	$t0, 0($t0)
	la	$t1, a_int 
	lw	$t1, 0($t1)
	la	$v0, string
	la	$v1, a_string
	move	$t2, $v0
	add	$t2, $t2, $t0
	move	$t3, $v1
	add	$t3, $t3, $t1
	li	$s0, 0
	
find_first_character_c:
	la	$v1, a_string
	beq	$v0, $t2, print_count
	lb	$t4, 0($v0)
	lb	$t5, 0($v1)
	addi	$v0, $v0, 1
	bne	$t4, $t5, find_first_character_c
	# here we have found first character
	move	$t6, $v0	# save first character
	subi	$v0, $v0, 1
loop_c:	
	addi	$v0, $v0, 1
	addi	$v1, $v1, 1
	beq	$v1, $t3, next
	beq	$v0, $t2, print_count
	lb	$t4, 0($v0)
	lb	$t5, 0($v1)
	bne	$t4, $t5, not_equal_c
	b 	loop_c
next:	
	addi	$s0, $s0, 1
not_equal_c:
	move	$v0, $t6
	b	find_first_character_c
	
	
print_count:
	move	$a0, $s0
	li	$v0, 1
	syscall


bad_end:
	
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
	.data
n:		.word 	0
string:		.asciiz "                                                                                                "
a_int:		.word 	0
a_string:	.asciiz "                                                                                                "
b_int:		.word	0
b_string:	.asciiz "                                                                                                "
