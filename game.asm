extern printf

%define STAGE_WIDTH 	0x50
%define STAGE_HEIGHT	0x20
%define GROUND			'X'
%define PLAYER			'O'

; Program variables
section .data
	is_running: dw 1
	timespec:
		tv_sec dq 0
		tv_nsec dq 100000000

	clear_str: db `\033[H\033[2J`
	clear_len: equ $ - clear_str
	
	curs_x: dq 0
	curs_y: dq 0
	curs_write_str: db "DEBUG", 0
	set_curs_pos_format: db `\033[%u;%uH%s`, 10, 0
		
	draw_ground_count: dq 1
	player_x: dq 20
	player_y: dq 20

	buff: db "asd", 0
	file: db "/dev/input/event3", 0
	
section .text
	global main

main:
	cmp dword[is_running], 1
	je GameLoop
	jmp Exit



GameLoop:
	call ClearScr

	mov word[draw_ground_count], 0x1
	call DrawGround

	call DrawPlayer

	xor ah, ah
	int 80h
	cmp ah, 01h
	je Exit
	
	mov rax, 35
	mov rdi, timespec
	xor rsi, rsi
	syscall

	jmp main

; Uses: eax
DrawPlayer:
	mov eax, [player_x]
	mov [curs_x], eax
	mov eax, [player_y]
	mov [curs_y], eax
	mov eax, PLAYER
	mov [curs_write_str], eax
	call WriteToXY 
	ret

; Uses: eax
DrawGround:	
	mov eax, [draw_ground_count]
	mov [curs_x], eax
	mov eax, STAGE_HEIGHT
	mov [curs_y], eax
	mov eax, GROUND
	mov [curs_write_str], eax
	call WriteToXY

	mov eax, 0x1
	add [draw_ground_count], eax

	mov al, [draw_ground_count]
	mov ah, STAGE_WIDTH
	cmp al, ah
	jne DrawGround
	ret

Exit:
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
	call printf
	ret

