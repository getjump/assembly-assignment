#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TYPE long

#define NOT_OPERATION -1
#define NUMBER_OPERAND -2

typedef TYPE operationFunc(TYPE, TYPE);

TYPE E[100];
int ec = 0;

char T[100];
int tc = 0;

static int transitionTable[6][7] =
  {
    { 6, 1, 1, 1, 1, 1, 5 },
    { 5, 1, 1, 1, 1, 1, 3 },
    { 4, 1, 2, 2, 1, 1, 4 },
    { 4, 1, 2, 2, 1, 1, 4 },
    { 4, 1, 4, 4, 2, 2, 4 },
    { 4, 1, 4, 4, 2, 2, 4 }
  };

int operationNumber(char operation)
{
  int number = NOT_OPERATION;

  switch(operation)
  {
    case '$':
      number = 0;
      break;
    case '(':
      number = 1;
      break;
    case '+':
      number = 2;
      break;
    case '-':
      number = 3;
      break;
    case '*':
      number = 4;
      break;
    case '/':
      number = 5;
      break;
    case ')':
      number = 6;
      break;
  }

  if(operation > 47 && operation < 58)
  {
    number = NUMBER_OPERAND;
  }

  return number;
}

TYPE _mul(TYPE a, TYPE b)
{
  return a*b;
}

TYPE _add(TYPE a, TYPE b)
{
  return a+b;
}

TYPE _sub(TYPE a, TYPE b)
{
  return a-b;
}

TYPE _div(TYPE a, TYPE b)
{
  return a/b;
}

operationFunc* operationSupport(char operation)
{
  operationFunc* fu;

  switch(operation)
  {
    case '+':
      fu = &_add;
      break;
    case '-':
      fu = &_sub;
      break;
    case '*':
      fu = &_mul;
      break;
    case '/':
      fu = &_div;
      break;
  }

  return fu;
}

void debug(char input, int functionNumber)
{
  printf("E : ");

  for(int i = 0; i <= ec; i++)
  {
    if(E[i] == '$')
      printf("$ ");
    else
      printf("%li ", E[i]);
  }

  printf("\n");

  printf("T : ");

  for(int i = 0; i <= tc+1; i++)
  {
    printf("%c ", T[i]);
  }

  printf("\n");

  printf("Input Symbol = %c\n", input);

  printf("Function Number = %i\n\n", functionNumber);
}

int process()
{
  char string[1000];

  scanf("%s", string);

  int i = 0;

  int operandCounter = 0;
  char operand[100];

  TYPE number = 0;

  E[0] = '$';
  T[0] = '$';

  while(1)
  {
    char input;
    if(string[i] != 0)
      input = string[i];
    else
      input = '$';

    int funcNum = 0;
    int opNum = operationNumber(input);
    // printf("op = %i\n", opNum);

    if(opNum == NUMBER_OPERAND)
    {
      operand[operandCounter++] = input;
    } else if(operandCounter != 0)
    {
      operand[operandCounter] = 0x0;
      number = strtol(operand, NULL, 10);

      //printf("%li\n", number);
      E[++ec] = number;
      operandCounter = 0;
    }

    if(opNum != NOT_OPERATION && opNum != NUMBER_OPERAND)
    {
      funcNum = transitionTable[operationNumber(T[tc])][opNum];
      //printf("operationNumber1 = %i, operationNumber2 = %i\n", operationNumber(T[tc]), opNum);

      TYPE firstOperand, secondOperand;
      operationFunc* op;

      switch(funcNum)
      {
        case 1:
          T[++tc] = input;
          break;
        case 2:
          secondOperand = E[ec--];
          firstOperand = E[ec--];
          op = operationSupport(T[tc]);
          E[++ec] = op(firstOperand, secondOperand);
          T[++tc] = input;
          break;
        case 3:
          T[tc] = ' ';
          tc = tc - 1;
          break;
        case 4:
          secondOperand = E[ec--];
          firstOperand = E[ec--];
          op = operationSupport(T[tc--]);
          T[tc+1] = ' ';
          TYPE r = op(firstOperand, secondOperand);
          //printf("1 = %li, 2 = %li, r = %li \n", firstOperand, secondOperand, r);
          E[++ec] = r;
          i = i-1;
          break;
        case 5:
          printf("ERORR");
          return 0;
        case 6:
          return 1;
      }
    }

    //debug(input, funcNum);

    // printf("num = %li\n", number);

    i++;
  }

  //debug(' ', -1);
  return 1;
  // printf("%s\n", &operand);
}

int main()
{
  while(process())
  {
    printf("= %li\n", E[ec]);
    ec = 0;
    tc = 0;
  }

  return 0;
}
