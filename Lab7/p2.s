.text

# bool rule1(unsigned short* board) {
#   bool changed = false;
#   for (int y = 0 ; y < GRIDSIZE ; y++) {
#     for (int x = 0 ; x < GRIDSIZE ; x++) {
#       unsigned value = board[y*GRIDSIZE + x];
#       if (has_single_bit_set(value)) {
#         for (int k = 0 ; k < GRIDSIZE ; k++) {
#           // eliminate from row
#           if (k != x) {
#             if (board[y*GRIDSIZE + k] & value) {
#               board[y*GRIDSIZE + k] &= ~value;
#               changed = true;
#             }
#           }
#           // eliminate from column
#           if (k != y) {
#             if (board[k*GRIDSIZE + x] & value) {
#               board[k*GRIDSIZE + x] &= ~value;
#               changed = true;
#             }
#           }
#         }
#       }
#     }
#   }
#   return changed;
# }
#a0: board

.globl rule1
rule1:
	sub $sp, $sp, 28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	li $s0, 0									# bool changed = true
	move $s1, $a0							# save board onto stack
	li $s2, 0									# int y = 0

y_loop:
	bge $s2, GRIDSIZE, end		# go to end if y>= GRIDSIZE
	#addi $s2, $s2, 1					# y++
	li $s3, 0									# int x = 0
	j x_loop

x_loop:
	bge $s3, GRIDSIZE, update_y	# go to update_y if x >= GRIDSIZE
	mul $t3, $s2, GRIDSIZE		# index = y*GRIDSIZE
	add $t3, $t3, $s3					#	index = y*GRIDSIZE + x
	mul $t3, $t3, 2						# index of array = index * 4
	add $t3, $s1, $t3					# &board[i]
	lhu $s5, ($t3)
	addi $a0, $s5, 0
	jal has_single_bit_set		# $v0 = returned boolean
	li $s4, 0									# int k = 0
	bne $v0, 0, k_loop
	addi $s3, $s3, 1					# x++
	j x_loop

update_y:
	addi $s2, $s2, 1					# y++
	j y_loop

update_x:
	addi $s3, $s3, 1					# x++
	j x_loop

k_loop:
	bge $s4, GRIDSIZE, update_x # go to update_x if k >= GRIDSIZE
	bne $s4, $s3, check_x
	bne $s4, $s2, check_y
	addi $s4, $s4, 1					# k++
	j k_loop

check_x:
	mul $t3, $s2, GRIDSIZE		# index = y*GRIDSIZE
	add $t3, $t3, $s4					#	index = y*GRIDSIZE + k
	mul $t3, $t3, 2						# index of array = index * 4
	add $t3, $s1, $t3					# &board[i]
	lhu $t6, ($t3)
	and $t4, $t6, $s5
	beq $t4, 0, check_y_temp
	not $t5, $s5
	and $t4, $t6, $t5
	sh $t4, ($t3)
	li $s0, 1
	j check_y_temp

check_y_temp:
	bne $s4, $s2, check_y
	add $s4, $s4, 1
	j k_loop

k_temp:
	#bne $s4, $s2, check_y
	add $s4, $s4, 1
	j k_loop

check_y:
	mul $s6, $s4, GRIDSIZE		# index = k*GRIDSIZE
	add $s6, $s6, $s3					#	index = y*GRIDSIZE + x
	mul $s6, $s6, 2						# index of array = index * 4
	add $s6, $s1, $s6					# &board[i]
	lhu $t6, ($s6)
	and $t4, $t6, $s5
	beq $t4, 0, k_temp
	not $t5, $s5
	and $t4, $t6, $t5
	sh $t4, ($s6)
	li $s0, 1
	j k_temp

end:
	move $v0, $s0
	move $a0, $s1
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	add $sp, $sp, 28
	jr $ra


# bool solve(unsigned short *current_board, unsigned row, unsigned col, Puzzle* puzzle) {
#     if (row >= GRIDSIZE || col >= GRIDSIZE) {
#         bool done = board_done(current_board, puzzle);
#         if (done) {
#             copy_board(current_board, puzzle->board);
#         }

#         return done;
#     }
#     current_board = increment_heap(current_board);

#     bool changed;
#     do {
#         changed = rule1(current_board);
#         changed |= rule2(current_board);
#     } while (changed);

#     short possibles = current_board[row*GRIDSIZE + col];
#     for(char number = 0; number < GRIDSIZE; ++number) {
#         // Remember & is a bitwise operator
#         if ((1 << number) & possibles) {
#             current_board[row*GRIDSIZE + col] = 1 << number;
#             unsigned next_row = ((col == GRIDSIZE-1) ? row + 1 : row);
#             if (solve(current_board, next_row, (col + 1) % GRIDSIZE, puzzle)) {
#                 return true;
#             }
#             current_board[row*GRIDSIZE + col] = possibles;
#         }
#     }
#     return false;
# }
# // a0, s0 = current_board
# // a1, s1 = row
# // a2, s2 = col
# // a3, s3 = puzzle
# // s4 = changed CAN BE USED LATER
# // s5 = possibles
# // s6 = char number
# // s7 = adress of curr board

.globl solve
solve:
	sub $sp, $sp, 36 # allocate stack
	sw $ra, 0($sp) # save $ra to stack
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	bge $s1, GRIDSIZE, r_done
	bge $s2, GRIDSIZE, r_done
	j inter

r_done:
	add $a0, $s1, 0
	add $a1, $s2, 0
	jal board_done
	bne $v0, 0, r_done_temp
	j clean_up
	#jr $ra

r_done_temp:
	move $s7, $v0
	add $a0, $s0, 0
	lhu	$a1, ($s3)
	jal copy_board
	move $v0, $s7
	j clean_up
	#jr $ra

inter:
	add $a0, $s0, 0
	jal increment_heap
	move $s0, $v0						# curr_board = inc_heap(curr_board)
	j do_loop
	#jr $ra

do_loop:
	move $a0, $s0
	jal rule1
	move $s7, $v0
	jal rule2
	or $s7, $s7, $v0
	move $s0, $a0
	j while

while:
	beq $s7, 0, exit_do_loop
	j do_loop

exit_do_loop:
	mul $s7, $s1, GRIDSIZE
	add $s7, $s7, $s2
	mul $s7, $s7, 2
	add $s7, $s0, $s7				# $t0 = &current_board[row*GRIDSIZE + col]
	lhu $s5, ($s7)						# $s5 = possibles
	li	$s6, -1
	j for_loop

for_loop:
	add $s6, $s6, 1
	bge $s6, 4, exit_for_loop
	li $s4, 1
	sll $s4, $s4, $s6					# s7 = 1 << number
	and $s4, $s4, $s5
	bne $s4, 0, if_check_1
	j for_loop

if_check_1:
	li $t0, 1
	sll $t0, $t0, $s6					# s7 = 1 << number
	sh 	$t0, ($s7)						# curr_board[index] = 1 << number
	li $t0, GRIDSIZE
	sub $t1, $t0, 1
	beq $s2, $t1, row_inc
	add $a1, $s1, 0
	j if_check_2

row_inc:
	add $a1, $s1, 1
	j if_check_2

if_check_2:
	add $a0, $s0, 0
	add $a2, $s2, 1
	rem $a2, $a2, GRIDSIZE
	add $a3, $s3, 0
	jal solve
	beq $v0, 0, board_update
	li $v0, 1
	j clean_up

board_update:
	sb $s5, ($s7)
	#add $s6, $s6, 1
	j for_loop

exit_for_loop:
	li $v0, 0
	j clean_up

clean_up:
	lw $ra, 0($sp) # save $ra to stack
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	add $sp, $sp, 36 # allocate stack
	jr $ra
