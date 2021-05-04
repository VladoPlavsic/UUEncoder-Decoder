uue_to_binary:
    next_binary:
        push cx
        nullRegs
        pop cx
        ; first
        mov ax, [si]
        xor ah, ah
        sub ax, 32d
        shl ax, 2
        mov bx, [si + 1]
        sub bx, 32d
        mov dx, 00110000b
        and bx, dx
        shr bx, 4
        or al, bl
        mov [di], ax

        inc si
        inc di

        ; second
        mov ax, [si]
        xor ah, ah
        sub ax, 32d
        shl ax, 4
        mov bx, [si + 1]
        sub bx, 32d
        mov dx, 00111100b
        and bx, dx
        shr bx, 2
        or al, bl
        mov [di], ax

        inc si
        inc di

        ; third
        mov ax, [si]
        xor ah, ah
        sub ax, 32d
        shl ax, 6
        mov bx, [si + 1]
        sub bx, 32d
        mov dx, 00111111b
        and bx, dx
        or al, bl
        mov [di], ax

        inc si
        inc si
        inc di

        dec cx
        jnz next_binary

    ret

binary_to_uue:
    cmp cx, 0
    jne next_uue
    jmp exit_uue
    next_uue:
        push cx
        nullRegs
        pop cx
        ; first
        mov ax, [si] ; load first character
        push ax
        mov dx, 11111100b
        and ax, dx
        shr ax, 2
        add ax, 32d
        mov [di], ax
        inc si
        inc di

        ; second
        pop ax
        mov bx, [si]
        push bx

        mov dx, 00000011b
        and ax, dx
        mov dx, 11110000b
        and bx, dx
        mov bh, al
        shr bx, 4
        add bx, 32d
        mov [di], bx
        inc si
        inc di

        ; third
        pop ax
        mov bx, [si]
        push bx

        mov dx, 11000000b
        and bx, dx
        mov dx, 00001111b
        and ax, dx
        mov bh, al
        shr bx, 6
        add bx, 32d
        mov [di], bx

        inc si
        inc di

        ; fourt
        pop ax
        mov dx, 00111111b
        and ax, dx
        add ax, 32d
        mov [di], ax

        inc di

        dec cx
        jz exit_uue
        jmp next_uue

    exit_uue:
        ret