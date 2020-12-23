TITLE Program Template     (template.asm)

; Author: Adam Slusser
; Last Modified: 11/10/2019
; OSU email address: slussera@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 4                Due Date: 11/10/2019
; Description: This program asks the user how many composites they would like to see. The number must between 1 and 300. 
; Perform input validation to ensure that user follows those guidlines 

INCLUDE Irvine32.inc
UPPER_LIMIT = 300
LOWER_LIMIT = 1

.data
;My name and title or program
program_title	BYTE	"Ranged composit numbers by ", 0
my_name			BYTE	"Adam Slusser", 0

;Messaages to display to the user
divider			BYTE	"========================================================================================", 0
instruction		BYTE	"Please enter the number of composites you would like the program to perform.", 0
instruction2	BYTE	"This program allows for numbers between 1 and 300. Please keep your entry in this range.", 0
error_message	BYTE	"I'm sorry but the number you entered was not between 1 and 300. Please try again.", 0
spaces			BYTE	"   ",0
bye				BYTE	"Thanks for using my program and have a great day.",0

;Number Variables
num_on_line		BYTE	0
user_number		DWORD	?
found			DWORD	0
test_number		DWORD	2
composit_total	DWORD	0



.code
main PROC
	call	introduction
	call	get_number
	call	print_numbers
	call	good_bye

	exit	; exit to operating system
main ENDP

;/////////////////////////////////////////////////
;Display the introduction with the title of the
;program as well as my name.
;/////////////////////////////////////////////////

introduction PROC
	mov		edx, OFFSET program_title
	call	WriteString
	mov		edx, OFFSET my_name
	call	WriteString
	call	CrLf
	mov		edx, OFFSET divider
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP

;/////////////////////////////////////////////////
;Ask the user for how many composits they would 
;like and tell them the limits they are allowed 
;to enter. Then retrieve that number.
;/////////////////////////////////////////////////

get_number PROC
;Display instructions for the user.
	mov		edx, OFFSET instruction
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruction2
	call	WriteString
	call	CrLf

;Retrieve number and validate it's within bounds.
	call	ReadInt
	mov		user_number, eax
	call	input_validation

	ret
get_number ENDP

;/////////////////////////////////////////////////
;Input validation to ensure the number the user
;entered is between 1 and 300.
;/////////////////////////////////////////////////

input_validation PROC
	cmp		user_number, LOWER_LIMIT
	JL		invalid_input

	cmp		user_number, UPPER_LIMIT
	JG		invalid_input

	JMP		input_good

	invalid_input:
	mov		edx, OFFSET error_message
	call	WriteString
	call	CrLf
	mov		edx, OFFSET divider	
	call	CrLf
	call	CrLf
	call	get_number

	input_good:  
	call	CrLf
	mov		edx, OFFSET divider
	call	WriteString
	call	CrLf	
	ret
input_validation ENDP


;/////////////////////////////////////////////////
;First calls a procedure to find a composite number
;if the number found to be a composite prints the
;number. Finally checks to make sure there are no
;more than 10 numbers on the line. If there are
;jump to a new line. 
;/////////////////////////////////////////////////

print_numbers PROC

	search:
		mov		found, 0			;Acts as bool to see if composite was found.
		call	composite_search
		cmp		found, 1
		JE		print
		inc		test_number			
		mov		eax, composit_total	;Keep going until the number found is number entered.
		cmp		eax, user_number	
		JL		search
		JMP		done
	
	
	print:
		mov		eax, test_number	
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		test_number

		;Test to see if a new line is needed
		inc		num_on_line
		cmp		num_on_line, 10
		JE		new_line
		JMP		search

		new_line:
		call	CrLf
		mov		num_on_line, 0
		JMP		search

	done:
	ret
print_numbers ENDP

;/////////////////////////////////////////////////
;Input validation to ensure the number the user
;entered is between 1 and 300.
;/////////////////////////////////////////////////

composite_search PROC

	mov		ecx, test_number
	dec		ecx

	testing:
		cmp		ecx, 1				;Since 1 cannot be a composite number if our test is one we're through.
		JE		none_left
		
		mov		eax, test_number
		cdq
		div		ecx
		cmp		edx, 0
		JE		got_one				;If modulus is 0 our test number is a composite.
		loop	testing;

	got_one:
		mov		found, 1			;Set bool to true to indicate we found composite number.
		inc		composit_total

	none_left:
		ret

composite_search ENDP

;/////////////////////////////////////////////////
;Goodbye message.
;/////////////////////////////////////////////////

good_bye PROC
	call	CrLf
	call	CrLf
	mov		edx, OFFSET divider
	call	WriteString
	call	CrLf	
	mov		edx, OFFSET bye
	call	WriteString
	call	CrLf

ret
good_bye ENDP

END main
