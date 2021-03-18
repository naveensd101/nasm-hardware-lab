section .data
	name: db 'name line', 10
	nameL: equ $-name

	ad1: db 'address line 1', 10
	ad1L: equ $-ad1

	ad2: db 'address line 2', 10
	ad2L: equ $-ad2

	ad3: db 'address line 3', 10
	ad3L: equ $-ad3

section .text
	global _start:
		_start:
			;print(name)
			mov eax, 4
			mov ebx, 1
			mov ecx, name 
			mov edx, nameL
			int 80h

			;print(ad1)
			mov eax, 4
			mov ebx, 1
			mov ecx, ad1
			mov edx, ad1L
			int 80h

			;print(ad2)
			mov eax, 4
			mov ebx, 1
			mov ecx, ad2
			mov edx, ad2L
			int 80h

			;print(ad3)
			mov eax, 4
			mov ebx, 1
			mov ecx, ad3
			mov edx, ad3L
			int 80h

			;exit()
			mov eax, 1
			mov ebx, 0
			int 80h
		
