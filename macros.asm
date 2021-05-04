saveRegs MACRO
    push ax
    push bx
    push cx
    push dx
ENDM

getRegs MACRO
    pop dx
    pop cx
    pop bx
    pop ax
ENDM

nullRegs MACRO
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
ENDM

; CREATE FILE
createFile MACRO fileName, fileHandler, attributes
    saveRegs
    mov ah, CREATE
    mov bx, fileHandler
    mov cx, attributes
    mov dx, fileName
    call create_file

    mov [bx], ax  ; save file handler
    lea bx, CREATE_

    operationLogger bx, cx
    getRegs
ENDM

; OPEN FILE
openFile MACRO fileName, fileHandler, mode
    saveRegs
    mov ah, OPEN
    mov al, mode
    mov bx, fileHandler
    mov dx, fileName
    call open_file

    mov [bx], ax
    lea bx, OPEN_

    operationLogger bx, cx
    getRegs
ENDM

; CLOSE FILE
closeFile MACRO fileHandler
    saveRegs
    mov ah, CLOSE
    mov bx, [fileHandler]
    call close_file

    lea bx, CLOSE_

    operationLogger bx, cx
    getRegs
ENDM

; READ FROM FILE
readFile MACRO fileHandler, bufferSize, buffer
    saveRegs
    mov ah, READ
    mov bx, [fileHandler]
    mov cx, bufferSize
    mov dx, buffer
    call read_file
    mov outBuffSize, ax

    lea bx, READ_

    operationLogger bx, cx
    getRegs
ENDM

; WRITE TO FILE
writeFile MACRO fileHandler, bufferSize, buffer
    saveRegs
    mov ah, WRITE
    mov bx, [fileHandler]
    mov cx, bufferSize
    mov dx, buffer
    call write_file

    lea bx, WRITE_

    operationLogger bx, cx
    getRegs
ENDM


; POSITION
moveCursor MACRO location, fileHandler, oldWord, youngerWord
    saveRegs
    mov ah, POSITION
    mov al, location
    mov bx, [fileHandler]
    mov cx, oldWord
    mov dx, youngerWord
    call move_cursor

    lea bx, POSITION_

    operationLogger bx, cx
    getRegs
ENDM

; CONVERT
convertEncoding MACRO convertionType, inBuffer, outBuffer, bufferSize
    ; convertionType:
    ;      0 - uue to binary
    ;      1 - binary to uue

    saveRegs
        
    cmp convertionType, 0
    je uueToBin
    cmp convertionType, 1
    je binToUue
    jmp exitConverter

    uueToBin:
        mov si, inBuffer
        mov di, outBuffer
        push bufferSize
        nullRegs
        pop ax
        mov cx, 4
        div cx
        mov cx, ax
        call uue_to_binary
        lea bx, UUE_TO_BIN_
        jmp exitConverter
    binToUue:
        mov si, inBuffer
        mov di, outBuffer
        push bufferSize
        nullRegs
        pop ax
        mov cx, 3
        div cx
        mov cx, ax
        call binary_to_uue

        lea bx, BIN_TO_UUE_
        jmp exitConverter

    exitConverter:
        mov cx, 0
        operationLogger bx, cx
        getRegs
ENDM



; LOG
operationLogger MACRO fileOperation, success
    LOCAL isError, noError, exitLogger
    saveRegs

    mov bx, fileOperation
    cmp success, 0
    je noError
    jmp isError

    isError:
        call ErrorMessage
        jmp end_program
    
    noError:
        call NoErrorMessage
        jmp exitLogger

    exitLogger: 
        getRegs
ENDM


