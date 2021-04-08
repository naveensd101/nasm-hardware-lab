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
	char: resw 1

	stringcopy: resw 100

	numOfWords: resw 10
	length_ith: resw 10

	temp_w1: resw 100
	temp_w2: resw 100
	char1: resw 10
	char2: resw 10

	n_minus_1: resw 10
	n_minus_i_minus_1: resw 10

section .text
	global _start:
	_start:


	mov eax, 0
	mov ebx, string
	mov ecx, stringcopy
	call read_string

	mov dword[strlen], eax

	mov eax, dword[strlen]
	mov ebx, 1
	for_this_question:
		cmp eax, 0
		je exit_for_this_question
		cmp ebx, dword[strlen]
		ja exit_for_this_question

		for_find_free_ebx:
			cmp ebx, dword[strlen]
			ja exit_for_find_free_ebx
			mov ecx, stringcopy
			dec ebx
			mov dl, byte[ecx+ebx]
			inc ebx
			mov byte[char], dl
			call is_ebx_special
			cmp ecx, 0
			je exit_for_find_free_ebx
			inc ebx
			jmp for_find_free_ebx

			exit_for_find_free_ebx:

		for_find_free_eax:
			cmp eax, 0
			je exit_for_find_free_eax
			mov ecx, string
			dec eax
			mov dl, byte[ecx+eax]
			inc eax
			mov byte[char], dl
			call is_ebx_special
			cmp ecx, 0
			je exit_for_find_free_eax
			dec eax
			jmp for_find_free_eax


			exit_for_find_free_eax:

			mov ecx, string
			dec eax
			mov dl, byte[ecx+eax]
			inc eax
			mov byte[char], dl
			mov ecx, stringcopy
			dec ebx
			mov dl, byte[char]
			mov byte[ecx+ebx], dl
			call print_hi
			inc ebx

			inc ebx
			dec eax
			jmp for_this_question
			


	exit_for_this_question:


	mov eax, dword[strlen]
	mov ebx, string
	dec eax
	for_backup:
		cmp eax, 0
		je exit_for_backup
		mov dl, byte[ebx+eax]
		mov byte[char], dl

		pusha
			mov eax, 4
			mov ebx, 1
			mov ecx, char
			mov edx, 1
			int 80h
		popa
		dec eax
		jmp for_backup
		exit_for_backup:

	mov eax, 4
	mov ebx, 1
	mov ecx, string
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h


	mov eax, 1
	mov ebx, 0
	int 80h

is_ebx_special:
	mov byte[char], cl
	mov ecx, 1 ; assume its special

	cmp byte[char], 48
	jb not_number
	cmp byte[char], 57
	ja not_number
	mov ecx, 0
	not_number:

	cmp byte[char], 65
	jb not_cap
	cmp byte[char], 90
	ja not_cap
	mov ecx, 0
	not_cap:

	cmp byte[char], 97
	jb not_small
	cmp byte[char], 122
	ja not_small
	mov ecx, 0
	not_small:

	ret

compare_eax_ebx:
	;eax will have the first word
	;ebx will have the second word
	;ecx will have the result
	;0 means equal
	;1 means eax is big
	;2 means ebx is big
	for_compare:
		mov dl, byte[eax]
		mov byte[char1], dl
		mov dl, byte[ebx]
		mov byte[char2], dl
		mov dh, byte[char1]
		mov dl, byte[char2]
		cmp dh, dl
		jb eax_is_small
		cmp dh, dl
		ja ebx_is_small

		mov dh, byte[eax]
		cmp dh, 0
		jne hhh
		mov ecx, 0
		ret

		eax_is_small:
			mov ecx, 2
			ret
		ebx_is_small:
			mov ecx, 1
			ret
		hhh:
		inc eax
		inc ebx
		jmp for_compare

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

copy_ith_word_to_ecx:
	;eax has i
	;ebx has string base
	;ecx has the destination base
	pusha
	copy_ith_word_to_ecx_for:
		cmp eax, 0
		jne else_copy_ith_word_to_ecx_for_1
		call copy_till_space
		popa
		ret

		else_copy_ith_word_to_ecx_for_1:
		mov dl, byte[ebx]
		mov byte[char], dl
		cmp byte[char], 32
		je ifPart_else_copy_ith_word_to_ecx_for_1
		inc ebx
		jmp copy_ith_word_to_ecx_for
		ifPart_else_copy_ith_word_to_ecx_for_1:
		dec eax
		inc ebx
		jmp copy_ith_word_to_ecx_for

copy_till_space:
	;ecx has the destinaltion
	;ebx has the string base pointer
	pusha
	for_copy_till_space:
		mov dl, byte[ebx]
		mov byte[char], dl
		cmp dl, 32
		je exit_copy_till_space
		cmp dl, 0
		je exit_copy_till_space
		mov dl, byte[char]
		mov byte[ecx], dl
		inc ecx
		inc ebx
		jmp for_copy_till_space
	exit_copy_till_space:
		mov byte[ecx], 0
		popa
		ret
append_string:
	mov eax, string
	mov ebx, dword[strlen]
	add eax, ebx
	mov byte[eax], 32
	inc eax
	for_append_string:
		pusha
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		popa
		mov bl, byte[char]
		cmp bl, 10
		je end_for_append_string
		mov byte[eax], bl
		inc eax
		inc dword[strlen]
		jmp for_append_string

	end_for_append_string:
	mov eax, 0
	inc dword[strlen]
	ret

print_array:
	pusha
	
	print_loop:
		cmp eax, dword[n]
		je end_print1
		mov cx, word[ebx+2*eax]
		mov word[num], cx

		call print_num
		inc eax
		jmp print_loop
		end_print1:
			popa
			ret

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
		mov byte[ecx], dl
		inc ebx
		inc eax
		inc ecx
		pusha
		jmp read_string_loop


	end_string_read:
		popa
		mov dl, 0
		mov byte[ebx], dl
		mov byte[ecx], dl
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





