#——————————————————————————
# 一位乘程序，计算完成后必须按下清零键才能进行下一步操作
# 输入：1-15（SW[3:0]），功能选择键（SW[23]：立方，SW[22]：平方），清零键SW[21]
# 时间：2021/6/29
# 作者：叶椅琦
#——————————————————————————	
	lui s1,0xFFFFF #偏移地址

	
numoperation:

	lw s0,0x70(s1) #读取拨码开关低位
	andi s0,s0,0x00F #取s0低四位
	lw s2,0x72(s1) #读取拨码开关高位
	andi s2,s2,0x0C0 #取拨码开关高位23,22号开关
	beq s2,zero,numoperation #如果结果不为零，程序继续往下走
	add s3,s0,zero #判断条件
	add s4,s0,zero #用来存储加数
	xor s0,s0,s0 #将s0置零，用来存储结果
	addi s5,zero,4 #count = 4

squreloop:
	andi s6,s3,0x001 #检查最低位是否为1,，如果为1，那么加S0
	beq s6,zero,squrenext
	add s0,s0,s4

squrenext:
	slli s4,s4,1 #加数逻辑左移一位 
	srli s3,s3,1 #判断条件右移一位
	addi s5,s5,-1 #count-1
	bne s5,zero,squreloop #如果s5不为0，那么继续循环
	
	andi s2,s2,0x080 #判断s2是否为立方操作，如果是那么，那么接着操作
	beq s2,zero,endoperation
	
	srli s4,s4,4 #平方完成后将加数还原
	add s3,zero,s4 #将S4赋值给S3，S3作为立方加的判断条件
	add s4,zero,s0 #将平方数S0赋值给S4，S4作为加数
	xor s0,s0,s0 #将S0清零，作为部分积的结果
	addi s5,zero,4 #count=4

cubicloop:
	andi s6,s3,0x001 #检查最低位是否为1,，如果为1，那么加S0
	beq s6,zero,cubicnext
	add s0,s0,s4 #如果不为零，那么将加数加到部分积S0上
cubicnext:
	slli s4,s4,1 #加数逻辑左移一位 
	srli s3,s3,1 #判断条件右移一位
	addi s5,s5,-1 #count-1
	bne s5,zero,cubicloop #如果s5不为0，那么继续循环
	
	
endoperation:
	sw s0,0x60(s1) #将结果写入LED中
	srli s0,s0,16
	sw s0,0x62(s1)
wait:
	lw s6,0x72(s1) #取SW高八位
	andi s6,s6,0x020 #将SW高八位与0010 0000相与，如果为零，代表未按下清零键
	beq s6,zero,wait #此时继续等待清零输入
	sw zero,0x60(s1) #将LED灭灯
	sw zero,0x62(s1)
	jal numoperation #跳转回首地址
		
	
