.data
	start: .asciiz "\nEnter the size of the matrix (0 to exit)"
	comma: .asciiz ","
	space: .asciiz " "
	nextLine: .asciiz "\n"
	enter: .asciiz "enter:"
	op1: .asciiz "1-Display:\n"
	col: .asciiz "col"
	row: .asciiz "row"
	op2: .asciiz "2-Row summation:\n"
	op3: .asciiz "3-Col summation\n"
	menuExit: .asciiz "0 to select size \n"
	invalid: .asciiz "Invalid\n"
	summation: .asciiz "Summation:"
	
	

.text

main:
	li $v0, 4
	la $a0, start
	syscall
	
	li $v0,5
	syscall
	
	beq $v0,0, exitMain
	
	move $s0,$v0
	
	mul $t0,$s0,4
	mul $t0,$t0,$s0
	addi $t0,$t0,4
	
	li $v0,9
	move $a0,$t0
	syscall
	
	#head
	move $s1,$v0

	move $t0,$zero
	move $t1,$zero
	
	move $t2,$s1
	
	li $t3,1
	
	loop:
		beq $t0,$s0,menu
		move $t1,$zero
		loop2:	
			beq $t1,$s0,colEnds
			sh $t3,($t2)
			addi $t2,$t2,2
			addi $t1,$t1,1
			addi $t3,$t3,1
			j loop2
		colEnds:
		
			add $t7,$t7,$t7
			addi $t0,$t0,1
			j loop
			
			add $t7,$t7,$t7
			add $t7,$t7,$t7
	
	
	menu:
	
	li $v0,4
	la $a0,op1
	syscall
	la $a0,op2
	syscall
	la $a0, op3
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	
	beq $t0,1,sub1
nop
	beq $t0,2,sub2
nop
	beq $t0,3,sub3
nop
	beq $t0,0,main
	nop
	
	li $v0,4
	la $a0,invalid
	syscall
	
	j menu
	
	
sub1:
	move $a0,$s0
	move $a1,$s1
	jal prog1			
	add $t7,$t7,$t7
	j menu
nop
nop
	
sub2:
	move $a0,$s0
	move $a1,$s1
	jal prog2
	
	j menu
	add $t7,$t7,$t7
	add $t7,$t7,$t7
	
	
	
sub3:
	move $a0,$s0
	move $a1,$s1
	jal prog3
	
	j menu
nop
nop
	j menu
	
	nop
prog1:
	move $t0,$a0
	move $t1,$a1
	
	li $v0,4
	la $a0,row
	syscall
	
	li $v0,5
	syscall
	
	#row
	move $t2,$v0
	addi $t2,$t2,-1
	
	li $v0,4
	la $a0,nextLine
	syscall
	
	la $a0,col
	syscall
	
	li $v0,5
	syscall
	
	#col
	move $t3,$v0
	addi $t3,$t3,-1
	
	li $v0,4
	la $a0,nextLine
	syscall
	
	mul $t2,$t0,$t2
	mul $t2,$t2,4
	
	mul $t3,$t3,4
	
	add $t4,$t2,$t3
	
	add $t5,$t1,$t4
	lhu $t6,($t5)
	
	li $v0,1
	move $a0,$t6
	syscall
	li $v0,4
	la $a0,nextLine
	syscall
	
	jr $ra
	
	nop
	nop
prog2:
	move $t0,$a0
	move $t1,$a1
	
	mul $t0,$t0,$t0
	addi $t3,$zero,0
	
	rowLoop:
		lhu $t4,($t1)
		add $t3,$t3,$t4
		
		addi $t1,$t1,4
		addi $t0,$t0,-1
		bne $t0,$zero,rowLoop
		
		li $v0,4
		la $a0,nextLine
		syscall
		
		li $v0,1
		move $a0,$t3
		syscall
		
		li $v0,4
	la $a0,nextLine
	syscall
	
	
		jr $ra
		
		
		
nop

nop
			
prog3:
	move $t0,$a0
	move $t1,$a0
	move $t7,$a0
	
	mul $t2,$t0,4
	
	move $t3,$a1
	move $t4, $a1
	
	li $t5,0
	
colLoop:	
	beq $t0,$0,colSumEnds
	colLoop2:
		beq $t1,$zero,colEnd
		lhu $t6,($t4)
		add $t5,$t5,$t6
		add $t4,$t4,$t2
		addi $t1,$t1,-1
	
		j colLoop2
					add $a2,$a2,$a2
	
		addi $a0,$a0,0
	colEnd:	
	move $t1,$t7
	addi $t3,$t3,4
	move $t4,$t3
	addi $t0,$t0,-1
	j colLoop
	nop

	
colSumEnds:
	li $v0,4
	la $a0,nextLine
	syscall
	
	li $v0,1
	move $a0,$t5
	syscall
	
	li $v0,4
	la $a0,nextLine
	syscall
	
	jr $ra
	
nop
nop

exitMain:

li $v0,10
syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
