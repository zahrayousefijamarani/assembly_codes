include 'emu8086.inc'

    
ORG    100h

    call scan_num
    mov n, cx 
  
    ; function call 
    mov ax ,1 ; output
    mov bx , cx ; input
    call func
    
    ;get the answer of f(input)
    call print_num ; print the answer     
   
           
    RET
    n dw 0
    arg dw 0
    pass_param dw 0 
     
    func proc
        cmp bx ,1
        je end_ 
        push bx
        dec bx
        call func
        pop bx
        add ax ,1 ; should be divided to bx
        mov dx,0
        div bx
        add dx,1; reminder+1
        
        mov ax, dx  
        end_:
    ret
    endp
             
    DEFINE_PRINT_STRING         
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END