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


			.text
			push    #result
            push    #list2
            push    #list1


            mov.w   #10, r12

            call    #sublab1


            add.w   #6, sp

            jmp     $


sublab1:
			push    r4
            push    r5
            push    r6
            push    r7

            mov.w   10(sp), r4            ; r4 = ls1 (address)
            mov.w   12(sp), r5            ; r5 = ls2 (address)
            mov.w   14(sp), r6            ; r6 = res (address)


            clr.w   r7                   ; sum = 0
            clr.w   r8                   ; i = 0

loop:       cmp.w   r12, r8
            jge     end_loop

            ; calculate ls1[i] + ls2[i]
            mov.w   r8, r9
            rla.w	r9
            add.w   r4, r9 				; r9 = address of ls1[i]

            mov.w   @r9, r10            ; r10 = ls1[i]

            mov.w   r8, r9
            rla.w	r9
            add.w   r5, r9              ; r9 = address of ls2[i]

            add.w   @r9, r10             ; r10 = ls1[i] + ls2[i]


            add.w   r10, r7              ; sum += ls1[i] + ls2[i]

			; calculate ls1[i]=ls2[N-i-1]
            mov.w   r12, r10
            sub.w   #1, r10
            sub.w   r8, r10              ; r10 = n-1-i
            rla.w   r10                  ; multiply by 2 (word offset)
            add.w   r5, r10              ; r10 = address of ls2[n-1-i]
            mov.w   @r10, r11            ; r11 = ls2[n-1-i]

            mov.w   r8, r9
            rla.w   r9                   ; multiply i by 2 (word offset)
            add.w   r4, r9               ; r9 = address of ls1[i]
            mov.w   r11, 0(r9)           ; ls1[i] = ls2[n-1-i]

            ; increment i
            inc.w   r8
            jmp     loop

end_loop:
            mov.w   r7, 0(r6)         ; *res = sum


            pop     r7
            pop     r6
            pop     r5
            pop     r4
            ret
                                            
list1:      .word 2, 4, 6, 8, 23, 61, 935, 12, 6, 2
list2:      .word 20, 213, 623, 7325, 231, 6547, 2141, 572, 2357, 237
result:     .word 0


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
            
