section .data
	prompt: db 'Enter a number (one digit): '
	promptL: equ $-prompt

	space: db ' '
	spaceL: equ $-space
	
	cr: db 10
	crL: equ $-cr
	
section .bss
	n: resb 2
	i: resb 1

section .text
	global _start:
		_start:
			;print(prompt)
			mov eax, 4
			mov ebx, 1
			mov ecx, prompt
			mov edx, promptL
			int 80h

			;scanf(n)
			mov eax, 3
			mov ebx, 0
			mov ecx, n
			mov edx, 2
			int 80h

			;making n actually integer
			sub byte[n], 30h
			;storing 0 in i
			mov byte[i], 0

			for:
				;making i to string and pringint i
				add byte[i], 30h
				;printing i
				mov eax, 4
				mov ebx, 1
				mov ecx, i
				mov edx, 1
				int 80h
				;printing ' '
				mov eax, 4
				mov ebx, 1
				mov ecx, space
				mov edx, spaceL
				int 80h

				;making i to integer
				sub byte[i], 30h
				; i = i + 1
				add byte[i], 1
				; al = byte[i]
				mov al, byte[i]
				; al - byte[n]
				cmp al, byte[n]
				;jump if i <= n
				jna for
			
			;print('\n')
			mov eax, 4
			mov ebx, 1
			mov ecx, cr
			mov edx, crL
			int 80h

			;exit(0)
			mov eax, 1
			mov ebx, 0
			int 80h

