.data
	equation: .asciiz "x = (2 *a - b) / (a + b)"
	a: .asciiz "\na: "
	b: .asciiz " \nb: "
	fin: .asciiz "\nResult is: "
	
.text
	li $v0, 4
	la $a0, equation
	syscall
	
	la $a0, a
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $v0, 4
	la $a0, b
	syscall
	li $v0, 5
	syscall
	move $s1, $v0
	
	

	mul $t0, $s0, 2
	sub $t0, $t0, $s1
	add $t1, $s0, $s1
	div $t0, $t1
	
	mflo $a0
	
	li $v0, 1
	syscall