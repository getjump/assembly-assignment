[bits 32]

section .data
  format_in db "%li", 0
  format_out db "x = %li, y = %li, d = %li", 0

  text_a db "a = ", 0
  text_b db "b = ", 0

section .bss
  a: resw 2
  b: resw 2
  d: resw 2
  x: resw 2
  y: resw 2
  x1: resw 2
  x2: resw 2
  y1: resw 2
  y2: resw 2
  q: resw 2
  r: resw 2

section .text

global start
extern _exit
extern _printf
extern _scanf

start:
  ; Align stack
  and esp, 0xFFFFFFF0

  mov dword[ esp ], text_a
  call _printf

  ; scanf
  mov dword[ esp ], format_in
  mov dword[ esp + 4 ], a
  call _scanf

  mov dword[ esp ], text_b
  call _printf

  ; scanf
  mov dword[ esp ], format_in
  mov dword[ esp + 4 ], b
  call _scanf

gcd:
  cmp dword [b], 0
  je _b_eq_zero

  mov dword [x2], 1
  mov dword [x1], 0
  mov dword [y2], 0
  mov dword [y1], 1

_loop:
  mov edx, 0

  mov eax, [a]
  div dword [b]
  mov [q], eax

  mov eax, [q]
  mul dword [b]
  mov ebx, [a]
  mov [r], ebx
  sub dword [r], eax

  mov eax, [q]
  mul dword [x1]
  mov ebx, [x2]
  mov [x], ebx
  sub dword [x], eax

  mov eax, [q]
  mul dword [y1]
  mov ebx, [y2]
  mov [y], ebx
  sub dword [y], eax

  mov eax, [b]
  mov [a], eax

  mov eax, [r]
  mov [b], eax

  mov eax, [x1]
  mov [x2], eax

  mov eax, [x]
  mov [x1], eax

  mov eax, [y1]
  mov [y2], eax

  mov eax, [y]
  mov [y1], eax

  cmp dword [b], 0
  ja _loop

_end_loop:
  mov eax, [a]
  mov dword [d], eax
  mov eax, [x2]
  mov [x], eax
  mov eax, [y2]
  mov [y], eax
  jmp _exit_c

_b_eq_zero:
  mov eax, [a]
  mov [d], eax
  mov dword [x], 1
  mov dword [y], 0
  jmp _exit_c

_exit_c:
  mov eax, [x]
  mov ebx, [y]
  mov ecx, [d]

  mov dword[ esp ], format_out
  mov dword[ esp + 4 ], eax
  mov dword[ esp + 8 ], ebx
  mov dword[ esp + 12 ], ecx
  call _printf

  mov     dword[ esp ],       0
  call   _exit
