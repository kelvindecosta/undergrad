# Optimization

## [`q1`](q1/)

```bash
gcc -Wall -O0 test.c -lm -o test0
gcc -Wall -O1 test.c -lm -o test1
gcc -Wall -O2 test.c -lm -o test2
gcc -Wall -O3 test.c -lm -o test3
gcc -Wall -O3 test.c -lm -o test3fr -funroll-loops
```

## [`q2`](q2/)

```bash
yacc -v calc.y
```

The above command generates:

- `y.output`, describing a finite state automata for the grammar described in `calc.y`.
- `y.tab.c`.

```bash
yacc -g calc.y
```

The above command generates `y.dot`, which defines a graph for the finite state automata using the [DOT graph description language](<https://en.wikipedia.org/wiki/DOT_(graph_description_language)>).
