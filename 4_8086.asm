include 'emu8086.inc'

    
ORG    100h

    start_pro:
           call scan_num  
           
        ;   call print_enter 
         ;  mov bx, head_address 
          ; mov ax,[bx]
           ;call print_num 
           
           call print_enter 
           
           cmp cx, 1
           je add__first_label 
           
           cmp cx,2
           je add_last_label
            
           cmp cx,3
           je add_a_after_b_label
           
           cmp cx, 4
           je delete_a_label 
           
           cmp cx,5
           je find_a_label   
           
           cmp cx,6
           je print_label
           
           cmp cx,7
           je end_pro
           
        add__first_label:
           call scan_num ; get a 
           call print_enter 
           call add_first_list ; cx is parameter
           jmp start_pro
           
        add_last_label:
           call scan_num ; get a  
           call print_enter 
           call add_last_list  ; cx is parameter
           jmp start_pro
          
        add_a_after_b_label:
           call scan_num ; get a  = dx
           call print_enter 
           mov dx, cx
           
           call scan_num ; get b  = cx 
           call print_enter 

           call add_a_after_b
           jmp start_pro
          
        delete_a_label:
          call scan_num
          call print_enter 
          call delete_a  ; cx is parameter
          jmp start_pro
          
        find_a_label:
          call scan_num
          call print_enter 
          call find_a ; cx is parameter
          jmp start_pro
          
        print_label:
          call print_func
          jmp start_pro
        
        end_pro:
          
           
    RET
    head_address dw 0  ; first value = value ; seconed = last pointer ; third = next pointer  
	tail_address dw 0 
	count dw 0        
	a_param dw 0
	b_param dw 0
	space db 100 dup(0) 
	save_b dw 0   
	
	print_enter proc
	    mov al, 10
	    mov ah, 0eh
	    int 10h

	    
	    mov al, 13
	    mov ah, 0eh
	    int 10h
	    
	ret
	endp

    add_first_list proc   
       ; cx is parameter 
       mov bx , 6     ; allocate memory
	   mov ah, 48h     ; 6 bytes 
	   int 21h         ; ax = address
	   mov bx, ax  ; bx = address
                
	   
	   mov [bx], cx ; as value
	   mov [bx+2], 0

	
	   mov ax, head_address  ; bx= s1 =@ new node ; ax= s2 =@ old first node
	   cmp ax, 0
	   je add_first_node ; is first node
	
	   mov [bx+4],ax ; save last head as next for new node

	   ; set last node of last head
	   mov bp, ax
	   mov [bp+2], bx

     add_first_node:
        mov head_address,bx 
        cmp ax, 0
        jne increase_count 
        mov tail_address, bx
   
     increase_count:	
	    add count, 1
    
    ret
    endp
    
    add_last_list proc  
       ; cx is parameter 
       mov bx , 6     ; allocate memory
	   mov ah, 48h     ; 12 bytes 
	   int 21h         ; ax = address
	   mov bx, ax  ; bx = address           
	   
	   mov [bx], cx  ; save value
	   mov [bx+4], 0
	   
	   mov si, tail_address ;s1= bx =@ new node ; s2= bp =@ old last node 

	   cmp si, 0
	   je set_first_node          
	   mov [bx+2], si ; save last tail as last for new node
       
       mov [si+4], bx ; set next node for old tail
      	
       mov tail_address, bx 
       
	   add count, 1
 	   jmp end_
	
      set_first_node:
	   add count, 1
	                 
	   mov tail_address, bx
	   mov head_address, bx
	
      end_:
 
    ret
    endp
    
    add_a_after_b proc   ; dx = a cx = b   my code works visa versa :/
       mov a_param, cx
       mov b_param , dx
       mov cx, 1 ;counter
	   mov bx, head_address
     loop_del_a:	 
       mov ax, [bx]
	   cmp ax, a_param
	   je a_found  
	   
	   inc cx
       mov bx, [bx+4] 
       cmp cx, count
       jle loop_del_a

     a_found:
       mov si, [bx+2]   ; @last node of a    = si
       mov di, [bx+4]   ; @next node of a    = di
       
       mov save_b,  bx     ; save bx
       mov bx , 6     ; allocate memory
	   mov ah, 48h     ; 6 bytes 
	   int 21h         ; ax = address
	   mov bp, ax  
	   mov ax, b_param
	   mov [bp], ax    
	   mov bx, save_b ; unsave :) bx  
       
       mov [bp+2], bx
       mov [bp+4], di
       mov ax,[bx+4]
       cmp ax, 0
       jne is_not_the_last_one

	   mov tail_address, bp

     is_not_the_last_one:	
       mov [bx+4], bp
	   
	   cmp di, 0
	   je s6_is_the_last
	   mov [di+2], bp
	
     s6_is_the_last: 
       add count ,1
  
    ret
    endp 
    
    delete_a proc
        ; cx is parameter
      	mov dx, 1 ; counter  t0
	    ; $s1, count
	    ; $s2, head_address
	    mov bx, head_address 
	    
      loop_delete_a:	
	    mov ax, [bx]  
	    cmp ax,cx 
	    je delete_label

	    inc dx 
	    mov bx, [bx+ 4] 
	    cmp dx,count
	    jle loop_delete_a
	
     delete_label: ; s2 is the address of a
        cmp dx,1
        je delete_first_node 
        cmp dx, count
        je delete_last_node
        ;  else:
        mov si, [bx+2] ; s5 = address of last  = si
        mov di, [bx+4] ; s6 = address of next  = di
        
        mov [si+4], di

        mov [di+2], si
        
        sub count,1
        jmp end_delete
        
     delete_first_node:
     	mov si,[bx+4] ; address of second 
     	cmp si, 0
     	je list_is_null_first
     	mov [si+2], 0
     list_is_null_first:
        sub count, 1
        mov head_address, si	
        jmp end_delete
     
     delete_last_node:
        mov si, [bx+2] ; address of last node 
        cmp si, 0
        je list_is_null_last
        mov [si+4], 0
        
     list_is_null_last:   
        sub count, 1
        mov tail_address, si        
        jmp end_delete
     
     end_delete:
	  
        
    ret
    endp  
    
    find_a proc 
        ; cx is parameter
       	mov dx, 1  ;counter
	    ; $s1, count
	    ; $s2, head_address
	    mov bx, head_address
      loop_find_a:	
	    mov ax, [bx]
	    cmp ax, cx 
	    je print_rank

	    inc dx
	    mov bx,[bx+4]  
	    cmp dx, count
	    jle loop_find_a
	
      print_rank: ; it is in list else it return 1!	
        mov ax, dx
        call print_num
        
	    mov al, 10
	    mov ah, 0eh
	    int 10h  
	   
        mov al, 13
	    mov ah, 0eh
	    int 10h

    ret
    endp 
    
    print_func proc
       mov cx, 1 ; counter
	   mov bx,  head_address  
     loop_:
       cmp count, 0
       je end_print 
       
       mov ax, [bx]
       call print_num
       
       mov al, 32    ; print space
       mov ah, 0eh
       int 10h
       
       add cx,1
	   
	   mov bx, [bx+4]
       cmp  cx, count
	   jle loop_
       
       mov al, 10   ; print enter
	   mov ah, 0eh
	   int 10h  
	   
       mov al, 13
	   mov ah, 0eh
	   int 10h

	
     end_print: 
        
    ret
    endp
    
    ;MACRO - PROC
             
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END