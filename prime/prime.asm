[bits 32]

section .data
  format db "%li", 0
  text_prime db "prime", 0
  text_not_prime db "not prime", 0
  number dd 4
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

  ; if num == 1
  cmp dword [number], 1
  je _not_prime

  mov ecx, 1

_prime_check:
  add ecx, 1
  mov eax, ecx
  cmp eax, dword [sqrt_number]
  ja _prime
  mov edx, 0
  mov eax, dword [number]
  mov ebx, ecx
  div ebx
  cmp edx, 0
  je _not_prime
  jmp _prime_check


_not_prime:
  mov dword[ esp ], text_not_prime
  call _printf
  jmp _exit_c

_prime:
  mov dword[ esp ], text_prime
  call _printf
  jmp _exit_c

_exit_c:
  ; Call 'exit': exit( 0 );
  mov     dword[ esp ],       0
  call   _exit
