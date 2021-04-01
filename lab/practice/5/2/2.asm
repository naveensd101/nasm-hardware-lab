section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi
	space: db ' '

section .bss
	;key words
	num: resw 1
	temp: resw 1
	count: resw 1

	n: resw 10
	array: resw 50
	;key words

	string: resw 100
	strlen: resw 100
	char: resw 10
	prev: resw 10
	max: resw 10
	count_reps:resw 10

	numOfWords: resw 10

section .text
	global _start:
	_start:


	mov eax, 0
	mov ebx, string
	call read_string

	mov dword[strlen], eax

	mov word[max], 0
	mov word[count_reps], 1
	mov eax, string
	mov dl, byte[space]
	mov byte[prev], dl
	for_this_question:
		cmp byte[eax], 0
		je exit_for_this_question
		mov dl, byte[prev]
		cmp byte[eax], dl
		je if_for_this_question
		;else part
		mov word[count_reps], 0
		mov dl, byte[eax]
		mov byte[prev], dl
		if_for_this_question:
		inc word[count_reps]
			mov dx, word[max]
			cmp word[count_reps], dx
			jb inside_if_is_chill
			mov dx, word[count_reps]
			mov word[max], dx

			inside_if_is_chill:
		inc eax
		jmp for_this_question

	exit_for_this_question:

	mov ax, word[max]
	mov word[num], ax
	call print_num

	mov eax, 1
	mov ebx, 0
	int 80h

read_string:
	;eax has 0
	;ebx has the string base
	;when returning eax has strlen
	pusha
	read_string_loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h

		cmp byte[char], 0Ah
		je end_string_read
		
		popa
		mov dl, byte[char]
		mov byte[ebx], dl
		inc ebx
		inc eax
		pusha
		jmp read_string_loop


	end_string_read:
		popa
		mov dl, 0
		mov byte[ebx], dl
		;inc ebx
		;inc eax

		ret

print_ith_word:
	;eax has the i value (base 0)
	;ebx has the base pointer of the string
	pusha
	print_ith_word_for:
		cmp eax, 0
		jne else_piw_1
		call print_till_space
		popa
		ret

		else_piw_1:
		mov dl, byte[ebx]
		mov byte[char], dl
		cmp byte[char], 32
		je ifPart_else_piw_1
		inc ebx
		jmp print_ith_word_for
		ifPart_else_piw_1:
		dec eax
		inc ebx
		jmp print_ith_word_for
		
print_till_space:
	;ebx has the base pointer of the string
	pusha
	for_print_till_space:
		mov dl, byte[ebx]
		mov byte[char], dl
		cmp dl, 32
		je exit_print_till_space
		cmp dl, 0
		je exit_print_till_space
		pusha
		mov eax, 4
		mov ebx, 1
		mov ecx, char
		mov edx, 1
		int 80h
		popa

		inc ebx
		jmp for_print_till_space
	
	exit_print_till_space:
		popa
		ret

print_hi:
	pusha
	mov eax, 4
	mov ebx, 1
	mov ecx, hi
	mov edx, hiL
	int 80h
	popa
	ret
read_num:
	pusha

	mov word[num], 0

	loop_read:
		mov eax, 3
		mov ebx, 0
		mov ecx, temp
		mov edx, 1
		int 80h

		cmp byte[temp], 10
		je end_read

		mov ax, word[num]
		mov bx, 10
		mul bx
		mov bl, byte[temp]
		sub bl, 30h
		mov bh, 0
		add ax, bx
		mov word[num], ax
		jmp loop_read

		end_read:
			popa
			ret
			
print_num:
	mov byte[count], 0
	pusha

	cmp word[num], 0
	je zero_handle

	extract_no:
		cmp word[num], 0
		je print_no
		inc byte[count]
		mov dx, 0
		mov ax, word[num]
		mov bx, 10
		div bx
		push dx
		mov word[num], ax
		jmp extract_no

		print_no:
			cmp byte[count], 0
			je end_print
			dec byte[count]
			pop dx
			mov byte[temp], dl
			add byte[temp], 30h
			mov eax, 4
			mov ebx, 1
			mov ecx, temp
			mov edx, 1
			int 80h
			jmp print_no

		end_print:
			mov eax, 4
			mov ebx, 1
			mov ecx, newline
			mov edx, 1
			int 80h
			popa
			ret
		zero_handle:
			mov eax, 4
			mov ebx, 1
			mov ecx, zero
			mov edx, 1
			int 80h
			jmp end_print


