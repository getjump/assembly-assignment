[bits 32]

section .data
  format_str_in db "%s", 0
  format_str_out db "%c", 0
  string: times 100 db 0

section .bss

section .text

global start
extern _exit
extern _printf
extern _scanf

_add:
  push ebp
  mov ebp,esp

  mov eax, [ebp+12]
  add eax, dword[ebp+8]

  leave
  ret

_mul:
  push ebp
  mov ebp,esp

  mov eax, [ebp+12]
  mul dword[ebp+8]

  leave
  ret

_div:
  push ebp
  mov ebp,esp

  mov eax, [ebp+12]
  div dword[ebp+8]

  leave
  ret

_sub:
  push ebp
  mov ebp,esp

  mov eax, [ebp+12]
  sub eax, dword[ebp+8]

  leave
  ret

start:
  ; Align stack
  and esp, 0xFFFFFFF0

  mov dword[ esp ], format_str_in
  mov dword[ esp + 4 ], string
  call _scanf

  ; mov dword[ esp ], format_str_out
  ; mov dword[ esp + 4 ], ebx
  ; call _printf
  mov eax, string

_parse:
  cmp byte[eax], 0
  je _exit_c
  mov dword[ esp ], format_str_out
  mov ebx, [eax]
  mov dword[ esp + 4 ], [ebx]
  call _printf
  inc eax
  jmp _parse


_exit_c:
  ; Call 'exit': exit( 0 );
  mov     dword[ esp ],       0
  call   _exit
