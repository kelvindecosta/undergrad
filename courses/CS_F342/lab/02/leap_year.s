.data
	msg0:	.asciiz "Enter a year : "
	msg1:	.asciiz " is a leap year"
	msg2:	.asciiz " is not a leap year"

.text
.globl main
main:
	li $v0, 4
	la $a0, msg0
	syscall

	li $v0, 5
	syscall
	move $t0, $v0

	li $t1, 4
	li $t2, 100
	li $t3, 400

	div $t0, $t1
	mfhi $t1

	div $t0, $t2
	mfhi $t2

	div $t0, $t3
	mfhi $t3

	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4

	divby4:
		beq $t1, 0, divby100
		j divby400

	divby100:
		bne $t2, 0, leapyear
		j divby400

	divby400:
		beq $t3, 0, leapyear
		j noleapyear

	leapyear:
		la $a0, msg1
		j endleap

	noleapyear:
		la $a0, msg2

	endleap:
		syscall

		li $v0, 10
		syscall
.end main
