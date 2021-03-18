section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi

section .bss
	num: resw 1
	temp: resw 1
	count: resw 1

	a: resw 1
	b: resw 1
	
section .text
	global _start:
	_start:
		call read_num
		mov ax, word[num]
		mov word[a], ax

		call read_num
		mov ax, word[num]
		mov word[b], ax

		call hcf

		mov ax, word[a]
		mov word[num], ax
		call print_num

		mov eax, 1
		mov ebx, 0
		int 80h

hcf:
	pusha
	mov ax, word[a]
	mov bx, word[b]
	
	cmp ax, bx
	jne whi
	popa
	ret

	whi:
		cmp ax, bx
		ja if

		else:
			sub bx, ax
			jmp Lhcf
		if:
			sub ax, bx
		Lhcf:

		cmp ax, bx
		jne whi

	mov word[a], ax
	mov word[b], bx
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



