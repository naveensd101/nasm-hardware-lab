section .data
	msg1: db 'Enter first number (one digit): '
	msg1L: equ $-msg1

	msg2: db 'Enter second number (one digit): '
	msg2L: equ $-msg2

	msg3: db ' is the largest', 10
	msg3L: equ $-msg3

section .bss
	n1: resb 2
	n2: resb 2
	
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

	;making n1 and n2 integers
	sub byte[n1], 30h
	sub byte[n2], 30h

	;if else logic
	;putting n1 into al
	mov al, byte[n1]
	cmp al, byte[n2]
	ja albig

	;print(n2)
	add byte[n2], 30h
	mov eax, 4
	mov ebx, 1
	mov ecx, n2
	mov edx, 1
	int 80h
	jmp L1

	albig:
		add byte[n1], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, n1
		mov edx, 1
		int 80h
	
	L1:
	;print(msg3)
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, msg3L
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h














