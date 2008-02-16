[cpu 8086]
[org 0]
%include 'macro.asm'




mov ax,0xc001



cli
hlt


%include 'pageman.asm'


