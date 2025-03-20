.model tiny
.code
org 100h
start:

    call copy_param
    call read_file

    ;file size limit 32000 byte control
    cmp limit, 0
    jne end

    end:
    mov ax, 4C00h
    int 21h

copy_param proc
    ; ds = PSP
    mov cx, ds:[80h]
    xor ch, ch
    mov si, 82h        ;at offset 81h space then first char of arg
    mov di, offset filename
    cld
    rep movsb
    dec di
    mov ds:[di], 0
ret
copy_param endp

read_file proc
mov dx, offset filename
mov ah, 3dh ;Open
mov al, 0   ;read only
int 21h
mov address, ax

mov ah, 3Fh    ;Read 
mov bx, address ;Source
mov cx, 32001    ;Number of bytes to read
mov dx, offset buffer ;Destination
int 21h  

MOV AH, 3Eh    ;Close
MOV BX, address
INT 21h

;TEMPORARY display file content
mov ah, 9h
mov dx, offset buffer
int 21h

ret
read_file endp

filename db '          ', '$'
address dw '$'
buffer db 32000 dup('$')
limit db 0


end start
