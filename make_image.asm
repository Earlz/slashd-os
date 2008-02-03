[org 0]
sector1:
jmp word .bootcode
dd (1440*1024)
dw 1
dw 2
.bootcode:
incbin "boot/boot.bin"
times 510-($-sector1)  db 0
boot_signature: dw 0xaa55 ;boot signature

sector2:
db "hello there",0


end_image:

times (1440*1024)-($-sector1)  db 66

