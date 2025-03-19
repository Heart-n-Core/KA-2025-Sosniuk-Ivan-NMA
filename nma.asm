.model tiny
.code
org 100h
start:

    call copy_param

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

filename db '          ', '$'

end start
