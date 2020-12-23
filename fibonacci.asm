TITLE Program Template     (template.asm)

; Author:Adam Slusser
; Last Modified: 10/16/2019
; OSU email address: slussera@oregonstate.edu
; Course number/section: CS 271
; Project Number: 2               Due Date:10/20/2019
; Description: This program will display the name of the program as well as that of the author. It will then ask the user to for their name and give a greeting using their name. 
;It will give a description of the purpose of the program asking them to enter between 1 and 46 Fibonacci numbers. It will then loop through a prompt asking the user to enter how ever many numbers that they wish
;user inputs will be validated. The Fibonacci numbers will be calculated at the time the user inputs them and displayed. below. 

INCLUDE Irvine32.inc

UPPERLIMIT = 46

.data
program_title		BYTE	"Elementry Arithmetic by ", 0
my_name				BYTE	"Adam Slusser", 0
extra_credit		BYTE	"The extra credit of alligning the columns so that they are all even was done.", 0
name_prompt			BYTE	"Hi, what is your name?", 0
buffer				BYTE	21 DUP(0)
byte_count			DWORD	?
user_greeting		BYTE	"It's nice to meet you ",0
instructions		BYTE	"This program will give you the Fibonacci numbers for between 1 and 46 numbers.",0
instructions_2		BYTE	"How many numbers would you like to enter. Remember it has to be between 1 and 46.", 0
user_nums			DWORD	?
error_message		BYTE	"Sorry the number you entered was out of range. Please select a number between 1-46.", 0
spaces				BYTE	"     ", 0
next_num			DWORD	1
count				DWORD	?
row_count			DWORD	0
rows				DWORD	1
good_bye			BYTE	"Thank you for using this program. Have a great day.", 0

.code
main PROC
				;Introduction

;Display Program title and my name.
	mov		edx, OFFSET program_title
	call	WriteString
	mov		edx, OFFSET my_name
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_credit
	call	WriteString
	call	CrLf
	call	CrLf
	
;Ask the user for their name. 	
	mov		edx, OFFSET name_prompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET buffer
	mov		ecx, SIZEOF	buffer
	call	ReadString
	mov		byte_count, eax

;Greet the user using their name. 
	mov		edx, OFFSET user_greeting
	call	WriteString
	mov		edx, OFFSET buffer
	call	WriteString 
	call	CrLf
	call	CrLf


			;Display Instructions
;Instructions displayed
	mov		edx, OFFSET instructions
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf


;Assign the number of loop iterations to a variable. 
num_entry:
	call	ReadInt
;Entry input validation for how many iterations the user would like to do. 
	mov		ebx, 1
	cmp		eax, ebx
	JB		input_error
	cmp		eax, UPPERLIMIT 
	JA		input_error

;Input is within bounds.
	mov		ecx, eax
	mov		ebx, 1
	call	CrLf
	JMP		calculations

input_error:
	mov		edx, OFFSET error_message
	call	WriteString
	JMP		num_entry


calculations:
	mov		eax, ebx
	call	WriteDec
	mov		ebx, next_num	
	add		eax, ebx
	mov		next_num, eax
	mov     al, 9               ; ASCII CHAR 9 =  TAB
    call    WriteChar			; First tab. Total of two tabs so that larger numbers allign with smaller for nice columns. 
	cmp		rows, 9
	JG		one_tab				; If this is the ninth row skip the second tab so that larger numbers allign with smaller. 
	call    WriteChar			; Second tab to allign smaller numbers to those that are larger
continue:
	inc		row_count			; Increase count of numbers in that row
	cmp		row_count, 4		
	JNE		loop_or_bye			; If numbers in row less than 4 continue row.
	call	CrLf				; If numbers in row greater than 4 start new row. 
	mov		row_count, 0		; Reset count of numbers in that row to 0.
	inc		rows				; Keeps track of row count for alignment purposes.

loop_or_bye:
	loop	calculations
	JMP		bye

one_tab:
		JMP		continue		; Skips the second tab in 10th or > row for alignment purposes to smaller numbers. 

bye:
	call	CrLf
	mov		edx, OFFSET good_bye
	call	WriteString
	exit	; exit to operating system
main ENDP
END main