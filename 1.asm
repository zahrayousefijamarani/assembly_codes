.data
	n: .word 0

.macro print_int (%x)
	add $a0, $zero, %x 
	li $v0, 1	# print integer
	syscall
.end_macro

.text

main:

# get input
li $v0, 5  
syscall
sw $v0, n

bnez  $v0, not_zero
print_int($zero) 
b end
not_zero:
	lw $v0, n
	bne $v0, 1, not_one 
	print_int($v0)
	b end
not_one:
	li $s5, 1 # counter
	lw $s3, n
	li $s0, 0 
	li $s1, 1
	
loop:
	add $s0, $s0, $s1
	add $s1,$s0,$s1
	add $s5,$s5,2
	bgt $s5,$s3, print_s0
	beq $s5, $s3, print_s1
	b loop	
	
print_s0:
	print_int($s0)
	b end
print_s1:
	print_int($s1)
	b end	

end:
  
     
     
     
   
   
