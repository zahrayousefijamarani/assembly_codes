.macro print_string(%string)
    li	$v0, 4			# load appropriate system call code into register $v0;
						# code for printing string is 4
    la	$a0, %string		# load address of string to be printed into $a0
    syscall				# call operating system to perform print operation

.end_macro
 .macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	print_string(enter)
.end_macro 
.macro make_array_full_zero(%x)
 	li $t0 , 0
 	lw $t1, n
 	la $t2, %x
       loop:
 	sb $zero , ($t2)
 	add $t0 , $t0, 1
 	add $t2, $t2, 1
 	bne $t0 , $t1 , loop
 .end_macro  
 .macro print_int_by_address(%x) #address
 	lb $t9, (%x)
 	li $v0, 1
	add $a0, $zero,$t9
	syscall 
 .end_macro 
 
 .macro print_array(%array)
 	li $t0 , 0
 	lw $t1, n
 	la $t2, %array
       loop:
 	print_int_by_address($t2)
 	add $t0 , $t0, 1
 	add $t2, $t2, 1
 	bne $t0 , $t1 , loop
 	print_string(enter)
 .end_macro