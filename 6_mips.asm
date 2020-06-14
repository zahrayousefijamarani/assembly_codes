	.globl main 
	.text 		
main:
	
	li	$v0, 5
	syscall 
	la	$s0, number_of_whites
	sw	$v0, 0($s0)
	move	$s0, $v0
	la	$s1, xy_color	
	move	$s2, $zero	# color

loop_for_getting_points:

	li	$v0, 5
	syscall 
	sw	$v0, 0($s1)	# x
	
	li	$v0, 5
	syscall 
	sw	$v0, 4($s1)	# y
	
	sw	$s2, 8($s1)	# color
	
	addi	$s1, $s1, 12
	subi	$s0, $s0, 1
	bnez	$s0, loop_for_getting_points
	beq	$s2, 1, sort
	
	move	$t8, $zero
	li	$v0, 5
	syscall 
	la	$s0, number_of_blacks
	sw	$v0, 0($s0)
	move	$s0, $v0
	li	$s2, 1
	b	loop_for_getting_points

sort:
	
	la	$s0, xy_color
	la	$s1, number_of_whites
	lw	$s1, 0($s1)
	la	$t0, number_of_blacks
	lw	$t0, 0($t0)
	add	$s1, $s1, $t0
	mul	$s1, $s1, 12
	move	$t9, $s1
	move	$t0, $zero
	move	$t1, $t0		# i
	addi	$t1, $t1, 12		# j
	
sort_x_or_y:
	move	$t2, $s0		# array[i]
	add	$t2, $t2, $t0
	add	$t2, $t2, $t8
	lw	$t4, 0($t2)
	
	move	$t3, $s0		# array[j]
	add	$t3, $t3, $t1
	add	$t3, $t3, $t8
	lw	$t5, 0($t3)		
	ble	$t4, $t5, continue
	
	# swap
	sub	$t2, $t2, $t8
	sub	$t3, $t3, $t8
	lw	$t4, 0($t2)
	lw	$t5, 0($t3)	
	sw	$t5, 0($t2)
	sw	$t4, 0($t3)
	lw	$t4, 4($t2)
	lw	$t5, 4($t3)
	sw	$t5, 4($t2)
	sw	$t4, 4($t3)
	lw	$t4, 8($t2)
	lw	$t5, 8($t3)
	sw	$t5, 8($t2)
	sw	$t4, 8($t3)
	
continue:
	addi	$t1, $t1, 12
	blt	$t1, $s1, sort_x_or_y
	addi	$t0, $t0, 12
	move	$t1, $t0
	addi	$t1, $t1, 12
	bge	$t1, $s1, out
	move	$s2, $s1
	subi	$s2, $s2, 1
	blt	$t0, $s2, sort_x_or_y	
	
out:

	# here we have sorted with x
	la	$s0, number_of_whites
	lw	$s0, 0($s0)			# total number of whites
	la	$s1, number_of_blacks
	lw	$s1, 0($s1)			# total number of blacks
	move	$s2, $s0
	bge	$s1, $s0, condition
	move	$s2, $s1			# we have minimum in $s2

condition:
	la	$s3, xy_color			# address
	li	$s4, -100000			# x || y > very small number		# number is smaller
	move	$t0, $s3
	add	$t0, $t0, $t8
	lw	$s5, 0($t0)			# x || y < $s5			# number is greater
	move	$s6, $zero			# number of whites
	move	$s7, $zero			# number of blacks
	add	$t9, $t9, $s3
	

loop_for_check:
	move	$t0, $s3
	add	$t0, $t0, $t8
	lw	$t0, 0($t0)
	bne	$t0, $s5, calculate
	move	$t2, $t9
	subi	$t2, $t2, 12	
	beq	$s3, $t2, calculate
	lw	$t0, 8($s3)
	addi	$s6, $s6, 1
	sub	$s6, $s6, $t0
	add	$s7, $s7, $t0
	addi	$s3, $s3, 12	
	bne	$s3, $t9, loop_for_check
calculate:
	move	$t0, $s0
	sub	$t0, $t0, $s6
	add	$t0, $t0, $s7	
	blt	$t0, $s2, change1
	b 	next_calculate
change1:
	move	$s2, $t0
	move	$t0, $s3
	add	$t0, $t0, $t8
	lw	$s4, -12($t0)
	lw	$s5, 0($t0)
next_calculate:
	move	$t0, $s6
	add	$t0, $t0, $s1
	sub	$t0, $t0, $s7
	blt	$t0, $s2, change2
	b	next_check
change2:
	move	$s2, $t0
	move	$t0, $s3
	add	$t0, $t0, $t8
	lw	$s4, -12($t0)
	lw	$s5, 0($t0)
next_check:
	lw	$t0, 8($s3)
	addi	$s6, $s6, 1
	sub	$s6, $s6, $t0
	add	$s7, $s7, $t0
	addi	$s3, $s3, 12
	blt	$s3, $t9, loop_for_check
	
	move	$a0, $s4
	li	$v0, 1
	syscall
	
	beq	$t8, 4, y
	la	$a0, msg1
	li	$v0, 4
	syscall
	b	x
	
y:
	la	$a0, msg2
	li	$v0, 4
	syscall
	
x:
	move	$a0, $s5
	li	$v0, 1
	syscall
	
	li	$a0, ' '
	li	$v0, 11
	syscall
	
	move	$a0, $s2
	li	$v0, 1
	syscall
	
	li	$a0, '\n'
	li	$v0, 11
	syscall

	beq	$t8, 4, y_divide_x
	li	$t8, 4
	b	sort
	
y_divide_x:
	#b	end
	
	la	$s0, xy_color
	la	$s1, number_of_whites
	lw	$s1, 0($s1)
	la	$t0, number_of_blacks
	lw	$t0, 0($t0)
	add	$s1, $s1, $t0
	mul	$s1, $s1, 12
	move	$t9, $s1
	move	$t0, $zero
	move	$t1, $t0		# i
	addi	$t1, $t1, 12		# j
	
sort_div:
	move	$t2, $s0		# array[i]
	add	$t2, $t2, $t0
	lw	$t4, 0($t2)
	lw	$t6, 4($t2)
	
	move	$t3, $s0		# array[j]
	add	$t3, $t3, $t1
	lw	$t5, 0($t3)
	lw	$t7, 4($t3)
	
	beqz	$t5, continue_div
	mul	$t7, $t7, $t4
	mul	$t6, $t6, $t5
		
	ble	$t6, $t7, continue_div
	
	# swap
	
	sw	$t5, 0($t2)
	sw	$t4, 0($t3)
	lw	$t4, 4($t2)
	lw	$t5, 4($t3)
	sw	$t5, 4($t2)
	sw	$t4, 4($t3)
	lw	$t4, 8($t2)
	lw	$t5, 8($t3)
	sw	$t5, 8($t2)
	sw	$t4, 8($t3)
	
continue_div:
	addi	$t1, $t1, 12
	blt	$t1, $s1, sort_div
	addi	$t0, $t0, 12
	move	$t1, $t0
	addi	$t1, $t1, 12
	bge	$t1, $s1, out_div
	move	$s2, $s1
	subi	$s2, $s2, 1
	blt	$t0, $s2, sort_div	
	
out_div:

	# here we have sorted with x
	la	$s0, number_of_whites
	lw	$s0, 0($s0)			# total number of whites
	la	$s1, number_of_blacks
	lw	$s1, 0($s1)			# total number of blacks
	move	$s2, $s0
	bge	$s1, $s0, condition_div
	move	$s2, $s1			# we have minimum in $s2

condition_div:
	la	$s3, xy_color			# address
	li	$s4, -100000			# y > very small number		# number is smaller
	li	$t4, 1
	move	$t0, $s3
	lw	$s5, 0($t0)			# y < $s5			# number is greater
	lw	$t5, 4($t0)
	move	$s6, $zero			# number of whites
	move	$s7, $zero			# number of blacks
	add	$t9, $t9, $s3
	

loop_for_check_div:
	lw	$t0, 0($s3)
	lw	$t1, 4($s3)
	move	$t2, $t5
	mul	$t2, $t2, $t0
	move	$t3, $s5
	mul	$t3, $t3, $t1
	bne	$t2, $t3, calculate_div
	
	move	$t2, $t9
	subi	$t2, $t2, 12	
	beq	$s3, $t2, calculate_div
	
	lw	$t0, 8($s3)
	addi	$s6, $s6, 1
	sub	$s6, $s6, $t0
	add	$s7, $s7, $t0
	addi	$s3, $s3, 12	
	bne	$s3, $t9, loop_for_check_div
calculate_div:
	move	$t0, $s0
	sub	$t0, $t0, $s6
	add	$t0, $t0, $s7		
	blt	$t0, $s2, change1_div
	b 	next_calculate_div
change1_div:
	move	$s2, $t0
	lw	$s4, -12($s3)
	lw	$t4, -8($s3)
	lw	$s5, 0($s3)
	lw	$t5, 4($s3)
next_calculate_div:
	move	$t0, $s6
	add	$t0, $t0, $s1
	sub	$t0, $t0, $s7
	blt	$t0, $s2, change2_div
	b	next_check_div
change2_div:
	move	$s2, $t0
	move	$t0, $s3
	lw	$s4, -12($t0)
	lw	$t4, -8($t0)
	lw	$s5, 0($t0)
	lw	$t5, 4($t0)
next_check_div:
	lw	$t0, 8($s3)
	addi	$s6, $s6, 1
	sub	$s6, $s6, $t0
	add	$s7, $s7, $t0
	addi	$s3, $s3, 12
	blt	$s3, $t9, loop_for_check_div
	
	
	move	$a0, $t4
	li	$v0, 1
	syscall
	
	li	$a0, '/'
	li	$v0, 11
	syscall
	
	move	$a0, $s4
	li	$v0, 1
	syscall
	
	
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	move	$a0, $t5
	li	$v0, 1
	syscall
	
	li	$a0, '/'
	li	$v0, 11
	syscall
	
	move	$a0, $s5
	li	$v0, 1
	syscall
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	
	move	$a0, $s2
	li	$v0, 1
	syscall

	li 	$v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
	
	la	$s0, xy_color
	move	$s1, $s0
	add	$s1, $s1, $t9

loop_for_printing_points:

	lw	$a0, 0($s0)
	li	$v0, 1
	syscall 
	
	li	$a0, ' '
	li	$v0, 11
	syscall
	
	lw	$a0, 4($s0)
	li	$v0, 1
	syscall 
	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	
	addi	$s0, $s0, 12
	blt	$s0, $s1, loop_for_printing_points

	
	.data
number_of_whites:	.word	0
number_of_blacks:	.word	0
xy_color:	.space 	160000
# 	first comes x, then y and finally the color			0: white	1: black
msg1:	.asciiz	" < x < "
msg2:	.asciiz	" < y < "
msg3:	.asciiz	"*x < y < "
msg4:	.asciiz	"*x "
