section .data
	cr: db 10
	crL: equ $-cr

section .bss
	d1: resb 1
	d2: resb 2
	n1: resb 1
	n2: resb 1
	q: resb 1
	rem: resb 1
	
section .text
	global _start:
	_start:
		mov eax, 3
		mov ebx, 0
		mov ecx, d1
		mov edx, 1
		int 80h

		mov eax, 3
		mov ebx, 0
		mov ecx, d2
		mov edx, 2
		int 80h

		sub byte[d1], 30h
		sub byte[d2], 30h

		;n1 = 10*d1 + d2
		mov al, byte[d1]
		mov bl, 10
		mul bl
		movzx bx, byte[d2]
		add ax, bx

		;now n1 has the first 2 digit number
		mov byte[n1], al

		mov eax, 3
		mov ebx, 0
		mov ecx, d1
		mov edx, 1
		int 80h

		mov eax, 3
		mov ebx, 0
		mov ecx, d2
		mov edx, 2
		int 80h

		sub byte[d1], 30h
		sub byte[d2], 30h

		;n2 = 10*d1 + d2
		mov al, byte[d1]
		mov bl, 10
		mul bl
		movzx bx, byte[d2]
		add ax, bx

		;now n2 has the first 2 digit number
		mov byte[n2], al

		;n1 and n2 has the two numbers
		mov ax, word[n1]
		add ax, word[n2]

		;ax has a 3 digit number and i want to print it	
		mov bl, 100
		mov ah, 0
		div bl
		mov byte[q], al
		mov byte[rem], ah

		;print(q)
		add byte[q], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, q
		mov edx, 1
		int 80h

		mov ah, 0
		mov ax, word[rem]

		mov bl, 10
		mov ah, 0
		div bl
		mov byte[q], al
		mov byte[rem], ah

		;print(q)
		add byte[q], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, q
		mov edx, 1
		int 80h

		;print(rem)
		add byte[rem], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, rem
		mov edx, 1
		int 80h

		;print(\n)
		mov eax, 4
		mov ebx, 1
		mov ecx, cr
		mov edx, crL
		int 80h

		mov eax, 1
		mov ebx, 0
		int 80h







