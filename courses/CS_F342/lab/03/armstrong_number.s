.data
    msg0:	.asciiz "Enter a number : "
    msg1:	.asciiz " is"
    msg2:	.asciiz	" not"
    msg3:	.asciiz	" an amstrong number"

.text
.globl main
main:
    li $v0, 4
    la $a0, msg0
    syscall

    li $v0, 5
    syscall
    move $t4, $v0

    li $t0, 0
    move $t1, $t4
    li $t5, 10

loop:
    beq $t1, 0, endloop
    div $t1, $t5
    mflo $t1
    mfhi $t2
    mfhi $t3

    mult $t2, $t3
    mflo $t3
    mult $t2, $t3
    mflo $t3

    add $t0, $t0, $t3
    j loop

endloop:
    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, msg1
    syscall

    beq $t0, $t4, nextmsg
    la $a0, msg2
    syscall

nextmsg:
    la $a0, msg3
    syscall

    li $v0, 10
    syscall
.end main
