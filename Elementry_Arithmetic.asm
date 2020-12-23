TITLE Elementry Arithmetic    (Elementry_Arithmetic.asm)

; Author: Adam Slusser
; Last Modified: 10/13/2019
; OSU email address: slussera@oregonstate.edu
; Course number/section: CS271
; Project Number: Project 1           Due Date: 10/13/2019
; Description: This program displays my name and the protram title on the output screen, 
;asks the user to input two numbers and then calculates the sum, difference, product, (integer) quotient and remainder of the numbers and then display a terminating message.
;**EC: Program verifies that the second number should be less than the first and displays a message if it is not it also gives the square of each number. 

INCLUDE Irvine32.inc

.data

program_title	BYTE	"Elementry Arithmetic by ", 0
my_name			BYTE	"Adam Slusser", 0
extra_credit	BYTE	"**EC: Program verifies second number less than first. Then gives the square of each of those numbers.", 0
directions		BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
first_num		BYTE	"First Number: ", 0
second_num		BYTE	"Second Number: ", 0
greater_than	BYTE	"The second number must be less than the first.", 0
good_bye		BYTE	"Hope that was helpful. See you next time. ", 0
num_square		BYTE	"Square of ", 0
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0
division		BYTE	" / ", 0
multiply		BYTE	" * ", 0
modulus			BYTE	" % ", 0
equals			BYTE	" = ", 0
number_1		DWORD	0
number_2		DWORD	0
sum				DWORD	?
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?
square_1		DWORD	?
square_2		DWORD	?


.code
main PROC
;Display your name and the title of the program
	mov		edx, OFFSET program_title
	call	WriteString
	mov		edx, OFFSET my_name
	call	WriteString
	call	CrLF

;Display extra credit description
	mov		edx, OFFSET extra_credit
	call	WriteString
	call	CrLf

;Give instructions to the user
	mov		edx, OFFSET directions
	call	WriteString
	call	CrLF

;Prompt the user for first number
	mov		edx, OFFSET	 first_num
	call	WriteString
	call	ReadDec
	mov		number_1, eax

;Prompt the user for second number
	mov		edx, OFFSET second_num
	call	WriteString
	call	ReadDec
	mov		number_2, eax
	mov		eax, number_2

;Check if number_2 is greater than number_1
	cmp		eax, number_1
	jg		greater_than_message
	jle		calculations
greater_than_message:
	mov		edx, OFFSET greater_than
	call	WriteString
	call	CrLf

calculations:

;Calculate the sum
	mov		eax, number_1
	add		eax, number_2
	mov		sum, eax

;Difference
	mov		eax, number_1
	sub		eax, number_2
	mov		difference, eax

;Product
	mov		eax, number_1
	mov		ebx, number_2
	mul		ebx
	mov		product, eax

;Quotient and Remainder
	mov		eax, number_1
	cdq
	mov		ebx, number_2
	cdq
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

;Square of first number
	mov		eax, number_1
	mov		ebx, number_1
	mul		ebx
	mov		square_1, eax

;Square of second number
	mov		eax, number_2
	mov		ebx, number_2
	mul		ebx
	mov		square_2, eax

;Display difference
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	equals
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

;Display difference
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	equals
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

;Display product
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET multiply
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	equals
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

;Display quotient
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET division
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	equals
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	call	CrLf

;Display remainder
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET modulus
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	equals
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

;Number One Squared
	mov		edx, OFFSET	num_square
	call	WriteString
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, square_1
	call	WriteDec
	call	CrLf

;Number Two Squared
	mov		edx, OFFSET	num_square
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, square_2
	call	WriteDec
	call	CrLf


;Display a terminating message.
	mov		edx, OFFSET good_bye
	call	WriteString
	call	CrLF
; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
