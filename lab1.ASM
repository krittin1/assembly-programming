STACK  SEGMENT  STACK
  DW  32  DUP(?)
STACK  ENDS

DATA  SEGMENT
DAD  DW (?) 
MOM  DW (?) 
SON  DB (?)
DAUGHTER DB (?)
DATA  ENDS
CODE    SEGMENT
        ASSUME CS:CODE,DS:DATA,SS:STACK
FIRST   PROC
        MOV DAD,179          ; move 179 to DAD 
        MOV MOM,162          ; move 162 to MOM
        MOV AX,DAD           ; assign DAD to  register AX
        MOV BX,MOM           ; assign MOM to  register AX
        ADD AX,BX            ; AX+BX= 179+162 = 341
        MOV CL,2             ; add 2 to CL
        DIV CL               ; use DIV with unsigned >> divide AX/CL = 341/2
        MOV DL,6             ; add 6 to DL
        ADD AL,DL            ; keep result in AL from AX/CL because When divide AX, int result keep in AL>> AL+DL = 170+6 = 176
        MOV SON,AL           ; assign source to destination >> SON = AL
        MOV AX,DAD           ; assign AX = DAD
        MOV BX,MOM           ; assign BX = MOM
        ADD AX,BX            ; AX+BX = 179+162 = 341
        DIV CL               ; divide AX/CL = 341/2
        SUB AL,DL            ; AL = 170.5 >> 170 so we AL-DL = 170-6 = 164
        MOV DAUGHTER,AL      ; assign DAUGHTER to register AL
        MOV AH,4CH           
        INT 21H
FIRST  ENDP
CODE  ENDS
END FIRST
