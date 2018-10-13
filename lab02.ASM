STACK   SEGMENT  STACK
     DW     32   DUP(?)
STACK   ENDS

DATA	SEGMENT
DVDEN   DW      269                     ; DVDEN = 269 size 1 word
DVSOR   DB      7                       ; DVSOR = 7   size 1 byte
N       DB      5 DUP(?)                ; N           size 5 bytes
N2      DB      3 DUP(?)                ; N2          size 3 bytes
N3      DB      5 DUP(?)                ; N3          size 5 bytes
N4      DB      3 DUP(?),'$'            ; N4          size 4 bytes
STR1    DB      ' divided by is '       
STR2    DB      ' is '
STR3    DB      '.'
T       DB      ?
TT      DB      ?
LAST    DW      0
DATA 	ENDS

CODE	SEGMENT
	ASSUME CS:CODE,DS:DATA
FIRST	PROC
        MOV AX,DATA                    ; copy DATA to register AX
        MOV DS,AX                      ; copy register AX to register DS
        LEA BX,N                       ; offset N
        MOV CX,5                       ; copy 5 to register CX
FILL:   MOV BYTE PTR[BX],' '
        INC BX                         ; BX + 1
        LOOP FILL                      
        MOV AX,DVDEN                   ; copy DVDEN to register AX
        MOV DI,10                      ; copy 10 to register DI
NEXT:   CWD                            ; convert word to doubleword
        DIV DI                         ; divide by DI
        ADD DX,'0'                     ; convert to ASCII
        DEC BX                         ; DEC - 1
        MOV [BX],DL                    ; stored char in string
        CMP AX,0                       ; copy 0 to register AX
        JNE NEXT                       ; no,get next digit

        MOV CX,3                       ; copy 3 tp register CX
        LEA BX,N2                      ; offset N2
FILL1:  MOV BYTE PTR[BX],' '           ; fill blank
        INC BX                         ; BX - 1
	LOOP FILL1
        MOV AL,DVSOR                   ; copy DVSOR to register AL
NEXT1:  CWD                            ; convert word to doubleword
        DIV DI                         ; divide  by DI
        ADD DX,'0'                     ; convert to ASCII
        DEC BX                         ; BX - 1
        MOV [BX],DL                    ; stored char in string
        CMP AX,0                       ; compare AX and 0 if not equal jump to NEXT1
        JNE NEXT1                      ; no, get next digit
	
        MOV AX,DVDEN                   ; copy DVDEN to register AX
        DIV DVSOR                      ; divided  by DVSOR
        MOV T,AH                       ; copy register AH to T
        MOV AH,0                       ; copy 0 to register AH
        MOV CX,5                       ; copy 5 to register CX
        LEA BX,N3                      ; offset N3
FILL2:  MOV BYTE PTR[BX],' '           ;
        INC BX                         ; BX + 1
        LOOP FILL2                     
NEXT2:  CWD                            ; convert word to doubleword
        DIV DI                         ; divided by DI
        ADD DX,'0'                     ; convert to ASCII
        DEC BX                         ; BX - 1
        MOV [BX],DL                    ; stored char in string
        CMP AX,0                       ; compare AX and 0 if not equal jump to NEXT2
	JNE NEXT2
	
        MOV AX,DVDEN                   ; copy DVDEN to register AX
        DIV DVSOR                      ; divided by DVSOR
        MOV AL,AH                      ; copy AH to register AL
        MOV AH,0                       ; copy 0 to register AH
        MOV CL,10                      ; copy 10 to register CL
        MUL CL                         ; 
        DIV DVSOR                      ; divided by DVSOR
        MOV TT,AH                      ; copy AH to TT
        MOV AH,0                       ; copy 0 to register AH
        MOV BL,100                     ; copy 100 to register BL
        MUL BL                         ; 
        MOV LAST,AX                    ; copy AX to LAST
        MOV AX,0                       ; copy 0 to register AX
        MOV AL,TT                      ; copy TT to register AL
        MUL CL                         ; 
        DIV DVSOR                      ; divided by DVSOR
        MOV TT,AH                      ; copy AH to TT
        MOV AH,0                       ; copy 0 to register AH
        MOV BL,10                      ; copy 10 to register BL
        MUL BL                         ; 
        ADD LAST,AX                    ; LAST + AX   stored in LAST
        MOV AX,0                       ; copy 0 to AX
        MOV AL,TT                      ; copy TT to register AL
        MUL CL                         ; 
        DIV DVSOR                      ; divided by DVSOR
        MOV AH,0                       ; copy 0 to register AH
        ADD LAST,AX                    ; LAST + AX  stored in LAST
        MOV AX,LAST                    ; copy LAST to register AX
        MOV CX,3                       ; copy 3 to register CX
        LEA BX,N4                      ; offset N4
FILL3:  MOV BYTE PTR[BX],' '           ; 
        INC BX                         ; BX + 1
        LOOP FILL3                     ; 
        CMP AX,0                       ; compare AX and 0 if not equal jump to NEXT3
        JNE NEXT3                      ; 
NEXT3:  CWD                            ; convert word to doubleword
        DIV DI                         ; divided by DI
        ADD DX,'0'                     ; DX + 0 stored in register DX
        DEC BX                         ; BX - 1
        MOV [BX],DL                    ; 
        CMP AX,0                       ; compare AX and 0 if not equal jump to NEXT3
	JNE NEXT3
	
DONE:   MOV AH,9                       ; copy 9 to register AH
        LEA DX,N                       ; offset N
        INT 21H                        ; output result
        MOV AH,4CH                     ; 
        INT 21H                        ; output result
FIRST   ENDP                           ; end of procedure
CODE	ENDS
        END FIRST                      ; end of program
