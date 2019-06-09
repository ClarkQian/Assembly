assume cs:code





code segment
main:
		mov ax, cs
		mov ds, ax
		mov si, offset setscreen


		mov ax, 0
		mov es, ax
		mov di, 200H

		mov cx, offset int7cend - offset setscreen

		rep movsb

		mov di, [7ch*4]
		mov word ptr es:[di], 200H
		mov word ptr es:[di+2], 0

		mov ah, 0
		int 7ch

		mov ax, 4c00H
		INT 21H

setscreen: jmp short set

	table dw offset sub1 - offset setscreen+200H, offset sub2 - offset setscreen+200H, offset sub3-offset setscreen+200H, offset sub4- offset setscreen+200H

set:
	push bx
	cmp ah, 3
	ja sret
	mov bl, ah
	mov bh, 0
	add bx, bx
	add bx, offset table - offset setscreen + 200H
	call word ptr cs:[bx]
sret:
	pop bx
	iret

;cls
sub1:
	push bx
	push cx
	push es
	mov bx, 0b800H
	mov es, bx
	mov bx, 0
	mov cx, 2000
sub1s:
	mov byte ptr es:[bx], ' '
	add bx, 2
	loop sub1s

	pop bx
	pop cx
	pop bx
	ret



;set foreground by al's rightest three bits
sub2:
	push bx
	push cx
	push es

	mov bx, 0b800H
	mov es, bx
	mov bx, 1
	mov cx, 2000
sub2s:
	and byte ptr es:[bx], 11111000b
	or es:[bx], al
	add bx, 2
	loop sub2s

	pop es
	pop cx
	pop bx
	ret


;set background by al's rightest thrre bits
sub3:
	push bx
	push cx
	push es
	mov cl, 4
	shl al, cl
	mov bx, 0b800H
	mov es, bx
	mov bx, 1
	mov cx, 2000
sub3s:
	and byte ptr es:[bx], 10001111b
	or es:[bx], al
	add bx, 2
	loop sub3s
	pop es
	pop cx
	pop bx
	ret


;roll up one line
sub4:
	push cx
	push si
	push di
	push es
	push ds

	mov si, 0b800H
	mov es, si
	mov ds,si
	mov si, 160
	mov di, 0
	cld
	mov cx, 24
sub4s:
	push cx
	mov cx, 160
	rep movsb
	pop cx
	loop sub4s

	mov cx, 80
	mov si, 0
sub4s1:
	mov byte ptr [160*24+si], ' '
	add si, 2
	loop sub4s1
	
	pop ds
	pop es
	pop di
	pop si
	pop cx
	ret
int7cend:
	nop

code ends
end main






