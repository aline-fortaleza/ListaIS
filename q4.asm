org 0x7c00
jmp start

start:
    xor ax, ax ;leitor
    xor bx, bx ;contador geral
    xor cx, cx ;contador
    call read
    xor ax, ax
    call return
    xor ax, ax
    call solve
    call return
    jmp done
    
    
read:
    xor ax, ax
    call get_char
    cmp al, 0x0d
    je .exit
        cmp al, '-'
        je .next
            sub al, '0'
            add bl, al
            add al, '0'
            call put_char
            jmp read
        .next:
            call put_char
            jmp read
    .exit:
        ret
    
    
    
get_char:
    mov ah, 0x00 
    int 16h        ; interrupção do teclado
    ret
    
put_char:
    mov ah, 0x0e  ; valor expecifico para printar
    int 10h       ; ^
    ret
    
return: ;função p ler o enter
    mov ax, 0x0a
    call put_char
    mov ax, 0x0d ; segunda parte do enter
    call put_char
    ret
    
solve:
    cmp bx, 9
    ja .decrease
        add bx, cx
        xor cx, cx
        cmp bx, 9
        ja solve
        add bx, '0'
        mov ax, bx
        call put_char
        ret
    .decrease:
        inc cx
        sub bx, 10
        jmp solve


done:
    jmp $
   
times 510 - ($ - $$) db 0
dw 0xaa55 
