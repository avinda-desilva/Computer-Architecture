.text

# // Finds the dot product between two different arrays of size n
# // Ignore integer overflow for the multiplication
# int paint_cost(unsigned int n, unsigned int* paint, unsigned int* cost) {
# 	int total = 0;
# 	for (int i = 0; i < n; i++) {
# 		total += paint[i] * cost[i];
# 	}
# 	return total;
# }

.globl paint_cost
paint_cost:
	add $v0, $0, $0		# v0 = total = 0
	add $t0, $0, $0				 	# t0 = i = 0
loop:
	mul $t1, $t0, 4					# i * 4 = index of array
	addu $t3, $a1, $t1				# &paint[i]
	addu $t4, $a2, $t1				# &cost[i]
	lw	$t3, ($t3)					# t3 = paint[i]
	lw 	$t4, ($t4)					#	t4 = cost[i]
	mul $t5, $t3, $t4				#	t5 = paint[i] * cost[i]
	add $v0, $v0, $t5				# v0 = total = (total + paint[i] * cost[i])
	addi $t0, $t0, 1				# i++
	blt $t0, $a0, loop			# i < n
end:
	jr	$ra									# return total
