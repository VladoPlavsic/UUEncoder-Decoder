INCLUDE const.asm
INCLUDE macros.asm

; 0 - uue to binary
; 1 - binary to uue
MODE EQU 0

.model small
.stack 100h
.data
    INCLUDE data.asm
    inFile db 'inF.uue',0
    outFile db 'outF.txt',0
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

    mov ax, 4C00h
    int 21h

end