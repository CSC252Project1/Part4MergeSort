	.data
nums: 	.word 10,9,8,7,6,5,4,3,2,1
sorted: .word 0:10
length: .word 10
space:	.asciiz  " "    # space to insert between numbers
	.text
	la   $t0, nums        	# load address of array
	la   $t2, sorted	# load address sorted
	la   $t5, length        # load address of length of array
	lw   $t5, 0($t5)	# load length to $t5
	li   $s0, 2		# set $s0 to 2 it will do each half seperately
	div  $s3,$t5,4		# set $s3 to 2 so it will be evaluating number in pairs
	j compare		# jump to comparing
reset:	div  $s3,$t5,4		# reset $s3 for second half
	addi $t0,$t0,-4		# start at beginning of second half
	addi $t2,$t2,-4		# start at beginning of second half
compare:lw   $t3, 0($t0)	# load first number
	lw   $t4, 4($t0)	# load second number
	ble  $t4, $t3, swap	# if second number is less than first number
	sw   $t3, 0($t2)	# if not smaller store as is
	sw   $t4, 4($t2)	# if not smaller store as is
	lw   $t6, 8($t0)	# skip next value
	sw   $t6, 8($t2)	# skip next value
	j    next		# jump to geting next value
swap:	sw   $t4, 0($t2)	# store second value first
	sw   $t3, 4($t2)	# store first value second
	lw   $t6, 8($t0)	# skip next value
	sw   $t6, 8($t2)	# skip next value
next:	addi $t2,$t2,12		# move to next spot stored
	addi $t0,$t0,12		# move to next spot nums
	addi $s3,$s3,-1		# iterate counter spot
	bgtz $s3, compare	# if not done
	addi $s0,$s0,-1		# iterate counter half
	bgtz $s0, reset		# reset if done with first half
	li   $s0, 2
	la   $t2, sorted
compare2:lw  $t3, 0($t2)	# load first number of sorted
	lw   $t4, 8($t2)	# load third number of sorted
	ble  $t4, $t3, swap2	# if smaller swap
	addi $t2, $t2, 4	# if not iterate one
	lw   $t3, 0($t2)	# load next value in sorted
	ble  $t4, $t3, swap2	# if smaller swap
	j next2
swap2:  lw   $t7, 4($t2)	# save temporary value
	sw   $t4, 0($t2)
	sw   $t3, 4($t2)
	sw   $t7, 8($t2)
next2:  addi $t2, $t2, 20
	addi $s0,$s0,-1		# iterate counter half
	bgtz $s0, compare2	# reset if done with first half
	li   $s0, 2
	la   $t2, sorted
	div  $s3,$t5,4		# set $s3 to 2 so it will be evaluating number in pairs
	j compare3
reset2: addi $t2,$t2,12
	li   $s0, 2
compare3:lw $t3, 0($t2)
	 lw $t4, 12($t2)
	 ble $t4, $t3, swap3
swap3:	lw $t7, 4($t2)
	lw $t8, 8($t2)
	sw $t4, 0($t2)
	sw $t3, 4($t2)
	sw $t7, 8($t2)
	sw $t8, 12($t2)
next3:  addi $t2, $t2, 4
	addi $s0,$s0,-1
	bgtz $s0,compare3
	addi $s3,$s3,-1
	bgtz $s3,reset2
	li   $s3,5
	la   $t0,nums
	la   $t2,sorted
	lw $t3, 0($t2)             # print
	lw $t4, 20($t2)             # print
compare4:ble $t4,$t3, swap4
	sw  $t3, 0($t0)
	lw $t3, 4($t2)
	j next4
swap4:  sw  $t4,0($t0)
      	addi $t2,$t2,4
	lw $t4,20($t2) 
next4:  addi $s3,$s3,-1
	addi $t0,$t0,4
	bgtz $s3,compare4
	li   $s3,5
	la   $t2,sorted
rest:	lw   $t3,0($t2)
	sw   $t3,0($t0)              # print
	addi $t2,$t2,4
	addi $t0,$t0,4
	addi $s3,$s3,-1
	bgtz $s3,rest	
	li   $t1,10		#PRINT
	la   $t2, sorted	
	la   $t0, nums		
print:	lw   $a0, 0($t0) 	#load number for syscall
      	li   $v0, 1           # specify Print Integer service
      	syscall               # print
      	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall
      	addi $t0,$t0,4
      	addi $t1,$t1,-1
      	bgtz $t1,print
      	li $v0,10
      	syscall