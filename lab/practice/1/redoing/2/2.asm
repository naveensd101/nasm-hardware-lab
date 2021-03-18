section .data
	prompt: db 'Enter your name: '
	promptL: equ $-prompt

section .bss
	nameVar: resb 1
	nameVarL: resb 1

section .text
	global _start:
		_start:
			;print(prompt)
			mov eax, 4
			mov ebx, 1
			mov ecx, prompt
			mov edx, promptL
			int 80h

			;scanf(nameVar)
			mov eax, 3
			mov ebx, 0
			mov ecx, nameVar
			mov edx, nameVarL
			int 80h

			;print(nameVar)
			mov eax, 4
			mov ebx, 1
			mov ecx, nameVar
			mov edx, nameVarL
			int 80h

			;exit()
			mov eax, 1
			mov ebx, 0
			int 80h
