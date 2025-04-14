;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------




			push #list1
			mov #10,r5      ; r5 = N
			mov #6,r4	   	; r4 = M

			call #sublab2

			sub #2 , SP

			jmp $
sublab2:

			mov #0,r7      ; r7 (i)= 0
			mov 2(SP), r9 ; r9 list1 address

sublab2Loop:
			cmp	r5, r7
			jge sublab2_end

			; r7 = i , r4 = M

			mov r4, r6 ; r6= M
			add r7 , r6 ; r6= M+i

			push r6  ; M+i
			push r7  ; i
			call #compare
			; r15 is return

			pop r7
			pop r6

			mov r7,r8    ; r8 = i
			rla r8		 ; r8 = i * 2

			add r9,r8    ; r8 = adress of list[i]

			mov r15 , 0(r8)



			inc r7
			jmp sublab2Loop


sublab2_end:
			ret


compare:
			sub #4, SP ;Reserve 2 word of stack
			; 2(SP) = a1
			; 4(SP) = a2

			push r8
			; r7 = 8(SP) = i = a , r4 = 10(SP) = M+i = b



			mov 8(SP),r8   ; R8=i
			rla r8
			mov r8 , 2(SP) ; a1 = i*2 = a*2

			mov 10(SP),r8  ;r8=M+i = b
			add #1, r8
			mov r8, 4(SP)  ; b1 = M+i+1 = b+1


			; a1=2(SP) , b1=4(SP)
			call #subInt
			; r15 = a1-b1

			pop r8
			add #4, SP ; clean a1 and b1

			cmp.w #0 ,r15
			jl compare_false

			mov.w   #1, r15
            jmp     compare_end

compare_false:
            ; return 0
            clr.w   r15
compare_end:
			ret

subInt:
			push r4
			push r5

			mov 8(SP), r4 ; r4=a1
			mov 10(SP), r5 ; r5=b1

			mov r4, r15 ; r15 = a1
			sub r5, r15 ; r15 = a1-b1

			pop r5
			pop r4

			ret

list1:		.word	1, 2, 3, 4, 5, 6, 7, 8, 9, 10


                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
