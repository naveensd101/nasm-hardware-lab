section .data
	odd: db 'Number is odd', 10
	oddL: equ $-odd

	even: db 'Number is even', 10
	evenL: equ $-even

section .bss
	n: resb 2

section .data
	global _start:
	_start:
		mov eax, 3
		mov ebx, 0
		mov ecx, n
		mov edx, 2
		int 80h

		sub byte[n], 30h
		
		mov bl, 2
		mov ax, 0
		movzx ax, byte[n]
		div bl
		;rem in ah
		;quo in al

		cmp ah, 0
		je eve

		oddd: 
			mov eax, 4
			mov ebx, 1
			mov ecx, odd
			mov edx, oddL
			int 80h
			jmp L1

		eve:
			mov eax, 4
			mov ebx, 1
			mov ecx, even
			mov edx, evenL
			int 80h
		
		L1:
			mov eax, 1
			mov ebx, 0
			int 80h



































