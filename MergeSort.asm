	.data
nums: 	.word 10,9,8,7,6,5,4,3,2,1
sorted: .word 0:10
length: .word 10
half1:	.word 0:5
half2:	.word 0:5
	.text
	la   $t0, nums        	# load address of array
	la   $t5, length        # load address of length of array
	la   $s0, half1		# load address of sorted array
	la   $s1, half2		# load address of sorted array
	li   $t1, 1     	# Counter for loop, starts at 1 (number of values in sorted array)
	li   $t9, 0		# counter for inner loop
	lw   $t5, 0($t5)	# load length of array
	div  $s3,$t5,2		# divide length by two (NEED TO MAKE SURE THIS IS INTEGER VALUE FOR ODDS)
half: 	sb   $s0, half2		# store current $s0 to half2 //PROBLEM
	lw   $t3, 0($t0)	# load first number of array
	sw   $t3, 0($s0)	# store first value of array in sorted array
      	addi $t0, $t0, 4	# increment array to start on second number
sort: 	lw   $t3, 0($t0)      	# next value from array is $t3
sort2:	lw   $t4, 0($s0)	# get next value from sorted array
      	ble  $t3, $t4, switch 	# if the $t3 is less than 0($t2), switch
back: 	addi $s0, $s0, 4	# increment address of sorted half
      	addi $t9, $t9, 1	# increment inner loop counter
      	bne  $t1, $t9, sort2	# if not finished start with next number in sorted array 
      	beq  $t1, $t9, place	# if finished, go to place
back2:	addi $t0, $t0, 4      	# increment address of array
      	addi $t1, $t1, 1     	# increment loop counter
      	la   $s0, half1		# load beginning address of sorted array //PROBLEM
      	li   $t9, 0		# set inner loop counter back to 0
      	bne  $t1, $s3, sort     # repeat if not finished yet.
      	j    merge		# jump to get ready to print
switch:	sw   $t3, 0($s0)	# replace number in array with number being sorted
      	move $t3, $t4		# put other number as the number being sorted 
      	j    back		# jump back to sort loop
place:	sw   $t3, 0($s0)	# place number in open array spot
      	j    back2		# back to sorting
      	addi $s3,$s3,-1
      	bgtz $s3,half
merge:	la   $t0, nums
	la   $t2, sorted	# load address of sorted array
back3:	lw   $t3, 0($s0)	#load first number from half1
	lw   $t4, 0($s1)	#load first number from half2
	la   $a0, newline       # load address of spacer for syscall
	ble  $t3, $t4, switch2 	# if half1 value is less than half2 value, switch
	ble  $t4, $t3, switch3	# if half2 value is less than half1 calue, switch
switch2:sw   $t3, 0($t2)	# place value in sorted array
      	addi $s0,$s0,4		# next iteration of first half
      	j    next		# jump to iterations
switch3:sw   $t4, 0($t2)	# replace number in array with number being sorted
      	addi $s1,$s1,4		# next iteration of second half
next:   addi $t2,$t2,4		# next spot in sorted array
      	addi $t5,$t5,-1		# decrease count
      	bgtz $t5, back3		# jump back to sort loop
      	j    ready
#print
		.data
newline:	.asciiz "\n"
space:		.asciiz  " "    # space to insert between numbers
		.text
ready:		li   $t1,5		#initialize array counter
		la   $a0, newline       # load address of spacer for syscall
		la   $s0, half1		# load address of sorted array
		la   $s1, half2
      		li   $v0, 4           	# specify Print String service
      		syscall
      		j print
print:		lw   $a0, 0($s0) 	#load number for syscall
      		li   $v0, 1      	# specify Print Integer service
      		syscall               	# print
      		la   $a0, space       	# load address of spacer for syscall
      		li   $v0, 4           	# specify Print String service
      		syscall
      		addi $s0,$s0,4
      		addi $t1,$t1,-1
      		bgtz $t1,print
      		li   $t1,5		# initiate counter
      		la   $a0, newline       # load address of spacer for syscall
      		li   $v0, 4           	# specify Print String service
      		syscall
      		j print2		#initialize array counter
print2:		lw   $a0, 0($s1) 	#load number for syscall
      		li   $v0, 1      	# specify Print Integer service
      		syscall               	# print
      		la   $a0, space       	# load address of spacer for syscall
      		li   $v0, 4           	# specify Print String service
      		syscall
      		addi $s1,$s1,4
      		addi $t1,$t1,-1
      		bgtz $t1,print2
ready2:		la   $a0, newline       # load address of spacer for syscall
      		li   $v0, 4           	# specify Print String service
      		syscall	
		la $t5,length
		lw $t5,0($t5)     		
print3:		lw   $a0, 0($t2) 	# load number for syscall
      		li   $v0, 1      	# specify Print Integer service
      		syscall               	# print
      		la   $a0, space       	# load address of spacer for syscall
      		li   $v0, 4           	# specify Print String service
      		syscall
      		addi $t2,$t2,4
      		addi $t5,$t5,-1
      		bgtz $t5,print3
      		
