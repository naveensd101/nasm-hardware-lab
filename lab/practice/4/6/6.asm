section .data
	newline: db 10
	zero: db '0'
	hi: db 'hi', 10
	hiL: equ $-hi
	space: db ' '

section .bss
	;key words
	num: resw 1
	temp: resw 1
	count: resw 1

	n: resw 10
	array: resw 500
	;key words

	string: resw 100
	strlen: resw 100
	char: resw 1
	sumkeeper: resw 10

section .text
	global _start:
	_start:
	
	mov word[sumkeeper], 0
	mov eax, 0
	mov ebx, string
	call read_string

	mov dword[strlen], eax

	mov eax, 4
	mov ebx, 1
	mov ecx, string
	mov edx, dword[strlen]
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

	;97 to 122
	;65 to 90
	mov eax, array
	mov ebx, 0
	for1:
		cmp ebx, 26
		je endfor1
		mov word[eax+2*ebx], 0
		inc ebx
		jmp for1
	endfor1:

	mov eax, string
	for:
		mov ebx, 0
		mov bh, byte[eax]
		mov byte[char], bh
		mov bh, 0
		cmp byte[char], 0
		je endfor
		mov bl, byte[char]

		cmp bl, 65
		jb notok1
		cmp bl, 90
		ja notok1
		sub bl, 65
		mov edx, array
		mov cx, word[edx+2*ebx]
		inc cx
		mov word[edx+2*ebx], cx
		notok1:

		cmp bl, 97
		jb notok2
		cmp bl, 122
		ja notok2
		sub bl, 97
		mov edx, array
		mov cx, word[edx+2*ebx]
		inc cx
		mov word[edx+2*ebx], cx
		notok2:

		inc eax
		jmp for
	endfor:

	mov eax, array
	mov ebx, 0
	printfor:
			jmp endprintfor
			cmp ebx, 26
			je endprintfor
			pusha
			add ebx, 97
			mov byte[char], bl
			popa
			pusha
			mov eax, 4
			mov ebx, 1
			mov ecx, char
			mov edx, 1
			int 80h
			
			mov eax, 4
			mov ebx, 1
			mov ecx, space
			mov edx, 1
			int 80h
			popa
			mov cx, word[eax+2*ebx]
			mov word[num], cx
			call print_num
			inc ebx
			jmp printfor

	endprintfor:
	;eax array ptr
	;ebx array location
	;fuc will print the char space number
	mov eax, array
	mov ebx, 0
	call fun

	mov eax, array
	mov ebx, 4
	call fun

	mov eax, array
	mov ebx, 8
	call fun

	mov eax, array
	mov ebx, 14
	call fun

	mov eax, array
	mov ebx, 20
	call fun

	mov cx, word[sumkeeper]
	mov word[num], cx
	call print_num

	mov eax, 1
	mov ebx, 0
	int 80h

fun:
	pusha
	pusha
	mov ecx, ebx
	add cx, 97
	mov word[char], cx

	mov eax, 4
	mov ebx, 1
	mov ecx, char
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, 1
	int 80h
	popa
	
	mov cx, word[eax+2*ebx]
	mov word[num], cx
	add word[sumkeeper], cx
	call print_num
	popa
	ret

	
read_string:
	;eax has 0
	;ebx has the string base
	;when returning eax has strlen
	pusha
	read_string_loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h

		cmp byte[char], 0Ah
		je end_string_read
		
		popa
		mov dl, byte[char]
		mov byte[ebx], dl
		inc ebx
		inc eax
		pusha
		jmp read_string_loop


	end_string_read:
		popa
		mov dl, 0
		mov byte[ebx], dl
		;inc ebx
		;inc eax

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
