.data
	head_address: .word 0  # first value = value ; seconed = last pointer ; third = next pointer  
	tail_address: .word 0 
	count: .word 0
	space: .asciiz " "
	enter: .asciiz "\n"

.macro print_string(%string)
    li	$v0, 4			
						
    la	$a0, %string		
    syscall				
.end_macro


.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	print_string(space)
.end_macro
.macro print_from_address(%x) 
   	lw $t3 , 0(%x)
   	print_int($t3)
.end_macro
		
.macro add_first_list(%a)
	li      $v0,9             # allocate memory
	li      $a0,12          # 12 bytes
	syscall                
	move    $s1,$v0           # $s1 = @ node
	add     $t0,$zero ,%a    # store value
	sw      $t0,0($s1)        # as value
	sw $zero,4($s1)
	
	lw $s2, head_address   #s1 =@ new node ; s2 =@ old first node
	beq $s2, $zero,add_first_node # is first node
	
	sw $s2, 8($s1) # save last head as next for new node

	# set last node of last head
	sw $s1, 4($s2)

     add_first_node:
        sw $s1, head_address
        bne $zero ,$s2 ,increase_count
        sw $s1, tail_address
   
     increase_count:	
	lw $t0, count
	addi $t0,$t0 , 1
	sw $t0, count
	
.end_macro
.macro add_last_list(%a)
	li      $v0,9             # allocate memory
	li      $a0,12           # 12 bytes
	syscall                
	move    $s1,$v0           # $s1 = @ node
	add     $t0,$zero ,%a    # store value
	sw      $t0,0($s1)        # as value
	sw $zero, 8($s1)
	
	lw $s2, tail_address   #s1 =@ new node ; s2 =@ old last node
	beq $s2,$zero, set_first_node
	
	sw $s2, 4($s1) # save last tail as last for new node

	
	sw $s1, 8($s2) # set next node for old tail
      	
        sw $s1, tail_address
	
	lw $t0, count # increase count
	addi $t0,$t0 , 1
	sw $t0, count
	b end_
	
      set_first_node:
	lw $t0, count # increase count
	addi $t0,$t0 , 1
	sw $t0, count
	
	sw $s1, tail_address
	sw $s1, head_address
	
      end_:
	
.end_macro 

.macro add_a_after_b(%a, %b) # do not use s3 ,s4
	li $t0, 1 #counter
	lw $s1, count
	lw $s2, head_address
     loop_delete_a:	
	lw $t1, 0($s2)
	beq $t1, %a,a_found

	addi $t0,$t0, 1 
	lw $s2, 8($s2)
	ble $t0, $s1, loop_delete_a
	
     a_found:
        lw $s5, 4($s2) # @last node of a
        lw $s6, 8($s2) # @next node of a
        
        li      $v0,9             # allocate memory
	li      $a0,12           # 12 bytes
	syscall                  # $v0 = @ node
	add     $t0,$zero ,%b    # store value
	sw      $t0,0($v0)        # as value
	

	sw $s2, 4($v0)
	sw $s6, 8($v0)
	lw $t9, 8($s2)
	bnez  $t9 ,is_not_the_last_one
	#is the last one
	sw $v0, tail_address
	
     is_not_the_last_one:	
	sw $v0, 8($s2)
	
	beqz  $s6, s6_is_the_last
	sw $v0, 4($s6)
     s6_is_the_last:
     
	addi $s1, $s1,1
	sw $s1, count
	
        		
.end_macro 
.macro delete_a(%a)
	li $t0, 1 #counter
	lw $s1, count
	lw $s2, head_address
     loop_delete_a:	
	lw $t1, 0($s2)
	beq $t1, %a,delete_label

	addi $t0,$t0, 1 
	lw $s2, 8($s2)
	ble $t0, $s1, loop_delete_a
	
     delete_label: # s2 is the address of a
        beq $t0, 1, delete_first_node
        beq $t0, $s1 , delete_last_node
        # else:
        lw $s5, 4($s2) # s5 = address of last
        lw $s6,8($s2) # s6 = address of next
        
        sw $s6, 8($s5)
        sw $s5, 4($s6)
        addi $s1,$s1,-1
        sw $s1, count
        b end_delete
        
     delete_first_node:
     	lw $s5, 8($s2) # address of second
     	beqz $s5,list_is_null_first
     	sw $zero, 4($s5)
     list_is_null_first:
        addi $s1,$s1,-1
        sw $s5,head_address
        sw $s1, count	
        b end_delete
     
     delete_last_node:
        lw $s5, 4($s2) # address of last node
        beqz $s5 , list_is_null_last
        sw $zero, 8($s5)
     list_is_null_last:   
        addi $s1,$s1,-1
        sw $s5,tail_address
        sw $s1, count
        b end_delete
     
     end_delete:
	
.end_macro 
.macro find_a(%a)
	li $t0, 1 #counter
	lw $s1, count
	lw $s2, head_address
     loop_find_a:	
	lw $t1, 0($s2)
	beq $t1, %a, print_rank

	addi $t0,$t0, 1 
	lw $s2, 8($s2)
	ble $t0, $s1, loop_find_a
	
      print_rank: # it is in list else it return 1!	
        print_int($t0)
        
	print_string(enter)
	
.end_macro 
.macro print()
	li $t0,1 #counter
	lw $s1, count
	lw $s2, head_address
     loop:
     	beqz $s1, end_print	
	print_from_address($s2)
	addi $t0,$t0, 1 
	lw $s2, 8($s2)
	ble $t0, $s1,loop
	print_string(enter)
	
     end_print:
.end_macro 
 	
.text
	main:
	 start_pro:
           li $v0, 5  # get input
           syscall
           
           beq $v0 , 1 , add__first_label
           beq $v0 , 2 , add_last_label
           beq $v0, 3, add_a_after_b_label
           beq $v0, 4, delete_a_label
           beq $v0, 5, find_a_label
           beq $v0, 6,print_label
           beq $v0, 7, end_pro
           
        add__first_label:
           li $v0, 5  
           syscall # get a
           add $s3, $zero, $v0
           add_first_list($s3)
           b start_pro
           
        add_last_label:
           li $v0, 5  
           syscall # get a
           add $s3, $zero, $v0
           add_last_list($s3)
           b start_pro
          
        add_a_after_b_label:
           li $v0, 5  
           syscall # get a
           add $s3, $v0, $zero
           
           li $v0, 5  
           syscall # get b
           add $s4, $zero,$v0
           add_a_after_b($s4, $s3) # my program work with a= is in list,b = want to add :(
           b start_pro
          
        delete_a_label:
          li $v0, 5  
          syscall # get a
          add $s7, $zero,$v0
          delete_a($s7)
          b start_pro
          
        find_a_label:
          li $v0, 5  
          syscall # get a
          add $s7, $zero,$v0
          find_a($s7)
          b start_pro
          
        print_label:
          print()
          b start_pro
        
        end_pro:
          addi $v0, $zero, 10
          syscall 