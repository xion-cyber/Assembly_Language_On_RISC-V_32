 # ----------------------------------------------------------------------------
 # ���ܣ�����SW[23:21]��ѡ����ʾ���ܣ�SW[23]ģʽ1����������������SW[22]ģʽ2��������
 # ����������������SW[21]ģʽ3������SW[4:0]��������ִ�С����ʾ��ˮ�ƣ�SW[5]Ϊ
 # ׼������źţ�ֻ�в���SW[5]�󣬳���Ŵ�SW[4:0]��ȡ������ǰģʽ��ť���غ󣬳���
 # ����ص�ģʽѡ��ģ�顣
 # ʱ�䣺2021/6/30
 # ���ߣ�Xion
 #-----------------------------------------------------------------------------



 	#lui s0,0x00802
 	#srli s0,s0,12 # 4.1KHz�°�������2050�����ڣ�250D=100000000010B=0x802 
 	addi s0,zero,0x001 # ������logisim���ֻ�ܴﵽ200HZ���ң�����ִ��ָ���ʱ��
					   # ������64HZģʽ����ˮ�ƴ���ܰ��뻻һ��
 	lui s1,0xFFFFF # ƫ�Ƶ�ַ
 	
 modesel:
 	sw zero,0x60(s1)
 	sw zero,0x62(s1)
 	lw s2,0x72(s1) # ��ȡ���뿪�ظ߰�λ
 	andi s3,s2,0x080 # �ж�SW[23]�Ƿ�Ϊ1��Ϊ1����ת��mode1
 	bne s3,zero,mode1
 	andi s3,s2,0x040 # �ж�SW[22]�Ƿ�Ϊ1��Ϊ1����ת��mode2
 	bne s3,zero,mode2
 	andi s3,s2,0x020 # �ж�SW[21]�Ƿ�Ϊ1��Ϊ1����ת��mode3
	bne s3,zero,mode3
 	jal modesel
 		
 mode1:
 	addi s10,zero,12 # 12�������Ƚ�ֵ
 	lui s4,0x00800
 	addi s5,zero,0x001
 	xor s6,s6,s6 # 2050������
 	xor s7,s7,s7 # 12������
 	xor s8,s8,s8 # led
 lightloop1:
 	addi s6,s6,1
	lw s2,0x72(s1)
	andi s2,s2,0x080
	beq s2,zero,modesel # �����뿪�ر仯ʱ����ת��ģʽѡ��
 	blt s6,s0,lightloop1
	
 light1:
 	xor s6,s6,s6
 	xor s8,s8,s4
 	xor s8,s8,s5 # ��s4,s5����s8�������������൱�ڶ�s8��Ӧλ��ȡ��
 	srli s4,s4,1 # �ֱ����ҡ������߼��ƶ�s4,s5��ͨ����λ���ı�s8��ͬλ�õ�ֵ
 	slli s5,s5,1
 	addi s7,s7,1
 	sw s8,0x60(s1)
 	srli s9,s8,16
 	sw s9,0x62(s1)
 	blt s7,s10,lightloop1
	xor s7,s7,s7 # ����12�κ����
	slli s4,s4,1 # ��Ϊ������һ��λ��Ҫ���仹ԭ����һ��
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
	lui s4,0x00800 # ��Ϊ���һ����λ������s5��Ϊ0�ˣ�������¸�ֵ
	addi s5,s5,0x001
	jal lightloop1
	
mode2:
	lui s4,0x00800
	addi s5,zero,24
	xor s6,s6,s6 # 2050������
	xor s7,s7,s7 # 24������
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
	srli s4,s4,1 # ÿ�ν�s4,s8����s4����һλ�Ա���һ��������
	addi s7,s7,1
	sw s8,0x60(s1)
	srli s9,s8,16
	sw s9,0x62(s1)
	blt s7,s5,lightloop2
	lui s4,0x00800 # s4���Ƴ���������¸�ֵ
	xor s7,s7,s7

gooutloop2:
	addi s6,s6,1
	lw s2,0x72(s1)
	andi s2,s2,0x040
	beq s2,zero,modesel
	blt s6,s0,gooutloop2

goout2:
	srli s8,s8,1 # ��Ҫѭ����ƣ�ֱ���߼����Ƽ���
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
	beq s3,zero,ready # ���SW[5]Ϊ0�������»�ȡ��ʼ�źţ����򣬿�ʼ��ʾ
	xor s5,s5,s5 # 2050������
	andi s2,s2,0x01F # 24λled����Ҫ5λ������
	addi s2,s2,-1
	blt s2,zero,mode3
	lui s8,0x00800
	lui s4,0x00800 # ѭ��ʱ���һλΪ1������s8��������ͷ������һλ

countloop: 			# s2���ڶ��٣���������յ��
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
	andi s6,s8,0x001 #������һλΪ1����ô���ƺ�Ҫ�����λ��1
	srli s8,s8,1
	beq s6,zero,lightloop3 #������һ��λΪ0����ôֱ�����¿�ʼѭ��
	xor s8,s8,s4 # ���λ��1
	jal lightloop3











