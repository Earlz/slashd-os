[org 0]
sector1: incbin "boot/boot.bin"
times 510-($-sector1)  db 0
boot_signature: dw 0xaa55 ;boot signature

sector2:

end_image:

times (1440*1024)-($-sector1)  db 66

