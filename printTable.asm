assume cs:code, ds:data, ss:stack 
;TODO: 1. upon creatring a number if this number can be sent to the gpu cache instread of restore it back to data segment?
;TODO: 2. create a new data segment to store the number and then show these number by using show_str method
;TODO: *3. create a new numeric data segment

data segment
	;the year
	dd 1975,1976,1977,1978,1979,1980,1981,1982,1983
	dd 1984,1985,1986,1987,1988,1989,1990,1991,1992
	dd 1993,1994,1995
	;the year

	;the renvenue
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530, 1183000,1843000,2759000,3753000,4649000,5937000
	;the renvenue
	
	;the employee number
	dd 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8826
	dd 11542, 14430, 15257,17800
	;the employee number
	
	dd 5,3,42,104,85,210,123,111,105,125,140,136,153,211,199,209,224,239,260,304,333

	dd 320 dup(0)
	dd 32 dup(0)
data ends

stack segment
	dw 16 dup(0)
stack ends




;@dotoc2
;data pointer: ds:si ~ array end '0'
;--after call dtoc--
;(dh,dl) -> output point in the screed
;cl -> color code

code segment
main:
	mov ax, data
	mov ds, ax
	mov si, 0 ;the pointer to the string
	mov di, 150H; the pointer to the number

	mov ax, stack
	mov ss, ax
	mov sp, 32



;discharge di to point to the numeric segment offset

	mov cx, 84
parseInt:

	push cx

	;here have changed the value of ax and dx
	mov ax, [si]
	mov dx, [si+2]
	

	call dtoc
	
	add si,4

	pop cx

loop parseInt

;showResult:

;add show result code here!
;reslise now: make '1930' -> 1930.1931....

	mov si, 150H
	mov dh, 3
	mov dl, 3

	mov cx, 4
col:
	push cx
	mov dh, 3


	mov cx, 21
row:
	push cx
	
	mov cx, 2
	call show_str
	inc dh
	
	pop cx
	loop row

	
	add dl, 12
	pop cx
	loop col







	mov ax, 4c00H
	INT 21H






;input   	(ax)=dword low
;	     	(dx)=dword high
;	     	ds:si to head head
;			!si is the part of input
;output 	ds:si related be the ascii start from si(input)
;output 	di: the start of the next start numeric datasegment

dtoc:
	push ax
	push bx
	push cx
	push dx
	push si

	mov bx, 0
for:
	mov cx, 10
	call divdw ;(dx, ax) ... cx
	push cx 
	inc bx
	mov cx, ax
	jcxz tout
	
	jmp short for

tout:
	mov cx, dx
	jcxz pass	
	jmp short for ; judege whether dx,ax is all zero, otherwise continue for loop


pass:
	mov cx, bx
stod:
	pop ax
	add al, 30H
	mov [di], al
	inc di
	loop stod

	mov byte ptr [di], 0; end with 0
	inc di

	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret





;intput: (ax)=dword's low
;		 (dx)=dowrd's high
;		 (cx)=divisor
;output: (dx)=dword result's high
;		 (ax)=dowrd result's low
;		 (cx)=remainder

divdw:
	push bx
	push si
	push ax
	mov ax, dx
	xor dx, dx
	div cx

	mov si, ax
	pop ax
	div cx

	mov cx, dx
	mov dx, si
	pop si
	pop bx	
	ret

;This code is used to show string in screen
;@paramter start---------
;dh: the row index
;dl: the col index
;cl: the byte color code
;ds:si -> the head of String
;@paramter end-----------
show_str:
	push dx
	push cx
	push ax
	push bx
	push di

	mov al, dh
	mov bl, 160
	mul bl ;row calc res in ax
	mov dh, 0
	add dx, dx
	add ax, dx ;pos in ax
	mov bx, 0b800H
	mov es, bx
	mov bx, ax
	mov di, bx ;destination is es:[di]
	mov bl, cl ; mov color code to bl to empty cx
	tmp:
	mov ch, 0
	mov cl, [si]
	jcxz ok
	mov al, [si]
	mov es:[di], al
	mov es:[di].1, bl
	inc si
	add di, 2
	jmp short tmp

	ok:

		inc si
		pop di
		pop bx
		pop ax
		pop cx
		pop dx
		ret


code ends
end main






