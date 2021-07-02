.data

# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11

paints_array: .word 1, 3, 5, 7
costs_array:  .word 0, 2, 4, 6

paint_1: .word 2, 4, 6, 7
cost_1: .word 1, 4, 6, 5

paint_2: .word 2, 4, 6, 7
cost_2: .word 0, 0, 0, 0

paint_3: .word 0, 0, 0, 0
cost_3: .word 1, 4, 6, 5

paint_4: .word 9, 8, 7, 6
cost_4: .word 8, 5, 3, 4

paint_5: .word 3, 3, 3, 3
cost_5: .word 4, 4, 4, 4

paint_6: .word 1, 2, 3, 4, 5, 6
cost_6: .word 6, 5, 4, 3, 2, 1

paint_7: .word 2
cost_7: .word 3
.text
# main function ########################################################
#
#  this will test paint_cost
#

.globl main
main:
	# Test1 from lab6.cpp
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)			# save $ra on stack


	li	$a0, 4				# test paint_cost
	la	$a1, paints_array
	la  $a2, costs_array
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 68


	# Test Case # 2
	li	$a0, 4				# test paint_cost
	la	$a1, paint_1
	la  $a2, cost_1
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 89

	# Test Case # 3 (Zero Check Cost)
	li	$a0, 4				# test paint_cost
	la	$a1, paint_2
	la  $a2, cost_2
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 0

	# Test Case # 4 (Zero Check Paint)
	li	$a0, 4				# test paint_cost
	la	$a1, paint_3
	la  $a2, cost_3
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 0

	# Test Case # 5 (Big Numbers)
	li	$a0, 4				# test paint_cost
	la	$a1, paint_4
	la  $a2, cost_4
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 157

	# Test Case # 6 (Duplicate)
	li	$a0, 4				# test paint_cost
	la	$a1, paint_5
	la  $a2, cost_5
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 48

	# Test Case # 7 (Different Size)
	li	$a0, 6				# test paint_cost
	la	$a1, paint_6
	la  $a2, cost_6
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 56

	# Test Case # 8 (One Element Array)
	li	$a0, 1				# test paint_cost
	la	$a1, paint_7
	la  $a2, cost_7
	jal	paint_cost

	move $a0, $v0 			# print result of paint_cost
	jal	print_int_and_space	# this should print 6


	lw	$ra, 0($sp)			# pop $ra from the stack
	add	$sp, $sp, 4
	jr	$ra
