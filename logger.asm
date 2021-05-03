ErrorMessage proc
    push ax
    push dx
    mov dx, bx
    call print
    pop dx
    pop ax

    cmp ax, FILE_NOT_FOUND
    je file_not_found_hnd
    cmp ax, PATH_NOT_FOUND
    je path_not_found_hnd
    cmp ax, TO_MANY_FILES
    je to_many_hnd
    cmp ax, ACCESS_DENIED
    je access_denied_hnd
    cmp ax, BAD_HANDLE
    je bad_handle_hnd
    cmp ax, DIRECTORY_DEL
    je directory_del_hnd
    cmp ax, NO_MORE_FILES
    je no_more_files_hnd
    jmp unknown_error_hnd

    file_not_found_hnd:
        lea dx, FILE_NOT_FOUND_MSG
        jmp print
    path_not_found_hnd:
        lea dx, PATH_NOT_FOUND_MSG
        jmp print 
    to_many_hnd:
        lea dx, TO_MANY_FILES_MSG
        jmp print 
    access_denied_hnd:
        lea dx, ACCESS_DENIED_MSG
        jmp print 
    bad_handle_hnd:
        lea dx, BAD_HANDLE_MSG
        jmp print 
    directory_del_hnd:
        lea dx, DIRECTORY_DEL_MSG
        jmp print 
    no_more_files_hnd:
        lea dx, NO_MORE_FILES_MSG
        jmp print 
    unknown_error_hnd:
        lea dx, UNKNOWN_ERROR_MSG
        jmp print

ErrorMessage endp

NoErrorMessage proc
    push ax
    push dx
    mov dx, bx
    call print
    pop dx
    pop ax

    lea dx, SUCCESS_MSG
    jmp print
NoErrorMessage endp

print:
    mov ah, 09h
    int 21h
    ret
