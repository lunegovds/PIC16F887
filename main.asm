;*******************************************************************************
;* main.asm
;
;* Microchip SHIELD:
;
;* - DEBUG RC6(TX), RC7(RX)    
;
;
; Автор: Д. Лунегов, dlunegov@gmail.com
;
; История: 03.03.2016 - Файл создан
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
; КОНСТАНТЫ (ПОЛЗОВАТЕЛЬСКИЕ)
;-------------------------------------------------------------------------------
    
F_OSC	equ	4000000 ; Тактовая частота (Гц)
;-------------------------------------------------------------------------------
; ДАННЫЕ
;-------------------------------------------------------------------------------
SHARED_DATA udata_shr
_work	res 1		; сохр. рабочего регистра, расшарен на все банки
	
gpr0	udata		; !!!первый банк RAM!!!
	
_status	res 1		; сохр. STATUS регистра
_pclath	res 1		; сохр. PCLATH
_fsr	res 1		; сохр. FSR
;-------------------------------------------------------------------------------
; ДАННЫЕ EEPROM
;-------------------------------------------------------------------------------	
EEHELLO	code	0x2100
	de	"Ксенечка моя любофф! ", 0
;*******************************************************************************
; ВЕКТОР СБРОСА
;*******************************************************************************
 
Res_	code	0x0000
	pagesel	Init
	goto	Init

;*******************************************************************************
; ВЕКТОР ПРЕРЫВАНИЯ
;*******************************************************************************
    
Int_	code	0x0004	    ; PC = 0x0004, stack = хранить предыдущий адрес,
			    ; буффер PCLATH хранит предыдущее ЗАНОСИМОЕ значение
			    ; 5 MSb битов в PCL
			    
	movwf	_work	    ; сохранение рабочего регистра и STATUS
	swapf	STATUS, w
	banksel	_status
	movwf	_status
	movf    PCLATH,	w   ; сохр. PCLATH и FSR
	movwf   _pclath     ; _pclath в том же банке что и _status
	movf	FSR, w
	movwf	_fsr
	
ISR
	banksel	PIR1
	pagesel	Start
	btfss	PIR1, RCIF	    ; было прерывание?
	goto	Start
	lcall	UartGetChar
	pagesel	$
	lcall	UartReturnData
	pagesel	$
	
	
	movf	_fsr, w	    ; восстанавливаем FSR
	movwf	FSR
	banksel	_pclath	    ; восстановление PCLATH В БУФФЕР
	movf	_pclath, w
	movwf	PCLATH
	swapf	_status, w  ; восстановление рабочего регистра и STATUS
	movwf	STATUS
	swapf	_work, f
	swapf	_work, w
	retfie		    ; возврат из прерывания GIE = 1
	
;*******************************************************************************
;* ФУНКЦИИ MAIN     :
;*******************************************************************************	

;*******************************************************************************
; ИНИЦИАЛИЗАЦИЯ
;*******************************************************************************	
Init
	lcall	UartInit
	pagesel	$
	lgoto	Start
;*******************************************************************************
; ОСНОВНОЙ ЦИКЛ ПРОГРАММЫ
;*******************************************************************************	
Start
	movlw	0x00		    ; передача начального адреса еепром
	banksel	ee_addr_data	    
	movwf	ee_addr_data
EERead
	lcall	EEReadData
	pagesel	$

	banksel	ee_data
	bcf	STATUS, Z           ; очистка признака нуля
	movf	ee_data, f	    ; проверка данных на ноль
    pagesel EEWrite
	btfsc	STATUS, Z	    
	goto	EEWrite		    ; если флаг, то EOF
	
	movf	ee_data, w
	banksel	uart_data_out
	movwf	uart_data_out
	lcall	UartPutChar
	pagesel	$
	
	incf	ee_addr_data
	lgoto	EERead		    ; иначе читай дальше
    
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
    movlw	0x20		    ; передача начального адреса еепром
	movwf	ee_addr_data
	lcall	EEReadData
	pagesel	$
    
	banksel	uart_data_out	    ; передача символа
    movf    ee_data, w
    movwf   uart_data_out
	lcall	UartPutChar
	pagesel	$
	
    goto    $
	
	end
	