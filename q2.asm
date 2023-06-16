org 0x7c00
jmp 0x0000:start


start:
    xor ax,ax
    xor si,si
    xor bx, bx
    xor dx,dx

    call gets
    call getchar
    xor bx, bx
    mov bx, ax
    call putchar

    call endl
    xor ax,ax
    xor cx,cx
    call comparar
    call printar
    jmp done


done:
    jmp $

putchar:
    mov ah,0x0e
    int 10h
ret

getchar:
    mov ah,0x00
    int 16h
ret

delchar:
    mov al,0x08
    call putchar

    mov al,''
    call putchar

    mov al, 0x08
    call putchar
ret

printString:
    .loop:
        lodsb
        cmp al,0

        je .endloop
        call putchar

        jmp .loop
    .endloop:
        ret

comparar:
    lodsb
    cmp al, 0
    je .endloop
    cmp bl,al
    je .contar
    jmp comparar

    .contar:
        inc cx
        jmp comparar
    
    .endloop:
        ret
    
printar:
    xor ax,ax
    mov ax,cx
    add ax, 48
    call putchar

    xor ax,ax
    mov ax,'/'
    call putchar

    xor ax,ax
    mov ax,dx
    add ax, 48
    call putchar
    ret


endl:
    mov ax,0x0a
    call putchar
    mov ax,0x0d
    call putchar
    ret



gets:
    xor cx,cx
    .loop1:
        call getchar
        cmp al,0x08
        je  .backspace
        cmp al, 0x0d
        je .done
        inc dx
        cmp cl,50
        je .loop1
        stosb
        inc cl
        call putchar
        jmp .loop1

        .backspace:
            cmp cl,0
            je .loop1
            dec di 
            dec cl
            mov byte[di],0
            call delchar
            jmp .loop1
    .done:
        mov al,0
        stosb
        call endl
    ret




times 510-($-$$) db 0
dw 0xaa55
