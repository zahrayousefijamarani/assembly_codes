.data 
  string: .space 100
  string_length: .word 0
  max_length: .word 0
  first_memory_index_of_max: .word 0
  enter: .asciiz  "\n"
  
 .macro print_string(%string)
        li $v0, 4			
	la $a0, %string       # load address of string to be printed into $a0
	syscall	
 .end_macro 
 .macro print_char(%x)
 	move $a0, %x
	li $v0, 11    # print_character
	syscall
 .end_macro 
.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	print_string(enter)
.end_macro
.macro print_label (%x)
	la $t1, %x 
   	lw $t3 , 0($t1)
   	print_int($t3)
.end_macro
.macro print_string(%string)
    li	$v0, 4			# load appropriate system call code into register $v0;
						# code for printing string is 4
    la	$a0, %string		# load address of string to be printed into $a0
    syscall				# call operating system to perform print operation

.end_macro

    
.macro get_length(%string)
   la $t0 ,%string
   loop:
    lb   $t1 0($t0)
    beq  $t1 $zero end
    addi $t0 $t0 1
    j loop
   end:
    la $t1 string
    sub $s0, $t0 $t1 #$s0 now contains the length of the string
    add $s0 ,$s0, -1

.end_macro
.macro check_mirrored(%start, %end,%len)
	la $t5 , string
	add $t0 , $t5, %start # t0 = start + address_of_string
	add %end , %end , $t5 # end = end + address_of_string
	li $s6 , 0
      loop_for_check:
	 lb $t1, ($t0) # get first char
	 
	 #print_int($t1)
	 
	 lb $t2,(%end) #get last char
	 
	 #print_int($t2)
	 #print_string(enter)
	 
	 bne $t1,$t2, end_false # compare
	 add $t0 , $t0, 1 # move index of first forward
	 add %end , %end , -1 # move index of last backward
	 add $s6,$s6, 1 # increase the counter
	 bne $s6, %len, loop_for_check # check the end condition
	 
	 #it was mirrored
	 lw $t6 , max_length
	 ble  %len ,$t6 , end_false
	 
	 add $t0 ,$t0 , -1
	 # find greater mirrored substring
	 sw %len, max_length
	 sw $t0 , first_memory_index_of_max
      end_false:
.end_macro

.macro find_mirror(%string, %string_len)
	lw $s0 , %string
	lw $s1 , %string_len # n
	add $s1, $s1, 1 # we want to get length = n too
	li $s2 , 1 # shows the length

      loop:
	sub $s4 , $s1, $s2 # s4 = n - len  s4 shows last index
	li $s3 , 0 # for indexing
        inner_loop2:
          add $s5 , $s3 , $s2 
          add $s5, $s5 , -1 # s5 = i + len -1
 	  
 	  #print_int($s3)
 	  #print_int($s5)
 	  #print_string(enter)
 	  
          check_mirrored ($s3,$s5,$s2)
          
          add $s3 , $s3, 1 # s3 +=1
          bne $s3 , $s4 , inner_loop2

	add $s2 , $s2 , 1
	bne $s2,$s1 , loop # from len 1 to n 
.end_macro

.macro print_string_from_address(%address , %len)
	move $s1, %len
	move $s0 , %address 
	li $s4 , 0
      loop:
      	lb $t0 , ($s0) 
        print_char($t0)
        add $s0, $s0, 1
        add $s4 ,$s4, 1
        bne $s4 , $s1 , loop 
        
.end_macro

.text 
  main:
    li $v0, 8       # take in input
    la $a0, string  # load byte space into address
    li $a1, 100      # allot the byte space for string
    move $t0, $a0   # save string to t0
    syscall
    
    #print_string(string)
    get_length(string)
    la $t0 , string_length
    sw $s0, 0($t0) #store the length
    
    find_mirror(string, string_length)

    lw $t0 , first_memory_index_of_max
    lw $t1 , max_length
    sub $t0 , $t0 ,$t1
    add $t0 ,$t0 ,1
    print_string_from_address($t0, $t1)
   
    
 
    


  
