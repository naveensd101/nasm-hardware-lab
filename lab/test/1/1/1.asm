section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi

section .bss
	num: resw 1
	temp: resw 1
	count: resw 1

	n: resw 10
	array: resw 50

	n1: resw 10
	array1: resw 50
	n2: resw 10
	array2: resw 50
	n1n2: resw 20
	array3: resw 100

	a1elem: resw 1
	a2elem: resw 1
	i: resw 1

section .text
	global _start:
	_start:
		call read_num
		mov cx, word[num]
		mov word[n], cx
		mov word[n1], cx

		mov ebx, array1
		mov eax, 0
		call read_array

		call read_num
		mov cx, word[num]
		mov word[n], cx
		mov word[n2], cx

		mov ebx, array2
		mov eax, 0
		call read_array

		mov eax, dword[n1]
		mov ebx, array1
		mov word[ebx+2*eax], 100

		;mov eax, dword[n2]
		;mov ebx, array2
		;mov word[ebx+2*eax], 1000

		pusha
		mov eax, dword[n2]
		mov ebx, array2
		fort:
			mov edx, eax
			dec edx
			mov cx, word[ebx+2*edx]
			mov word[ebx+2*eax], cx
			dec eax
			cmp eax, 0
			ja fort
		popa

		mov eax, 0
		mov ebx, array2
		mov cx, 1000
		mov word[ebx+2*eax], cx

		mov word[i], 0
		mov cx, word[n1]
		mov word[n1n2], cx
		mov cx, word[n2]
		add word[n1n2], cx

		mov eax, 0
		mov ebx, dword[n2]
		dec ebx

		pusha
			mov eax, 0
			mov ebx, array2
			mov cx, word[n2]
			mov word[n], cx
			call print_array
		popa

		call print_hi

		for:

			;cmp ebx, 0
			;jnb if1:
			;mov word[a2elem], 1000
			;jmp Lfirst
			;if1:

			;cmp eax, word[n1]
			;jb if2:
			;mov word[a1elem], 1000
			;jmp Lsecond
			;if2:


			;Lsecond:
			mov edx, array2
			call pritn_hi
			mov cx, word[edx+2*ebx]
			mov word[a2elem], cx

			;Lfirst:
			mov edx, array1
			mov cx, word[edx+2*eax]
			mov word[a1elem], cx

			mov cx, word[a1elem]
			cmp cx, word[a2elem]
			jb iffinal
				elsefinal:
					pusha
					mov edx, array3
					mov eax, dword[i]
					mov cx, word[a2elem]
					mov word[edx+2*eax], cx
					popa
					dec ebx
					jmp Lfor
				iffinal:
					pusha
					mov edx, array3
					mov eax, dword[i]
					mov cx, word[a1elem]
					mov word[edx+2*eax], cx
					popa
					inc eax
			Lfor:
			pusha
			mov dx, word[i]
			cmp dx, word[n1n2]
			popa
			jb for
			
		mov ax, word[n1n2]
		mov word[n], ax
		mov eax, 0
		mov ebx, array3
		call print_array


	
		mov eax, 1
		mov ebx, 0
		int 80h
		
		
	

read_array:
	pusha
	read_loop:
	cmp eax, dword[n]
	je end_read_ar
	call read_num

	mov cx, word[num]
	mov word[ebx+2*eax], cx
	inc eax
	jmp read_loop

	end_read_ar:
		popa
		ret

print_array:
	pusha
	
	print_loop:
		cmp eax, dword[n]
		je end_print1
		mov cx, word[ebx+2*eax]
		mov word[num], cx

		call print_num
		inc eax
		jmp print_loop
		end_print1:
			popa
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




