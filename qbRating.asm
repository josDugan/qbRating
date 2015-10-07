# JOSEPH DUGAN (I worked alone for this project)
# This is an updated assignment without the read and write requirements.
.data
COMP: .asciiz "Enter the number of completions. "
ATT:  .asciiz "Enter the number of attempts. "
YARDS: .asciiz "Enter the number of passing yards. "
TDS: .asciiz "Enter the number of touchdowns. "
INT: .asciiz "Enter the number of interceptions. "
endMsg:  .asciiz "The QBRating is "

.text
# handle completion input
la $a0, COMP
li $v0, 4
syscall
li $v0, 6
syscall
mov.s $f15, $f0

# handle attempts input
la $a0, ATT
li $v0, 4
syscall
li $v0, 6
syscall
mov.s $f16, $f0

# handle yards input
la $a0, YARDS
li $v0, 4
syscall
li $v0, 6
syscall
mov.s $f17, $f0

# handle touchdowns input
la $a0, TDS
li $v0, 4
syscall
li $v0, 6
syscall
mov.s $f18, $f0

# handle interceptions input
la $a0, INT
li $v0, 4
syscall
li $v0, 6
syscall
mov.s $f19, $f0

# FORMULA CONSTANTS
li $t0, 10
li $t1, 3
li $t2, 5
li $t3, 2
li $t4, 375
li $t5, 0

addi $sp, $sp, -24
sw $t5, 20($sp)				# send to stack
sw $t4, 16($sp)
sw $t3, 12($sp)
sw $t2, 8($sp)
sw $t1, 4($sp)
sw $t0, 0($sp)

lwc1 $f20, 0($sp)		# load to float registers
lwc1 $f21, 4($sp)
lwc1 $f22, 8($sp)
lwc1 $f23, 12($sp)
lwc1 $f24, 16($sp)
lwc1 $f10, 20($sp)
addi $sp, $sp, 20

cvt.s.w $f20, $f20		# convert to singles
cvt.s.w $f21, $f21
cvt.s.w $f22, $f22
cvt.s.w $f23, $f23
cvt.s.w $f24, $f24
cvt.s.w $f10, $f10

div.s $f25, $f21, $f20		# calculate remaining constants
mul.s $f26, $f23, $f20
mul.s $f27, $f26, $f25
add.s $f28, $f26, $f22
div.s $f29, $f22, $f26
mul.s $f30, $f20, $f20
mul.s $f31, $f30, $f20
div.s $f24, $f24, $f31
add.s $f24, $f23, $f24

# VARIABLES			


# calculate a: completions, attempts, constants
div.s $f1, $f15, $f16
sub.s $f1, $f1, $f25
mul.s $f1, $f1, $f22

# calculate b: yards, attempts, constants
div.s $f2, $f17, $f16
sub.s $f2, $f2, $f21
mul.s $f2, $f2, $f29

# calculate c: tds, attempts, constants
div.s $f3, $f18, $f16
mul.s $f3, $f3, $f26

#calculate d: interceptions, attempts, constants
div.s $f4, $f19, $f16
mul.s $f4, $f4, $f28
sub.s $f4, $f24, $f4

# GET MAX
mov.s $f5, $f1
jal min
mov.s $f1, $f5

mov.s $f5, $f2
jal min
mov.s $f2, $f5

mov.s $f5, $f3
jal min
mov.s $f3, $f5

mov.s $f5, $f4
jal min
mov.s $f4, $f5

j prequation


# MIN/MAX calculation
min:
c.lt.s $f5, $f24
bc1f changeValue
j max

changeValue:
mov.s $f5, $f24

max:
c.lt.s $f5, $f10
bc1f return
mov.s $f5, $f10
jr $ra

return:
jr $ra

prequation:
add.s $f6, $f1, $f2
add.s $f7, $f3, $f4
add.s $f12, $f6, $f7
div.s $f12, $f12, $f27
mul.s $f12, $f12, $f30

# print result
la $a0, endMsg
li $v0, 4
syscall
li $v0, 2
syscall