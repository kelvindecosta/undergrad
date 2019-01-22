# GNU Compiler Collection

## q01

```bash
man gcc
```

## [`q02`](q02/)

```bash
gcc -S 02a.c
```

## [`q03`](q03/)

```bash
gcc -E 03.c > 03.i
```

## [`q04`](q04/)

```bash
gcc –m32 -O2 04.c -o a-O2.out
gcc –m32 -O2 -S 04.c; cp a.s a-O2.s
gcc –m32 -O0 -S 04.c
```

## [`q05`](q05/)

```bash
gcc 05.c
time a.out
```
