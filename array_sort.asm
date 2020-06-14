DATASEG SEGMENT
    ARRAY: DW 2,5,3,6,3,8,7,77,43,24,1,0,12,34,54
    COUNT: DW 15
    
DATASEG ENDS


STACKSEG SEGMENT
    DW 128 DUP(0)
    
STACKSEG ENDS


CODESEG SEGMENT
    START:
     MOV AX, DATASEG
     MOV DS, AX
     MOV ES, AX
     MOV AX, STACKSEG
     MOV SS, AX
     
     MOV SI , 0    ; SI = FIRST INDEX
     MOV DI , 0    ; DI = SECOND INDEX
     
     LEA BX , ARRAY
   OUT_LOOP:  
     MOV CX, [BX][SI]
     MOV DI, 0
   INNER_LOOP:  
     MOV DX, [BX][DI]
     CMP CX, DX
     JL COUNINUE 
     MOV [BX][SI],DX
     MOV DX, CX
     MOV CX, [BX][SI]
     
   COUNINUE:  
     ADD DI , 2
     CMP DI , COUNT
     JL INNER_LOOP 
     ADD SI , 2
     CMP SI , COUNT
     JL OUT_LOOP
     
     MOV AX, 4C00H
     INT 21H
     
CODESEG ENDS
    END START