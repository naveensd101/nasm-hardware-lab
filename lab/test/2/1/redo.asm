section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi
	space: db ' '

section .bss
	num: resw 1
	temp: resw 1
	count: resw 1
	char: resw 100
	str: resw 100
	strlen: resw 100
	ansStr: resw 100

section .text
	global _start:
	_start:

	mov eax, 0
	mov ebx, str
	mov ecx, ansStr
	call read_string
	mov dword[strlen], eax

	mov ebx, ansStr
	call write_stirng

	mov eax, dword[strlen]
	dec eax
	mov ebx, 0
	for_this_question:
		cmp eax, dword[strlen]
		jnb exit_for_this_question
		cmp ebx, dword[strlen]
		jnb exit_for_this_question

		mov edx, ansStr
		mov cl, byte[edx+ebx]
		mov byte[char], cl
		call if_char_special
		cmp ecx, 1
		je if_part_of_outer_for
		else_part_of_outer_for:
			inside_for_loop:
				cmp eax, dword[strlen]
				jnb exit_inside_for_loop
				mov edx, str
				mov cl, byte[edx+eax]
				mov byte[char], cl
				call if_char_special
				cmp ecx, 1
				je if_part_of_inner_for
				else_part_of_inner_for:
					mov cl, byte[char]
					mov edx, ansStr
					mov byte[edx+ebx], cl
					dec eax
					inc ebx
					jmp exit_inside_for_loop

				if_part_of_inner_for:
					dec eax
					jmp inside_for_loop

			exit_inside_for_loop:

		jmp for_this_question
	if_part_of_outer_for:
		inc ebx
		jmp for_this_question
	exit_for_this_question:

	mov ebx, ansStr
	call write_stirng

	mov eax, 1
	mov ebx, 0
	int 80h

if_char_special:
	;ecx = 0 if char is alphabet
	;ecx = 1 if char is special charecter
	pusha
	cmp byte[char], 65
	jb exit_as_yes
	cmp byte[char], 122
	ja exit_as_yes
	cmp byte[char], 96
	ja exit_as_no
	cmp byte[char], 91
	jb exit_as_no

	exit_as_yes:
		popa
		mov ecx, 1
		ret
	exit_as_no:
		popa
		mov ecx, 0
		ret

read_string:
	;eax has 0
	;ebx has the string base
	;ecx has the copy string base
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
		inc ecx
		inc eax
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

write_stirng:
	;ebx has the string base
	write_string_loop:
		cmp byte[ebx], 0
		je end_write_stirng_loop

		mov dl, byte[ebx]
		mov byte[char], dl
		pusha
		mov eax, 4
		mov ebx, 1
		mov ecx, char
		mov edx, 1
		int 80h
		popa

		inc ebx
		jmp write_string_loop


	end_write_stirng_loop:
		pusha
		mov eax, 4
		mov ebx, 1
		mov ecx, newline
		mov edx, 1
		int 80h
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
