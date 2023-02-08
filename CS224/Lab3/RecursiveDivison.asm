#RecursiveDivison

.data

msg: .asciiz "\nEnter the dividend: (0 to exit)"
msg2: .asciiz "\nEnter the divisor: "
quotitent: .asciiz "\nQuotitent: "
.text

main:
	li $v0,4
	la $a0,msg
	syscall
	
	li $v0,5
	syscall
	
	move $s0,$v0	#dividend
	
	beq $s0,0,exitMain
	
	li $v0,4
	la $a0,msg2
	syscall
	
	li $v0,5
	syscall
	
	move $s1,$v0	#divisor
	
	move $a0,$s0
	move $a1,$s1
	move $a2,$zero
	
	jal recursiveDivison
	
	move $s2, $v0
	
	li $v0,4
	la $a0, quotitent
	syscall
	
	li $v0,1
	move $a0,$s2
	syscall
	
	j main
	
	
recursiveDivison:
	addi $sp,$sp,-16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0,$a0 #dividend
	move $s1,$a1 #divisor
	move $s2,$a2 #quo
	
	blt $s0,$s1,returnQ
	
	sub $s0,$s0,$s1
	
	addi $s2,$s2,1
	
	move $a0,$s0
	move $a1,$s1
	move $a2,$s2
	
	jal recursiveDivison
	
	exitDiv:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		addi $sp,$sp,16
		
		jr $ra
	returnQ:
		move $v0,$s2
		j exitDiv
exitMain:
	li $v0,10
	syscall