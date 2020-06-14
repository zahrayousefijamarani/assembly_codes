include 'emu8086.inc'

    
ORG    100h

   call scan_num     ; get input
   mov a,cx
   call scan_num
   mov b,cx
   call scan_num
   mov x,cx 
   
   mov ax, b         ;wanna change b
   mov number ,ax
   mov ax, a
   mov base, ax 
   mov s_num,0   
   call change_base_to_decimal
   mov ax, s_num   ; save b in decimal base
   mov b, ax   

   
   mov ax, x         ;wanna change b
   mov number ,ax
   mov ax, a
   mov base, ax  
   mov s_num ,0
   call change_base_to_decimal  
   mov ax, s_num   ; save b in decimal base
   mov x, ax  
   

   mov ax, x         ;wanna change b
   mov number ,ax
   mov ax, b
   mov base, ax  
   mov s_num ,0
   call change_decimal_to_base  
   mov ax, s_num   ; save b in decimal base 
   call CLEAR_SCREEN
   call print_num
 
 
   
    
    
           
    RET
    a dw 0
    b dw 0
    x dw 0 
    base dw 0
    number dw 0 
    s_num dw 0
 
    change_base_to_decimal proc
    
	  mov ax, number  ;move $s1 , %number 
	  mov bx,1 ; powers of base
     division:
      mov dl,10
	  div dl ; divide to get last digit
	  ;ah = reminder
	  ;al = division 
	  mov cx ,ax  ;save ax  
	  
	  mov al,ah
	  mov ah,0
	  mul bx 
	  add s_num, ax
	  
	  mov ax, base
	  mul bx
	  mov bx, ax     ; bx is power of base 

	
	  mov ax , cx; last division is the new number
	  mov ah ,0  
	  cmp ax, 0
	  jne division 
      
    ret
    endp 
    
    change_decimal_to_base proc
        mov bx, 1
        mov ax, number
      division_for_change_base: 
        
        mov dx, base
        div dl        
        ;ah is reminder
      	;al is division 
      	mov cx ,ax
      	
      	mov al,ah
      	mov ah,0    ; ax = reminder
      	mul bx 
        add s_num, ax
        
        mov ax,10
        mul bx
        mov bx,ax
        
        mov ax,cx
        mov ah, 0   
        cmp ax ,0
	    jne division_for_change_base
	
        
    ret
    endp
    
    
    DEFINE_CLEAR_SCREEN         
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END