section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi

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
	string2: resw 100
	strlen2: resw 100

section .text
	global _start:
	_start:
	
	mov eax, 0
	mov ebx, string
	call read_string

	mov dword[strlen], eax

	mov eax, 0
	mov ebx, string2
	call read_string

	mov dword[strlen2], eax

	mov eax, dword[strlen]
	mov ebx, string
	mov ecx, string2

	for:
		mov dl, byte[ecx]
		cmp dl, 0
		je endfor
		cmp dl, 32
		je endfor
		mov byte[ebx+eax], dl
		mov byte[char], dl
		inc ecx
		inc eax
		jmp for
	endfor:
	mov byte[ebx+eax], 0

	mov ax, word[strlen]
	mov bx, word[strlen2]
	add ax, bx
	mov word[strlen], ax

	mov eax, 4
	mov ebx, 1
	mov ecx, string
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

