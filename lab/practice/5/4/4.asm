section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi
	space: db ' '
	prompt: db 'all words are of equal length', 10
	promptL: equ $-prompt

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
	char: resw 1

	numOfWords: resw 10
	length_ith: resw 10

	max_value: resw 10
	max_i: resw 10
	min_value: resw 10
	min_i: resw 10

section .text
	global _start:
	_start:


	mov eax, 0
	mov ebx, string
	call read_string

	mov dword[strlen], eax

	mov eax, string
	mov ebx, 0
	for_to_find_num_of_words:
		cmp byte[eax], 0
		je exit_for_to_find_num_of_words
		cmp byte[eax], 32
		jne skip_increment_in_for
		inc ebx

		skip_increment_in_for:
		inc eax
		jmp for_to_find_num_of_words

	exit_for_to_find_num_of_words:
	inc ebx
	mov dword[numOfWords], ebx

	mov eax, 0 ;analogus to i in for loop
	mov word[max_value], 0
	mov word[min_value], 100
	mov word[max_i], 0
	mov word[min_i], 0
	for_this_question:
		cmp eax, dword[numOfWords]
		je exit_for_this_question
		mov ebx, string
		call count_ith_word
		
		mov cx, word[max_value]
		cmp cx, word[length_ith]
		ja max_value_chill
		mov cx, word[length_ith]
		mov word[max_value], cx
		mov word[max_i], ax
		max_value_chill:

		mov cx, word[min_value]
		cmp cx, word[length_ith]
		jb min_value_chill
		mov cx, word[length_ith]
		mov word[min_value], cx
		mov word[min_i], ax
		min_value_chill:

		inc eax
		jmp for_this_question


	exit_for_this_question:

	mov ax, word[max_value]
	mov bx, word[min_value]
	cmp ax, bx
	jne edge_case_chill
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, promptL
	int 80h
	mov eax, 1
	mov ebx, 0
	int 80h

	edge_case_chill:

	mov eax, dword[max_i]
	mov ebx, string
	call print_ith_word

	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, 1
	int 80h

	mov ax, word[max_value]
	mov word[num], ax
	call print_num

	mov eax, dword[min_i]
	mov ebx, string
	call print_ith_word

	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, 1
	int 80h

	mov ax, word[min_value]
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

count_ith_word:
	;eax has the i value (base 0)
	;ebx has the base pointer of the string
	;length_ith will have the length of the ith word
	pusha
	count_ith_word_for:
		cmp eax, 0
		jne else_pciw_1
		mov word[length_ith], 0
		call count_till_space
		popa
		ret

		else_pciw_1:
		mov dl, byte[ebx]
		mov byte[char], dl
		cmp byte[char], 32
		je ifPart_else_pciw_1
		inc ebx
		jmp count_ith_word_for
		ifPart_else_pciw_1:
		dec eax
		inc ebx
		jmp count_ith_word_for

count_till_space:
	;ebx has the base pointer of the string
	pusha
	for_count_till_space:
		mov dl, byte[ebx]
		mov byte[char], dl
		cmp dl, 32
		je exit_count_till_space
		cmp dl, 0
		je exit_count_till_space
		inc word[length_ith]

		inc ebx
		jmp for_count_till_space
	
	exit_count_till_space:
		popa
		ret

print_ith_word:
	;eax has the i value (base 0)
	;ebx has the base pointer of the string
	pusha
	print_ith_word_for:
		cmp eax, 0
		jne else_piw_1
		mov word[length_ith], 0
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


