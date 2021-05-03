create_file:
    int 21h
    jc error_create
    xor cx, cx
    jmp no_error_create
    error_create:
    mov cx, ax
    no_error_create:
    ret

close_file:
    int 21h
    jc error_close
    xor cx, cx
    jmp no_error_close
    error_close:
    mov cx, ax
    no_error_close:
    ret

open_file:
    int 21h
    jc error_open
    xor cx, cx
    jmp no_error_open
    error_open:
    mov cx, ax
    no_error_open:
    ret

read_file:
    int 21h
    jc error_read
    xor cx, cx
    jmp no_error_read
    error_read:
    mov cx, ax
    no_error_read:
    ret

write_file:
    int 21h
    jc error_write
    xor cx, cx
    jmp no_error_write
    error_write:
    mov cx, ax
    no_error_write:
    ret

move_cursor:
    int 21h
    jc error_move
    xor cx, cx
    jmp no_error_move
    error_move:
    mov cx, ax
    no_error_move:
    ret