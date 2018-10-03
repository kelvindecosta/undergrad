.data
    A:      .word -32, -16, 0, 8, 16, 32, 64
    n:      .word 7
    data:   .word -1
    msg1:   .asciiz " found at pos: "
    msg2:   .asciiz " not found"

.text
.globl main
main:
    lw $t0, data
    li $t1, 0
    li $t2, 0
    lw $t3, n
    addi $t3, $t3, -1

L1:
    bgt $t2, $t3, end_loop
    add $t4, $t2, $zero
    sll $t4, $t4, 2
    lw $t5, A($t4)
    bne $t0, $t5, not_equal
    li $t1, 1
    j end_loop

not_equal:
    addi $t2, $t2, 1
    j L1

end_loop:
    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    beq $t1, $zero, msg_nf

    la $a0, msg1
    syscall

    li $v0, 1
    move $a0, $t2
    syscall
    j exit

msg_nf:
    la $a0, msg2
    syscall

exit:
    li $v0, 10
    syscall
.end main
