	.globl main 
	
	.data		0x10010000
str_prompt:		.asciiz		"> "
str_new_line:		.asciiz		"\n"
str_err_syntax:		.asciiz		"Wrong Parentheses.\n"
str_divide_by_zero:	.asciiz		"Divide by zero!\n"
str_err_overflow:	.asciiz		"Overflow!\n"
str_quit:		.asciiz		"Quit.\n"
str_input:		.space		101		# Max inputsize

	
	.text 		0x00400000
main:
	# Set infinity constants
	li	$t0, 0x05f5e0ff
	#li	$t0, 0x06800000
	mtc1	$t0, $f28		# +Infinity
	li	$t0, 0xfa0a1f01
	#li	$t0, 0xff800000
	mtc1	$t0, $f30		# -Infinity
	
	move	$fp, $sp		# Save StackPointer's position in the start

prompt_loop:	
	move	$sp, $fp
	la	$s0, str_input		# address of input string
		
	# Print prompt
	la	$a0, str_prompt
	li	$v0, 4
	syscall
		
	# Read input
	la	$a0, str_input		
	li	$a1, 101		# character limit
	jal	read_input
	
	# end program
	la	$t0, str_input
	lb	$t1, ($t0)
	beq	$t1, 'q', stop
		
	beq	$t1, 0, prompt_loop	# input is empty
	
	jal	calculation
	
	# Check that we reached the end of input
	# Prevent calculations like 5+5)+1
	lb	$t0, ($s0)
	bne	$t0, 0, error_syntax
	
	lw	$t0, ($sp)		# Load result from stack
	mtc1	$t0, $f12		# Move result to coprocessor
		
	
	# Check if result was +-infinity
	c.lt.s	$f28, $f12
	bc1t	print
	c.lt.s	$f30, $f12
	bc1t	print
	b	error_overflow
print:		
	# Print result, it is already in correct register($f12)
	li	$v0, 2
	syscall
	la	$a0, str_new_line		# Print '\n'
	li	$v0, 4
	syscall				
		
	j	prompt_loop
	
	

# Read input from user. Replaces '\n' character with '\0'
# Parameters:
#   $a0 = Address to memory where to write input
#   $a1 = Maximum characters to read
read_input:
	li	$v0, 8			# Read input from user, $a0 and $a1 are already set.
	syscall

replace_nl_loop:
	lb	$t0, ($a0)		# Load character
	addi	$a0, $a0, 1
	beq	$t0, 0, read_input_return  # We reached the end of input.
	bne	$t0, '\n', replace_nl_loop   # If character is not '\n' move to next character
		
	li	$t1, 0			# Replace '\n' -> '\0'
	sb	$t1, -1($a0)		# Loop adds 1 times too much.

read_input_return:
	jr 	$ra
	

# Handles + and - operations
# calculation ::= term("+"|"-" term)*
calculation:		
	subi	$sp, $sp, 4		# Write return address to calculation to stack
	sw	$ra, ($sp)
	jal	term
		
		# while ( read_char != '\0' and (read_char == '-' or read_char == '+') )
calculation_loop:
	lb	$t2, ($s0)		# Read char
	sne	$t3, $t2, 0		# char != \0 ?
	seq	$t4, $t2, '-'		# char == '-' ?
	seq	$t5, $t2, '+'		# char == '+' ?
		
	subi	$sp, $sp, 4
	sw	$t5, ($sp)		# Save boolean "Is this addition(+) operation" to stack
				
	or	$t4, $t4, $t5		# char != '\0' and (char == '/' or char == '*')
	and	$t3, $t3, $t4
	beq	$t3, 0, calculation_return
	addi	$s0, $s0, 1		# Next char
		
	jal	term
		
	lw	$t4, ($sp)		# Load second operand
	addi	$sp, $sp, 4
	lw	$t5, ($sp)		# Load "Is this addition(+) operation" boolean
	addi	$sp, $sp, 4
	lw	$t6, ($sp)		# Load first operand

	mtc1	$t6, $f2		# First operand -> $f2
	mtc1	$t4, $f4		# Second operand -> $f4	
	beq	$t5, 1, calculation_add
		
calculation_sub:
	sub.s	$f2, $f2, $f4		# Substitute the operands to $f2
	swc1	$f2, ($sp)		# Move result to stack
	j	calculation_loop
		
calculation_add:
	add.s	$f2, $f2, $f4		# Add the operands to $f2
	swc1	$f2, ($sp)		# Move result to stack	
	j	calculation_loop

calculation_return:
	addi	$sp, $sp, 4
	lw	$t0, ($sp)		# Load result from stack
	addi	$sp, $sp, 4
	lw	$ra, ($sp)		# Load return address to calculation from stack
	sw	$t0, ($sp)		# Save result to stack(result now replaced the return address)
	jr	$ra


# Handles * and / operations
# term ::= number("*"|"/" number)*
term:		
	subi	$sp, $sp, 4		# Write return address to calculation to stack
	sw	$ra, ($sp)
	jal	number
		
		# while ( read_char != '\0' and (read_char == '/' or read_char == '*') )
term_loop:
	lb	$t2, ($s0)		# Read char
	sne	$t3, $t2, 0		# char != \0 ?
	seq	$t4, $t2, '/'		# char == '/' ?
	seq	$t5, $t2, '*'		# char == '*' ?
		
	subi	$sp, $sp, 4
	sw	$t5, ($sp)		# Save boolean "Is this multiply(*) operation" to stack
				
	or	$t4, $t4, $t5		# char != '\0' and (char == '/' or char == '*')
	and	$t3, $t3, $t4
	beq	$t3, 0, term_return
	addi	$s0, $s0, 1		# Next char
		
	jal	number
		
	lw	$t4, ($sp)		# Load second operand
	addi	$sp, $sp, 4
	lw	$t5, ($sp)		# Load "Is this multiply(*) operation" boolean
	addi	$sp, $sp, 4
	lw	$t6, ($sp)		# Load first operand

	mtc1	$t6, $f2		# First operand -> $f2
	mtc1	$t4, $f4		# Second operand -> $f4	
	beq	$t5, 1, term_mul
		
term_div:
	beq	$t4, 0, error_divide_by_zero
	div.s	$f2, $f2, $f4		# Divide the operands to $f2
	swc1	$f2, ($sp)		# Move result to stack
	j	term_loop
	
term_mul:
	mul.s	$f2, $f2, $f4		# Multiply the operands to $f2
	swc1	$f2, ($sp)		# Move result to stack	
	j	term_loop

term_return:	
	addi	$sp, $sp, 4
	lw	$t0, ($sp)		# Load result from stack
	addi	$sp, $sp, 4
	lw	$ra, ($sp)		# Load return address to calculation from stack
	sw	$t0, ($sp)		# Save result to stack(result now replaced the return address)
	jr	$ra


# Returns number to term
# number ::= ("0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|",")+
# calls function recursively until the '(' are finished
number:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)		# Save return address to term to stack
		
	lb	$t0, ($s0)		# Read character		
	bne	$t0, '(', no_new_calculation  # If char != '(', skip section
		
	addi	$s0, $s0, 1		# Next character
	jal	calculation		# Recursively start new calculation
	lb	$t0, ($s0)		# Read character
	sne	$t1, $t0, ')'		
	seq	$t2, $t0, 0
	or	$t1, $t1, $t2		# If char != ')' or char == '\0'
	bne	$t1, 0, error_syntax

	addi	$s0, $s0, 1		# Next character
	j	number_return

no_new_calculation:		
	jal	atof

# return from function number		
number_return:	
	lw	$t0, ($sp)
	addi	$sp, $sp, 4
	lw	$ra, ($sp)
	sw	$t0, ($sp)
	jr	$ra


# Reads number from input string, converts it to float and writes the float to stack
# Maximum number is 2^31 - 1 = 2147483647
atof:		
	lb	$t1, ($s0)		# Read character
	move	$t9, $t1
	bne	$t1, '-', not_minus
	addi	$s0, $s0, 1
	lb	$t1, ($s0)	
not_minus:
	sle	$t2, $t1, '9'		# Check that character is '0' - '9'
	sge	$t3, $t1, '0'
	and	$t3, $t2, $t3
	beq	$t3, 0, error_syntax
		
		
	li	$t0, 0			# Save length of number to $t0
atof_loop:	
	lb	$t1, ($s0)		# Read character
	sle	$t2, $t1, '9'
	sge	$t3, $t1, '0'
	and	$t3, $t2, $t3		# $t3 = character is '0' - '9'
		
	addi	$t0, $t0, 1		# Increase length
	addi	$s0, $s0, 1		# Next character
	beq	$t3, 1, atof_loop	# Read character was a digit, read next character
		
		
	subi	$t0, $t0, 1		# Loop adds 1 times too much
	move	$t1, $t0		# Length of the number to $t1
	li	$t5, 1
	li	$t6, 0			# Total value of number
	li	$t7, 10
	subi	$s0, $s0, 2		# Loop adds too muchs, go back to the last digit.
		
	li	$v0, 0
		
convert_loop:	
	lb	$t4, ($s0)		# Read digit
	subi	$t4, $t4, '0'		# Convert it to number
	subi	$t1, $t1, 1		#
	mul	$t4, $t4, $t5		# $t4 = $t4 * $t5, number * 10^x
	add	$t6, $t6, $t4		# Add number to total value
	beq	$v0, 1, error_overflow
	bge	$t6, 99999999, error_overflow
	mul	$t5, $t5, $t7		# $t5 = $t5 * 10
	subi	$s0, $s0, 1		# Move to previous digit
	bne	$t1, 0, convert_loop
	
	add	$s0, $s0, $t0		# Move cursor back to last digit
	addi	$s0, $s0, 1		# Next char
						
atof_return:	
	bne	$t9, '-', not_minus_return
	move	$t9, $t6
	move	$t6, $zero
	sub	$t6, $t6, $t9
not_minus_return:
	mtc1	$t6, $f0		# Move total number to coprocessor
	cvt.s.w	$f0, $f0
	subi	$sp, $sp, 4
	swc1	$f0, ($sp)		# Save converted number to stack
	jr	$ra			# Jump back to number


# Error handlers:
error_syntax:	
	la	$a0, str_err_syntax
	li	$v0, 4	
	syscall
	j 	prompt_loop

error_overflow:	
	la	$a0, str_err_overflow
	li	$v0, 4
	syscall
	j 	prompt_loop

error_divide_by_zero:
	la	$a0, str_divide_by_zero
	li	$v0, 4
	syscall
	j 	prompt_loop

stop:		
	la	$a0, str_quit
	li	$v0, 4
	syscall
	j 	end
	
end:		
	li	$v0, 10
	syscall 
	
	
# When exception comes from convert_loop, it handles the exception and prints str_err_overflow
 	.ktext	0x80000180
 	li	$v0, 1
	mfc0 	$k0,$14   		# Coprocessor 0 register $14 has address of trapping instruction
 	addi 	$k0,$k0,4 		# Add 4 to point to next instruction
	mtc0 	$k0,$14   		# Store new address back into $14
	eret
