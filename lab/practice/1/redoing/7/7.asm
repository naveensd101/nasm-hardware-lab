section .data
	capital: db 'The entered charecter is uppercase', 10
	capitalL: equ $-capital

	small: db 'The entered character is lowercase', 10
	smallL: equ $-small
	
section .bss
	char: resb 1

section .text
	global _start:
	_start:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 2
		int 80h

		cmp byte[char], 61h
		jb up

		low:
			mov eax, 4
			mov ebx, 1
			mov ecx, small
			mov edx, smallL
			int 80h
			jmp L1

		up:
			mov eax, 4
			mov ebx, 1
			mov ecx, capital
			mov edx, capitalL
			int 80h

		L1:
			mov eax, 1
			mov ebx, 0
			int 80h















