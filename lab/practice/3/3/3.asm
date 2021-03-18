section .data
space:db ' '
newline:db 10
section .bss
nod: resb 1
num: resw 1
temp: resb 1
counter: resw 1
num1: resw 1
num2: resw 1
n: resd 10
array: resw 50
matrix: resw 1
count: resb 10
section .text
	global _start
	_start:
		call read_num
		mov cx,word[num]
		mov word[n],cx
		mov ebx,array
		mov eax,0
		call read_array
		mov ebx,array
		mov eax,0
		mov dx,0
	loop1:
		mov cx,word[ebx+2*eax]
		add dx,cx
		inc eax
		cmp eax,dword[n]
		jb loop1
		mov word[num], dx
		call print_num
		mov ax,dx
		mov bx,word[n]
		mov dx,0
		div bx
		mov word[num],ax
		call print_num
		;mov eax,4
		;mov ebx,1
		;mov ecx,newline
		;mov edx,1
		;int 80h
		mov eax,0
		mov ebx,array
		;call print_array
	exit:
	mov eax,1
	mov ebx,0
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
