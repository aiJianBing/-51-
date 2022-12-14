DATA SEGMENT      
    NUM1   DB  03H DUP(0)      
    NUM    DB  03H DUP(0)
DATA ENDS 

STACK SEGMENT        
    DW  100 DUP(0) 
STACK ENDS 

CODE SEGMENT 
    ASSUME CS:CODE,DS:DATA,SS:STACK 
        PORTA  EQU 30H 
        PORTB  EQU 32H 
        PORTC  EQU 34H  
        PORT8255   EQU  36H
       
    MAIN PROC  FAR  
    START: MOV AX,DATA            
        MOV DS,AX             
        MOV DX,PORT8255            
        MOV AL,81H            
        OUT DX,AL           ;送10000001给8255控制器
  LOPL:      
        XOR    AH,AH            
        CALL   KEY            
        CMP    AH,00H           
        JZ     LOPL            
        CMP    AL,0FH            
        JZ     CCCL            
        CMP    AL,0AH           
        JZ     LOPL            
        JNC    LOPL       ;当输入的数大于10的时候，跳到lopl（用于判断输入的数是否大于10）    
        OUT    32H,AL 
   LOPL2:   LEA    SI,NUM   ;将输入的数放到num中，并将ax入栈        
            MOV    [SI],AL            
            PUSH   AX 
   LOPL1:     
            XOR    AH,AH            
            CALL   KEY            
            CMP    AH,00H            
            JZ     LOPL1            
            CMP    AL,0FH            
            JZ     CCCL           
            CMP    AL,0AH            
            JZ     XX1            
            CMP    AL,0BH            
            JZ     XX2            
            CMP    AL,0CH           
            JZ     XX3D            
            CMP    AL,0DH            
            JZ     XX4D            
            JMP    LOPL1 
     CCCL:  
            MOV    AL,00H            
            OUT    32H,AL            
            JMP    LOPL 
     XX3D:      CALL   XX3

    XX4D:      CALL   XX4
    MAIN ENDP  
 XX1  PROC    
         NOP           ;加 
       
 LOPL3:     XOR    AH,AH     
         CALL   KEY      
         CMP    AH,00H         
         JZ     LOPL3         
         CMP    AL,0FH      
         JZ    CCCL         
         CMP    AL,0AH        
         JZ     LOPL3        
         JNC    LOPL3       
         OUT    32H,AL      
         PUSH   AX       
         LEA    SI,NUM   
         MOV    [SI+1],AL   ;将第二个数放入num中
 LOPL4:  
         XOR    AH,AH    
         CALL   KEY        
         CMP    AH,00H     
         JZ     LOPL4     
         CMP    AL,0FH          
         JZ     CCCL           
         CMP    AL,0EH           
         JZ     XXX1           
         JMP    LOPL4 
    XXX1:      
            LEA    SI,NUM          
            MOV    AL,[SI]           
            AND    AL,0FH          
            MOV    DL,[SI+1]          
            AND    DL,0FH           
            ADD    AX,DX           
            DAA             
            OUT    32H,AX            
            JMP    LOPL 
            XX1  ENDP   
 XX2 PROC            
     NOP                             ;减 
 LOPL5:     XOR    AH,AH           
  CALL   KEY            
  CMP    AH,00H  
  

           JZ     LOPL5            
           CMP    AL,0FH            
           JZ    CCCL            
           CMP    AL,0AH            
           JZ     LOPL5            
           JNC    LOPL5            
           OUT    32H,AL            
           PUSH   AX           
            LEA    SI,NUM            
            MOV    [SI+1],AL 
LOPL6:             
            XOR    AH,AH            
            CALL   KEY            
            CMP    AH,00H            
            JZ     LOPL6            
            CMP    AL,0FH            
            JZ    CCCL7           
            CMP    AL,0EH            
            JZ     XXX2           
            JMP    LOPL6 
        XXX2:      
              LEA    SI,NUM            
              MOV    AL,[SI]            
              AND    AL,0FH           
              MOV    DL,[SI+1]            
              AND    DL,0FH           
              SUB    AL,DL           
              ADD    AL,00H           
              DAA            
              OUT    32H,AL            
              JMP    LOPL 
          CCCL7:     
                MOV    AL,00H           
                OUT    32H,AL            
                JMP    LOPL  
                XX2  ENDP  
                XX3  PROC 
LOPL7:     
              XOR    AH,AH             
              CALL   KEY               ;乘            
              CMP    AH,00H            
              JZ     LOPL7            
              CMP    AL,0FH            
              JZ    CCCL2            
              CMP    AL,0AH 

              JZ LOPL7            
              JNC LOPL7           
              OUT 32H,AL           
              PUSH AX            
              LEA SI,NUM            
              MOV [SI+1],AL 
LOPL8:    
              XOR    AH,AH            
              CALL   KEY           
              CMP    AH,00H            
              JZ     LOPL8            
              CMP    AL,0FH            
              JZ    CCCL3            
              CMP    AL,0EH            
              JZ     XXX3           
              JMP    LOPL8 
          XXX3:      
                LEA    SI,NUM             
                
                MOV    AL,[SI]           
                AND    AL,0FH            
                MOV    DL,[SI+1]           
                AND    DL,0FH           
                MUL    DL            
                   ;AAM
                CALL CAAM             
                MOV    CL,4           
                SAL    AH,CL
                              
                OR     AL,AH            
                     
                MOV CL,4
                ROR AL,CL
                     OUT    32H,AL            
                     JMP    LOPL 
            CCCL2:      
                     MOV    AL,00H            
                     OUT    32H,AL            
                     JMP    LOPL 
            CCCL3:      
                     MOV    AL,00H           
                      OUT    32H,AL            
                      JMP    LOPL   
                      XX3  ENDP 
                CAAM:PUSH AX
                MOV BL,0AH
                XOR AH,AH
                DIV BL
                MOV BX,AX
                POP AX
                MOV AX,BX
                
                RET
                XX4  PROC                            ;除 
  LOPL9:     XOR    AH,AH            
             CALL   KEY            
             CMP    AH,00H            
             JZ     LOPL9            
             CMP    AL,0FH            
             JZ    CCCL5            
             CMP    AL,0AH 

           JZ     LOPL9            
           JNC    LOPL9            
           OUT    32H,AL            
           PUSH   AX            
           LEA    SI,NUM            
           MOV    [SI+1],AL 
 LOPL10:    XOR    AH,AH            
            CALL   KEY            
            CMP    AH,00H            
            JZ     LOPL10           
             CMP    AL,0FH            
             JZ    CCCL4            
             CMP    AL,0EH           
              JZ     XXX4            
              JMP    LOPL10 
XXX4:      
              LEA    SI,NUM           
               MOV    AL,[SI]            
               AND    AL,0FH            
               MOV    BL,[SI+1]           
               AND    BL,0FH            
               AND    AX,000FH            
               DIV    BL            
               OUT    32H,AL            
               JMP    LOPL 
 CCCL4:      
               MOV    AL,00H            
               OUT    32H,AL            
               JMP    LOPL 
 CCCL5:      
               MOV    AL,00H           
               OUT    32H,AL            
               JMP    LOPL   
               XX4  ENDP   
     KEY     PROC         
                    NOP          
                    LEA SI,NUM1         
                    MOV AL,0EH         
                    OUT 30H,AL         
                    IN  AL,34H         
                    CMP AL,07H         
                    JZ  LL7         
                    CMP AL,0BH         
                    JZ  LL8         
                    CMP AL,0DH 

                    JZ  LL9        
                   CMP AL,0EH        
                   JZ  LDIV 
    SS1:    MOV AL,0DH         
                  OUT 30H,AL        
                  IN  AL,34H         
                  CMP AL,07H         
                  JZ  LL4         
                  CMP AL,0BH         
                  JZ  LL5         
                  CMP AL,0DH         
                  JZ  LL6         
                  CMP AL,0EH         
                  JZ  LMUL 
    SS2:    MOV AL,0BH        
            
            OUT 30H,AL         
            IN  AL,34H         
            CMP AL,07H         
            JZ  LL1         
            CMP AL,0BH         
            JZ  LL2         
            CMP AL,0DH         
            JZ  LL3         
            CMP AL,0EH         
            JZ  LSUB 
   SS3:      MOV AL,07H         
            OUT 30H,AL         
            IN  AL,34H         
            CMP AL,07H         
            JZ  SCLC         
            CMP AL,0BH         
            JZ  LL0         
            CMP AL,0DH         
            JZ  LEQU         
            CMP AL,0EH         
            JZ  LADD         
            JMP KCLC 
 LDIV:   MOV AL,0DH         
          JMP LCLC 
 LL0:    MOV AL,00H        
          JMP LCLC 
 LL1:     MOV AL,01H         
               JMP LCLC 
 LL2:     MOV AL,02H 
               
        JMP LCLC 
LL3:     MOV AL,03H    
     JMP LCLC 
LL4:     MOV AL,04H        
     JMP LCLC 
LL5:     MOV AL,05H   
      JMP LCLC 
 LL6:     MOV AL,06H 
         JMP LCLC 
LL7:   MOV AL,07H        
          JMP LCLC 
 LL8:     MOV AL,08H         
         JMP LCLC
 LL9:     MOV AL,09H         
         JMP LCLC 
 LADD:   MOV AL,0AH         
          JMP LCLC 
LSUB:   MOV AL,0BH        
           JMP LCLC 
           LMUL:   MOV AL,0CH        
           JMP LCLC   
      LEQU:   MOV AL,0EH        
       JMP LCLC 
   SCLC:   MOV AL,0FH
    LCLC:   MOV [SI],AL        
         MOV AH,01H
         KCLC:          RET 
         KEY     ENDP   
         CODE ENDS             
         END START           

                                      
                                      