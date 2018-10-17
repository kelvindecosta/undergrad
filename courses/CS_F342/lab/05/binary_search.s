.data
	A:		.word -32, -16, 0, 8, 16, 32, 64
	n:		.word 7
	data:	.word -16
	msg1:	.asciiz " Found at pos: "
	msg2:	.asciiz " Not found"

.text
.globl main
main:
	lw $t0, data
	li $t1, 0
	li $t2, 0
	lw $t3, n
	add $t3, $t3, -1

L1:
	bgt $t2, $t3, end_loop
	add $t4, $t2, $t3
	srl $t4, $t4, 1
	sll $t5, $t4, 2
	lw $t6, A($t5)
	bne $t0, $t6, not_equal
	li $t1, 1
	j end_loop

not_equal:
	blt $t0, $t6, less_than
	addiu $t2, $t4, 1
	j L1

less_than:
    addiu $t3, $t4, -1
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
    move $a0, $t4
    syscall
    j exit

msg_nf:
    la $a0, msg2
	syscall

exit:
	li $v0, 10
    syscall
.end main
