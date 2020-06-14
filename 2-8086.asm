include 'emu8086.inc'

    
ORG    100h

    call scan_num
    mov n, cx      ; get n
     
    call print_enter 
    
    mov dx, n         ; get string
    inc dx
    lea di, string
    call get_string
	
	call print_enter  
	
	mov ah, 1
	int 21h  
	cmp al ,'c' ; means count
	je count
	;else : replace
	
	call print_enter
	
	call scan_num       ; get a in replace mode
	mov a_int, cx 
	
	call print_enter
	
	call scan_num       ; get b in replace mode
	mov b_int, cx 
	
	call print_enter
	
	mov dx,100          ; get first string length = a
	lea di, a_string
	call get_string 
	
	call print_enter                
	                
	mov dx, b_int      ; get second string length = b
	inc dx
	lea di, b_string
	call get_string 

    call print_enter
    
    
    ;t0 = n
    ; t1= a_int
	lea si, string
	lea	di, a_string  
	add si, n
	add di, a_int 
	mov string_p_n,si   ;t2
	mov a_string_p_a_int,di   ; t3 
	
	lea si, string             ; si =s0 ,  di=s1
find_first_character:
 
    lea di, a_string 
	cmp si,string_p_n
	je	end_ 

	mov	cl, [si]
	mov	ch, [di]
	inc si
	cmp cl, ch
	jne find_first_character
	
	; here we have found first character
	mov as_t_six, si	; save first character
	sub	si, 1
loop_:	
	inc si
	inc di 
	cmp di,a_string_p_a_int
	je	end_
	cmp si,string_p_n
	je	 end_  
	
	mov	cl,[si]
	mov	ch,[di]     
	cmp cl,ch
	jne	 not_equal
	jmp 	loop_
not_equal:
	mov si, as_t_six
	jmp	find_first_character

	
end_:
    cmp di, a_string_p_a_int 	
	jne	 bad_end 
	
	; we have found the string	 
	mov as_t_four, si  
	mov ax, a_int  
	sub as_t_four, ax  
	lea di, string 
	lea bx,b_string ; bx = s2 , s1= di 
	
	mov b_string_p_b_int , bx  
	mov dx, b_int
	add b_string_p_b_int, dx  ; s3


loop_for_print_replace:
    cmp di, string_p_n    ; v1 = di
	je	bad_end
	cmp di, as_t_four
	je	print_b 
	
	mov	al, [di]        ; print!!!
	mov ah, 0eh
	int 10h
	
	inc di 
	cmp di, as_t_four
	jne	loop_for_print_replace 
	
 ;   lea si , b_string ; remove it
 ;   lea di, b_int

print_b:
loop_for_print_b:
	mov	al, [bx]       ; print!!!
	mov ah, 0eh
	int 10h
	
	inc bx 
	cmp bx,  b_string_p_b_int
	jne	loop_for_print_b
	mov dx, a_int 
	add as_t_four, dx
	mov di, as_t_four
	lea dx, string
	mov as_t_four, dx
	jmp loop_for_print_replace
	
			
count:  
    call print_enter 

	call scan_num
	mov a_int, cx
	
	call print_enter
	
	mov dx, 100 ; a_int does not work :(
	lea di, a_string
	call get_string 
	
	call print_enter
    
	lea	ax, string 
	add ax, n
	mov string_p_n, ax   ; t2
	
	
	lea ax, a_string
	add ax, a_int 
	mov a_string_p_a_int,ax  ;t3
	
	mov cx, 0 ;s0
	 
	lea si, string; v0= si   
	
	

	
	
find_first_character_c: 

	lea	di, a_string;di= v1 
	cmp si, string_p_n
	jge	print_count 
	
	mov	al, [si]
	mov ah, [di]
	
	inc si
	cmp al,ah
	jne	find_first_character_c 
	
	; here we have found first character
	mov	as_t_six, si	; save first character
	sub si,1
loop_c:	
   	inc si
	inc di 

	cmp di, a_string_p_a_int
	jge	next
	
	cmp si,string_p_n
	jge	print_count
	mov	ah, [si]
	mov	al, [di] 
	cmp al,ah

	jne	not_equal_c  
	jmp loop_c  
	
next:	
	inc cx
not_equal_c:
	mov si, as_t_six
	jmp	find_first_character_c
	
	
print_count:
	mov ax, cx
	call print_num

bad_end:
	
	; Exit
    
    
           
    RET
    n dw 0 
    string_p_n dw 0 
    b_string_p_b_int dw 0
    a_string_p_a_int dw 0
    string db 200 dup(0)
    a_int dw 0
    a_string db 200 dup(0)
    b_int dw 0
    b_string db 200 dup(0),0   ; end data                                                                                           "
    as_t_six dw 0 
    as_t_four dw 0
    save_di dw 0                             
                                  
    
    print_enter proc
      mov al, 10     ;print enter
      mov ah, 0eh
	  int 10h
	
	  mov al, 13
	  mov ah, 0eh
      int 10h 
     
    ret 
    endp
    
    DEFINE_CLEAR_SCREEN 
    DEFINE_GET_STRING         
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END