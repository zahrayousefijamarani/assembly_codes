include 'emu8086.inc'

    
ORG    100h

	call scan_num     ;scan y
	mov x, cx

	call scan_num     ;scan x            
	mov y, cx   
	
	call scan_num     ; scan obstacle
	mov obstacle_num, cx
	
	lea	si, xy     ; find position= 100y+x
	mov ax,100
	mov bx, y
	mul bx
	add si, ax
	add si, x  

	
    mov al,2
	mov byte ptr[si],al  ; set treasure position   = 2

	mov di , obstacle_num ; use for indexing :(
loop_for_getting_blocks:
	call scan_num
	mov bx,cx ; bx = x
	
	call scan_num  ; cx  = y
	
	
	lea	si, xy 
	add si, bx ; xy + x
	mov ax,100
	mul cx
	add si, ax ; find position 400y + x
	
	mov al,1
	mov [si],al ;set block position   = 1
	
	sub di ,1 
	cmp di ,0
	jne	loop_for_getting_blocks
	 
	 
    lea di, xy 
    mov bx, 0
while_not_destination:
	mov ah, 1  ; get input                  ; not change bx , di
	int 21h
	
	cmp al, 'u' 
	je	up
	cmp al, 'd'
	je	down  
	cmp al, 'r'
	je	right
	cmp al, 'l'
	je	left 
	
	mov bx,0
	
up:	
	mov bx, 100
	jmp	change_place
down:
	mov bx, -100
	jmp	change_place
right:
	mov bx, 1
	jmp change_place
left:
	mov bx, -1
	jmp	change_place
	
change_place:  

	add	di, bx
	mov	cl, [di] 
  
	cmp cl, 0
	je	next   ; can move
	cmp cl , 2 ; find treasure
	je	end_
	
	mov al,10
	mov ah, 0eh
	int 10h   
	
	mov al, 13   ; go nextline
	mov ah, 0eh
	int 10h 
	           ; can not move:( block is here
	lea si, msg1
	call PRINT_STRING 
	
	mov al,10
	mov ah, 0eh
	int 10h   
	
	mov al, 13   ; go nextline
	mov ah, 0eh
	int 10h 
	
	sub	di,bx
	jmp	while_not_destination


next:	
	mov al, 10
	mov ah, 0eh
	int 10h   
	
	mov al, 13   ; go nextline
	mov ah, 0eh
	int 10h
	
	lea si, xy
	sub si, di
	neg si  ; si = ekhtelaf
	; di = 100 y +x 
	mov ax, si
	mov cx, 100
	mov dx, 0
	div cx  ; ax = division, dx = reminder= a0

	mov cx, ax
	mov ax, dx      ;print x
	call print_num
	
	mov al, 32      ; print space
	mov ah, 0eh
	int 10h   
	 
	mov ax,cx       ; print y
	call print_num
	
	; go nextline
	mov al, 10
	mov ah, 0eh
	int 10h   
	
	mov al, 13   
	mov ah, 0eh
	int 10h 
	
	jmp	while_not_destination
	
	
end_:
    mov al, 10
	mov ah, 0eh
	int 10h   
	
	mov al, 13   ; go nextline
	mov ah, 0eh
	int 10h
	
	lea si, xy
	sub si, di
	neg si  ; si = ekhtelaf
	; di = 100 y +x 
	mov ax, si
	mov cx, 100
	mov dx, 0
	div cx  ; ax = division, dx = reminder= a0

	mov cx, ax
	mov ax, dx      ;print x
	call print_num
	
	mov al, 32      ; print space
	mov ah, 0eh
	int 10h   
	 
	mov ax,cx       ; print y
	call print_num
	
	; go nextline
	mov al, 10
	mov ah, 0eh
	int 10h   
	
	mov al, 13   
	mov ah, 0eh
	int 10h 
    
	lea	si, msg2
	call PRINT_STRING  
	
	mov ah, 0eh
	int 10h   
	
	mov al, 13   ; go nextline
	mov ah, 0eh
	int 10h
	
           
    RET
    xy      db 	10000 dup(0)
    x dw 0
    y dw 0
    msg1	db	"can't move, obstacle ahead",0
    msg2	db	"reached treasure!",0 
    obstacle_num dw 0 
    s dw 0 
    x_now dw 0
    y_now dw 0

    
    ;MACRO - PROC
             
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END