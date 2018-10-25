# Prog de prueba para Pr�ctica 2. Ej 2

.data 0
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 4 # posic 8 
num3: .word 8 # posic 12 
num4: .word 16 # posic 16 
num5: .word 32 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28
num8: .word 0 # posic 32
num9: .word 0 # posic 36
num10: .word 0 # posic 40
num11: .word 0 # posic 44
.text 0
main:
lw $t0, 20($zero)
lw $t1, 20($zero)
beq $t0, $t1, salto_e_l
lui $t3, 5
salto_e_l:
lw $t1, 16($zero)
beq $t1, $t0, salto_n_l
lw $t3, 0($zero)
salto_n_l:
add $t1, $t1, $t1
beq $t1, $t0, salto_e_r
lui $t4, 6
salto_e_r:
add $t1, $t1, $t1
beq $t1, $t0, salto_n_r
lw $t4, 0($zero)
salto_n_r:
beq $zero, $zero, salto_n_r