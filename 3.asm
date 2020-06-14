.data
	array: .space 400
	array_2: .space 400
	array_3: .space 400
	n: .word 0
	gnome_count: .word 0
	insertion_count: .word 0
	merge_count: .word 0
	space: .asciiz " "
	enter: .asciiz "\n"
	gnome_explain: .asciiz "gnome count is: "
  	insertion_explain: .asciiz "insertion count is: "
  	merge_explain: .asciiz "merge count is: "
	
.macro print_int (%x)
	add $a0, $zero, %x 
	li $v0, 1	# print integer
	syscall
.end_macro

.macro print_char(%label)
	lb $a0, %label
	li $v0, 11    # print_character
	syscall
 .end_macro 

.macro insertion_sort(%array)
	li $s6, 0#counter for operation	

	lw $t0, n
	ble  $t0, 1,end_insert 
	
	li $s0, 1 # for i 
     loop_insert :
     	mul $t0, $s0, 4 # i in index
     	lw $t1, %array($t0) # t1 = KEY	
     	add $s3,$s0, -1 # s3 = j
     	
     loop_change_place:
     		blt $s3, $zero , end_change
     		mul $t3, $s3, 4
     		lw $t4 , %array($t3)
     		
     		addi $s6,$s6,1
     		bge $t1,$t4, end_change	
     		addi $s6,$s6,1
     		add $t3,$t3,4
     		sw  $t4, %array($t3)
     		add $s3,$s3, -1
     		b loop_change_place
        
      end_change:  
      	add $s3, $s3,1
      	mul $t5, $s3, 4
     	sw $t1, %array($t5)
     	add $s0,$s0,1
     	lw $t9, n
     	blt $s0, $t9 , loop_insert
	
	 
     end_insert :
     	sw $s6, insertion_count
.end_macro 
.macro gnome_sort(%array)
	li $s6,0
	li $s0, 0 # index
	lw $s7, n
    gnome_loop:	
    	bge $s0, $s7, end_gnome_sort
	bnez  $s0, not_zero_state
	add $s0, $s0, 1
	b gnome_loop
	 
    not_zero_state:
    	mul $t0,$s0,4
    	lw $t1, %array($t0)
    	add $t0, $t0, -4
    	lw $t2, %array($t0)
    	blt $t1, $t2, not_g_e
    	
    	add $s6,$s6,1
    	
    	add $s0,$s0,1
    	b gnome_loop
    not_g_e:
    	add $s6,$s6,3
    	
    	sw $t1,%array($t0)
    	add $t0,$t0,4
    	sw $t2, %array($t0)
    	add $s0,$s0,-1
    	b gnome_loop  	
    end_gnome_sort:
    	sw $s6, gnome_count	

.end_macro 

.macro print_array(%array)

	lw $s0, n
	li $s1, 0 # indexing
loop_print:
	lw $s3,%array($s1) 
	print_int($s3)
	print_char(space)
	add $s1,$s1 ,4
	add $s0,$s0, -1
	bnez $s0, loop_print
.end_macro 

.macro print_string(%string)
    li	$v0, 4			# code for printing string is 4				
    la	$a0, %string		# load address of string to be printed into $a0
    syscall				

.end_macro

.text 
main: 

li $v0, 5  
syscall
sw $v0, n

lw $s5, n
li $s0, 0 # for indexing array
get_input:
	beqz $s5, end_input
	li $v0, 5
	syscall
	sw $v0, array($s0)
	sw $v0, array_2($s0)
	sw $v0, array_3($s0)
	add $s0,$s0, 4
	add $s5, $s5, -1
	b get_input
	
end_input:
insertion_sort(array)
gnome_sort(array_2)
b merge_sort

end_prog:
	print_array(array)
	print_char(enter)
	
	print_string(gnome_explain)
	lw $s0, gnome_count
	print_int($s0)
	
	print_char(enter)
	print_string(insertion_explain)
	lw $s0, insertion_count
	print_int($s0)
	
	print_char(enter)
	print_string(merge_explain)
	lw $s0, merge_count
	print_int($s0)

	li $v0, 10    
	syscall

merge_sort:
li $s7 ,0 # counter for operation
la $a0, array_3 
lw $t0, n
mul $t0, $t0,4
add $a1, $a0,$t0
jal merge_sort_func      # jump f function and save position to $ra
sw $s7, merge_count
b end_prog

merge_sort_func:	# a1 - @array_end | a0 = @array_start
    addi $sp, $sp, -16   # adjust stack pointer to store return address and 2 arguments and midpoint
    sw $a1, 8($sp) # a1	
    sw $a0, 4($sp) # a0	
    sw $ra, 0($sp) # set return address
    
    sub $t0, $a1,$a0 # t0 = 4 * length
    ble $t0, 4, merge_func_return # 4 = one word

    div $t0, $t0, 8
    mul $t0, $t0,4
    add $a1, $a0,$t0 # MIDPOINT ADDRESS = end address of left 
    sw $a1, 12($sp) # save midpoint
    
    jal merge_sort_func
    
    lw $a1, 8($sp) # end of array is end of right
    lw $a0, 12($sp) # last midpoint is start right array
    
    jal merge_sort_func
    
    # left and right is srted now
    
    lw $a0, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp) # set midpoint
    
    jal merge
 
merge_func_return: 
    lw $ra , 0($sp)
    add $sp,$sp, 16
    jr $ra 

  
merge:
     add $sp, $sp, -16	# adjust the stack pointer
     sw	$ra, 0($sp)	# save return address 
     sw	$a0, 4($sp) #@start_array 
     sw	$a1, 8($sp) #@midpoint
     sw	$a2, 12($sp) # @end_array
     
     sub $t0, $a2,$a0
     move $s0, $a0
 
     move $a0,$t0   # $a0 contains the number of bytes           
     li $v0,9     # allocate memory
     syscall           
     
     move $a0, $s0
     move $s3, $v0 # start of new array
     move $s4, $a0 # start of left
     move $s5, $a1 # start of right
     
 merge_loop_first:
    bge $s4,$a1, merge_loop_second
    bge $s5, $a2 , merge_loop_second
    
    lw $t0, 0($s4)
    lw $t1, 0($s5)
    addi $s7,$s7,2
    blt  $t0,$t1, set_left
    # set right
    sw $t1,0($s3) 
    addi $s5,$s5, 4
    addi $s3, $s3,4
    b merge_loop_first
    
 set_left:  
    sw $t0, 0($s3)
    addi $s4,$s4,4
    addi $s3,$s3,4
    b merge_loop_first
 
 
 merge_loop_second:
    bge $s4, $a1, merge_loop_third
    addi $s7,$s7,1
    lw $t0,0($s4)
    sw $t0,0($s3)
    addi $s3,$s3,4
    addi $s4,$s4,4
    b merge_loop_second
    
 merge_loop_third:
    bge $s5, $a2,start_copy
    addi $s7,$s7,1
    lw $t0, 0($s5)
    sw $t0, 0($s3)
    addi $s3,$s3,4
    addi $s5,$s5,4
    b merge_loop_third
    
 start_copy:
    move $s3,$v0  
    sub $t0, $a2,$a0 
    div $t0,$t0,4
    move $t8, $a0
 copy:
    blez $t0, end_merge
    lw $t1,0($s3)
    sw $t1,0($t8)
    addi $s3,$s3,4
    addi $t8,$t8,4
    sub $t0,$t0,1
    b copy
    
end_merge:   	      
    lw $ra, 0($sp) # Load the return address
    addi $sp, $sp, 16 # Adjust the stack pointer
    jr $ra # Return


     
     
     
   
   

 

