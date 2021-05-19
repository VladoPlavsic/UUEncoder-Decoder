INCLUDE const.asm
INCLUDE macros.asm

; 0 - uue to binary
; 1 - binary to uue
.model small
.stack 100h
.data
    INCLUDE data.asm
    MODE dw ?
    inFile db 12 dup(?),'$',0
    outFile db 12 dup(?),'$',0
    inHnd  dw ?
    outHnd dw ?
    outBuffSize dw outBuffSize_
    inBuffer db inBuffSize dup (?)
    outBuffer db outBuffSize_ dup (?)
    count db ?

.code
start:
    nullRegs
    mov ax, @data
    mov ds, ax
    mov es, ax

    jmp start_program

    INCLUDE filehnd.asm
    INCLUDE logger.asm
    INCLUDE convert.asm

start_program:
    ; get files from cmd args
    mov ah, 62h
    int 21h
    ; bx containing address of PSP
    push ds
    push si
    mov ds, bx
    xor bx, bx
    mov bl, ds:[80h]
    cmp bl, 07Eh
    jle parse_cmd
    jmp end_program

parse_cmd:
    mov byte ptr ds:[bx+81h], ' '
    mov si, 82h
    mov di, offset inFile
    
    xor ax, ax
    read_mode_:
        lodsb
        sub ax, 30h
        mov es:[MODE], ax
        inc si
        cmp al, 0
        je parse_in_file
        cmp al, 1
        je parse_in_file
        jmp exit

    parse_in_file:
        lodsb
        stosb
        cmp al, ' '
        jne parse_in_file

    mov di, offset outFile

    parse_out_file:
        lodsb
        stosb
        cmp al, ' '
        jne parse_out_file

    pop si
    pop ds

    saveRegs
    ; create out file
    lea dx, outFile
    lea bx, outHnd
    mov cx, JUST_FILE
    createFile dx, bx, cx
    
    ; close out file
    closeFile bx

    ; open out file in write mode
    mov cx, WRITE_MODE
    openFile dx, bx, cl

    ; open in file in read mode
    lea dx, inFile
    lea bx, inHnd
    mov cx, READ_MODE
    openFile dx, bx, cl

    mov count, 1

next_4k:
    ; read from in file
    lea bx, inHnd
    mov cx, inBuffSize
    lea dx, inBuffer
    readFile bx, cx, dx
    cmp outBuffSize, 0
    jne $ + 5
    jmp end_program

    ; convert and store in outBuffer
    nullRegs
  
    lea ax, inBuffer
    lea bx, outBuffer
    mov cx, outBuffSize
    mov dx, MODE
    convertEncoding dx, ax, bx, cx
    
    ; wrtie to out file
    nullRegs

    ; calculate ammount of bits to write
    mov ax, MODE
    cmp ax, 0
    jne $ + 5
    call write_binary
    mov ax, MODE
    cmp ax, 1
    jne $ + 5
    call write_uue

    mov ax, inBuffSize
    mov bx, outBuffSize
    cmp ax, bx
    je $ + 5
    jmp end_program

    jmp next_4k

write_binary:
    call calculate_bits_write_binary
    call do_write
    ret
write_uue:
    call calculate_bits_write_uue
    call do_write
    ret

do_write:
    lea bx, outHnd
    lea dx, outBuffer
    writeFile bx, cx, dx
    ret

jmp end_program
calculate_bits_write_binary:
    mov ax, outBuffSize
    mov cx, 4
    div cx

    xor cx, cx
    mov cx, outBuffSize
    sub cx, ax
    ret

calculate_bits_write_uue:
    mov ax, outBuffSize
    mov cx, 3
    div cx

    xor cx, cx
    mov cx, outBuffSize
    add cx, ax
    ret

end_program:
    ; close files
    lea bx, inHnd
    closeFile bx
    lea bx, outHnd
    closeFile bx

    ; return initial register state
    getRegs
exit:
    mov ax, 4C00h
    int 21h

end