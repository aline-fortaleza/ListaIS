org 0x7c00
jmp 0x0000:start

x dd 0
y dd 0
z dd 0
w dd 0

op1 dq 0
op2 dq 0
op3 dq 0
op4 dq 0
res1 dq 0
res2 dq 0
res_fim dq 0

msginv db "Nao se divide por 0", 0
msgpar db "O resultado eh par", 0
msgimpar db "O resultado eh impar", 0

string times 16 db 0

getchar: 
    mov ah, 0x00
    int 16h
    ret
delchar:
    mov al, 0x08
    call putchar

    mov al, ''
    call putchar

    mov al, 0x08
    call putchar
    ret
gets:
    xor cx,cx 
    .loop1:
        call getchar
        cmp al, 0x08 ; 0x08 == espaço
        je .backspace
        cmp al, 0x0d
        je .done
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
        call end
    ret

putchar:
    mov ah, 0x0e 
    int 10h
    ret
stoi:							; mov si, string
	xor cx, cx
	xor ax, ax
	.loop1:
		push ax
		lodsb
		mov cl, al
		pop ax
		cmp cl, 0				; check EOF(NULL)
		je .endloop1
		sub cl, 48				; '9'-'0' = 9
		mov bx, 10
		mul bx					; 999*10 = 9990
		add ax, cx				; 9990+9 = 9999
		jmp .loop1
	.endloop1:
	ret

printString:
    .loop:
        lodsb ; carrega caracter em la
        cmp al, 0 ; verifica o fim da string

        je .endloop
        call putchar

        jmp .loop

    .endloop:
    ret

invalida: ; printar a mensagem invalida
    xor si, si
    mov si, msginv
    call printString
    call end
    ret

par:
    xor si, si
    mov si, msgpar
    call printString
    call end
    ret

impar:
    xor si, si
    mov si, msgimpar
    call printString
    call end
    ret

pegar:
    xor ax,ax ; zerar registrador
    
    mov di, string ; apontar pra string para guardar
    call gets ; pegar a string

    mov si, string ; apontar pra string para transformar
    call stoi
    add ax, 48 ; transformar pra inteiro
    ret

start:
; para o x
    
    call pegar ; pega os numeros e transforma em inteiro
    mov [x], ax ; guardar o numero
    call putchar

    ; para o y
    call pegar
    mov [y], ax ; guardar o numero
    call putchar

    ; para z
    call pegar
    mov [z], ax ; guardar o numero
    call putchar

    ; para w
    call pegar
    mov [w], ax ; guardar o numero
    call putchar
    

    ; fazendo a primeira operação
    xor ax,ax
    mov ax,[x] ; mover x no registrador
    mov bx,bx
    mov bx, [y]; mover y no registrador
    imul ax,bx ; multiplica ax por bx e guarda em ax
    mov [op1], ax ; guarda o resultado da multiplicação que ta em ax na primeira operação


    ; fazendo a segunda operação
    xor ax,ax
    mov ax, [z] ; mover z para o registrador
    xor bx,bx
    mov bx, [w] ; mover w para o registrador
    imul ax,bx ; multiplica ax por bx e guarda em ax
    mov [op2], ax ; guarda o resultado da operação 2

    ; fazendo a terceira operação
    xor ax,ax
    mov ax, [x]
    xor bx,bx
    mov bx,[z]
    cmp bx, 0
    je invalida
    xor dx,dx
    div bx
    mov [op3], ax

    ; fazendo a quarta operação
    xor ax,ax
    mov ax, [w]
    xor bx,bx
    mov bx,y
    cmp bx, 0
    je invalida
    xor dx,dx
    div bx
    mov [op4],ax 

    ; soma entre op 1 e op 2
    xor ax,ax 
    mov ax, [op1]
    xor bx,bx
    mov bx,[op2]
    add ax,bx
    mov [res1],ax

    ; subtração entre op4 e op3
    xor ax,ax 
    mov ax, [op4]
    xor bx,bx
    mov bx,[op3]
    sub ax,bx
    mov [res2], ax

    ; somar as duas partes
    xor ax,ax 
    mov ax, [res1] 
    xor bx,bx
    mov bx, [res2]
    add ax,bx
    mov [res_fim], ax ; note que ax ainda eh igual a res_fim

    ; checar se é par ou impar 
    xor cx,cx 
    mov cx,2
    xor dx,dx
    div cx
    cmp dx, 0
    je par 
    call impar
    mov ax,0
    ret  


end:
times 510 - ($ - $$) db 0
dw 0xaa55




