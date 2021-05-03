INCLUDE const.asm
INCLUDE macros.asm

.model small
.stack 100h
.data
    INCLUDE data.asm
    inFile db 'inF.uue',0
    outFile db 'outF.txt',0
    inHnd  dw ?
    outHnd dw ?
    inBuffer db inBuffSize dup (?)
    outBuffer db outBuffSize dup (?)
.code
start:
    mov ax, @data
    mov ds, ax

    jmp start_program

    INCLUDE filehnd.asm
    INCLUDE logger.asm

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

    ; read from in file
    lea bx, inHnd
    mov cx, inBuffSize
    lea dx, inBuffer
    readFile bx, cx, dx

    ; wrtie to out file
    lea bx, outHnd
    mov cx, outBuffSize
    lea dx, inBuffer
    writeFile bx, cx, dx

    ; close files
    lea bx, inHnd
    closeFile bx
    lea bx, outHnd
    closeFile bx

    ; return initial register state
    getRegs


end_program:
    mov ax, 4C00h
    int 21h

end