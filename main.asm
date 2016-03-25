;*******************************************************************************
;* main.asm
;
;* Microchip SHIELD:
;
;* - DEBUG RC6(TX), RC7(RX)    
;
;
; �����: �. �������, dlunegov@gmail.com
;
; �������: 03.03.2016 - ���� ������
;
;*******************************************************************************

    #include "hardware_profile.inc"
    #include "ledarray8.inc"
    #include "uart_hardware.inc"
    #include "e2prom.inc"
    
    ; CONFIG1
    ; __config 0xF8E5
    __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_ON
    ; CONFIG2
    ; __config 0xFEFF
    __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF
    
    radix dec
    
    ERRORLEVEL -302

;-------------------------------------------------------------------------------
; ��������� (���������������)
;-------------------------------------------------------------------------------
    
F_OSC	equ	4000000 ; �������� ������� (��)
;-------------------------------------------------------------------------------
; ������
;-------------------------------------------------------------------------------
SHARED_DATA udata_shr
_work	res 1		; ����. �������� ��������, �������� �� ��� �����
	
gpr0	udata		; !!!������ ���� RAM!!!
	
_status	res 1		; ����. STATUS ��������
_pclath	res 1		; ����. PCLATH
_fsr	res 1		; ����. FSR
;-------------------------------------------------------------------------------
; ������ EEPROM
;-------------------------------------------------------------------------------	
EEHELLO	code	0x2100
	de	"�������� ��� ������! ", 0
;*******************************************************************************
; ������ ������
;*******************************************************************************
 
Res_	code	0x0000
	pagesel	Init
	goto	Init

;*******************************************************************************
; ������ ����������
;*******************************************************************************
    
Int_	code	0x0004	    ; PC = 0x0004, stack = ������� ���������� �����,
			    ; ������ PCLATH ������ ���������� ��������� ��������
			    ; 5 MSb ����� � PCL
			    
	movwf	_work	    ; ���������� �������� �������� � STATUS
	swapf	STATUS, w
	banksel	_status
	movwf	_status
	movf    PCLATH,	w   ; ����. PCLATH � FSR
	movwf   _pclath     ; _pclath � ��� �� ����� ��� � _status
	movf	FSR, w
	movwf	_fsr
	
ISR
	banksel	PIR1
	pagesel	Start
	btfss	PIR1, RCIF	    ; ���� ����������?
	goto	Start
	lcall	UartGetChar
	pagesel	$
	lcall	UartReturnData
	pagesel	$
	
	
	movf	_fsr, w	    ; ��������������� FSR
	movwf	FSR
	banksel	_pclath	    ; �������������� PCLATH � ������
	movf	_pclath, w
	movwf	PCLATH
	swapf	_status, w  ; �������������� �������� �������� � STATUS
	movwf	STATUS
	swapf	_work, f
	swapf	_work, w
	retfie		    ; ������� �� ���������� GIE = 1
	
;*******************************************************************************
;* ������� MAIN     :
;*******************************************************************************	

;*******************************************************************************
; �������������
;*******************************************************************************	
Init
	lcall	UartInit
	pagesel	$
	lgoto	Start
;*******************************************************************************
; �������� ���� ���������
;*******************************************************************************	
Start
	movlw	0x00		    ; �������� ���������� ������ ������
	banksel	ee_addr_data	    
	movwf	ee_addr_data
EERead
	lcall	EEReadData
	pagesel	$

	banksel	ee_data
	bcf	STATUS, Z           ; ������� �������� ����
	movf	ee_data, f	    ; �������� ������ �� ����
    pagesel EEWrite
	btfsc	STATUS, Z	    
	goto	EEWrite		    ; ���� ����, �� EOF
	
	movf	ee_data, w
	banksel	uart_data_out
	movwf	uart_data_out
	lcall	UartPutChar
	pagesel	$
	
	incf	ee_addr_data
	lgoto	EERead		    ; ����� ����� ������
    
EEWrite
    banksel ee_addr_data
    movlw   0x20
    movwf   ee_addr_data
    
    banksel ee_data
    movlw   'Z'
    movwf   ee_data
    
    lcall   EEWriteData
    pagesel $
    
    banksel	ee_addr_data
    movlw	0x20		    ; �������� ���������� ������ ������
	movwf	ee_addr_data
	lcall	EEReadData
	pagesel	$
    
	banksel	uart_data_out	    ; �������� �������
    movf    ee_data, w
    movwf   uart_data_out
	lcall	UartPutChar
	pagesel	$
	
    goto    $
	
	end
	