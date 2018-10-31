.data
	num1:	.word 0
	num2:	.word 0
	result:	.word 0
	msg1:	.asciiz	"A : "
	msg2:	.asciiz	"B : "
	msg3:	.asciiz	"GCD : "

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

	lw $a0, num1
	lw $a1, num2

	jal gcd
	sw $v0, result

	li $v0, 4
	la $a0, msg3
	syscall

	li $v0, 1
	lw $a0, result
	syscall

	li $v0, 10
	syscall
.end main

.globl gcd
.ent gcd
gcd:
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)

	div $a0, $a1
	mfhi $v0

	bne $v0, $zero, gcd_next
	add $v0, $a1, $zero
	j gcd_done

gcd_next:
	add $a0, $a1, $zero
	add $a1, $v0, $zero
	jal gcd

gcd_done:
	lw $ra, ($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
.end gcd
