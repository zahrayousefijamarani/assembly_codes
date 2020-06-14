.data
	n: .word 0
	power: .asciiz "^"
	space: .asciiz " "

.macro print_int (%x)
	li $v0, 1	# print integer
	add $a0, $zero, %x 
	syscall
.end_macro

.macro print_char(%label)
	lb $a0, %label
	li $v0, 11    # print_character
	syscall
 .end_macro 

.text

main:
	
# get input
li $v0, 5  
syscall
sw $v0, n

move $t0, $v0
li $t2, 2
li $s0, 0
loop_divide_two:
	div $t0, $t2
	mfhi $t1
	mflo $t0
	add $s0, $s0, 1
	beqz $t1, loop_divide_two
add $s0, $s0, -1 # power of two is in s0
beqz $s0,no_power_of_two
# print power of two
print_int($t2)
print_char(power)
print_int($s0)
print_char(space)

no_power_of_two:
	li $s0, 3
	lw $s1, n
	li $s2, 0
	lw $s5 ,n # always contains n

find_other_factor:
	bgt  $s0,$s5, end
	div $s1, $s0
	mfhi $t0
	add $s2, $s2,1
	beqz $t0, dividable
# not dividable
	bne  $s2,1, print_factor
	add $s0, $s0, 2
	li $s2, 0
	b find_other_factor
print_factor:
	print_int($s0)
	print_char(power)
	add $s2,$s2,-1
	print_int($s2)
	print_char(space)
	add $s0, $s0, 2
	li $s2, 0
	b find_other_factor

dividable:
	mflo $s1
	beq $s1, 1, end
	b find_other_factor

end:
beq $s2, $zero, end_no_print
	print_int($s0)
	print_char(power)
	print_int($s2)
end_no_print:
	
