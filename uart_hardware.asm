;*******************************************************************************
; uart_hardware.asm
; Функции модуля UART
; - DEBUG RC6(TX), RC7(RX)
;
; Автор: Д. Лунегов, dlunegov@gmail.com
;
; История: 07.03.2016 - Файл создан
;
;*******************************************************************************
    #include "hardware_profile.inc"
    radix dec
;-------------------------------------------------------------------------------
; ГЛОБАЛЬНЫЕ ФУНКЦИИ
;-------------------------------------------------------------------------------
    global  UartInit, UartPutChar, UartGetChar
;-------------------------------------------------------------------------------
; ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
;-------------------------------------------------------------------------------
    global  uart_data_out, uart_data_in, uart_error 
;-------------------------------------------------------------------------------
; ДАННЫЕ    (ПОЛЗОВАТЕЛЬСКИЕ, НАСТРАИВАЕМЫЕ) 
;-------------------------------------------------------------------------------
    #define	BAUD	9600			; скорость обмена
    #define	XTAL	4000000			; частота резонатора
    #define	X	(XTAL / BAUD / 16) - 1	; число для регистра SPBRG (.25)
;-------------------------------------------------------------------------------
; РЕГИСТРЫ  (ПОЛЗОВАТЕЛЬСКИЕ, НАСТРАИВАЕМЫЕ)
;-------------------------------------------------------------------------------
    #define    UART_RX	TRISC, RC7	; нога на прием
    #define    UART_TX	TRISC, RC6	; нога на передачу
;-------------------------------------------------------------------------------
; РЕГИСТРЫ  ФУНКЦИЙ
;-------------------------------------------------------------------------------
    udata
uart_data_out	res 1	; байт на передачу
uart_data_in	res 1	; принятый байт	
uart_error	res 1	; регистр - ошибка приема 
;-------------------------------------------------------------------------------
; НАЧАЛО КОДА
;-------------------------------------------------------------------------------
   
STARTUP	code

;*******************************************************************************
;* ФУНКЦИЯ  : Инициализация UART
;* РЕСУРСЫ  : EUSART	
;* ОПИСАНИЕ : Асинхронный, Speed 9600, 8 bit, NO PARITY, 1STOP
;*******************************************************************************
UartInit
	banksel	TRISC		; устрановка RX & TX на вход
	bsf	UART_RX
	bsf	UART_TX
	
	banksel	SPBRG		;установка baud rate
	movlw	X
	movwf	SPBRG
	
	banksel	BAUDCTL
	bcf	BAUDCTL, BRG16
	
	banksel	TXSTA
	bsf	TXSTA,	BRGH
	bsf	TXSTA,	TXEN	; включение передатчика
	
	banksel	RCSTA
	bsf	RCSTA,	CREN	; включение приемкника
	bsf	RCSTA,	SPEN	; включение UART
	
	banksel	PIE1
	bsf	PIE1,	RCIE	; прерывание от приеменика
;	bsf	PIE1,	TXIE	; прерывание от передатчика			    влетаю в прерывание, продумать
	
	banksel	INTCON
	bsf	INTCON,	PEIE	; вкл. прерывание от переферии
	bsf	INTCON,	GIE	; глобальное прерывание
	
	return
;*******************************************************************************
;* ФУНКЦИЯ  : Передает 8-битное значение по асинхронному каналу
;* РЕСУРСЫ  : Модуль USART	
;* ВХОД	    : 8-битное значение в uart_data_out	    
;* ВЫХОД    : Содержимое uart_data_out не изменяется, байт передан	
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
;* ФУНКЦИЯ  : Принимает 8-битное значение по асинхронному каналу
;* РЕСУРСЫ  : Модуль USART	
;* ВХОД	    : Нет
;* ВЫХОД    : Принятый байт - uart_data_in
;* ВЫХОД    : Байт-ошибка uart_error:
;				    00 - ошибок нет
;				    .-4 - ошибка прерывания
;				    .-1 - ошибка кадрирования
;				    .-2	- ошибка переполнения
;				    .-3 - ошибка кадрирования и переполнения
;*******************************************************************************	
UartGetChar
	banksel	uart_error
	clrf	uart_error	    ; обнуляем признак ошибки
	banksel	PIR1
	pagesel	UartCheckFrame
	btfsc	PIR1, RCIF	    ; было прерывание?
	goto	UartCheckFrame	    ; Да, проверяем ошибки
	banksel	uart_error
	movlw	-4
	movwf	uart_error	    ; Нет, ошибка прерывания (.-4)
	lgoto	UartExit	
	
UartCheckFrame			    ; проверка ошибки кадрирования
	banksel	RCSTA
	pagesel	UartCheckOverrun
	btfss	RCSTA, FERR	    ; была ошибка кадрирования?
	goto	UartCheckOverrun    ; Нет, проверяем ошибки далее
	banksel	uart_error
	decf	uart_error	    ; Да, ошибка кадрирования (.-1)
			
UartCheckOverrun		    ; проверка ошибки переполнения
	banksel	RCSTA
	pagesel	UartCheckError
	btfss	RCSTA, OERR	    ; была ошибка переполнения?
	goto	UartCheckError	    ; Нет, проверяем признак ошибки 
	banksel	uart_error
	decf	uart_error	    ; Да, ошибка переполнения (.-2)
	decf	uart_error
	
UartCheckError			    ; проверяем ошибки приема по UART
	banksel	uart_error
	bcf	STATUS, Z
	movf	uart_error	    ; проверяем признак на 00
	pagesel	UartReadByte	    ; если Z = 1, ошибок нет, читаем байт
	btfsc	STATUS, Z	    
	goto	UartReadByte
	banksel	RCSTA
	bcf	RCSTA, SPEN	    ; перегружаем модуль UART, очищаем флаги 
	bsf	RCSTA, SPEN	    ; RCSTA<OERR>, RCSTA<FERR>
	lgoto	UartExit
	
UartReadByte
	banksel	RCREG
	movf	RCREG, w
	movwf	uart_data_in	
	
UartExit
	return
	
	end