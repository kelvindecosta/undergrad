# Code Generation - Part 1

An implementation of a simple code generator that follows this grammar:

```
stmt -> id = expr
expr -> term + expr
expr -> term
term -> d
term -> num
```

Refer to [`Generator.java`](Generator.java).
