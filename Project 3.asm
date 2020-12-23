TITLE Program Template     (template.asm)

; Author:Adam Slusser
; Last Modified: 11/01/2019
; OSU email address: slussera@oregonstate.edu
; Course number/section: CS 271
; Project Number: 3               Due Date:11/03/2019
; Description: This program will first greet the user and ask for their name. It will then display a set of instructions to the user and ask them to enter a number between -1 to -150 and do
;input validation to make sure that the entry is within that range. It will continue to reprompt the user for another another until the user enters a non negative number. At which point the program will 
;calculate the rounded average of the users entries. The program will do one of two things if the user did enter negative numbers it will tell them how many entries they made, give the sum of those entries
;as well as the average and then display a farewell message. If the user did not enter any negative numbers the program will simply display a fairwell message. 
; Extra Credit options: I did label the lines during the user input. 

INCLUDE Irvine32.inc

UPPER_LIMIT = -1
LOWER_LIMIT = -150

.data
;Introduction strings
program_title		BYTE	"Accumulator Project by ", 0
my_name				BYTE	"Adam Slusser", 0
name_prompt			BYTE	"Hi, what is your name?", 0
user_greeting		BYTE	"It's nice to meet you ",0
extra_credit1		BYTE	"Extra credit for the numbered lines during input entry was done.", 0

;Instruction strings
instruction1		BYTE	"Please enter a list of numbers between -1 and -150 and I will calculate their sum and average for you.", 0
instruction2		BYTE	"If you enter 0 or greater number the sum and average of the numbers entered will be displayed and the program will end.", 0

;Variables to get and store the users name. 
user_name			BYTE	21 DUP(0)
byte_count			DWORD	?

;Entry and math strings. 
entry_instruction	BYTE	") Enter a number: ", 0
ignore_input		BYTE	"Sorry but that number will not be stored as it was not between -1 and -150.", 0
valid_entries		BYTE	"Valid numbers entered: ", 0
sum_message			BYTE	"The sum of your valid numbers is ", 0
average_message		BYTE	"The average of your valid numbers is ", 0

;Variables of getting and calculating the sum and average. 
entry_counter		DWORD	1
user_entry			DWORD	?
sum					DWORD	0
remainder			DWORD	?
average				DWORD	?

;Special message if no valid inputs
special_message		BYTE	"It doesn't look like you put in any valid inputs but that is okay.", 0

;Exit message
bye					BYTE	"Thanks for using my program and have a great day ",0
period				BYTE	".", 0

.code
main PROC

;Introduction

;Display Program title and my name.
	mov		edx, OFFSET program_title
	call	WriteString
	mov		edx, OFFSET my_name
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_credit1
	call	WriteString
	call	CrLf
	
;Ask the user for their name. 	
	mov		edx, OFFSET name_prompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET user_name
	mov		ecx, SIZEOF	user_name
	call	ReadString
	mov		byte_count, eax

;Greet the user using their name. 
	mov		edx, OFFSET user_greeting
	call	WriteString
	mov		edx, OFFSET user_name
	call	WriteString 
	call	CrLf
	call	CrLf

;Display instructions
	mov		edx, OFFSET instruction1
	call	WriteString	
	call	CrLf
	mov		edx, OFFSET instruction2
	call	WriteString	
	call	CrLf

;User inputs numbers
number_input:
	mov		eax, entry_counter
	call	WriteDec
	mov		edx, OFFSET entry_instruction
	call	WriteString
	call	ReadInt
	mov		user_entry, eax 
	cmp		user_entry, LOWER_LIMIT
	JL		ignore_message
	cmp		user_entry, UPPER_LIMIT
	JG		do_math
	inc		entry_counter
	mov		eax, user_entry
	add		sum, eax
	JMP		number_input

;Mathmatics behind calculating the proper average. 
do_math:

;Check to see if any valid entries were made.
	cmp		entry_counter, 1
	JE		no_entries

;If there were valid entries determine if average
;needs to be doubled and if so do.
	mov		eax, sum
	cdq		;Prep for signed division
	dec		entry_counter
	mov		ebx, entry_counter
	idiv	ebx
	mov		average, eax

;See if rounding is needed.
	cmp		edx, 0
	JE		display_calculations

;Calculations for if rounding is needed
	mov		remainder, edx
	mov		eax, remainder
	mov		ebx, 2
	imul	eax, ebx
	cmp		eax, entry_counter
	JL		display_calculations

;If the doulbed remainder is larger than the number
;of entries round down. 
	mov		eax, remainder
	dec		remainder

display_calculations:
;Display the sum
	mov		edx, OFFSET sum_message
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

;Display the average.
	mov		edx, OFFSET average_message
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf
	JMP		good_bye


;Message to be displayed if input was out of bounds. 
ignore_message:
	mov		edx, OFFSET ignore_input
	call	WriteString
	call	CrLf
	JMP		number_input

;Specail message if user does not put in any valid entries
no_entries:
	mov		edx, OFFSET special_message
	call	WriteString
	call	CrLf
	JMP		good_bye

good_bye:
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET user_name
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP
END main