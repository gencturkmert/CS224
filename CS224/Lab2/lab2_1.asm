#Convert hex to decimal
.data
    buffer: .space 20
    str1: .asciiz "\n Enter a hex with 4 characters "
    str2: .asciiz "\n Decimal equivalent of your hex: "
    strE: .asciiz "\n Invalid input. Program ends."
.text
    main:

		input:
			li $v0, 4		# $v0 = 4 
			la $a0, str1
			syscall
			li $v0, 8
			la $a0, buffer #address of hex string
			li $a1,5 #size of the string
			syscall

			la $a0, buffer
			jal doHex
	
			move $s0, $v0
			beq $s0,-1,quit
        
			li $v0,4
			la $a0, str2
			syscall
			li $v0, 1
			move $a0, $s0
			syscall
			j input
	
		quit:
			li $v0,4
			la $a0,strE
			syscall
			li $v0,10
			syscall

    doHex:
			sw $s0,-4($sp) #byte	
			sw $s1,-8($sp) #counter 1 to 4
			sw $s2,-12($sp) #shamt
	
			li $s2, 4
			li $s1,0
			li $v0,0
	
			loop:
		
				lbu $s0,($a0)	#take the first byte(character)
				beq $s0, $zero, next #go to next one if its 0
		
				bltu $s0,48,exit	#invalid check
				bgt $s0, 57, cont	#A B C D E or F
		
				addiu $s0,$s0,-48	#ascii number convertion
				addi $s1,$s1,1		#next byte
				j next
		
			cont:
				addiu $s0,$s0,-48
				bltu $s0,17,exit	#invalid check
				bgt $s0,22, cont2	#small character
				addi $s0,$s0, -7	#ascii convertion
		
				addi $s1,$s1,1
				j next
		
		
			cont2:
				bltu $s0,49,exit	#for small chracters
				bgt $s0,54,exit
		
				addi $s0,$s0,-39
		
				addi $s1,$s1,1
				j next
			
			next:
				beq $s1, 0, mul0	#digit placement
				beq $s1, 1,mul1
				beq $s1, 2, mul2
				beq $s1, 3, mul3
				beq $s1, 4, continue
				mul0:
					sll $s0, $s0, 16
					j continue
				mul1:
					sll $s0, $s0, 12
					j continue
				mul2:
					sll $s0,$s0,8
					j continue
				mul3:
					sll $s0,$s0,4
					j continue

				continue:
				add $v0, $v0, $s0
				beq $s1, 4, return
				addi $a0,$a0,1
				li $s0,0
				j loop

			return:
				lw $s0,-4($sp)
				lw $s1,-8($sp) 
				lw $s2,-12($sp) 
				jr $ra
				exit: 
        			addi $v0, $zero, -1
        			lw $s0,-4($sp)
				lw $s1,-8($sp) 
				lw $s2,-12($sp) 
				jr $ra
        	
