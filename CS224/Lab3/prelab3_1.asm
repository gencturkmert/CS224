.data 
	start: .asciiz "\nEnter 1 to continue 0 to exit"
	firstList: .asciiz "\nFirst List:"
	secondList: .asciiz "\nSecond List"
	enter: .asciiz "\nEnter an integer (-1 to exit)"
	size: .asciiz "\nSize: "
	comma: .asciiz ","
	end: .asciiz "\n----------\n"
	merge: .asciiz "\nMerged List: "
.text	

main:
	la $a0,start
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	beq $v0,0,exitProgram

	la $a0, firstList
	li $v0, 4
	syscall
	
	jal createList
	
	move $s0, $v0 #Address of the head of the first list
	
	move $a0,$s0
	jal printList
	
	la $a0, secondList
	li $v0,4
	syscall
	
	jal createList
	
	move $s1,$v0 #Address of the head of the second list
	
	move $a0,$s1
	jal printList
	
	move $a0,$s0
	move $a1,$s1
	
	jal mergeSortedLists
	
	move $s2,$v0 #Address of the merged lisst
	move $s3,$v1 #Size of the merged list
	
	la $a0, merge
	li $v0,4
	syscall
	
	move $a0,$s2
	jal printList
	
	
	j main
	
createList:
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

	firstNode:
	
	la $a0,enter
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	move $s0, $v0
	
	beq $s0,-1,emptyList
	
	li	$a0, 8
	li	$v0, 9
	syscall
	
	move	$s1, $v0	# $s1 points to the first and last node of the linked list.
	move	$s2, $v0	# $s2 now points to the list head.
	
	
	sw	$s0, 4($s1)	# Store the data value.
	
	addNode:
	la $a0,enter
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	move $s0,$v0
	
	beq $s0,-1,allDone
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall

	sw	$v0, 0($s1)
	
	lw $s1,0($s1)	# $s1 now points to the new node.
		
	sw 	$s0, 4($s1)

	
	

	j	addNode
	
	allDone:
	# Make sure that the link field of the last node cotains 0.
	# The last node is pointed by $s21

	sw	$zero, 0($s1)
	move	$v0, $s2	# Return head
	
	# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
	emptyList:
	
	move $v0,$zero
	
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr $ra
		
printList:
	sw	$s0, -4($sp) #address of the head of the linked list
	sw	$s1, -8($sp) #curr data
	sw 	$s2, -12($sp) #Size
	move $s0,$a0
	li $s2,0
	
	next: 
		beq $s0,$zero,finishPrint ##if list is empty
		lw $s1,4($s0)
		
		li $v0,1
		move $a0,$s1
		syscall
		
		addi $s2,$s2,1
		
		lw $s0,0($s0)
		beq $s0,$zero,finishPrint
		
		li $v0,4
		la $a0,comma
		syscall
    		j next
		
	finishPrint:
	
		la $a0,size
		li $v0,4
		syscall
		
		move $a0, $s2
		li $v0, 1
		syscall
		
		la $a0,end
		li $v0,4
		syscall
		
		lw	$s0, -4($sp) #address of the head of the linked list
		lw	$s1, -8($sp) #curr data
		jr $ra
		
mergeSortedLists:
	sw	$s0, -4($sp) #first list head
	sw	$s1, -8($sp) #second list head
	sw 	$s2, -12($sp) #data list1
	sw	$s3, -16($sp) #data list2
	sw 	$s4, -20($sp) #head list 3
	sw 	$s5, -24($sp) #last node list 3
	sw 	$ra,-28($sp) #return address

	
	
	move $s0, $a0
	move $s1, $a1
	li $v1,0
	
	li $v0,9
	li $a0,8
	syscall
	
	move $s4,$v0 #head
	move $s5,$v0 #last
	
	loop:
		beq $s1,0,list2ends
		beq $s0,0,list1ends
			
		lw $s2,4($s0)
		lw $s3,4($s1)
		

		ble $s2,$s3,s2
	
		
		s3:
		sw $s3,4($s5)
		lw $s1,($s1)
		
		li $v0,9
		li $a0,8
		syscall
			
		sw $v0, ($s5)
		lw $s5, ($s5)
		addi $v1,$v1,1
		j loop
	
		s2:
		sw $s2,4($s5)
		lw $s0,($s0)
		
		li $v0,9
		li $a0,8
		syscall
			
		sw $v0, ($s5)
		lw $s5, ($s5)
		addi $v1,$v1,1
		j loop
		
		list1ends:
			beq $s1,0,ends
			
			lw $s3,4($s1)
			sw $s3,4($s5)
			
		  	lw $s1,($s1)
		  	
			addi $v1,$v1,1
		  	beq $s1,0,ends
		  	
		  	li $v0,9
			li $a0,8
			syscall
			
			sw $v0, ($s5)
			lw $s5, ($s5)
		  	j list1ends
		list2ends:
			beq $s0,0,ends
			lw $s2,4($s0)
			sw $s2,4($s5)
			
		  	lw $s0,($s0)
			addi $v1,$v1,1
			
		  	beq $s0,0,ends
		  	
		  	li $v0,9
			li $a0,8
			syscall
			
			sw $v0, ($s5)
			lw $s5, ($s5)
		  	
		  	j list2ends
		  ends:
		  	beq $v1,0,noNode
		  	j exitMerge
		  	noNode:
		  	li $s5,0
		  	j exitMerge
	exitMerge:
	move $a0,$s4 #head add
	jal deleteRepetitions
	move $v1,$v0
	
	move $v0,$s4 #head add
	
	lw	$s0, -4($sp) #first list head
	lw	$s1, -8($sp) #second list head
	lw 	$s2, -12($sp) #data list1
	lw	$s3, -16($sp) #data list2
	lw 	$s4, -20($sp) #head list 3
	lw 	$s5, -24($sp) #last node list 3
	lw	$ra, -28($sp) 	
	
	jr $ra
	
deleteRepetitions:
	sw	$s0, -32($sp) #head add
	sw 	$s1, -36($sp) #curr data
	sw 	$s2, -40($sp) #prev data
	sw 	$s3, -44($sp) #size
	sw	$s4, -48($sp) #prev node


	
	move $s0,$a0
	move $s4,$s0
	
	li $s3,0
	
	beq $s0,0,returnRep
	
	lw $s0,($s0)
	addi $s3,$s3,1
	repLoop:
	
		beq $s0,0,last
		lw $s1, 4($s0)
		lw $s2, 4($s4)
		
		beq $s1,$s2,equals
		addi $s3,$s3,1
		move $s4,$s0
		lw $s0,($s0)
		
		j repLoop
		
		equals:
			lw $s0,($s0)
			sw $s0, ($s4)
			j repLoop
		last:
			lw $s2, 4($s4)
			bne $s1,$s2,returnRep
			sw $s0,($s4)
			
		returnRep:
			move $v0,$s3
			move $v1,$s0
			lw	$s0, -32($sp) #head add
			lw 	$s1, -36($sp) #curr data
			lw 	$s2, -40($sp) #prev data
			lw 	$s3, -44($sp) #size
			lw	$s4, -48($sp) #prev nodes

			
			jr $ra
exitProgram:
	li $v0,10
	syscall
	

	
	
