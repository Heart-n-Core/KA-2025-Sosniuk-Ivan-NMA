.model tiny
.code
org 100h
start:
    mov [buffer+32000], '$'
    call copy_param
    call read_file

    cmp [buffer+32000], '$';file size limit 32000 byte control
    jne end

    mov si, offset buffer       ;locate line and rules in appropriate vars
    mov ax, [si]
    add si, ax
    add line, si    
    mov ax, [si+4]
    mov bx, ax
    mov line_size, bx
    add si, ax
    add si, 6
    mov [si], '$$'     ;clear 0d0a
    mov ax, [si+2]
    mov cx, ax      ;rule length
    add cx, 6
    push cx
    mov di, line
    add di, 32767    ;-1
    add di, cx
    add si, cx
    dec si
    std
    rep movsb
    pop ax
    mov cx, 32771  ;+3
    sub cx, bx
    inc di
    mov rules, di
    mov di, si
    inc di
    mov ax, '$'       ;set symbol for filling gap
    cld
    rep stosb

    print:
    mov ah, 9h      ;display working line - final result
    mov dx, [line]
    int 21h

    end:
    mov ax, 4C00h
    int 21h

    exceed:     ;line size exceed case for future(recover and output original line)
    call read_file
    mov di, line
    add di, line_size
    mov [di], '$'
    jmp print

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
; mov ah, 9h
; mov dx, offset buffer
; int 21h

ret
read_file endp

rules dw 0     ;pointer at rules
line dw 8       ;pointer at line
filename db '          ', '$'
address dw '$'
line_size dw 0
buffer db 0
end start
