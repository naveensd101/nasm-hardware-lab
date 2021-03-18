section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi
	yes: db 'yes', 10
	yesL: equ $-yes
	no: db 'no', 10
	noL: equ $-no

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
	revstr: resw 100

section .text
	global _start:
	_start:
	
	mov eax, 0
	mov ebx, string
	call read_string

	mov dword[strlen], eax

	mov ebx, string
	mov eax, 0
	mov ecx, dword[strlen]
	dec ecx
	mov edx, revstr

	fori:
		pusha
		mov dl, byte[ebx+eax]
		mov byte[char], dl
		cmp dl, 0
		je endfori
		popa
		
		pusha
		mov al, byte[char]
		mov byte[edx+ecx], al
		popa

		inc eax
		dec ecx
		jmp fori

	endfori:
	popa
	mov eax, dword[strlen]
	mov ebx, revstr
	mov word[ebx+eax], 0

	mov eax, 4
	mov ebx, 1
	mov ecx, revstr
	mov edx, dword[strlen]
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

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
		cmp byte[temp], 32
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

