[bits 32]

section .data
  format db "%li", 0
  format_out db "(%li, %li)", 10, 0
  divider dd 1
  number dd 2
  sqrt_number dd 2

section .text

global start
extern _exit
extern _printf
extern _scanf

start:
  ; Align stack
  and esp, 0xFFFFFFF0

  ; scanf
  mov dword[ esp ], format
  mov dword[ esp + 4 ], number
  call _scanf

  ; sqrt
  fild dword [number]
  fsqrt
  fistp dword [sqrt_number]

_loop:
  mov eax, [divider]
  cmp eax, [sqrt_number]
  ja _exit_c
  add dword [divider], 1
  mov edx, 0
  mov eax, [number]
  div dword [divider]
  cmp edx, 0
  je _eq
  jne _loop

_eq:
  mov dword[ esp ], format_out
  mov dword[ esp + 4 ], eax
  mov ebx, [divider]
  mov dword[ esp + 8 ], ebx
  call _printf
  jmp _loop

_exit_c:
  ; Call 'exit': exit( 0 );
  mov     dword[ esp ],       0
  call   _exit
