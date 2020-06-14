	.globl main 
	.text 		
main:
	
	la	$t0, xy
	move	$t2, $zero
	
loop_for_making_zero:
	sw 	$zero, 0($t0)
	addi	$t2, $t2, 1
	addi	$t1, $t1, 4
	bne	$t2, 160000, loop_for_making_zero
	
	
	li	$v0, 5		
	syscall	
	move	$t0, $v0 	# x

	li	$v0, 5		
	syscall	
	move	$t1, $v0 	# y
	
	la	$s0, xy
	mul	$t0, $t0, 4
	add	$s0, $s0, $t0
	mul	$t1, $t1, 400
	add	$s0, $s0, $t1
	
	li	$t0, 2
	sw 	$t0, 0($s0)	# set treasure position
	

	li	$v0, 5		
	syscall	
	move	$s0, $v0 	# number of blocks is in s0
	
loop_for_getting_blocks:
	li	$v0, 5		
	syscall	
	move	$t0, $v0	# x
	
	li	$v0, 5		
	syscall	
	move	$t1, $v0	# y
	
	la	$s1, xy
	mul	$t0, $t0, 4
	add	$s1, $s1, $t0
	mul	$t1, $t1, 400
	add	$s1, $s1, $t1
	
	li	$t0, 1
	sw 	$t0, 0($s1)	# set block position
	
	subi	$s0, $s0, 1
	bnez	$s0, loop_for_getting_blocks
	

	la	$s0, xy		# position address
	move	$s1, $zero	# last
	
	
	
while_not_destination:
	li	$v0, 12		
	syscall	
	beq	$v0, 'u', up
	beq	$v0, 'd', down
	beq	$v0, 'r', right
	beq	$v0, 'l', left
	
up:	
	li	$s1, 400
	b	change_place
down:
	li	$s1, -400
	b	change_place
right:
	li	$s1, 4
	b	change_place
left:
	li	$s1, -4
	b	change_place
	
change_place:
	add	$s0, $s0, $s1
	lw	$t0, 0($s0)
	beq	$t0, 0, next
	beq	$t0, 2, end
	
	la	$a0, msg1
	li	$v0, 4
	syscall
	sub	$s0, $s0, $s1
	sub	$s2, $s2, $s1
	b	while_not_destination


next:	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	move	$s2, $s0
	la 	$t0, xy
	sub	$s2, $s2, $t0
		
	div	$s2, $s2, 400	
	mfhi	$a0
	mflo	$a1
	div	$a0, $a0, 4
	mflo	$a0
	li	$v0, 1
	syscall
	li	$a0, ' '
	li	$v0, 11
	syscall
	move	$a0, $a1
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall
	b	while_not_destination
	
	
end:
	la	$a0, msg2
	li	$v0, 4
	syscall
	

	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
	.data
space:	.space	160000
xy:	.space 	160000
#	block: 1	treasure: 2
msg1:	.asciiz	"\ncan't move, obstacle ahead\n"
msg2:	.asciiz	"\nreached treasure!\n"