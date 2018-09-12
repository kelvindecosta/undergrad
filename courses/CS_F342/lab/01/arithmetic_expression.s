.data
    msg1: .asciiz "a = "
    msg2: .asciiz "b = "
    msg3: .asciiz "c = "
    msg4: .asciiz "d = "
    msg5: .asciiz "e = "
    msg6: .asciiz "\na = a * b / c % d + e\n"

.text
.globl main
main:
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall
    add $t0, $v0, $zero

    li $v0, 4
    la $a0, msg2
    syscall

    li $v0, 5
    syscall
    add $t1, $v0, $zero

    li $v0, 4
    la $a0, msg3
    syscall

    li $v0, 5
    syscall
    add $t2, $v0, $zero

    li $v0, 4
    la $a0, msg4
    syscall

    li $v0, 5
    syscall
    add $t3, $v0, $zero

    li $v0, 4
    la $a0, msg5
    syscall

    li $v0, 5
    syscall
    add $t4, $v0, $zero

    mult $t0, $t1
    mflo $t0

    div $t0, $t2
    mflo $t0

    div $t0, $t3
    mfhi $t0

    add $t0, $t0, $t4

    li $v0, 4
    la $a0, msg6
    syscall

    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 1
    add $a0, $t0, $zero
    syscall

    li $v0, 10
    syscall
.end main
