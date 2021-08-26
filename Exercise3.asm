 # ----------------------------------------------------------------------------
 # 功能：根据SW[23:21]来选择显示功能，SW[23]模式1：两边亮，两边灭；SW[22]模式2：由左至
 # 右亮，由左至右灭；SW[21]模式3：根据SW[4:0]输入的数字大小来显示流水灯，SW[5]为
 # 准备完成信号，只有拨动SW[5]后，程序才从SW[4:0]中取数。当前模式按钮拨回后，程序
 # 程序回到模式选择模块。
 # 时间：2021/6/30
 # 作者：Xion
 #-----------------------------------------------------------------------------



 	#lui s0,0x00802
 	#srli s0,s0,12 # 4.1KHz下半秒大概有2050个周期，250D=100000000010B=0x802 
 	addi s0,zero,0x001 # 但好像logisim最高只能达到200HZ左右，加上执行指令的时间
					   # 发现在64HZ模式下流水灯大概能半秒换一次
 	lui s1,0xFFFFF # 偏移地址
 	
 modesel:
 	sw zero,0x60(s1)
 	sw zero,0x62(s1)
 	lw s2,0x72(s1) # 读取拨码开关高八位
 	andi s3,s2,0x080 # 判断SW[23]是否为1，为1则跳转到mode1
 	bne s3,zero,mode1
 	andi s3,s2,0x040 # 判断SW[22]是否为1，为1则跳转到mode2
 	bne s3,zero,mode2
 	andi s3,s2,0x020 # 判断SW[21]是否为1，为1则跳转到mode3
	bne s3,zero,mode3
 	jal modesel
 		
 mode1:
 	addi s10,zero,12 # 12计数器比较值
 	lui s4,0x00800
 	addi s5,zero,0x001
 	xor s6,s6,s6 # 2050计数器
 	xor s7,s7,s7 # 12计数器
 	xor s8,s8,s8 # led
 lightloop1:
 	addi s6,s6,1
	lw s2,0x72(s1)
	andi s2,s2,0x080
	beq s2,zero,modesel # 当拨码开关变化时，跳转到模式选择
 	blt s6,s0,lightloop1
	
 light1:
 	xor s6,s6,s6
 	xor s8,s8,s4
 	xor s8,s8,s5 # 用s4,s5来对s8进行亦或操作，相当于对s8对应位置取非
 	srli s4,s4,1 # 分别向右、向左逻辑移动s4,s5，通过移位来改变s8不同位置的值
 	slli s5,s5,1
 	addi s7,s7,1
 	sw s8,0x60(s1)
 	srli s9,s8,16
 	sw s9,0x62(s1)
 	blt s7,s10,lightloop1
	xor s7,s7,s7 # 计数12次后归零
	slli s4,s4,1 # 因为多移了一次位，要将其还原到上一步
	srli s5,s5,1

 gooutloop1:
 	addi s6,s6,1
	lw s2,0x72(s1)
	andi s2,s2,0x080
	beq s2,zero,modesel
 	blt s6,s0,gooutloop1

 
 goout1:
 	xor s6,s6,s6
 	xor s8,s8,s4
 	xor s8,s8,s5
 	slli s4,s4,1
 	srli s5,s5,1
 	addi s7,s7,1
 	sw s8,0x60(s1)
 	srli s9,s8,16
 	sw s9,0x62(s1)
 	blt s7,s10,gooutloop1
	xor s7,s7,s7
	lui s4,0x00800 # 因为最后一次移位操作后，s5变为0了，因此重新赋值
	addi s5,s5,0x001
	jal lightloop1
	
mode2:
	lui s4,0x00800
	addi s5,zero,24
	xor s6,s6,s6 # 2050计数器
	xor s7,s7,s7 # 24计数器
	xor s8,s8,s8 # led
	
lightloop2:
	addi s6,s6,1
	lw s2,0x72(s1)
	andi s2,s2,0x040
	beq s2,zero,modesel
	blt s6,s0,lightloop2
		
light2:
	xor s6,s6,s6
	xor s8,s8,s4
	srli s4,s4,1 # 每次将s4,s8异或后将s4右移一位以便下一次异或操作
	addi s7,s7,1
	sw s8,0x60(s1)
	srli s9,s8,16
	sw s9,0x62(s1)
	blt s7,s5,lightloop2
	lui s4,0x00800 # s4被移出，因此重新赋值
	xor s7,s7,s7

gooutloop2:
	addi s6,s6,1
	lw s2,0x72(s1)
	andi s2,s2,0x040
	beq s2,zero,modesel
	blt s6,s0,gooutloop2

goout2:
	srli s8,s8,1 # 想要循环灭灯，直接逻辑右移即可
	addi s7,s7,1
	sw s8,0x60(s1)
	srli s9,s8,16
	sw s9,0x62(s1)
	blt s7,s5,gooutloop2
	xor s7,s7,s7
	jal lightloop2


mode3:

ready:
	lw s2,0x70(s1)
	andi s3,s2,0x020
	beq s3,zero,ready # 如果SW[5]为0，则重新获取开始信号；否则，开始显示
	xor s5,s5,s5 # 2050计数器
	andi s2,s2,0x01F # 24位led共需要5位来计算
	addi s2,s2,-1
	blt s2,zero,mode3
	lui s8,0x00800
	lui s4,0x00800 # 循环时最后一位为1则将其与s8异或则可在头部增添一位

countloop: 			# s2等于多少，就亮多少盏灯
	addi s2,s2,-1
	blt s2,zero,lightloop3
	srli s8,s8,1
	xor s8,s8,s4
	jal countloop
lightloop3:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x020
	beq s2,zero,modesel
	blt s5,s0,lightloop3

light3:
	sw s8,0x60(s1)
	srli s9,s8,16
	sw s9,0x62(s1)
	xor s5,s5,s5
	andi s6,s8,0x001 #如果最后一位为1，那么右移后要在最高位补1
	srli s8,s8,1
	beq s6,zero,lightloop3 #如果最后一个位为0，那么直接重新开始循环
	xor s8,s8,s4 # 最高位补1
	jal lightloop3











