.text

# short count_odd_nodes(TreeNode* head) {
#     // Base case
#     if (head == NULL) {
#         return 0;
#     }
#     // Recurse once for each child
# 	short count_left = count_odd_nodes(head->left);
#     short count_right = count_odd_nodes(head->right);
#     short count = count_left + count_right;
#     // Determine if this current node is odd
#     if (head->value%2 != 0) {
#         count += 1;
#     }
#     return count;
# }

.globl count_odd_nodes
count_odd_nodes:
	bne $a0, $zero, count_recurse					# if head != NULL start recurse
	li $v0, 0															# return = 0
	jr $ra
count_recurse:
	sub $sp, $sp, 20 # allocate stack
	sw $ra, 0($sp) # save $ra to stack
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	lw $s0, 0($a0) # calculate recursive argument(s)
	lw $s1, 4($a0)
	lw $s2, 8($a0)
	add $a0, $s0, 0
	jal count_odd_nodes
	add $a0, $s1, 0
	move $s3, $v0
	jal count_odd_nodes
	add $v0, $v0, $s3
	rem $t0, $s2, 2
	bne $t0, 0, count_inc
	j clean_up
count_inc:
	addi $v0, $v0, 1
	j clean_up
clean_up:
	lw $ra, 0($sp) # restore $ra from stack
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	add $sp, $sp, 20 # deallocate stack
	jr $ra
