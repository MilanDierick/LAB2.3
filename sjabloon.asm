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

	EXTERN Delay1s,Delay50ms,Delay20ms,Delay100ms,Delay10ms,Delay1ms
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
choice RES 1 

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

frequentie:
    movlw 0d
    btg PORTD,RD3
    bra processChoice
    
continueAfterChoice:
    btfss PORTB,RB4
    bra releaseBtn
    bra frequentie
    
releaseBtn:
    btfss PORTB, RB4
    bra releaseBtn

waitForBtnUp:
    call Delay50ms
    incf W
    cpfsgt 4
    bra resetFrequentie
    bra frequentie
    
processChoice:
    bcf PORTD, RD3
    xorlw 0d
    bnz startDelay1s
    xorlw 1d
    bnz startDelay100ms
    xorlw 2d
    bnz startDelay10ms
    xorlw 3d
    bnz startDelay1ms
    bra frequentie
    
resetFrequentie:
    movlw 0d
    bra frequentie
    
startDelay1s:
    call Delay1s
    bra continueAfterChoice
    
startDelay100ms:
    call Delay100ms
    bra continueAfterChoice
    
startDelay10ms:
    call Delay10ms
    bra continueAfterChoice
    
startDelay1ms:
    call Delay1ms
    bra continueAfterChoice
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
