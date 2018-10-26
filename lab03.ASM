KRITTIN  KANOKWILAIRAT  5910450026

STACK	SEGMENT	STACK
 DW	64	DUP(?)
STACK	ENDS

DATA		SEGMENT
NAME		DB	20	DUP(?)		
TICKETS		DW	?				
DISCOUNT        DW      ?                        
TOTAL		DW	?				
PRINT		DB	'NAME            TICKETS                 %DISCOUNT                TOTAL (BAHT)',13,10,'-----------------------------------------------------------------------------',13, 10, '$'
BEE             DW      ?
FILENAME        DB      'order.dat',0
MEM                     DB      25 DUP(?)               ; name=20 ,num=3 ,newline=2
RESULT                     DB  '                                                                             ',13, 10, '$'
DATA		ENDS

CODE	SEGMENT	
ASSUME	CS:CODE,DS:DATA,SS:STACK

MAIN PROC			
		MOV AX,DATA
		MOV DS,AX			; initialize data
		MOV AH,3DH			; open file
		MOV AL,0			; read from file
                LEA DX,FILENAME     
		INT 21H
                MOV BEE,AX                   ; file HANDLE in AX

		MOV AH,9
		LEA DX,PRINT
		INT 21H


READ:		MOV AH,3FH
                MOV BX,BEE                   ; HANDLE of file that already opened
		MOV	CX,25			; number of characters
                LEA     DX,MEM                  ; read buffer
		INT 21H

                LEA BX,MEM
                LEA     DI,RESULT
		MOV	CX,20			; num of characters = 20

L1:		MOV AL,[BX]			; move BX to AL
		MOV [DI],AL			; move AL to DI
		INC BX
		INC DI
		LOOP L1

		MOV CX,3
                LEA DI,MEM
		ADD DI,20			; across string to num
		MOV AX,0

ASCtoBIN:	MOV SI,10
		IMUL SI 			; DX:AX = AX*10
		SUB BX,BX
		MOV BL,[DI]			; get ASCII code
		SUB BX,30H
		ADD AX,BX			; update partial result
		INC DI
		LOOP ASCtoBIN

		MOV TICKETS,AX		; move AX to TICKETS => get TICKETS num

		CMP TICKETS, 49
                JBE DICS0
		CMP TICKETS, 199 
		JA DICS10
		CMP TICKETS, 50
		JAE DICS5

DICS0:          MOV DISCOUNT,0
			JMP L2

DICS5:          MOV DISCOUNT,5
			JMP L2

DICS10:         MOV DISCOUNT,10
			JMP L2

L2:		MOV AX,100			; AX = 100
                SUB AX,DISCOUNT                     ; 100 - DISC
		MOV BX,TICKETS			; BX = TICKETS
		MUL BX				; (100 - DISC) * TICKETS
		MOV TOTAL,AX			; TOTAL = (100 - DISC) * TICKETS

                LEA SI,RESULT                                       
		ADD SI,19						
		MOV	AX,TICKETS
            
			CMP AX, 0
			JE STOP					
		
STRTICKET:	MOV	DH,10	
			DIV	DH							
			ADD AH,30H
			MOV	BYTE PTR[SI],AH
			DEC	SI
			MOV AH,0
			CMP AL,0						
			JNE STRTICKET

                        LEA SI,RESULT                                       
			ADD SI,44						
                        MOV     AX,DISCOUNT                  
		
STRDISC:	MOV	DH,10	
			DIV	DH							
			ADD AH,30H
			MOV	BYTE PTR[SI],AH
			DEC	SI
			MOV AH,0
			CMP AL,0						
			JNE STRDISC

                        LEA SI,RESULT                                       
			ADD SI,71						
			MOV	AX,TOTAL
			MOV DX,0					
		
STRTOTAL:	MOV	CX,10	
			DIV	CX							
			ADD DX,30H
			MOV	BYTE PTR[SI],DL
			DEC	SI
			MOV DX,0
			CMP AX,0						
			JNE STRTOTAL

			MOV AH,9
                        LEA DX,RESULT
			INT 21H
                        LEA BX,RESULT
			MOV CX,77
			CALL RESET
			JMP READ

STOP:		MOV AH,3EH
                        MOV BX,BEE           ; handle of existing file
			INT 21H

			MOV AH,4CH
			INT 21H

MAIN	ENDP
RESET	PROC
LRESET:		MOV BYTE PTR[BX],' '
			INC BX
			LOOP LRESET
			RET 

RESET	ENDP
CODE 	ENDS
END 	MAIN






