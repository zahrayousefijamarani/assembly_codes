.data
	n: .word 0
	stack_cap: .word 0
	remain_cap: .word 0
	full_stack: .asciiz "full stack \n"
	empty_stack: .asciiz "empty stack \n"
	

.macro print_string(%string)
    li	$v0, 4			# code for printing string is 4				
    la	$a0, %string		# load address of string to be printed into $a0
    syscall				

.end_macro

.macro print_int (%x)
	add $a0, $zero, %x 
	li $v0, 1	# print integer
	syscall
.end_macro

.text
main:
li $v0, 5  # get input
syscall
sw $v0, n


bnez  $v0, not_zero
print_int($zero)
b end
not_zero:
bne $v0, 1 , not_one
li $t0,1
print_int($t0)
b end
not_one:

addi $v0, $v0, 5 # for not having overlap
sw $v0, stack_cap
sw $v0, remain_cap

move $a0, $v0 # first arg is capacity
jal create_stack # call procedure
move $s0, $s7 # stack address

li $a0, 0
move $a1, $s0
jal push_stack
move $s0, $s7

li $a0, 1
move $a1, $s0
jal push_stack
move $s0, $s7

lw $s4, n
add $s4,$s4, -1

loop_get_result:
	move $a0, $s0
	jal pop_stack
	move $s0, $s7
	move $s1, $s6 # first number
	
	move $a0, $s0
	jal pop_stack
	move $s0, $s7
	move $s2,  $s6 # second number
	
	move $a0, $s2
	move $a1, $s0
	jal push_stack
	move $s0, $s7
	
	move $a0, $s1
	move $a1, $s0
	jal push_stack
	move $s0, $s7
	
	add $s3, $s1,$s2
	
	move $a0, $s3
	move $a1, $s0
	jal push_stack
	move $s0, $s7

	addi $s4,$s4,-1
	bgtz $s4, loop_get_result
	

print_int($s3)

end:
# end of prog
li $v0, 10
syscall

create_stack:
addi $sp,$sp,-8     # Moving Stack pointer
sw $a0,4($sp)
sw $ra,0($sp)

mul $t0, $a0, 4
move $a0,$t0   # $a0 contains the number of bytes           
li $v0,9     # allocate memory
syscall 
move $s7, $v0
 
# return
lw $ra,0($sp)
addi $sp,$sp,8
jr $ra

push_stack: # a0 = number | a1 = stack adddress | return new stack address($s7)
addi $sp,$sp,-12     
sw $a0,4($sp)  # number
sw $a1, 8($sp)# contains stack pointer
sw $ra,0($sp)

sw $a0, 0($a1)
addi $s7, $a1, 4 # return address
 
lw $t0, remain_cap
addi $t0, $t0, -1
sw $t0, remain_cap
bnez  $t0,end_push

# print full stack
print_string(full_stack)

end_push:
# return
lw $ra,0($sp)
addi $sp,$sp,12
jr $ra 

pop_stack: # a0 = stack_address | $s6  = number | s7 = new address
addi $sp,$sp,-8     
sw $a0,4($sp)  # stack address
sw $ra,0($sp)

addi $a0,$a0,-4
lw $s6, 0($a0)
sw $zero,0($a0)
move $s7, $a0

lw $t0, remain_cap
lw $t1, stack_cap
addi $t0, $t0, 1
sw $t0, remain_cap
blt $t0,$t1,end_pop

# print empty stack
print_string(empty_stack)

end_pop:
# return
lw $ra,0($sp)
addi $sp,$sp,8
jr $ra 
