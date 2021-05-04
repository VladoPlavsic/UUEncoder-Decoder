; BUFFER SIZES (Must be divisible by 3 and 4!)
; dec / enc
; inBuffSize = 27648 ; ~21 sec ~= 6912 => optimal buffer size ~ 6912
inBuffSize = 6912 ; ~21 sec / 21 sec
; inBuffSize = 768 ; ~27 sec / 27 sec
; inBuffSize = 48 ; ~1 min / 52 sec

outBuffSize_ = inBuffSize + (inBuffSize / 3)

; File operation messages
OPEN_     db 'Open:', 0Ah, '$'
READ_     db 'Read:', 0Ah, '$'
WRITE_    db 'Write: ',0Ah, '$'
CLOSE_    db 'Close:', 0Ah, '$'
CREATE_   db 'Create:', 0Ah, '$'
POSITION_ db 'Position:', 0Ah, '$'
BIN_TO_UUE_ db 'Binary-to-UUE:', 0Ah, '$'
UUE_TO_BIN_ db 'UUE-to-Binary:', 0Ah, '$'

; Error messages
FILE_NOT_FOUND_MSG db 'File not found',0Ah,'$'
PATH_NOT_FOUND_MSG db 'Path not found',0Ah,'$'
TO_MANY_FILES_MSG  db 'To many files open',0Ah,'$'
ACCESS_DENIED_MSG  db 'Access denied',0Ah,'$'
BAD_HANDLE_MSG     db 'Bad handle',0Ah,'$'
DIRECTORY_DEL_MSG  db 'Trying to delete direcotry',0Ah,'$'
NO_MORE_FILES_MSG  db 'No more files found',0Ah,'$'
UNKNOWN_ERROR_MSG  db 'Unknown error raised.',0Ah, '$' 
SUCCESS_MSG        db 'Successfully executed.',0Ah, '$'