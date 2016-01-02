[bits 32]

section .data
  format_str_in db "%s", 0
  format_int_out db "%i", 0
  format_str_out db "%c", 0
  format_dollar db "$", 0
  eCount dd 0
  tCount dd 0

  string: times 1000 db 0
  operand: times 100 db 0
  stackE: times 100 db 0
  stackT: times 100 db 0

  _transitionTable dd 6, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 3, 4, 1, 2, 2, 1, 1, 4, 4, 1, 2, 2, 1, 1, 4, 4, 1, 4, 4, 2, 2, 4, 4, 1, 4, 4, 2, 2, 4

section .bss
  number: resw 2
  input: resw 2
  result: resw 2
  operandCounter: resw 2
  functionNumber: resw 2
  opNum: resw 2
  funcNum: resw 2
  firstOperand: resw 2
  secondOperand: resw 2
  operationFunc: resw 2

section .text

global start
extern _exit
extern _printf
extern _strtol
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

on_dollar:
  mov eax, 0
  jmp l2

on_bracket_open:
  mov eax, 1
  jmp l2

on_plus:
  mov eax, 2
  jmp l2

on_minus:
  mov eax, 3
  jmp l2

on_multiply:
  mov eax, 4
  jmp l2

on_divide:
  mov eax, 5
  jmp l2

on_bracket_close:
  mov eax, 6
  jmp l2

on_number:
  cmp ebx, 58
  jl on_number_p2
  jmp l2

on_number_p2:
  mov eax, -2
  jmp l2

operationNumber:
  push ebp
  mov ebp,esp

  mov eax, -1

  mov ebx, [ebp+8]

  cmp ebx, 36 ; $
  je on_dollar
  cmp ebx, 40 ; (
  je on_bracket_open
  cmp ebx, 41 ; )
  je on_bracket_close
  cmp ebx, 42 ; *
  je on_multiply
  cmp ebx, 43 ; +
  je on_plus
  cmp ebx, 45 ; -
  je on_minus
  cmp ebx, 47 ; /
  je on_divide

  jg on_number

l2:
  leave
  ret

os_on_plus:
  mov eax, _add
  jmp l3

os_on_minus:
  mov eax, _sub
  jmp l3

os_on_divide:
  mov eax, _div
  jmp l3

os_on_multiply:
  mov eax, _mul
  jmp l3

operationSupport:
  push ebp
  mov ebp,esp

  mov ebx, [ebp+8]

  cmp ebx, 42 ; *
  je os_on_multiply
  cmp ebx, 43 ; +
  je os_on_plus
  cmp ebx, 45 ; -
  je os_on_minus
  cmp ebx, 47 ; /
  je os_on_divide

l3:
  leave
  ret

_string_i_neq_zero:
  mov dword[input], ebx
  jmp l1

_string_i_eq_zero:
  mov dword[input], 36
  jmp l1

_op_num_eq_number_operand:
  mov edx, [operandCounter]
  lea edx, [operand + edx]
  mov [edx], ebx
  inc dword[operandCounter]
  jmp l5

_op_num_neq_number_operand:
  cmp dword[operandCounter], 0
  je l5

  mov edx, [operandCounter]
  lea edx, [operand + edx]
  mov dword[edx], 0

  mov dword[esp], operand
  mov dword[esp+4], 0
  mov dword[esp+8], 10
  call _strtol

  mov ebx, eax

  inc dword[eCount]

  push 4
  push dword[eCount]
  call _mul
  add esp, 8
debug10:
  mov [stackE + eax], ebx
  mov dword[operandCounter], 0
  jmp l5

f_n_eq_one:
  inc dword[tCount]
  mov eax, [tCount]
  lea ebx, [stackT + eax]
  mov eax, [ebx]
  mov al, [input]
  mov [ebx], eax
  jmp l6

f_n_eq_two:
  mov edx, 0
  mov eax, dword[eCount]
  mov ecx, 4
  mul ecx
  lea ebx, [stackE + eax]
  mov eax, [ebx]
  mov [secondOperand], eax
  dec dword[eCount]

  mov edx, 0
  mov eax, dword[eCount]
  mov ecx, 4
  mul ecx
  lea ebx, [stackE + eax]
  mov eax, [ebx]
  mov [firstOperand], eax
debug7:
  dec dword[eCount]

  mov edx, 0
  mov eax, dword[tCount]
  lea ebx, [stackT + eax]
  mov eax, 0
  mov al, [ebx]
debug6:
  push eax
  call operationSupport
  add esp, 4 ; align stack
  dec dword[tCount]

  push dword[firstOperand]
  push dword[secondOperand]
  call eax
debug5:
  add esp, 8 ; align stack

  mov [result], eax

  inc dword[eCount]
  mov eax, dword[eCount]
  mov ecx, 4
  mul ecx
  lea ebx, [stackE + eax]
  mov eax, [result]
  mov [ebx], eax

  inc dword[tCount]
  mov eax, dword[tCount]
  lea ebx, [stackT + eax]
  mov eax, [ebx]
  mov al, [input]
  mov [ebx], eax

  jmp l6

f_n_eq_three:
  dec dword[tCount]
  jmp l6

f_n_eq_four:
  mov edx, 0
  mov eax, dword[eCount]
  mov ecx, 4
  mul ecx
  lea ebx, [stackE + eax]
  mov eax, [ebx]
  mov [secondOperand], eax
  dec dword[eCount]

  mov edx, 0
  mov eax, dword[eCount]
  mov ecx, 4
  mul ecx
  lea ebx, [stackE + eax]
  mov eax, [ebx]
  mov [firstOperand], eax
  dec dword[eCount]

  mov edx, 0
  mov eax, dword[tCount]
  lea ebx, [stackT + eax]
  mov eax, 0
  mov al, [ebx]
  dec dword[tCount]

  push eax
  call operationSupport
  add esp, 4 ; align stack

  push dword[firstOperand]
  push dword[secondOperand]
debug17:
  call eax
debug13:
  add esp, 8 ; align stack

  mov [result], eax

  inc dword[eCount]
  mov eax, dword[eCount]
  mov ecx, 4
  mul ecx
  lea ebx, [stackE + eax]
  mov eax, [result]
  mov [ebx], eax

  dec esi
  jmp l6

f_n_eq_five:
  jmp _exit_c

f_n_eq_six:
  jmp _exit_c

op_num_greater_zero:
  mov eax, [tCount]
  lea ebx, [stackT + eax]
  mov eax, 0
  mov al, [ebx]

  push eax
debug14:
  call operationNumber
  add esp, 4 ; align stack
debug12:

  mov edx, 0
  mov ebx, 7

  mul ebx

  mov edx, [opNum]
  add eax, edx

  mov ebx, 4
  mul ebx
debug4:
  lea ebx, [_transitionTable + eax]
  mov eax, [ebx]

  mov dword[funcNum], eax
debug9:

  cmp dword[funcNum], 1
  je f_n_eq_one
  cmp dword[funcNum], 2
  je f_n_eq_two
  cmp dword[funcNum], 3
  je f_n_eq_three
  cmp dword[funcNum], 4
  je f_n_eq_four
  cmp dword[funcNum], 5
  je f_n_eq_five
  cmp dword[funcNum], 6
  je f_n_eq_six

start:
  ; Align stack
  and esp, 0xFFFFFFF0

  mov dword[ esp ], format_str_in
  mov dword[ esp + 4 ], string
  call _scanf

  ; i = 0
  mov ecx, string
  mov esi, ecx

  ; number = 0;
  mov dword[number], 0

  ; operandCounter = 0
  mov dword[operandCounter], 0

  mov dword[stackT], 36
  mov dword[stackE], 36

  mov ebx, 0

_loop:
  mov ebx, esi
  xor eax, eax
  mov al, [ebx]
  mov ebx, eax
debug2:
  mov [input], ebx
  cmp ebx, 0
  jne _string_i_neq_zero
  je _string_i_eq_zero

l1:
  mov dword[funcNum], 0

  push dword[input]
  call operationNumber
  mov dword[opNum], eax
  add esp, 4 ; align stack
debug:
l7:
  cmp dword[opNum], -2
  je _op_num_eq_number_operand
  jne _op_num_neq_number_operand

l5:
  cmp dword[opNum], 0
  jge op_num_greater_zero

l6:
sup_deb:
  inc esi
  jmp _loop

_exit_c:
  mov dword[ esp ], format_int_out
  mov eax, [eCount]
  mov edx, 0
  mov ebx, 4
  mul ebx
  lea ebx, [ stackE + eax ]
  mov eax, [ebx]
  mov dword[ esp + 4 ], eax
  call _printf
debug15:
  ; Call 'exit': exit( 0 );
  mov     dword[ esp ],       0
  call   _exit
