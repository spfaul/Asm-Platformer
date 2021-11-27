global _start
	section .text


_start:
	mov rax, 0x1 ; write syscall
	mov rdi, 0x1 ; choose stdout
	mov rsi, msg
	mov rdx, msglength
	syscall

	; exit
	mov rax, 0x3C
	mov rdi, 0x0 ; error code 0
	syscall

section .data
	msg: db `\033[H\033[2J`
	msglength: EQU 0x20