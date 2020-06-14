include 'emu8086.inc'

    
ORG  100h

          call scan_num  
          mov number, cx

          ;shows the turn 0 = computer; 1 = user   s1  => turn

        loop_: 
          mov bx, number
          add bx, 3
          mov number, bx   ;current number in hop

          mov ax, turn 
          cmp ax ,0   
          jne user_turn_label   
                    

          mov turn, 1 ;change the turn 
                                        
                             
          mov dx, number                              
          mov param, dx
          call CHECK_PRIME
          mov bx, param 
          
          cmp bx ,0
          jne print_hop ; is prime  
          
          mov ax, number
          call print_num ; print number
          mov al, 10  ; print_enter
	      mov ah, 0eh
	      int 10h
	      mov al, 13
	      mov ah, 0eh
	      int 10h
	      
          jmp continue
        print_hop:  
          lea si, hop
          CALL  print_string  
          
          mov al, 10  ; print_enter
	      mov ah, 0eh
	      int 10h
	      mov al, 13
	      mov ah, 0eh
	      int 10h

          jmp continue 
          
        user_turn_label:
          mov turn, 0; change turn 
           
          mov dx, number                              
          mov param, dx
          call CHECK_PRIME
          mov bx, param 
          
   ;       mov ax,bx
  ;         call print_num
          
          jne 0,bx, check_hop ; is prime
       check_number:   
          call scan_num 
          mov bx, number
          cmp cx, bx
          jne end_pro
          jmp continue
       check_hop:
          mov bx, 3
          lea di, user_input
          call GET_STRING 
          
    	check_equallity:
    	  lea si, hop
    	  lea di, user_input  
    	  mov cx ,3 ;count of loop
    	 loop_equality:  ;check input equals to hop
    	  mov al, [si]
    	  mov ah, [di]
    	  
    	 
    	  
    	  cmp al, ah
    	  jne end_pro
          inc si
          inc di
    	  loop loop_equality
          
       continue: 
          jmp loop_   
        
          
        end_pro:
          lea si, lose
          CALL  print_string 
           
          
        
    RET
    number     dw 0 
	hop        db 'hop',0
	lose       db 'You Lose :p' ,0
	user_input db 100 dup(' ')  
	turn       dw 0
	param      dw 0
	
	CHECK_PRIME proc ;answer is in stack if  = 0 --> not prime ;  = 1 --> is prime
	    
	    MOV bx, 2
      loop_check_prime: 
        mov ax ,param
        mov dx, 0
       	div bx
       	
       	cmp dx,0 
       	je not_prime ; reminder = 0
	    inc bx 
	    cmp bx,param
	    jne  loop_check_prime
	    mov param, 1 ; it is prime  ; branch to end  
	    jmp end_
      not_prime:
	    mov param,0
       end_:
    ret
    endp
    ;MACRO - PROC
    
    DEFINE_GET_STRING         
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END