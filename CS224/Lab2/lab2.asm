#Lab 2

.data
	strSize: .asciiz "\nEnter the size of the array: (0 to exit)"
	strArray: .asciiz "\n1-Initialize the array."
	strElement: .asciiz "\nEnter an element: "
	strSort: .asciiz "\n2-Bubble sort the array"
	invalid: .asciiz "\nInvalid array size. Retry"
	strMinMax: .asciiz "\n3-min and max values of the array."
	strMin: .asciiz "\nmin value is: "
	strMax: .asciiz "\nmax value is: " 
	NL: .asciiz "\n"
	space: .asciiz " "
	sortedArray: .asciiz "\nSorted Array:"
.text

main:
	li $v0,4
	la $a0,strSize
	syscall
	
	li $v0,5
	syscall
	
	move $s0,$v0 #Size of the array
	
	beq $s0,$zero,exitProgram
	blt $s0,0,invalidSize
	
	li $v0,9
	mul $a0, $s0, 4 #allocating story for 4*(size+1) bytes just to be safe
	addi $a0,$a0,4
	syscall
	
	move $s1,$v0 #Beginning addres of the array
	
	move $a0,$s0
	move $a1,$s1
	
	jal monitor
	
	move $s2,$v0 #min
	move $s3,$v1 #max
	
	li $v0,4
	la $a0,sortedArray
	syscall
	
	move $t0,$s0
	move $t1,$s1
	
	print:
		li $v0,1
		lw $a0,($t1)
		syscall
		
		li $v0,,4
		la $a0,space
		syscall
		
		addi $t0,$t0,-1
		addi $t1,$t1,4
		
		bnez $t0,print
	
	li $v0,4
	la $a0,strMin
	syscall
	
	li $v0,1
	move $a0,$s2
	syscall
	
	li $v0,4
	la $a0,strMax
	syscall
	
	li $v0,1
	move $a0,$s3
	syscall
	
	j main
	
	exitProgram:
		li $v0,10
		syscall
		
	invalidSize:
		li $v0,4
		la $a0,invalid
		syscall
		j main
	
	
	monitor:
		sw $s0, -4($sp)
		sw $s1, -8($sp)
		sw $ra, -12($sp)
		sw $s2, -16($sp) #counter for input loop
		sw $s3, -20($sp) #address to increment
		sw $s4, -24($sp) #temp
		
		move $s0, $a0 #size
		move $s1, $a1 #array address
		
		li $v0,4
		la $a0,strArray
		syscall
		
		add $s2,$zero,$s0
		add $s3,$zero,$s1
		
		inputLoop:
			beq $s2,$zero,continue
				li $v0,4
				la $a0,strElement
				syscall
				
				li $v0,5
				syscall
				
				move $s4,$v0
				
				sw $s4,($s3)
				addi $s3,$s3,4
				addi $s2,$s2,-1
				
				j inputLoop
				
		continue:
			li $v0,4
			la $a0,strSort
			syscall
			
			move $a0, $s0
			move $a1, $s1
			jal bubbleSort
			
			li $v0,4
			la $a0,strMinMax
			syscall
			
			move $a0, $s0
			move $a1, $s1
			jal minMax

			lw $s0, -4($sp)
			lw $s1, -8($sp)
			lw $ra, -12($sp)
			lw $s2, -16($sp)
			lw $s3, -20($sp) 
			lw $s4, -24($sp) 
			
			jr $ra
					
			
				
	bubbleSort:
		sw $s0, -28($sp) #size
		sw $s1, -32($sp) #address
		sw $ra, -36($sp) #return address
		sw $s2, -40($sp) #counter for loop 1
		sw $s3, -44($sp) #counter for loop 2
		sw $s4, -48($sp) #temp1
		sw $s5, -52($sp) #temp2
		sw $s6, -56($sp) #bound for inner loop
		
		move $s0,$a0
		move $s1,$a1
		
		move $s2,$zero
		
		sort:
			beq $s2,$s0,doneSort
			
			move $s3,$zero
			sub $s6,$s0,$s2
			addi $s6,$s6,-1
			
			sortLoop:
				beq $s3,$s6,nextLoop
				
				lw $s4, ($s1)
				lw $s5, 4($s1)
				
				bgt $s4,$s5,swap
				addi $s1,$s1,4
				addi $s3,$s3,1
				j sortLoop	
				
				swap:
					sw $s4,4($s1)
					sw $s5, ($s1)
					addi $s1,$s1,4
					addi $s3,$s3,1
					
					j sortLoop
				
			nextLoop:
				addi $s2,$s2,1
				lw $s1, -32($sp)
				j sort	
					
					
		doneSort:
			lw $s0, -28($sp) #size
			lw $s1, -32($sp) #address
			lw $ra, -36($sp) #return address
			lw $s2, -40($sp) #counter for loop 1
			lw $s3, -44($sp) #counter for loop 2
			lw $s4, -48($sp) #temp1
			lw $s5, -52($sp) #temp2
			lw $s6, -56($sp) #bound for inner loop	
			
			jr $ra	
			
	minMax:
		sw $s0, -28($sp) #size
		sw $s1, -32($sp) #address
		sw $ra, -36($sp) #return address
		sw $s2, -40($sp) #min
		sw $s3, -44($sp) #max
		
		move $s0,$a0
		move $s1,$a1
		
		lw $s2,($s1)
		
		mul $s3,$s0,4
		add $s1,$s3,$s1
		addi $s1,$s1,-4
		lw $s3,($s1)
		
		move $v0,$s2
		move $v1,$s3
		
		lw $s0, -28($sp) #size
		lw $s1, -32($sp) #address
		lw $ra, -36($sp) #return address
		lw $s2, -40($sp) #min
		lw $s3, -44($sp) #max
		
		jr $ra
		
		
		
