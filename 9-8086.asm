include 'emu8086.inc'

    
ORG    100h
    
    lea di, string
    mov dx, 100
    call get_string

    
    call get_length 

    call find_mirror
    

    mov ax , first_memory_index_of_max
    mov bx , max_length
    sub ax,bx
    add ax, 1    
    mov start_param, ax
    mov len_param, bx   
    call CLEAR_SCREEN
    call print_string_from_address
    
   
    
    
    
           
    RET
     string                    db 100 dup(0)
     string_length             dw 0
     max_length                dw 0
     first_memory_index_of_max dw 0 
     start_param               dw 0
     end_param                 dw 0
     len_param                 dw 0
     ax_r dw 0
     bx_r dw 0
     cx_r dw 0
     dx_r dw 0
     si_r dw 0
     di_r dw 0
     
    
    print_string_from_address proc
       mov bx, len_param
	   mov si, start_param 
	   mov cx, 0
      loop_print:
      	mov al, [si]
	    mov ah, 0eh
	    int 10h 
        
        inc si
        inc cx
        cmp cx, bx
        jne loop_print 
  
    ret
    endp
    
    get_length proc
       lea si ,string
      loop_:
        mov bl,[si]
        cmp bl, 0 
        je  end_
        inc si
        jmp loop_
      end_:
        lea di, string
        sub si,di ;si now contains the length of the string
        mov string_length, si       
    ret
    endp  
    
    check_mirror proc 
      mov ax_r, ax
      mov bx_r,bx  
      mov cx_r,cx
      mov dx_r,dx
      mov si_r,si
      mov di_r,di 
      
    
           
      lea si, string
	  add si, start_param  ; si = start + address_of_string 
	  lea di, string
	  add di, end_param ; end = end + address_of_string 	  
	  
	  mov cx, 0
    loop_for_check:
	  mov al, [si] ; get first char
	 
	  mov bl,[di] ; get last char 
      
      cmp al, bl
	  jne end_false ; compare 
      
      
 
      
	  
	  inc si    ; move index of first forward  
	  sub di, 1 ; move index of last backward
	  inc cx    ; increase the counter  
	  mov dx, len_param 
	  cmp cx, dx
	  jne loop_for_check ; check the end condition
	 
	  ;it was mirrored
	  mov dx , max_length 
	  cmp len_param, dx  
	  
	  
	  jle end_false   
	  
	  
	 
	 
	  sub si, 1
	  ; find greater mirrored substring   
	  mov ax, len_param
	  mov  max_length, ax
	  mov first_memory_index_of_max ,si  
    end_false:    
      
      mov di, di_r
      mov si, si_r
      mov dx, dx_r
      mov cx, cx_r
      mov bx, bx_r
      mov ax, ax_r
      
    ret
    endp
         
    find_mirror proc
       	lea si, string
	    mov ax, string_length  ; n
	    add ax, 1 ; we want to get length = n too  so add it 1 
	    mov cx, 1; shows the length
                                                                               
      loop_find_mirror:  
        mov ax, string_length  ; n  
        add ax, 1
        mov bx, ax
        sub bx, cx   ;bx = n - len  bx shows last index
	    mov dx, 0 ; for indexing
      inner_loop2:
        mov di, dx
        add di, cx
        sub di, 1 ; di = i + len -1 

        mov start_param, dx
        mov end_param, di
        mov len_param, cx
        call check_mirror    
          
        add dx, 1 ; dx +=1
        cmp dx,bx
        jne inner_loop2

	    add cx, 1
	    cmp cx, string_length 
	    jle loop_find_mirror ; from len 1 to n
    
    ret
    endp
    
    DEFINE_CLEAR_SCREEN
    DEFINE_GET_STRING         
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END