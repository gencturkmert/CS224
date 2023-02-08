#Reverse bytes
.data
	str1: .asciiz "\nEnter the decimal (0 to exit) "
	str2: .asciiz "\nYour input: "
	str3: .asciiz "Your reversed input: "
	hex: .space 9
	reverse: .space 9
	
.text
main:

	li $v0, 4
	la $a0, str1
	syscall
	li $v0, 5
	syscall
	
	move $s0, $v0
	beq $s0,0,end
	

	la $a0, hex		#address of hex to be filled
	move $a1,$s0	#input
	
	jal decimalToHex
	
	move $s1, $v0
	li $v0, 4
	la $a0,str2
	syscall
	li $v0, 4
	la $a0, hex
	syscall
	
	la $a0,hex			#address of hex string
	la $a1, reverse		#address of reversed string to be filled
	jal revert
	
	li $v0, 4
	la $a0,str3
	syscall
	li $v0, 4
	la $a0, reverse
	syscall
	
	
	
	j main
	
	end:
		li $v0,10
		syscall
	
decimalToHex:
	sw $s0,-4($sp) #counter
	sw $s1,-8($sp) #Rotate Counter
	sw $s2,-12($sp) #store
	sw $s3, -16($sp) #input
	
	move $s2, $a0
	li $s1,4
	li $s0, 0
	
	rotate:
		beq $s0,8,return	#counter check
		rol $s3,$a1,$s1		#rotate four bits and destroy bits expect first four
		andi $s3,$s3,0xf
		ble $s3,9,add48		#if number add 48 to be ascii
		addi $s3,$s3,87		#if not add 87 to be a character a b c d e or f
		
		j insert
		
		add48:
			addi $s3,$s3,48
			
		insert:
			sb $s3, ($s2)	#store byte and increment counters
			addi $s0,$s0,1
			addi $s2,$s2,1
			addi $s1,$s1,4
			j rotate
			
		return:
			move $v0,$a0 #returns the address of hex
			
			lw $s0,-4($sp)
			lw $s1,-8($sp) 
			lw $s2,-12($sp) 
			lw $s3, -16($sp)
			
			jr $ra
			

revert:
	sw $s0,-4($sp) #add for hex
	sw $s1,-8($sp) #add for reverse hex
	sw $s2,-12($sp) #counter
	sw $s3, -16($sp) #temp byte 1
	sw $s4, -20($sp) #temp byte 2
	
	process:					#replace bytes of hex and reverse in reversed orders
		addi $s2,$zero,8
		move $s0,$a0
		move $s1,$a1
		addi $s1,$s1,7
		loop: 
			beq $s2,0,return2
			lbu $s3,($s0)
			lbu $s4,($s1)
			
			sb $s4, ($s0)
			sb $s3, ($s1)
			
			addi $s0,$s0,1
			addi $s1,$s1,-1
			addi $s2,$s2,-1
			
			j loop
			
		return2:
			sw $s0,-4($sp) #add for hex
			sw $s1,-8($sp) #add for reverse hex
			sw $s2,-12($sp) #counter
			sw $s3, -16($sp) #temp byte 1
			sw $s4, -20($sp) #temp byte 2
			jr $ra
			
		
		
		
