.text

# int count_painted(int *wall, int width, int radius, int coord) {
# 	int row = (coord & 0xffff0000) >> 16;
# 	int col = coord & 0x0000ffff;
# 	int value = 0;
# 	for (int row_offset = -radius; row_offset <= radius; row_offset++) {
# 		int temp_row = row + row_offset;
# 		if (width <= temp_row || temp_row < 0) {
# 			continue;
# 		}
# 		for (int col_offset = -radius; col_offset <= radius; col_offset++) {
# 			int temp_col = col + col_offset;
# 			if (width <= temp_col || temp_col < 0) {
# 				continue;
# 			}
# 			value += wall[temp_row*width + temp_col];
# 		}
# 	}
# 	return value;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius
# // a3: int coord
# // t0: int row
# // t1: int col
# // t2: int row_offset
# // t3: int col_offset
# // t4: int temp_row
# // t5: int temp_col
# // t6: int index
# //

.globl count_painted
count_painted:
	and $t0, $a3, 0xffff0000		# int row = coord & 0xffff0000
	srl $t0, $t0, 16						# int row >> 16
	and $t1, $a3, 0x0000ffff		# int col = coord & 0x0000ffff
	add $v0, $0, $0							# int value = 0
	mul $t2, $a2, -1						# int row_offset = -radius

row_loop:
	add $t4, $t0, $t2						# int temp_row = row + row_offset
	ble $a1, $t4, update1				# width <= temp_row
	blt $t4, $zero, update1			# temp_row < 0
	bgt $t2, $a2, end
	addi $t2, $t2, 1						# row_offset++
	mul $t3, $a2, -1						#	int col_offset = -radius
	j col_loop

update1:
	addi $t2, $t2, 1						# row_offset++
	ble $t2, $a2, row_loop			# row_offset <= radius
	j end

col_loop:
	add $t5, $t1, $t3						# int temp_col = col + col_offset
	ble $a1, $t5, update2				# width <= temp_col
	blt $t5, $zero, update2			# temp_col < 0
	mul $t6, $t4, $a1						# index = temp_row * width
	add $t6, $t6, $t5						# index = (temp_row * width) + temp_col
	mul $t6, $t6, 4							# index * 4 = index of array
	add $t7, $a0, $t6						# &wall[temp_row*width + temp_col]
	lw $t6, ($t7)								# t6 = wall[index]
	add $v0, $v0, $t6						# value += wall[index]
	ble $t3, $a2, update2				# col_offset <= radius
	j update1

update2:
	addi $t3, $t3, 1						# col_offset++
	ble $t3, $a2, col_loop			# col_offset <= radius
	#addi $v0, $v0, 1
	j row_loop

end:
	jr	$ra											# return value


# int* get_heat_map(int *wall, int width, int radius) {
# 	int value = 0;
# 	for (int col = 0; col < width; col++) {
# 		for (int row = 0; row < width; row++) {
# 			int coord = (row << 16) | (col & 0x0000ffff);
# 			output_map[row*width + col] = count_painted(wall, width, radius, coord);
# 		}
# 	}
# 	return output_map;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius
# // a3: int coord

.globl get_heat_map
get_heat_map:
	# Can access output_wall from p2.s
	la $v0, output_wall
	add $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	move $s0, $v0							# move array to s0
	li $s1, 0									# col = 0

col_loop_h:
	bge $s1, $a1, end_h					# go to end if col >= width
	li $s2, 0									# row = 0
	j row_loop_h

row_loop_h:
	sll $t0, $s2, 16						# int row << 16
	and $t1, $s1, 0x0000ffff		# int col = col & 0x0000ffff
	or $a3, $t0, $t1						# coord = (row << 16) | (col & 0x0000ffff);
	jal count_painted						# call count_painted saved in v0
	mul $s3, $s2, $a1						# index = row*width
	add $s3, $s3, $s1						#	index = row*width + col
	mul $s3, $s3, 4							# index of array = index * 4
	add $s3, $s0, $s3						# &output_wall[i]
	sw 	$v0, ($s3)
	addi $s2, $s2, 1					# row++
	bgt $s2, $a1, update_col	# go to update_col if row >= width
	j row_loop_h
update_col:
	addi $s1, $s1, 1					# col++
	j col_loop_h
end_h:
	move $v0, $s0
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	add $sp, $sp, 20
	jr $ra
