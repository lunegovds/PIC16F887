;*******************************************************************************
; uart_hardware.asm
; ������� ������ UART
; - DEBUG RC6(TX), RC7(RX)
;
; �����: �. �������, dlunegov@gmail.com
;
; �������: 07.03.2016 - ���� ������
;
;*******************************************************************************
    #include "hardware_profile.inc"
    radix dec
;-------------------------------------------------------------------------------
; ���������� �������
;-------------------------------------------------------------------------------
    global  UartInit, UartPutChar, UartGetChar
;-------------------------------------------------------------------------------
; ���������� ����������
;-------------------------------------------------------------------------------
    global  uart_data_out, uart_data_in, uart_error 
;-------------------------------------------------------------------------------
; ������    (���������������, �������������) 
;-------------------------------------------------------------------------------
    #define	BAUD	9600			; �������� ������
    #define	XTAL	4000000			; ������� ����������
    #define	X	(XTAL / BAUD / 16) - 1	; ����� ��� �������� SPBRG (.25)
;-------------------------------------------------------------------------------
; ��������  (���������������, �������������)
;-------------------------------------------------------------------------------
    #define    UART_RX	TRISC, RC7	; ���� �� �����
    #define    UART_TX	TRISC, RC6	; ���� �� ��������
;-------------------------------------------------------------------------------
; ��������  �������
;-------------------------------------------------------------------------------
    udata
uart_data_out	res 1	; ���� �� ��������
uart_data_in	res 1	; �������� ����	
uart_error	res 1	; ������� - ������ ������ 
;-------------------------------------------------------------------------------
; ������ ����
;-------------------------------------------------------------------------------
   
STARTUP	code

;*******************************************************************************
;* �������  : ������������� UART
;* �������  : EUSART	
;* �������� : �����������, Speed 9600, 8 bit, NO PARITY, 1STOP
;*******************************************************************************
UartInit
	banksel	TRISC		; ���������� RX & TX �� ����
	bsf	UART_RX
	bsf	UART_TX
	
	banksel	SPBRG		;��������� baud rate
	movlw	X
	movwf	SPBRG
	
	banksel	BAUDCTL
	bcf	BAUDCTL, BRG16
	
	banksel	TXSTA
	bsf	TXSTA,	BRGH
	bsf	TXSTA,	TXEN	; ��������� �����������
	
	banksel	RCSTA
	bsf	RCSTA,	CREN	; ��������� ����������
	bsf	RCSTA,	SPEN	; ��������� UART
	
	banksel	PIE1
	bsf	PIE1,	RCIE	; ���������� �� ����������
;	bsf	PIE1,	TXIE	; ���������� �� �����������			    ������ � ����������, ���������
	
	banksel	INTCON
	bsf	INTCON,	PEIE	; ���. ���������� �� ���������
	bsf	INTCON,	GIE	; ���������� ����������
	
	return
;*******************************************************************************
;* �������  : �������� 8-������ �������� �� ������������ ������
;* �������  : ������ USART	
;* ����	    : 8-������ �������� � uart_data_out	    
;* �����    : ���������� uart_data_out �� ����������, ���� �������	
;*******************************************************************************	
UartPutChar
	banksel PIR1
	pagesel	UartPutChar
	btfss	PIR1, TXIF
	goto	UartPutChar
	banksel	uart_data_out
	movf	uart_data_out, w
	banksel	TXREG
	movwf	TXREG
	
	return

;*******************************************************************************
;* �������  : ��������� 8-������ �������� �� ������������ ������
;* �������  : ������ USART	
;* ����	    : ���
;* �����    : �������� ���� - uart_data_in
;* �����    : ����-������ uart_error:
;				    00 - ������ ���
;				    .-4 - ������ ����������
;				    .-1 - ������ ������������
;				    .-2	- ������ ������������
;				    .-3 - ������ ������������ � ������������
;*******************************************************************************	
UartGetChar
	banksel	uart_error
	clrf	uart_error	    ; �������� ������� ������
	banksel	PIR1
	pagesel	UartCheckFrame
	btfsc	PIR1, RCIF	    ; ���� ����������?
	goto	UartCheckFrame	    ; ��, ��������� ������
	banksel	uart_error
	movlw	-4
	movwf	uart_error	    ; ���, ������ ���������� (.-4)
	lgoto	UartExit	
	
UartCheckFrame			    ; �������� ������ ������������
	banksel	RCSTA
	pagesel	UartCheckOverrun
	btfss	RCSTA, FERR	    ; ���� ������ ������������?
	goto	UartCheckOverrun    ; ���, ��������� ������ �����
	banksel	uart_error
	decf	uart_error	    ; ��, ������ ������������ (.-1)
			
UartCheckOverrun		    ; �������� ������ ������������
	banksel	RCSTA
	pagesel	UartCheckError
	btfss	RCSTA, OERR	    ; ���� ������ ������������?
	goto	UartCheckError	    ; ���, ��������� ������� ������ 
	banksel	uart_error
	decf	uart_error	    ; ��, ������ ������������ (.-2)
	decf	uart_error
	
UartCheckError			    ; ��������� ������ ������ �� UART
	banksel	uart_error
	bcf	STATUS, Z
	movf	uart_error	    ; ��������� ������� �� 00
	pagesel	UartReadByte	    ; ���� Z = 1, ������ ���, ������ ����
	btfsc	STATUS, Z	    
	goto	UartReadByte
	banksel	RCSTA
	bcf	RCSTA, SPEN	    ; ����������� ������ UART, ������� ����� 
	bsf	RCSTA, SPEN	    ; RCSTA<OERR>, RCSTA<FERR>
	lgoto	UartExit
	
UartReadByte
	banksel	RCREG
	movf	RCREG, w
	movwf	uart_data_in	
	
UartExit
	return
	
	end