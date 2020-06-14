	
	.globl main 
		.data
	
n:			.word	0
matrix:			.space	160000
c:			.word	0
argumented_matrix: 	.space 	160000
one:			.float	1.0
zero:			.float	0.0
msg1:			.asciiz	"=======sort=======\n\n"
msg2:			.asciiz	"=======triangle=======\n\n"
msg3:			.asciiz	"=======divide=======\n\n"
msg4:			.asciiz	"=======inverse matrix=======\n\n"
msg5:			.asciiz	"=======this matrix has no inverse=======\n\n"	
	.macro	print_func(%address)
	add	$t0, $zero, %address
	move	$t1, $t0
	subi	$t0, $t0, 4
	lw	$t0, 0($t0)
	mul	$t2, $t0, $t0
loop_for_print:
	lwc1	$f12, ($t1)
	li	$v0, 2
	
	syscall
	
	li	$a0, ' '
	li 	$v0, 11
	syscall
	
	subi	$t2, $t2, 1
	
	move	$t3, $t2
	div	$t3, $t3, $t0
	mfhi	$t3
	
	bnez	$t3, next 
	li	$a0, '\n'
	li 	$v0, 11
	syscall
next:
	add	$t1, $t1, 4
	bnez	$t2, loop_for_print
	
	li	$a0, '\n'
	li 	$v0, 11
	syscall
	.end_macro 

	.macro interchange (%address, %s, %r, %c, %x)
	add	$t0, $zero, %address
	subi	$t0, $t0, 4	# n is in $t0
	lw	$t0, ($t0)
	mul	$t0, $t0, 4
	add	$t1, $zero, %s
	mul	$t1, $t1, $t0	# source row address is in $t1
	add	$t1, $t1, %address
	add	$t2, $zero, %r
	mul	$t2, $t2, $t0	# destination row address is in $t2
	add	$t2, $t2, %address	
	move	$t4, $zero
	
loop_for_multiply:
	lwc1	$f3, ($t1)
	mtc1	$zero, $f31
	add.s	$f6, $f31, %c
	mul.s	$f3, $f3, $f6
	lwc1	$f5, ($t2)
	li	$t7, %x
	beqz 	$t7, ignore_add
	add.s	$f3, $f3, $f5
ignore_add:
	swc1	$f3, ($t2)
	addi	$t1, $t1, 4
	addi	$t2, $t2, 4
	addi	$t4, $t4, 4
	blt	$t4, $t0, loop_for_multiply
	print_func (%address)
	.end_macro
	
	.macro afunc (%address, %s, %r, %c)
	interchange (%address, %s, %r, %c, 1)
	.end_macro 
	
	.macro	bfunc(%address, %r, %c)
	lw	$t0, -4(%address)	# n
	mul	$t1, $t0, %r		# i * n
	mul	$t1, $t1, 4		# i * n * 4
	add	$t1, $t1, %address	# address of row
	mul	$t0, $t0, 4		# 4 * n
	add	$t0, $t0, $t1
	mov.s	$f0, %c
loop_for_mul:
	lwc1	$f1, ($t1)
	mov.s	$f3, $f0
	mul.s	$f1, $f1, $f3
	swc1	$f1, ($t1)
	addi	$t1, $t1, 4
	blt	$t1, $t0, loop_for_mul
	print_func (%address)
	.end_macro 
	
	
	.text 		
main:
	li	$v0, 5
	syscall
	la	$s0, n
	sw	$v0, ($s0)
	move	$s0, $v0
	
	mul	$s0, $s0, $s0
	la	$s1, matrix
	
loop_for_getting_input:
	li	$v0, 6
	syscall
	swc1	$f0, ($s1)
	addi	$s1, $s1, 4
	subi	$s0, $s0, 1
	bnez	$s0, loop_for_getting_input

	# Create the augmented matrix
	li	$s0, 0		# i
	li	$s1, 0		# j
	la	$s2, n		# boundary for i, j
	lw	$s2, ($s2)	
	la	$s3, argumented_matrix
	sw	$s2, -4($s3)
	
loop_for_setting_ones:
	li	$t0, 1
	add	$t1, $s3, $s1
	mul	$t2, $s0, $s2
	add	$t1, $t1, $t2
	mul	$t1, $t1, 4
	l.s	$f0, zero
	swc1	$f0, ($s3)
	bne	$s0, $s1, not_storing_one
	l.s	$f0, one
	swc1	$f0, ($s3)
not_storing_one:
	addi	$s3, $s3, 4
	addi	$s1, $s1, 1
	blt	$s1, $s2, loop_for_setting_ones
	move	$s1, $zero
	addi	$s0, $s0, 1
	blt	$s0, $s2, loop_for_setting_ones
	
	
       	# Interchange the row of matrix,
	# interchanging of row will start from the last row
	
	la	$a0, msg1
	li	$v0, 4
	syscall
	
	la	$s0, n
	lw	$s0, ($s0) 	
	subi	$s0, $s0, 1
	mul	$s0, $s0, 4	# i = n - 1 -> 1
	la	$s1, matrix
	la	$s2, argumented_matrix
	
loop_for_interchange_row:
	add	$t0, $s0, $s1
	subi	$t1, $t0, 4
	lw	$t2, ($t0)
	lw	$t3, ($t1)
	bge	$t3, $t2, do_not_change_row
	li	$t4, 4
	div	$s0, $t4
	mflo	$t8
	subi	$t9, $t8, 1
	la	$t2, n
	lw	$s7, ($t2)
	
	l.s	$f30, one
	interchange ($s1, $t8, $s7, $f30, 0)
	interchange ($s2, $t8, $s7, $f30, 0)
	interchange ($s1, $t9, $t8, $f30, 0)
	interchange ($s2, $t9, $t8, $f30, 0)
	interchange ($s1, $s7, $t9, $f30, 0)
	interchange ($s2, $s7, $t9, $f30, 0)
do_not_change_row:
	subi	$s0, $s0, 4
	bnez	$s0, loop_for_interchange_row
	
	
	# Replace a row by sum of itself and a
    	# constant multiple of another row of the matrix
    	 
	la	$a0, msg2
	li	$v0, 4
	syscall
	
	move	$s0, $zero		# i
	move	$s1, $zero		# j
	la	$s2, matrix
	la	$s3, argumented_matrix
	la	$s4, n
	lw	$s4, ($s4)
	
loop_for_making_triangle:
	beq	$s0, $s1, do_not_change_triangle
	mul	$t0, $s0, 4		# i * 4
	mul	$t1, $s1, $s4		# j * n
	mul	$t1, $t1, 4		# j * n * 4
	add	$t2, $t0, $t1		# i * 4 + j * n * 4 
	add	$t2, $t2, $s2		# address of matrix[j][i] 
	mul	$t1, $s4, $t0		# i * n * 4
	add	$t3, $t0, $t1		# i * n * 4 + i * 4
	add	$t3, $t3, $s2		# address of matrix[i][i]
	lwc1	$f0, ($t2)
	lwc1	$f2, ($t3)
	div.s	$f3, $f0, $f2		# matrix[j][i] / matrix[i][i]
	l.s	$f4, zero
	sub.s	$f4, $f4, $f3
	afunc ($s2, $s0, $s1, $f4)
	afunc ($s3, $s0, $s1, $f4)
do_not_change_triangle:
	addi	$s1, $s1, 1
	blt	$s1, $s4, loop_for_making_triangle
	move	$s1, $zero
	addi	$s0, $s0, 1
	blt	$s0, $s4, loop_for_making_triangle
	
	move	$s0, $zero		# i
	la	$s1, matrix
	la	$s3, n
	lw	$s3, ($s3) 
	
loop_for_check:
	mul	$t0, $s0, 4		# i * 4
	mul	$t1, $t0, $s3		# i * n * 4
	add	$t2, $t0, $t1
	add	$t2, $t2, $s1		
	lwc1	$f0, ($t2)		# matrix[i][i]
	l.s	$f1, zero
	c.eq.s	$f0, $f1
	bc1t	no_inverse
	addi	$s0, $s0, 1
	blt	$s0, $s3, loop_for_check
	
	
    	# Multiply each row by a nonzero integer.
	# Divide row element by the diagonal element
	
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	move	$s0, $zero		# i
	la	$s1, matrix
	la	$s2, argumented_matrix
	la	$s3, n
	lw	$s3, ($s3) 
loop_for_multiply_row:
	mul	$t0, $s0, 4		# i * 4
	mul	$t1, $t0, $s3		# i * n * 4
	add	$t2, $t0, $t1
	add	$t2, $t2, $s1		
	lwc1	$f0, ($t2)		# matrix[i][i]
	l.s	$f1, one
	div.s	$f11, $f1, $f0
	bfunc($s1, $s0, $f11)
	bfunc($s2, $s0, $f11)
	addi	$s0, $s0, 1
	blt	$s0, $s3, loop_for_multiply_row
	
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	
	la	$s3, argumented_matrix
	print_func($s3)
	b 	end
	
no_inverse:	
	la	$a0, msg5
	li	$v0, 4
	syscall
	
end:
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
