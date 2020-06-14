.data
	array: .word 3,4,2,6,12,7,18,26,2,14,19,7,8,12,13
	count: .word 15
	enter: .asciiz "\n"
	
.text
 	main:
 	  la $s0 , array
 	  lw $s1 , count #s1 = counter
 	  addi $s2,$zero ,0   #s2 =  max
 	  addi $s3, $zero,100000 #s3 = min
 	  
 	loop:
 	  lw $t0 , 0($s0)
 	  sub $t1, $t0, $s2
 	  blez $t1, countinue_max
 	  add $s2, $t0,$zero	  
 	countinue_max:
          lw $t0 , 0($s0)
 	  sub $t1, $t0, $s3
 	  bgtz $t1, countinue_min
 	  add $s3, $t0,$zero	  
 	countinue_min:
 	  addi $s0, $s0 , 4
 	  addi $s1 ,$s1 , -1
 	  bnez $s1 ,loop
 	  
 	
 	addi $v0 , $zero , 1
 	add $a0, $zero , $s2
 	syscall
 	
 	la $a0, enter
 	addi $v0 , $zero , 4
 	syscall
 	
 	
 	addi $v0 , $zero , 1
 	add $a0, $zero , $s3
 	syscall 
 	
 	
 	
 		  
 	addi $v0, $zero, 10
 	syscall	  
 	  
 	  
 	  
 		