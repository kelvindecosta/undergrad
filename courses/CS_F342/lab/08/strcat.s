.data
    msg1: .asciiz "Enter String 1 : "
    msg2: .asciiz "Enter String 2 : "
    msg3: .asciiz "Concatenated String : "
    str1: .space 20
    str2: .space 20

.text
.globl main
main:
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 8
    la $a0, str1
    li $a1, 20
    syscall

    move $a2, $a0

    li $v0, 4
    la $a0, msg2
    syscall

    li $v0, 8
    la $a0, str2
    li $a1, 20
    syscall

    move $a3, $a0

    jal strcat

    li $v0, 4
    la $a0, msg3
    syscall

    li $v0, 4
    la $a0, 0($v1)
    syscall

    li $v0, 10
    syscall
.end main

.globl strcat
.ent strcat
strcat:
    li $t0, 0
    li $t3, 0

loop1:
    add $t1, $t0, $a2
    lbu $t2, 0($t1)

    beq $t2, $zero, loop2

    addi $t0, $t0, 1
    j loop1

loop2:
    add $t4, $t3, $a3
    lbu $t5, 0($t4)

    beq $t5, $zero, end_loop

    sb $t5, 0($t1)

    addi $t1, $t1, 1
    addi $t3, $t3, 1
    j loop2

end_loop:
    lb $t6, 0($t4)
    sb $t6, 0($t1)

    move $v1, $a2
    jr $ra
.end strcat
