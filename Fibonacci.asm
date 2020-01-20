# Who:  Meetkumar Patel
# What: Fibonacci.asm
# Why:  Project 2 - Fibonacci Sequence
# When: Created: 03/09/2019 Due: 03/17/19
# How:  t0 array, t1 end of array, t2 user input, t3 a of algorithm, 
# 		t4 b of algorithm, t5 i of algorithm, t6 temp of algorithm

.data
maximum_index:			.word			47
array:					.space			188
input_prompt:			.asciiz			"Please enter an integer for position: "
number_output:			.asciiz			"The fibonacci number at the entered position is: "
array_output:			.asciiz			"\nThe array of all calculated values is: "

.align 2


.text
.globl main


main:								#program entry

la $t0, array						# load the address of array in t0.
la $t1, maximum_index				# load the address of maximum_index in t1.
lw $t1, 0($t1)						# get the actual value and store it in t1.
sll $t1, $t1, 2						# multiply t1 by 4 to get the max size of array in bytes.
addu $t1, $t0, $t1					# adding max size to the starting address. t1 points at end of the array

									# get user input_prompt
input_validation:

li $v0, 4
la $a0, input_prompt
syscall    							# prints the input_prompt
li $v0, 5
syscall								# read the input integer
add $t2, $v0, $0					# store the input integer in t2.

									# validate user input: [0, 47]
slt $t3, $t2, $0					# if input integer is less than 0, repeat.
bne $t3, $0, input_validation
slti $t3, $t2, 48					# if input integer is greater than 47, repeat.
beq $t3, $0, input_validation

addiu $t2, $t2, 1					# user input incremented by one to align with fibonacci requirements 

									# apply the algorithm
add $t3, $0, $0						# a = 0
addiu $t4, $0, 1					# b = 1
addu $t5, $0, $0					# i = 0

loop:
slt $t6, $t5, $t2					# loop condition checking
beq $t6, $0, end_loop 
sw $t3, 0($t0)
addu $t6, $t4, $0					# temp = b
addu $t4, $t4, $t3					# b += a
addu $t3, $t6, $0					# a = temp 
addi $t0, $t0, 4					# increment array iterator
addi $t5, $t5, 1					# increment counter i
j loop

end_loop:
									# print the nth number
li $v0, 4
la $a0, number_output
syscall    							# prints the number_output
addiu $t0, $t0, -4					# decrement array iterator
lw $a0, 0($t0)						# get the value at the position
addi $v0, $0, 36					# print as unsigned
syscall

									# print all the content of the array
li $v0, 4
la $a0, array_output
syscall    							# prints the array_output

la $t0, array
li $t5, 0							# set t5(i, counter) to 0

output_loop:						# loop to print all the array contents
slt $t3, $t5, $t2 					# condition checking to end the loop
beq $t3, $0, end_output_loop

li $v0, 36
lw $a0, 0($t0)
syscall								# prints the fibonacci number unsigned
li $v0, 11
li $a0, 0x20
syscall								# print a space

addiu $t0, $t0, 4					# increment array iterator
addiu $t5, $t5, 1					# increment counter i

j output_loop
end_output_loop:



exit:								#terminate the program
li $v0, 10
syscall

