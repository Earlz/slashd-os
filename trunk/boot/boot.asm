[org 0x7C0B]
[cpu 8086]
[section .text]
entry:
mov ax,cs
mov ds,ax
mov es,ax
mov ss,ax
mov sp,0x7000

call ReadBoot
;call ReadDiskDriver

mov si,string1
mov bx,string2

mov ax,si
mov cx,bx
call _CompareStrings
je .equal
cli
hlt

.equal:
jmp $


cli
hlt



ReadBoot:
ret


;DS:SI and ES:BX being null-terminated strings
;returns with zero flag set if the same
_CompareStrings: ;Works fully(though not always safe..)
push si
push bx
push ax
.loop1:
mov al,[SI]
cmp al,[ES:BX]
jne .leave

cmp al,0
je .leave
inc si
inc bx
jmp .loop1
.leave:
pop ax
pop bx
pop si
ret



;DS:SI file string(no directory)
;ES:BX buffer place(must have at least 512 bytes)
;DL drive
_ReadFile:
push ax
mov ax,word [6]
mov cx,1
call _ReadSector
cmp byte [bx+11],byte 0 ;If not in the / directory
jne .more_search
push bx
add bx,15
call _CompareStrings
pop bx
jne .more_search



.more_search:



ret

;AX absolute sector number, DL drive
;ES:BX buffer place
;CX for number of sectors
;CF for error
_ReadSector: ;Not full error checking, but all works..
.over_check:
cmp ax,18*80*2-1
stc
jg .leave
push bx
mov [tmp],dl
.loop1:
push cx
push ax
push dx
mov cl,18 ;SPT (sectors per track)
div cl
mov cl,ah
inc cl ;now got sector
mov ah,0
mov ch,80 ;CPH(cylinders oer head)
div ch

mov ch,ah
mov dh,al

;set things up for int 13h
mov al,1 ;one sector
mov dl,[tmp]

;do it!
mov ah,0x02
int 0x13
jc .leave2
pop cx
pop ax
pop dx
add bx,512
inc ax
loop .loop1
pop bx
ret

.leave2:
pop cx
pop ax
pop dx
pop bx
.leave:
ret




[section .data]

disk_driver_name: db "dd.d",0
fs_driver_name: db "sfs.d",0
string1: db "test1 string",0
string2: db "test1 string",0


[section .bss]
reserved_space:
tmp: resb 1


