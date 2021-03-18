section .data
	msg1: db 'Enter first number (one digit number): '
	msg1L: equ $-msg1

	msg2: db 'Enter second number (one digit number): '
	msg2L: equ $-msg2

	cr: db 10
	crL: equ $-cr

section .bss
	n1: resb 2
	n2: resb 2
	ans1: resb 1
	ans2: resb 1

section .text
	global _start:
		_start:
			;print(msg1)
			mov eax, 4
			mov ebx, 1
			mov ecx, msg1
			mov edx, msg1L
			int 80h

			;scanf(n1)
			mov eax, 3
			mov ebx, 0
			mov ecx, n1
			mov edx, 2
			int 80h

			;print(msg2)
			mov eax, 4
			mov ebx, 1
			mov ecx, msg2
			mov edx, msg2L
			int 80h

			;scanf(n2)
			mov eax, 3
			mov ebx, 0
			mov ecx, n2
			mov edx, 2
			int 80h

			sub byte[n1], 30h
			sub byte[n2], 30h
			mov ax, word[n1]
			add ax, word[n2]

			mov bl, 10
			mov ah, 0
			div bl

			mov byte[ans1], al
			mov byte[ans2], ah
			add byte[ans1], 30h
			add byte[ans2], 30h

			;print(ans1)
			mov eax, 4
			mov ebx, 1
			mov ecx, ans1
			mov edx, 1
			int 80h

			;print(ans2)
			mov eax, 4
			mov ebx, 1
			mov ecx, ans2
			mov edx, 1
			int 80h

			;print(\n)
			mov eax, 4
			mov ebx, 1
			mov ecx, cr
			mov edx, crL
			int 80h

			;exit(0)
			mov eax, 1
			mov ebx, 0
			int 80h



