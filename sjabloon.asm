;*************************************************************************
;
;Bestandsnaam: sjabloon.asm
;Auteur: Milan Dierick
;Versie: 
;Datum: 
;commentaar: 
;
;*************************************************************************

	LIST P=18F4550, F=INHX32

	#include <P18F4550.INC>


;Definieer externe, globale en locale labels

	EXTERN Delay1s,Delay50ms,Delay20ms
	;GLOBAL
	;LOCAL

;Declaratie van variabelen buiten accesbank
	UDATA 
WREG_TEMP_LO 	RES 1
STATUS_TEMP_LO 	RES 1
BSR_TEMP_LO		RES 1
WREG_TEMP_HI 	RES 1
STATUS_TEMP_HI 	RES 1
BSR_TEMP_HI		RES 1

;Declaratie van variabelen in acces-bank
	UDATA_ACS
keuze	RES 1

;*************************************************************************
;
;Standaard reset- en interruptvectoren
; Resetvector: adres 0x0008
; High priority interrupt : adres 0x0008
; Low priority interrupt : adres 0x0018;
;
;*************************************************************************

	ORG 0x0000
	goto 0x0800

	ORG 0x0008
	goto 0x0808

	ORG 0x0018
	goto 0x0818
	

;*************************************************************************
;
;Remapping van reset- en interruptvectoren door gebruik van bootloader
;op PIC-USB-STK bordje.
; Resetvector: adres 0x0800
; High priority interrupt : adres 0x0808
; Low priority interrupt : adres 0x0818
;
;*************************************************************************
RSET CODE 0x0800
	goto Main

HP_INT CODE 0x0808
	goto HighINT

LP_INT CODE 0x0818
	goto LowINT


Programma code
;*************************************************************************
;
;Hoofdprogramma. Plaats hier jouw eigen code
;
;*************************************************************************

Main:
configIO:
    bcf TRISD, RD3
    bsf TRISB, RB4
    ;Zet RB4 als digitale ingang.

frequentie:
    btg PORTD,RD3
    
    ;switch case in assembler
    movf      SWITCH, w
    xorlw     1
    btfsc     STATUS, Z                ; If SWITCH = CASE1, jump to LABEL1
    goto      LABEL1
    xorlw     2^1
    btfsc     STATUS, Z                ; If SWITCH = CASE2, jump to LABEL2
    goto      LABEL2
    xorlw     3^2
    btfsc     STATUS, Z                ; If SWITCH = CASE3, jump to LABEL3
    goto      LABEL3
    
    ;call Delay1s
    btfss PORTB,RB4
    MOVF 2, WREG
    ;btfss PORTB,RB4
    bra releaseBtn
    bra frequentie1Hz
    
releaseBtn:
    ;btfsc PORTB, RB4
    bra waitForBtnUp
    bra releaseBtn

waitForBtnUp:
    call Delay50ms
    call TABLE
    movwf keuze
    
    bra frequentie1Hz
    
ORG 0x1000h
TABLE ADDWF PCL
    RETLW 22
    bra frequentie10Hz
    bra frequentie100Hz
    bra frequentie1kHz
    
;*************************************************************************
;
;High priority interrupt. 
;
;*************************************************************************
HighINT:

;context saving
	movwf WREG_TEMP_HI
	movff STATUS,STATUS_TEMP_HI
    movff BSR,BSR_TEMP_HI

;plaats hier de interruptcode

;context restore
	movff BSR_TEMP_HI,BSR
	movf  WREG_TEMP_HI,W
	movff STATUS_TEMP_HI,STATUS

	retfie

;*************************************************************************
;
;Low priority interrupt. 
;
;*************************************************************************
LowINT:
;context saving
	movwf WREG_TEMP_LO
	movff STATUS,STATUS_TEMP_LO
    movff BSR,BSR_TEMP_LO

;plaats hier de interruptcode

;context restore
	movff BSR_TEMP_LO,BSR
	movf  WREG_TEMP_LO,W
	movff STATUS_TEMP_LO,STATUS

	retfie


end
