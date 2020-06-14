include 'emu8086.inc'

    
ORG    100h

    ;CODE
    
    ; get n   
    call scan_num
    mov ch, 0
    mov n, cl
     
       
       
    mov si, 0
    
     
    mov dh, 0         ; row
	mov dl, 0         ; column


       
       
GETMATRIX:  
    ; set cursor position for better code analyzing 
    add dh, 2
    mov x, dl
    mov y, dh
    GOTOXY x, y
	          
    ;mov bx, offset matrix	          
    call scan_num
    mov ch, 0  
    mov matrix[si], cl  

    add si, 1
                        
    add dl, 2
    mov al, n
    mov cl, 2
    mul cl
    cmp dl, al
    jne NOTEQUALTON            
    mov dl, 0
    add dh, 2

NOTEQUALTON:
    sub dh, 2
    cmp dh, al     
    jne GETMATRIX  
    
    
    
 
 

     
    ;PRINTMATRIX offset matrix

                               
    ; get r
    GOTOXY 12, 0   
    call scan_num  
    mov r, cl
    
    ; get c     
    GOTOXY 14, 0
    call scan_num 
    mov c, cl
    
    mov bl, r
    mov cl, c 
    lea si, matrix    
        
 
    RET
    n db ?  ; size of matrix
    matrix db 10000 dup(?)
    aug_matrix db 10000 dup(?) 
    buff db 10 dup('0')
    x db 0
    y db 0 
    s db 0
    r db 0
    c db 0
    matrix_address dw 0   
    
    PRINTMATRIX macro
    push si
    push ax
    push bx
    push cx
    push dx
    
    call CLEAR_SCREEN
    mov si, 0
    mov dh, 0   ; row
    mov dl, 0   ; column    
    
LOOPFORPRINTMATRIX:
    
    ; set cursor location
    mov x, dl
    mov y, dh
    gotoxy x, y
	; end cursor location
	
	;mov bx, offset matrix
	mov ax, 0
	mov al, matrix[si]
    call print_num         
    add si, 1
    
    ; change cursor location           
    add dl, 2 
    mov ax, 0
    mov al, n
    mov cl, 2
    mul cl
    cmp dl, al
    jne NOTEQUALTONPRINTMATRIX            
    mov dl, 0
    add dh, 2

NOTEQUALTONPRINTMATRIX:
    cmp dh, al     
    jne LOOPFORPRINTMATRIX   

    
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
      

endm                      
                


CHANGEROW macro s, r, c, matrix_address    ; s, r, c should be byte, matrix_address should be word
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov s_in_loop, s
    mov r_in_loop, r
    mov c_in_loop, c     
    mov si, matrix_address
    mov cx, 0
    mov cl, n                      ; cx is counter 
    mov ax, 0
    mov al, s_in_loop
    mul n
    mov s_in_loop, al
    mov ax, 0
    mov al, r_in_loop
    mul n  
    mov r_in_loop, al

    

LOOPFORROW:
    mov bx, 0   
    mov bl, r_in_loop
    mov al, byte ptr[si][bx] 
    mov dx, 0
    mov dl, c_in_loop 
    imul dl  
    mov bx, 0
    mov bl, r_in_loop
    add al, byte ptr[si][bx]
    mov byte ptr[si][bx], al
    add bx, 1
    mov r_in_loop, bl
    mov bl, s_in_loop
    add bx, 1       
    mov s_in_loop, bl
    loop LOOPFORROW 
   
    
    
    
    PRINTMATRIX
    
    s_in_loop db ?
    r_in_loop db ?
    c_in_loop db ?   
          
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
endm          

CHANGEROW_PROC PROC
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov s_in_loop, s
    mov r_in_loop, r
    mov c_in_loop, c     
    mov si, matrix_address
    mov cx, 0
    mov cl, n                      ; cx is counter 
    mov ax, 0
    mov al, s_in_loop
    mul n
    mov s_in_loop, al
    mov ax, 0
    mov al, r_in_loop
    mul n  
    mov r_in_loop, al

    

LOOPFORROW:
    mov bx, 0   
    mov bl, r_in_loop
    mov al, byte ptr[si][bx] 
    mov dx, 0
    mov dl, c_in_loop 
    imul dl  
    mov bx, 0
    mov bl, r_in_loop
    add al, byte ptr[si][bx]
    mov byte ptr[si][bx], al
    add bx, 1
    mov r_in_loop, bl
    mov bl, s_in_loop
    add bx, 1       
    mov s_in_loop, bl
    loop LOOPFORROW 
   
    
    
    
    PRINTMATRIX
    
    s_in_loop db ?
    r_in_loop db ?
    c_in_loop db ?   
          
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
RET    
ENDP          

    

CROSSAROW macro r, c, matrix_address    ; r, c should be byte, matrix_address should be word
    push ax
    push bx
    push cx
    push dx
    push si
    push di 
    
    mov r_in_cross, r
    mov c_in_cross, c     
    mov si, matrix_address
    mov cx, 0
    mov cl, n                      ; cx is counter 
    mov ax, 0
    mov al, r_in_cross
    mul n  
    mov r_in_cross, al
    
LOOPFORMULTIPLY:
    mov bx, 0 
    mov bl, r_in_cross
    mov al, byte ptr[si][bx]
    imul c_in_cross  
    mov byte ptr[si][bx], al
    inc r_in_cross
    loop LOOPFORMULTIPLY 
   
    
    PRINTMATRIX        
    
    r_in_cross db ?
    c_in_cross db ? 
         
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax 

endm   


CROSSAROW_PROC proc ; r, c should be byte, matrix_address should be word
    push ax
    push bx
    push cx
    push dx
    push si
    push di 
    
    mov r_in_cross, r
    mov c_in_cross, c     
    mov si, matrix_address
    mov cx, 0
    mov cl, n                      ; cx is counter 
    mov ax, 0
    mov al, r_in_cross
    mul n  
    mov r_in_cross, al
    
LOOPFORMULTIPLY:
    mov bx, 0 
    mov bl, r_in_cross
    mov al, byte ptr[si][bx]
    imul c_in_cross  
    mov byte ptr[si][bx], al
    inc r_in_cross
    loop LOOPFORMULTIPLY 
   
    
    PRINTMATRIX        
    
    r_in_cross db ?
    c_in_cross db ? 
         
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax 

ret
endp

             
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END