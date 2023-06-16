org 0x7c00
jmp 0x0000:start

img db 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 9, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 9, 9, 8, 9, 9, 8, 0, 0, 0, 0, 0, 0, 8, 1, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 9, 9, 9, 9, 9, 1, 0, 0, 0, 0, 0, 0, 8, 9, 15, 15, 15, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 8, 9, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 8, 8, 8, 1, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

start:                 ; começa da questão

    mov ah, 0
    mov al, 12h
    int 10h

	xor ax, ax
    mov ds, ax
    mov es, ax
    mov dx, 0
    mov cx, 0
	mov si, 0
	mov si, img
	call imprimir_imagem
	ret

imprimir_imagem:

	lodsb
	mov ah, 0ch
    mov bh, 0
    int 10h
	inc cx
	cmp cx, 16
	
	je ir
	jmp imprimir_imagem

ir:

	mov cx, 0
	inc dx
	cmp dx, 16

	je done
	jmp imprimir_imagem

done: 				; acaba o programa

    jmp $

times 510 - ($-$$) db 0
dw 0xaa55
