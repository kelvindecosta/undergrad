# Yacc

```bash
yacc -d prog.y
lex prog.l
gcc -c lex.yy.c
gcc -c y.tab.c
gcc lex.yy.o y.tab.o -ll
./a.out < input.txt > output.txt
```

## [`q1`](q1)

Evaluates a [prefix expression](https://en.wikipedia.org/wiki/Polish_notation).

## [`q2`](q2)

Follows the following grammar, while counting the number of `0` and `1`.

```
S -> 1A
A -> 0S | 0 | 1S
```
