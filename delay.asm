;*************************************************************************
;
;Bestandsnaam: Delay.asm
;Auteur: code-generator www.piclist.com
;Versie: 1.00
;Datum: 9/03/2011
;commentaar: http://www.piclist.com/techref/piclist/codegen/delay.htm
;
;*************************************************************************
	#include <P18F4550.INC>

;global labels
	GLOBAL Delay1s,Delay20ms,Delay50ms,Delay100ms,Delay10ms,Delay1ms

;variable definitions
	udata_acs 
d1:	res 1
d2:	res 1
d3: res 1

; Delay = 1 seconds
; Clock frequency = 48 MHz

; Actual delay = 1 seconds = 12000000 cycles
; Error = 0 %

	CODE
Delay1s
			;11999993 cycles
	movlw	0x6C
	movwf	d1
	movlw	0x29
	movwf	d2
	movlw	0x1B
	movwf	d3
Delay_0
	decfsz	d1,f
	bra		j1
	decfsz	d2,f
j1:	bra		j2
	decfsz	d3,f
j2:	bra		Delay_0
			;3 cycles
	bra		j3
j3:	nop

			;4 cycles (including call)
	return FAST

; Delay = 0.02 seconds
; Clock frequency = 48 MHz

; Actual delay = 0.02 seconds = 240000 cycles
; Error = 0 %

Delay20ms
			;239993 cycles
	movlw	0x7E
	movwf	d1
	movlw	0xBC
	movwf	d2
Delay20ms_0
	decfsz	d1, f
	bra		j4
	decfsz	d2, f
j4:	bra		Delay20ms_0

			;3 cycles
	bra		j5
j5:	nop

			;4 cycles (including call)
	return FAST

; Delay = 0.05 seconds
; Clock frequency = 48 MHz

; Actual delay = 0.05 seconds = 600000 cycles
; Error = 1.94025536378e-014 %

Delay50ms
			;599996 cycles
	movlw	0xD1
	movwf	d1
	movlw	0x4F
	movwf	d2
	movlw	0x02
	movwf	d3
Delay50ms_0
	decfsz	d1, f
	bra		j6
	decfsz	d2, f
j6:	bra		j7
	decfsz	d3, f
j7:	bra		Delay50ms_0

			;4 cycles (including call)
	return FAST

; Delay = 0.1 seconds
; Clock frequency = 48 MHz

; Actual delay = 0.1 seconds = 1200000 cycles
; Error = 1.94025536378e-014 %

Delay100ms
			;1199994 cycles
	movlw	0xA3
	movwf	d1
	movlw	0x9E
	movwf	d2
	movlw	0x03
	movwf	d3
Delay100ms_0
	decfsz	d1, f
	bra	j8
	decfsz	d2, f
j8:	bra	j9
	decfsz	d3, f
j9:	bra	Delay100ms_0

			;2 cycles
	bra	j10
j10:
			;4 cycles (including call)
	return FAST

; Delay = 0.01 seconds
; Clock frequency = 48 MHz

; Actual delay = 0.01 seconds = 120000 cycles
; Error = 0 %

Delay10ms
			;119993 cycles
	movlw	0xBE
	movwf	d1
	movlw	0x5E
	movwf	d2
Delay10ms_0
	decfsz	d1, f
	bra	j11
	decfsz	d2, f
j11:	goto	Delay10ms_0

			;3 cycles
	bra	j12
j12:	nop

			;4 cycles (including call)
	return FAST
	
; Delay = 0.001 seconds
; Clock frequency = 48 MHz

; Actual delay = 0.001 seconds = 12000 cycles
; Error = 0 %

Delay1ms
			;11993 cycles
	movlw	0x5E
	movwf	d1
	movlw	0x0A
	movwf	d2
Delay1ms_0
	decfsz	d1, f
	bra	j13
	decfsz	d2, f
j13:	bra	Delay1ms_0

			;3 cycles
	bra	j14
j14:	nop

			;4 cycles (including call)
	return FAST
end