.data
   n: .word 0

.text
   main:
     la $s0 , n
     li $v0, 5  # get input
     syscall
     move $s1, $v0
     sw $s1,0($s0) 
  
    # function call
    move      $a0, $s1
    jal       recursive      # jump f function and save position to $ra
    move      $t0, $v0       # $t0 = $v0

    li        $v0, 1        # system call #1 - print int
    move      $a0, $t0      # $a0 = $t0
    syscall       
             
    li        $v0, 10       # $v0 = 10
    syscall


.text

recursive:
    addi    $sp, $sp, -8   # adjust stack pointer to store return address and argument
    # save $s0 and $ra
    sw      $s0, 4($sp)
    sw      $ra, 0($sp)
    bne     $a0, 0, else
    
    addi    $v0, $zero, 1    # return 1
    j recursive_return

else:
    # backup $a0 : a0 = n in recursive
    move    $s0, $a0
    addi    $a0, $a0, -1 # x -= 1
    jal     recursive
    # when we get here, we already have f(n) store in $v0
    add $s6, $v0 , 1
    div $s6 , $s0
    mfhi $v0
    add $v0 ,$v0 ,1 # save the answer of return in v0

recursive_return:
    lw      $s0, 4($sp)
    lw      $ra, 0($sp)
    addi    $sp, $sp, 8
    jr      $ra
        
  
     
     
     
   
   
