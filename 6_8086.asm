include 'emu8086.inc'

    
ORG    100h

    	
	call scan_num 
	mov	number_of_whites, cx
	mov	as_s_zero, cx 
	lea ax, xy_color
	mov	as_s_one, ax 	
	mov	as_s_two, 0	; color

loop_for_getting_points:
	call scan_num
	mov si , as_s_one
	mov [si], cx	  ; x
	
	call scan_num
	mov [si+2],cx	; y

	move_memory_to_memory	[si+4], as_s_two ; color
	
	add	as_s_one, 6
	sub	as_s_zero, 1
	cmp as_s_zero, 0
	jne	loop_for_getting_points 
	cmp as_s_two, 1
	je	sort
	
	mov	as_t_eight, 0
	call scan_num  
	mov number_of_blacks, cx  
	mov as_s_zero, cx
	
	mov	as_s_two, 1
	jmp	loop_for_getting_points

sort: 
    lea ax, xy_color
	mov	as_s_zero, ax   
	move_memory_to_memory as_s_one, number_of_whites

	
	move_memory_to_memory as_t_zero, number_of_blacks
    
    mov ax, number_of_blacks
	add	as_s_one, ax  
	mov ax, as_s_one
	mov dl, 6
	mul dl
	mov	as_s_one,ax
	mov bx, as_s_one
	mov	as_t_nine, bx
	mov	as_t_zero, 0   
	mov	as_t_one, 0		; i
	add	as_t_one, 6	; j
	
sort_x_or_y:
    mov ax, as_s_zero
	mov	as_t_two, ax	; array[i]  
	mov bx, as_t_zero
	add	as_t_two, bx 
	mov cx, as_t_eight
	add	as_t_two, cx 
	mov si, as_t_two
	move_memory_to_memory	as_t_four, [si]
	
	mov ax, as_s_zero
	mov	as_t_three, ax		; array[j]
	mov bx, as_t_one
	add	as_t_three, bx  
	mov cx, as_t_eight
	add	as_t_three,  cx 
	mov si, as_t_three
	move_memory_to_memory	as_t_five, [si]
	mov ax, as_t_five
	cmp as_t_four,ax
	jle	continue
	
	; swap
	mov ax, as_t_eight
	sub	as_t_two,  ax
	sub	as_t_three, ax  
	mov si, as_t_two 
	mov di, as_t_three
	move_memory_to_memory	as_t_four, [si]
	move_memory_to_memory	as_t_five, [di]	
	move_memory_to_memory	[si] ,as_t_five
	move_memory_to_memory	[di] ,as_t_four
	
	move_memory_to_memory	as_t_four, [si+2]
	move_memory_to_memory	as_t_five, [di+2]	
	move_memory_to_memory	[si+2] ,as_t_five
	move_memory_to_memory	[di+2] ,as_t_four
	
	move_memory_to_memory	as_t_four, [si+4]
	move_memory_to_memory	as_t_five, [di+4]	
	move_memory_to_memory	[si+4] ,as_t_five
	move_memory_to_memory	[di+4] ,as_t_four
	
continue:
	add	as_t_one, 6  
	mov ax, as_s_one 
	cmp as_t_one, ax
	jl	sort_x_or_y
	add	as_t_zero, 6
	mov ax, as_t_zero
	mov	as_t_one, ax
	add	as_t_one, 6 
	mov bx, as_s_one
	cmp as_t_one, bx
	jge	out_  
	mov cx, as_s_one
	mov	as_s_two, cx
	sub	as_s_two, 1
	mov ax, as_s_two
	cmp as_t_zero , ax
	jl	sort_x_or_y	
	
out_:

	; here we have sorted with x
	move_memory_to_memory	as_s_zero, number_of_whites ;total number of whites
	move_memory_to_memory	as_s_one, number_of_blacks  ; total number of blacks
	mov ax, as_s_zero
	mov	as_s_two, ax  
	mov ax, as_s_zero
	cmp as_s_one, ax
	jge	condition 
	mov bx, as_s_one
	mov	as_s_two, bx			; we have minimum in as_s_two

condition:     
    lea ax, xy_color
	mov	as_s_three, ax		    ; address
	mov	as_s_four, -10000	    ; x || y > very small number		# number is smaller
	mov ax, as_s_three
	mov	as_t_zero, ax
	mov bx, as_t_eight
	add	as_t_zero, bx 
	mov si, as_t_zero
	move_memory_to_memory	as_s_five, [si]		    ; x || y < as_s_five			# number is greater
	mov	as_s_six, 0			    ; number of whites
	mov	as_s_seven, 0			; number of blacks
	mov ax, as_s_three
	add	as_t_nine, ax
	

loop_for_check: 
    mov ax, as_s_three
	mov	as_t_zero, ax
	mov cx, as_t_eight
	add	as_t_zero, cx
	mov si, as_t_zero
	move_memory_to_memory	as_t_zero, [si]   
	mov bx, as_s_five 
	cmp as_t_zero,bx
	jne	calculate 
	mov ax, as_t_nine
	mov	as_t_two, ax
	sub	as_t_two, 6
	
	mov ax, as_t_two
	cmp as_s_three, ax	
	je	calculate 
	mov si, as_s_three
	move_memory_to_memory	as_t_zero, [si+4]
	add	as_s_six, 1
	
	mov ax, as_t_zero
	sub	as_s_six, ax
	add	as_s_seven, ax
	add	as_s_three, 6
	mov bx, as_s_three
	cmp bx, as_t_nine	
	jne	loop_for_check
calculate:
    mov ax, as_s_zero
	mov	as_t_zero, ax
	mov bx, as_s_six
	sub	as_t_zero, bx 
	mov cx, as_s_seven
	add	as_t_zero, cx 
	mov cx, as_s_two
	cmp as_t_zero, cx
	jl  change1
	jmp 	next_calculate
change1: 
    mov ax, as_t_zero
	mov	as_s_two, ax 
	mov bx, as_s_three
	mov	as_t_zero,bx  
	mov cx, as_t_eight
	add	as_t_zero, cx
	
	mov si, as_t_zero
	move_memory_to_memory	as_s_four, [si-6]
	move_memory_to_memory	as_s_five, [si]  
	
next_calculate: 
    mov ax, as_s_six
	mov	as_t_zero, ax 
	mov bx, as_s_one
	add	as_t_zero, bx
	mov cx, as_s_seven
	sub	as_t_zero, cx 
	mov bx, as_t_zero
	cmp bx, as_s_two
	jl	change2
	jmp	next_check
change2:
    mov ax, as_t_zero
	mov	as_s_two, ax
	mov bx, as_s_three
	mov	as_t_zero, bx
	mov ax, as_t_eight
	add	as_t_zero, ax
	mov si, as_t_zero
	move_memory_to_memory	as_s_four, [si-6]
	move_memory_to_memory	as_s_five, [si]
next_check:  
    mov di, as_s_three
	move_memory_to_memory	as_t_zero, [di+4]
	add	as_s_six, 1   
	mov ax, as_t_zero
	sub	as_s_six, ax
	mov bx, as_t_zero
	add	as_s_seven, bx
	add	as_s_three, 6   
	mov dx, as_s_three
	cmp dx, as_t_nine
	jl  loop_for_check
	
	mov ax, as_s_four
	call print_num
	
	cmp as_t_eight, 2
	je	y
	
	lea si, msg1          ; prnit mesage 1
	call print_string
	jmp	x
	
y:
	lea si, msg2
	call print_string     ; print mesage 2
	
x:
	mov ax, as_s_five
	call print_num
	
	mov al, ' '           ; print space
	mov ah, 0eh
	int 10h

	mov ax, as_s_two
	call print_num  
	
	mov al, 10
	mov ah, 0eh
	int 10h   
	
	mov al, 13
	mov ah, 0eh
	int 10h
	
	
    cmp as_t_eight, 2
	je	y_divide_x
	mov	as_t_eight, 2
	jmp	sort
	
y_divide_x:
    lea ax, xy_color
	mov	as_s_zero, ax
	move_memory_to_memory	as_s_one, number_of_whites
	move_memory_to_memory	as_t_zero, number_of_blacks   
	mov ax, as_t_zero
	add	as_s_one, ax
	mov ax, as_s_one
	mov dl, 6
	mul dl
	mov	as_s_one, ax  
	mov bx, as_s_one
	mov	as_t_nine, bx
	mov	as_t_zero, 0
	mov	as_t_one, 0         	; i
	add	as_t_one, 6		    ; j
	
sort_div:    
    mov ax, as_s_zero
	mov	as_t_two, ax     ; array[i] 
	mov bx, as_t_zero
	add	as_t_two, bx  
	
	mov si, as_t_two
	move_memory_to_memory	as_t_four, [si]
	move_memory_to_memory	as_t_six, [si+2] 
	
	mov ax, as_s_zero 
	mov	as_t_three,ax		; array[j] 
	mov bx, as_t_one
	add	as_t_three, bx
	mov si, as_t_three
	move_memory_to_memory	as_t_five, [si]
	move_memory_to_memory	as_t_seven, [si+2]
	
	cmp as_t_five, 0
	je	continue_div
	mov ax,as_t_four  
	mov bx, as_t_seven
	mul bx
	mov as_t_seven, ax
	
	mov ax,as_t_five
	mov bx, as_t_six
	mul bx
	mov as_t_six, ax

	mov ax, as_t_seven
	cmp as_t_six, ax	
	jle	continue_div
	
	; swap
	mov si, as_t_two
	mov di, as_t_three
	move_memory_to_memory [si], as_t_five
	move_memory_to_memory [di], as_t_four
	move_memory_to_memory	as_t_four, [si+2]
	move_memory_to_memory	as_t_five, [di+2]
	move_memory_to_memory [si+2],	as_t_five
	move_memory_to_memory	[di+2], as_t_four
	move_memory_to_memory	as_t_four, [si+4]
	move_memory_to_memory	as_t_five, [di+4]
	move_memory_to_memory [si+4], as_t_five
	move_memory_to_memory	[di+4], as_t_four
	
continue_div:
	add	as_t_one, 6  
	mov ax, as_s_one
	cmp as_t_one ,ax
	jl	sort_div
	add	as_t_zero, 6
	mov bx , as_t_zero
	mov	as_t_one, bx
	add	as_t_one, 6 
	mov bx ,as_s_one
	cmp as_t_one, bx
	jge	out_div 
	mov cx, as_s_one
	mov	as_s_two, cx
	sub	as_s_two, 1  
	mov ax, as_t_zero
	cmp ax, as_s_two
	jl	sort_div	
	
out_div:
	; here we have sorted with x
	move_memory_to_memory	as_s_zero, number_of_whites ; total number of whites
	move_memory_to_memory	as_s_one, number_of_blacks  ; total number of blacks 
	mov ax, as_s_zero
	mov	as_s_two, ax
	mov bx, as_s_zero
	cmp as_s_one, bx
	jge	condition_div 
	mov cx, as_s_one
	mov	as_s_two, cx 			; we have minimum in as_s_two

condition_div:
    lea ax, xy_color
	mov	as_s_three, ax			; address
	mov	as_s_four, -10000	; y > very small number		# number is smaller
	mov	as_t_four, 1  
	mov ax, as_s_three
	mov	as_t_zero, ax
	mov si, as_t_zero
	move_memory_to_memory	as_s_five, [si] 	    ; y < as_s_five			# number is greater
	move_memory_to_memory	as_t_five, [si+2]
	mov	as_s_six, 0			; number of whites
	mov	as_s_seven, 0			; number of blacks	
	mov ax, as_s_three
	add	as_t_nine, ax	

loop_for_check_div:
    mov si, as_s_three
	move_memory_to_memory	as_t_zero, [si]
	move_memory_to_memory	as_t_one, [si+2] 
	                                      
	mov ax, as_t_five
	mov	as_t_two, ax 
	mov ax, as_t_zero
	mov bx, as_t_two
	mul bx
	mov as_t_two, ax
	mov ax, as_s_five
	mov	as_t_three, ax
	mov ax, as_t_one
	mov bx, as_t_three
	mul bx 
	mov as_t_three, ax
	mov bx, as_t_three
	cmp as_t_two, bx
	jne	calculate_div
	
	mov cx, as_t_nine
	mov	as_t_two, cx
	sub	as_t_two, 6	 
	mov bx, as_s_three
	cmp bx, as_t_two
	je	calculate_div      
	
	
	mov si, as_s_three
	move_memory_to_memory	as_t_zero, [si+4]
	add	as_s_six, 1
	mov bx, as_t_zero
	sub	as_s_six, bx
	mov ax, as_t_zero
	add	as_s_seven, ax
	add	as_s_three, 6	
	mov cx, as_t_nine
	cmp as_s_three, cx
	jne loop_for_check_div
	
calculate_div: 
    mov ax, as_s_zero
	mov	as_t_zero, ax
	mov ax, as_s_six
	sub	as_t_zero,ax
	mov ax, as_s_seven
	add	as_t_zero, ax
	mov cx, as_s_two
	cmp as_t_zero, cx	
	jl	change1_div
	jmp next_calculate_div
change1_div:
    mov ax, as_t_zero
	mov	as_s_two, ax
	mov si, as_s_three
	move_memory_to_memory	as_s_four, [si-6]
	move_memory_to_memory	as_t_four, [si-4]
	move_memory_to_memory	as_s_five, [si]
	move_memory_to_memory	as_t_five, [si+2]  
  
next_calculate_div:
    mov ax, as_s_six
	mov	as_t_zero, ax
	mov ax, as_s_one
	add	as_t_zero, ax   
	mov ax, as_s_seven
	sub	as_t_zero, ax 
	mov cx, as_s_two
	cmp as_t_zero, cx
	jl	change2_div
	jmp	next_check_div
	
change2_div: 
    mov ax, as_t_zero
	mov	as_s_two, ax
	mov bx, as_s_three
	mov	as_t_zero, bx
	mov si, as_t_zero
	move_memory_to_memory	as_s_four, [si-6]
	move_memory_to_memory	as_t_four, [si-4]
    move_memory_to_memory	as_s_five, [si]
	move_memory_to_memory	as_t_five, [si+2]   
  
	
next_check_div:          
    mov si, as_s_three
	move_memory_to_memory	as_t_zero, [si+4]
	add	as_s_six, 1    
	mov ax, as_t_zero
	sub	as_s_six,ax
	mov ax, as_t_zero 
	add	as_s_seven, ax
	add	as_s_three, 6
	mov bx, as_t_nine
	cmp as_s_three, bx
	jl	loop_for_check_div
	
	
	mov ax, as_t_four
	call print_num
	
	mov al, '/'
	mov ah, 0eh
	int 10h

	
	mov ax, as_s_four
	call print_num
	
	
	lea si, msg3
	call print_string
	
	
	mov ax, as_t_five
	call print_num
	
	mov al, '/'
	mov ah, 0eh
	int 10h

	mov ax, as_s_five
	call print_num
	
	lea si, msg4
	call print_string
	
	
	mov	ax , as_s_two
	call print_num 

	jmp end_pro
	
	
	lea ax, xy_color
	mov	as_s_zero, ax 
	mov bx, as_s_zero
	mov	as_s_one, bx
	mov ax, as_t_nine
	add	as_s_one, ax

loop_for_printing_points:
    
    mov si, as_s_zero
    mov ax, [si]
	call print_num
	
	mov al, ' '
	mov ah, 0eh
	int 10h

	
	mov ax, [si+2]
	call print_num   
	
	mov al, 10
	mov ah, 0eh
	int 10h 
	
	mov al, 13
	mov ah, 0eh
	int 10h
	
	add	as_s_zero, 6 
	mov cx, as_s_one
	cmp as_s_zero, cx
	jl	loop_for_printing_points

end_pro:    
    
           
    RET
    number_of_whites dw	0
    number_of_blacks dw	0
    xy_color db 	10000 dup(0)
    ; 	first comes x, then y and finally the color			0: white	1: black
    msg1 db	" < x < ",0
    msg2 db	" < y < " ,0
    msg3 db	"*x < y < ",0
    msg4 db "*x ",0  
    as_t_one dw 0
    as_t_zero dw 0
    as_t_two dw 0
    as_t_three dw 0
    as_t_four dw 0
    as_t_five dw 0
    as_t_six dw 0
    as_t_seven dw 0
    as_t_eight dw 0
    as_t_nine dw 0
    as_s_one dw 0
    as_s_two dw 0
    as_s_three dw 0
    as_s_four dw 0
    as_s_five dw 0
    as_s_six dw 0
    as_s_seven dw 0 
    as_s_zero dw 0
    
    move_memory_to_memory macro a,b
        mov bp , b
        mov a, bp
           
    endm
             
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END