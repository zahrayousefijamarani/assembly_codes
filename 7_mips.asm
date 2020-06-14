.data
	number: .word 0
	enter: .asciiz "\n"
	hop: .asciiz "hop"
	lose: .asciiz "You Lose :p"
	user_input: .space 100
.macro print_string(%string)
        li $v0, 4			
	la $a0, %string       # load address of string to be printed into $a0
	syscall	
 .end_macro 

.macro check_prime(%x) #answer is in $s7 if $s7 = 0 --> not prime ; $s7 = 1 --> is prime
	li $t0, 2
       loop_check_prime:
       	div %x , $t0
       	mfhi $t1 
       	beq $t1, $zero, not_prime
	addi $t0,$t0,1
	bne $t0, %x, loop_check_prime
	addi $s7,$zero ,1 # it is prime ; set s1 ; branch to end
	b end
       not_prime:
	li $s7, 0
       end:
.end_macro

.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	print_string(enter)
.end_macro

.text
	main:
	  la $s0 , number
     	  li $v0, 5  # get input
          syscall
          move $s1, $v0 # s1 = number
          sw $s1,0($s0) 
          
  
          add $s0,$zero,$s1 # number in hop
          li $s1, 0 #shows the turn 0 = computer; 1 = user 
          li $s2, 2
        loop:
          addi $s0,$s0, 3 #current number in hop
          
          div $s1,$s2
          mfhi $t0 #check who's turn is it
          bne $t0 , $zero , user_turn 
          addi $s1,$zero, 1 #change the turn 
          
          check_prime($s0)
          bne $zero,$s7, print_hop # is prime
          print_int($s0)
          b continue
        print_hop:
          print_string(hop)
          print_string(enter)
          b continue
        user_turn:
          add $s1,$zero,0
          check_prime($s0)
          bne $zero,$s7, check_hop # is prime
       check_number:   
          li $v0, 5  # get input
          syscall 
          bne $v0, $s0 , end
          b continue
       check_hop:
          li $v0, 8       # take in input
    	  la $a0, user_input  # load byte space into address
    	  li $a1, 100      # allot the byte space for string
   	  move $t0, $a0   # save string to t0
    	  syscall
    	check_equallity:
    	  la $t0, hop
    	  la $t1, user_input  
    	  li $t2 ,3 #count of loop
    	 loop_equality:  #check input equals to hop
    	  lb $t3, ($t0)
    	  lb $t4, ($t1)
    	  bne $t3, $t4 , end
    	  addi $t1 ,$t1,1
    	  addi $t0,$t0,1 
    	  addi $t2,$t2,-1
    	  bgtz $t2 , loop_equality
          
       continue: 
          b loop   
        
          
        end:
          print_string(lose)    
          
        addi $v0, $zero , 10
        syscall   
          
         
