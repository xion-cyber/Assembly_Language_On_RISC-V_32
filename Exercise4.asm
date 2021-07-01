#————————————————————————————
# 功能：将内存中一变量VAL（假设其内存地址为0X00000000）取出，
# 然后根据SW[23:21]选择对应功能对其进行操作,
#	SW[23:21] = b'X00 时，无操作
#	SW[23:21] = b'001 时，将SW[15:0]的值付给VAL的低16位
#	SW[23:21] = b'010 时将，将VAL的值加1
#	SW[23:21] = b'011 时将，将VAL的值减1
#	SW[23:21] = b'101 时将，将VAL的值逻辑左移
#	SW[23:21] = b'110 时将，将VAL的值加逻辑右移
#	SW[23:21] = b'111 时将，将VAL的值加算术右移
#
# 时间：2021/6/30
# 作者：叶椅琦
#--------------------------------------------------------
	lui s1,0xFFFFF
	lui s0,0xFFFF0
	lui s11,0x0FFFF
	srli s11,s11,12 # s11 0x0000FFFF
	addi s10,zero,1 # s10作为周期控制来使用，调节其大小可以控制流水灯的速率
			# 经验证，在64HZ模式下，流水灯大概半秒变化一次
	lw s8,0x00(zero)
	sw s8,0x60(s1)

	
funsel: # 根据SW[23:21]输入选择功能
	lw s2,0x72(s1)
	andi s2,s2,0x0E0 # 取SW[23:21]
	beq s2,zero,funsel
	addi s3,zero,0x080
	beq s2,s3,funsel
	addi s3,zero,0x020
	beq s2,s3,assign
	addi s3,zero,0x040
	beq s2,s3,plus1
	addi s3,zero,0x060
	beq s2,s3,minus1
	addi s3,zero,0x0A0
	beq s2,s3,lshift1
	addi s3,zero,0x0C0
	beq s2,s3,lrshift1
	addi s3,zero,0x0E0
	beq s2,s3,arshift1
	jal funsel
	

assign: # 赋值
	lw s4,0x70(s1)
	and s4,s4,s11 # 取输入的低16位
	and s9,s9,s0 # 保护高位
	add s8,zero,s4 #赋值
	or s8,s8,s9 # 将原先的高位和赋值后的低位组合
	sw s8,0x00(zero)
	sw s8,0x60(s1)
	lw s2,0x72(s1) # 读取输入，若功能选择改变，退出该模块
	andi s2,s2,0x0E0
	addi s3,zero,0x020
	beq s2,s3,assign
	jal funsel


plus1: # 加一
	xor s5,s5,s5
loop1:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x040
	bne s2,s3,funsel
	blt s5,s10,loop1
	
	xor s5,s5,s5
	and s9,s8,s0 # 高位保护
	addi s8,s8,1
	xor s8,s8,s0 # 将高位置零
	or s8,s8,s9 # 将原来的高位和低位组合
	sw s8,0x00(zero)
	sw s8,0x60(s1)
	jal loop1



minus1: # 减一
	xor s5,s5,s5
loop2:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x060
	bne s2,s3,funsel
	blt s5,s10,loop2
	
	xor s5,s5,s5
	and s9,s8,s0 # 高位保护
	or s8,s8,s0 # 将高位全置为1
	addi s8,s8,-1
	and s8,s8,s11 # 将高位还原为零
	or s8,s8,s9 # 高低位组合
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop2
	

	
lshift1: # 逻辑左移一位
	xor s5,s5,s5
loop3:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x0A0
	bne s2,s3,funsel
	blt s5,s10,loop3
	
	xor s5,s5,s5
	and s9,s8,s0 # 高位保护
	slli s8,s8,1
	and s8,s8,s11 # 取左移后的低16位
	or s8,s8,s9 # 将原先的高位和左移后的低位组合
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop3
	

lrshift1: # 逻辑右移一位
	xor s5,s5,s5
loop4:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x0C0
	bne s2,s3,funsel
	blt s5,s10,loop4
	
	xor s5,s5,s5
	and s9,s8,s0 # 高位保护
	and s8,s8,s11 # 将高位全置为0
	srli s8,s8,1
	or s8,s8,s9 # 将原先的高位和逻辑右移后的低位组合
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop4

arshift1: # 算术右移一位
	xor s5,s5,s5
loop5:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x0E0
	bne s2,s3,funsel
	blt s5,s10,loop5
	
	xor s5,s5,s5
	and s9,s8,s0 # 高位保护
	lui s6,0x00008 
	and s6,s8,s6
	and s8,s8,s11 # 将高位置零
	srli s8,s8,1
	beq s6,zero,next5 #如果最高位为零，那么相当于逻辑右移高位不用补1
	xor s8,s8,s6
next5:
	and s8,s8,s11
	or s8,s8,s9
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop5

