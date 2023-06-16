org 0x7c00
jmp 0x0000:start

string times 16 db 0 
msginv db "Nao se divide por 0", 0
msgpar db "O resultado eh par", 0
msgimpar db "O resultado eh impar", 0

start:
    xor ax,ax 
    ;xor ds,ax 
    ;xor es,ax 
    xor si, si
    xor di,di 
    call pegar ; pegando x
    push ax ; x na 1 pos da stack

    call pegar ; pegando y
    cmp ax,0
    je .invalida
    push ax ; y na 2 pos da stack

    call pegar ; pegando z
    cmp ax,0
    je .invalida
    push ax ; z na 3 pos da stack

    call pegar ; pegando w 
    push ax; w na 4 pos da stack

    pop ax ; ax = w
    pop bx ; bx = z
    pop cx ; cx =y 
    pop di ; dx = x
    



    ;primeira operação x . y
    imul di,cx
    push di ; guaradou x.y na pos 1 da pilha
    xchg ax, di ; ax = x.y, bx = z, cx = y, dx = w
    div cl ; recupera o x em ax ->  ax = x, bx = z, cx = y, dx = w
    


    ; segunda operação z . w
    imul bx, di 
    push bx ; guardou z.w na pos 2 da pilha
    xchg ax, bx ; ax = z.w, bx = x, cx = y, dx = w
    xchg cx,di ; ax = z.w, bx = x, cx = w, dx = y
    div cl ; recupera z em ax -> ax = z, bx = x, cx = w, dx = y
    

    ; terceira operação x/z
    xchg ax, bx ; ax = x, bx = z, cx = w, dx = y
    xchg bx,cx ; ax = x, bx = w, cx = z, dx = y
    div cl ; ax = x/z , bx = w, cx = z, dx = y
    push ax ; guardou x/z na pos 3 da pilha
  
    

    ; quarta operação w/y

    xchg ax,bx ; ax = w , bx = x/z, cx = z, dx = y 
    xchg cx,di; ax = w , bx = x/z, cx = y, dx = z
    div cl ; ax = w/y , bx = x/z, cx = y, dx = z 
    push ax ; guardou w/y na pos 4 da pilha 
    

    ; Pegar a pilha
    pop ax ; ax = w/y
    pop bx ; bx = x/z
    pop cx ; cx = z.w 
    pop di ; dx = x.y

    add di,cx ; dx = x.y + z. w -> ax = w/y, bx = x/z, cx = z.w , dx = x.y + z. w
    sub ax, bx ; ax = w/y - x/z -> ax = w/y - x/z, bx = x/z, cx = z.w , dx = x.y + z. w 
    add ax,dx ; ax = w/y - x/z + x.y + z. w, bx = x/z, cx = z.w , dx = x.y + z. w


    ; checar se eh par
    xor bx, bx
    xor di,di
    mov cx, 2
    div cl 
    cmp di,0
    je .par
    jne .impar
    

    .par:
        xor si, si
        mov si, msgpar
        call printString
        call done

    .impar:
        xor si, si
        mov si, msgimpar
        call printString
        call done


    .invalida: ; printar a mensagem invalida
        xor si, si
        mov si, msginv
        call printString
        call done 



     



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
        call endl
    ret

endl:
    mov ax, 0x0a
    call putchar
    mov ax, 0x0d
    call putchar
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



pegar:
    xor ax,ax ; zerar registrador
    
    mov di, string ; apontar pra string para guardar
    call gets ; pegar a string

    mov si, string ; apontar pra string para transformar
    call stoi
 ; transformar pra inteiro
    ret

done:
    jmp $


tostring:						; mov ax, int / mov di, string
	push di
	.loop1:
		cmp ax, 0
		je .endloop1
		xor dx, dx
		mov bx, 10
		div bx					; ax = 9999 -> ax = 999, dx = 9
		xchg ax, dx				; swap ax, dx
		add ax, 48				; 9 + '0' = '9'
		stosb
		xchg ax, dx
		jmp .loop1
	.endloop1:
	pop si
	cmp si, di
	jne .done
	mov al, 48
	stosb
	.done:
		mov al, 0
		stosb
		call reverse
		ret

reverse:						; mov si, string
	mov di, si
	xor cx, cx					; zerar contador
	.loop1:						; botar string na stack
		lodsb
		cmp al, 0
		je .endloop1
		inc cl
		push ax
		jmp .loop1
	.endloop1:
	.loop2: 					; remover string da stack				
		pop ax
		stosb
		loop .loop2
	ret	

times 510 - ($ - $$) db 0
dw 0xaa55
