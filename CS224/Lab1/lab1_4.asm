.data
 	arr: .space 400
	firstMessageString: .asciiz "Please enter the size of the array (max 100)"
	secondMessageString: .asciiz " \n enter the next element"
	a: .asciiz "\n 1. Find summation of numbers stored in the array which is greater than an input number."
	b: .asciiz "\n 2. Find summation of even and odd numbers and display them."
	c: .asciiz "\n 3. Display the number of occurrences of the array elements divisible by a certain input number."
	d:.asciiz "\n 4. Quit."
	NL: .asciiz "\n"
	Space: .asciiz " "
	comma: .asciiz ", "
	sumInput: .asciiz "Enter a number "
	sumStr: .asciiz "\n Sum of the elements is: "
	evenStr: .asciiz "\n Sum of evens "
	oddStr: .asciiz "\n Sum of odd "
	enterDividor: .asciiz "Enter a dividor to find the occurence "
	divOccStr: .asciiz "Number of occurences "
	
	
.text
la $a0, firstMessageString #Address of the first prompt
li $v0, 4 #System code for printing string : 4
syscall

li $v0, 5 #System code for getting integer input
syscall

move $s0, $v0 #s0 stores the size of the array

la $t1, arr #Starting address of allocated space


li $t0, 0 #pointer for loop
#loop for taking array elements as inputs
while: beq $s0, $t0, display

	la $a0, secondMessageString #Address of the second prompt
	li $v0, 4 #System code for printing string : 4
	syscall
	
	li $a0, 0 #Taking the int input
	li $v0, 5
	syscall
	
	move $t2, $v0		#t2 contains the input
	sw $t2, ($t1)	#Storing the input to the memory
	addi $t1, $t1 ,4	#Incresing address pointer by 4	
	addi $t0, $t0,1		#Increasing loop counter by 1
	j while

#Displaying the array
display:
	li $t2, 0
	li $t0, 0
	move $a0, $zero
	la $t1, arr #Starting address of allocated space
	
	while_2:beq $s0, $t0, menu
		li $v0, 1 #Printing int
		lw $a0, ($t1)
		syscall
		li $v0, 4 
		la $a0, Space	
		syscall
		addi $t1, $t1 ,4
		addi $t0, $t0, 1
		j while_2

menu: 
	li $v0, 4
	la $a0, a
	syscall
	la $a0, b
	syscall
	la $a0, c
	syscall
	la $a0,d
	syscall
	
	li $v0, 5
	li $a0, 0
	syscall
	
	menuLoop:
	beq $v0, 1,sum
	beq $v0,2,evenOdd
	beq $v0,3,divOcc
	beq $v0,4,exit
	
	j menu
	
	sum:
		li $t0, 0
		la $t1, arr
		li $t2, 0 ##current Num
		li $t3, 0 ##sum
		
		li $v0, 4
		la $a0, sumInput
		syscall
		li $v0, 5
		syscall
		move $t5, $v0
		
		while_sum:beq $s0, $t0, printSum
		lw $t2, ($t1)
		
		bgt $t2, $t5, addNumber
		j nextNumber
		addNumber:add $t3, $t3, $t2
		nextNumber:
		addi $t1, $t1 ,4
		addi $t0, $t0, 1
		j while_sum
		printSum:
			li $v0,4
			la $a0, sumStr
			syscall
			li $v0,1
			move $a0, $t3
			syscall
			
			j menu
			
	evenOdd:
		li $t0, 0
		la $t1, arr
		li $t2, 0 ##curr
		li $t3, 0 ##sum of odds
		li $t4, 0 ## sum of evens
		li $t5, 0 ## control
		li $t6, 2 ##fixed to 2
		while_eo:beq $s0, $t0, printEo
		lw $t2, ($t1)
		
		div $t2, $t6
		mfhi $t5
		
		beq $t5, 1, odd
		add $t4, $t4, $t2
		j next
		
		odd:
		add $t3, $t3, $t2
		
		next:
		addi $t1, $t1 ,4
		addi $t0, $t0, 1
		j while_eo
		
		printEo:
			li $v0,4
			la $a0, oddStr
			syscall
			li $v0,1
			move $a0, $t3
			syscall
			
			li $v0,4
			la $a0, evenStr
			syscall
			li $v0,1
			move $a0, $t4
			syscall
			
			j menu
			
	divOcc:	
		li $t0, 0
		la $t1, arr
		li $t2, 0 ##current Num
		li $t3, 0 ##count
		
		li $v0, 4
		la $a0, enterDividor
		syscall
		
		li $v0, 5
		li $a0,0
		syscall
		
		move $t4, $v0 ##Dividor
		
		while_div: beq $s0, $t0, printDiv
		lw $t2, ($t1)
		
		div $t2, $t4
		mfhi $t5
		
		bne $t5, 0, nextDiv
			addi $t3, $t3, 1 ##Increment count
	
		nextDiv:
		addi $t1, $t1 ,4
		addi $t0, $t0, 1
		
		j while_div
		printDiv:
			li $v0,4
			la $a0, divOccStr
			syscall	
			li $v0, 1
			move $a0, $t3
			syscall		
			j menu
			
	exit:
		li $v0,10
		syscall
