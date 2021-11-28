extern printf

section .text
	global main


main:
	call ClearScr

	mov eax, 0x25
	mov [curs_x], eax
	mov eax, 0x15
	mov [curs_y], eax
	call WriteToXY

	; exit
	mov rax, 0x3C
	mov rdi, 0x0 ; error code 0
	syscall


; Clears the screen
ClearScr:
	mov rax, 0x1 ; write syscall
	mov rdi, 0x1 ; choose stdout
	mov rsi, clear_str
	mov rdx, clear_len
	syscall
	ret

; Write curs_write_str to Position (curs_x, curs_y)
WriteToXY:
	mov rdi, set_curs_pos_format
	mov rsi, [curs_y]
	mov rdx, [curs_x]
	mov rcx, curs_write_str
	mov rax, 0
	call printf WRT ..plt
	ret


; Program variables
section .data
	clear_str: db `\033[H\033[2J`
	clear_len: equ $ - clear_str
	
	curs_x: dq 0x0
	curs_y: dq 0x0
	
	curs_write_str: db "Hey!", 0
	set_curs_pos_format: db `\033[%x;%xH%s`, 10, 0
	
	msg: db "asd"
	msglength: equ $ - msg
	
