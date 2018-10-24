.data
    msg1: .asciiz "Enter number 1: "
    msg2: .asciiz "Enter number 2: "
    msg3: .asciiz "GCD : "
    num1: .word 0
    num2: .word 0
    res: .word 0

.text
.globl main
main:
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall
    sw $v0, num1

    li $v0, 4
    la $a0, msg2
    syscall

    li $v0, 5
    syscall
    sw $v0, num2

    lw $t1, num1
    lw $t2, num2
    blt $t2, $t1, next
    lw $t1, num2
    lw $t2, num1

next:
    div $t1, $t2
    mfhi $t3

loop:
    beq $t3, $zero, end_loop
    add $t1, $t2, $zero
    add $t2, $t3, $zero
    div $t1, $t2
    mfhi $t3
    j loop

end_loop:
    sw $t2, res

    li $v0, 4
    la $a0, msg3
    syscall

    li $v0, 1
    lw $a0, res
    syscall

    li $v0, 10
    syscall
.end main
