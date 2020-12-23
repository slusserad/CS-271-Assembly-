TITLE Sorting Random Integers     (sortingNumbers.asm)

; Author: Adam Slusser
; Last Modified: 11/20/2019
; OSU email address: slussera@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 4                Due Date: 11/24/2019
; Description: This program asks the user how many composites they would like to see. The number must between 1 and 300. 
; Perform input validation to ensure that user follows those guidlines 

INCLUDE Irvine32.inc

GENERATE_MAX = 999
GENERATE_MIN = 100

ENTRY_MAX = 200
ENTRY_MIN = 15

.data
;My name and title or program
program_title	BYTE	"Sorting Random Integers by ", 0
my_name			BYTE	"Adam Slusser", 0

;Messaages to display to the user
divider			BYTE	"========================================================================================", 0
instruction		BYTE	"This program generates a random sequence of numbers between 100 and 999. ", 0
instruction2	BYTE	"This list is then displayed, sorted from highest to lowest and finally the median ", 0
instruction3	BYTE	"of the list is calculated.", 0
entry_prompt	BYTE	"How many numbers would you like to enter? (15-200): ", 0
error_message	BYTE	"I'm sorry but the number you entered was not between 15 and 200. Please try again.", 0
unsort_message	BYTE	"Unsorted list: ", 0
sorted_message	BYTE	"Sorted list: ", 0
median_message	BYTE	"Median: ", 0
spaces			BYTE	"   ",0
bye				BYTE	"Thanks for using my program and have a great day.",0

;Variables to be used.
user_entry		DWORD	?
numbers_array	DWORD	ENTRY_MAX		DUP(?)


.code
main PROC
	;Display introduction
	push	OFFSET program_title
	push	OFFSET my_name
	push	OFFSET divider
	push	OFFSET instruction
	push	OFFSET instruction2
	push	OFFSET instruction3
	call	introduction


	;Get number from user. 
	push	OFFSET entry_prompt	
	push	OFFSET user_entry
	push	OFFSET error_message
	call	get_numbers

	;Fill the array with random numbers.
	push	OFFSET	numbers_array
	push	user_entry
	call	fill_array

	;Display the unsorted array
	push	OFFSET numbers_array
	push	user_entry
	push	OFFSET unsort_message
	call	display_array

	;Sort the array
	push	OFFSET numbers_array
	push	user_entry
	call	sort_array

	;Calculate and display the median
	push	OFFSET numbers_array
	push	user_entry
	push	OFFSET median_message
	call	display_median


	;Display the sorted array
	push	OFFSET numbers_array
	push	user_entry
	push	OFFSET sorted_message
	call	display_array

	;Display exit message
	call	good_bye

	exit	; exit to operating system
main ENDP


;/////////////////////////////////////////////////
;Display the introduction with the title of the
;program as well as my name.
;/////////////////////////////////////////////////

introduction PROC
	pushad
	mov		ebp, esp

	mov		edx, [ebp + 56]
	call	WriteString

	mov		edx, [ebp + 52]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 48]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 44]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 40]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 36]
	call	WriteString
	call	CrLf
	call	CrLf
	popad
	ret		16
introduction ENDP


;/////////////////////////////////////////////////
;User is prompted for how many numbers they would 
;like to enter. Number is checked to ensure it is
;between 15 and 200.
;/////////////////////////////////////////////////

get_numbers PROC

	push	ebp
	mov		ebp, esp

prompt:
	mov		edx, [ebp + 12]
	mov		eax, 0

	;Prompt user for and obtain their input. 
	mov		edx, [ebp + 16]
	call	WriteString
	call	CrLf
	call	ReadInt

	;Check to see if number user entered is within range. 
	cmp		eax, ENTRY_MAX
	JG		validation_error
	cmp		eax, ENTRY_MIN
	JL		validation_error

	;Store user entry into variable "user_entry".
	mov		ebx, [ebp + 12]
	mov		[ebx], eax	
	
	;Return to main once valid input is obtained. 
	pop		ebp
	ret		12	

validation_error:
	mov		edx, [ebp + 8]
	call	WriteString
	call	CrLf
	JMP		prompt

get_numbers ENDP



;/////////////////////////////////////////////////
;Fills the array with randomly generated numbers.
;/////////////////////////////////////////////////

fill_array	PROC

	;Initialize both the stack and array
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 12]
	mov		ecx, [ebp + 8]
	call	Randomize

fill_loop:	
	mov		eax, GENERATE_MAX	;999
	sub		eax, GENERATE_MIN	;100
	inc		eax
	call	RandomRange
	add		eax, GENERATE_MIN

	mov		[edi], eax
	add		edi, 4
	loop	fill_loop

	pop		ebp
	ret		8
fill_array	ENDP


;/////////////////////////////////////////////////////////////
;Displays the array values with set space between each number
;/////////////////////////////////////////////////////////////
display_array PROC
;Initialize stack and variables

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 16]
	mov		ecx, [ebp + 12]
	mov		edx, [ebp + 8 ]
	mov		ebx, 0 
	call	WriteString
	call	CrLf


;Keep track of the number or rows
continue:
	inc		ebx
	mov		eax, [esi]
	call	WriteDec
	add		esi, 4
	cmp		ebx, 10
	JNE		space
	call	crLf
	mov		ebx, 0
	JMP		end_cont

space:
	mov		edx, OFFSET spaces
	call	WriteString
	
end_cont:
	loop	continue
	call	CrLf


	pop		ebp
	ret		12

display_array ENDP


;//////////////////////////////////////////////
;Sorts the array values from highest to lowest. 
;//////////////////////////////////////////////
sort_array	PROC

	pushad
	mov		ebp, esp
	mov		ecx, [ebp + 36]
	mov		edi, [ebp + 40]
	dec		ecx
	mov		edx, 0

outer_loop:
	mov		eax, ebx
	mov		edx, eax 
	inc		edx
	push	ecx
	mov		ecx, [ebp + 36]


inner_loop:
	mov		esi, [edi + edx * 4]
	cmp		esi, [edi + eax * 4]
	JLE		skip
	mov		eax, edx

;If the number is not greater than skip it. 
skip: 
	inc		edx
	loop	inner_loop

;If the nuber being compared is greater than swap it.
	lea		esi, [edi + ebx * 4]
	push	esi
	lea		esi, [edi + eax * 4]
	push	esi
	call	swap_numbers
	pop		ecx
	inc		ebx
	loop	outer_loop
	popad
	ret		8

sort_array	ENDP


;Swaps the numbers in the array so they can be sorted. 
swap_numbers PROC

	pushad
	mov		ebp, esp
	mov		eax, [ebp + 40]
	mov		ecx, [eax]
	mov		ebx, [ebp + 36]
	mov		edx, [ebx]
	mov		[eax], edx
	mov		[ebx], ecx

	popad
	ret 8 
swap_numbers ENDP

;///////////////////////////////////////////////////////
;Calculates and displays the median values of the array
;///////////////////////////////////////////////////////
display_median	PROC

	pushad
	mov		ebp, esp
	mov		edi, [ebp + 44]

;Print "Median: " 
	mov		edx, [ebp + 36]
	call	WriteString

;Calculation to find the median value
	mov		eax, [ebp + 40]
	cdq
	mov		ebx, 2
	div		ebx
	shl		eax, 2
	add		edi, eax
	cmp		edx, 0
	JE		even_number

;If the array is odd show the number in the middle. 
	mov		eax, [edi]
	call	WriteDec
	call	CrLf
	call	CrLf
	JMP		done

;If array is even add the 2 numbers in the middle and divide by 2
even_number:
	mov		eax, [edi]
	add		eax, [edi - 4]
	cdq
	mov		ebx, 2
	div		ebx
	call	WriteDec
	call	CrLf
	call	CrLf

;Clear stack and return to main. 
done:
	popad
	ret 12
display_median ENDP

;/////////////////////
;Display exit message
;/////////////////////

good_bye	PROC
	mov		edx, OFFSET bye
	call	WriteString
	call	CrLf
	call	CrLf
	ret		
good_bye	ENDP
END main