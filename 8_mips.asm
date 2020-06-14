.data 
  a: .word 0
  b: .word 0
  x: .word 0
 
.text
.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

.macro print_label (%x)
	la $t1, %x 
   	lw $t3 , 0($t1)
   	print_int($t3)
.end_macro

.macro change_from_base_to_decimal(%base,%number)
	li $t0, 10
	move $s1 , %number
	li $s2, 1
	move $s3 ,%base
	li $s5 , 0
      division:
	div $s1, $t0 # divide to get last digit
	mfhi $t1 # reminder
	mflo $t2 # division 
	mul $t3, $t1, $s2 # * base
	mflo $t3
	mul $s2,$s2,$s3  #s2 is power of base 
	add $s5, $t3, $s5 # t5 = sum
	move $s1 , $t2 # last division is the new number
	bne $s1 , $zero, division 

.end_macro
.macro change_base_of_label(%base, %number)
	la $t0, %base
   	lw $t6 , 0($t0)
   	la $s4, %number
        lw $t7, 0($s4)
        change_from_base_to_decimal($t6,$t7)
        sw  $s5 , 0($s4)
        
   	
.end_macro 
.macro change_base(%base, %number)
	li $t0, 1
	move $s0, %base
	move $s1, %number
	li  $s5 , 0 # use for sum
      division_for_change_base:
      	div $s1, $s0
      	mfhi $t1 #reminder
      	mflo $s1 #division  
	mul $t2, $t0, $t1 # reminder * power of 10 
	add $s5, $s5, $t2
	mul $t0 , $t0, 10
	bne $s1 , $zero ,  division_for_change_base
	print_int($s5)
	
.end_macro

.macro change_base_with_label(%base, %number)
	la $t0, %base
   	lw $t6 , 0($t0)
   	la $s4, %number
        lw $t7, 0($s4)
        change_base($t6,$t7)

.end_macro

  main:
   li $s0, 3
   la $s1, a

  input:
   li $v0, 5  # get input
   syscall
   move $t0, $v0
   sw $t0, 0($s1)
   addi $s1, $s1, 4
   addi $s0, $s0, -1
   bgt $s0, $zero , input # loop for get input
   
   change_base_of_label(a,b)
   #print_label(b)
   change_base_of_label(a,x)
   #print_label(x)
   change_base_with_label(b,x)
 
 
   
 
 
