#��������������������������������������������������������
# ���ܣ����ڴ���һ����VAL���������ڴ��ַΪ0X00000000��ȡ����
# Ȼ�����SW[23:21]ѡ���Ӧ���ܶ�����в���,
#	SW[23:21] = b'X00 ʱ���޲���
#	SW[23:21] = b'001 ʱ����SW[15:0]��ֵ����VAL�ĵ�16λ
#	SW[23:21] = b'010 ʱ������VAL��ֵ��1
#	SW[23:21] = b'011 ʱ������VAL��ֵ��1
#	SW[23:21] = b'101 ʱ������VAL��ֵ�߼�����
#	SW[23:21] = b'110 ʱ������VAL��ֵ���߼�����
#	SW[23:21] = b'111 ʱ������VAL��ֵ����������
#
# ʱ�䣺2021/6/30
# ���ߣ�Ҷ����
#--------------------------------------------------------
	lui s1,0xFFFFF
	lui s0,0xFFFF0
	lui s11,0x0FFFF
	srli s11,s11,12 # s11 0x0000FFFF
	addi s10,zero,1 # s10��Ϊ���ڿ�����ʹ�ã��������С���Կ�����ˮ�Ƶ�����
			# ����֤����64HZģʽ�£���ˮ�ƴ�Ű���仯һ��
	lw s8,0x00(zero)
	sw s8,0x60(s1)

	
funsel: # ����SW[23:21]����ѡ����
	lw s2,0x72(s1)
	andi s2,s2,0x0E0 # ȡSW[23:21]
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
	

assign: # ��ֵ
	lw s4,0x70(s1)
	and s4,s4,s11 # ȡ����ĵ�16λ
	and s9,s9,s0 # ������λ
	add s8,zero,s4 #��ֵ
	or s8,s8,s9 # ��ԭ�ȵĸ�λ�͸�ֵ��ĵ�λ���
	sw s8,0x00(zero)
	sw s8,0x60(s1)
	lw s2,0x72(s1) # ��ȡ���룬������ѡ��ı䣬�˳���ģ��
	andi s2,s2,0x0E0
	addi s3,zero,0x020
	beq s2,s3,assign
	jal funsel


plus1: # ��һ
	xor s5,s5,s5
loop1:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x040
	bne s2,s3,funsel
	blt s5,s10,loop1
	
	xor s5,s5,s5
	and s9,s8,s0 # ��λ����
	addi s8,s8,1
	xor s8,s8,s0 # ����λ����
	or s8,s8,s9 # ��ԭ���ĸ�λ�͵�λ���
	sw s8,0x00(zero)
	sw s8,0x60(s1)
	jal loop1



minus1: # ��һ
	xor s5,s5,s5
loop2:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x060
	bne s2,s3,funsel
	blt s5,s10,loop2
	
	xor s5,s5,s5
	and s9,s8,s0 # ��λ����
	or s8,s8,s0 # ����λȫ��Ϊ1
	addi s8,s8,-1
	and s8,s8,s11 # ����λ��ԭΪ��
	or s8,s8,s9 # �ߵ�λ���
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop2
	

	
lshift1: # �߼�����һλ
	xor s5,s5,s5
loop3:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x0A0
	bne s2,s3,funsel
	blt s5,s10,loop3
	
	xor s5,s5,s5
	and s9,s8,s0 # ��λ����
	slli s8,s8,1
	and s8,s8,s11 # ȡ���ƺ�ĵ�16λ
	or s8,s8,s9 # ��ԭ�ȵĸ�λ�����ƺ�ĵ�λ���
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop3
	

lrshift1: # �߼�����һλ
	xor s5,s5,s5
loop4:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x0C0
	bne s2,s3,funsel
	blt s5,s10,loop4
	
	xor s5,s5,s5
	and s9,s8,s0 # ��λ����
	and s8,s8,s11 # ����λȫ��Ϊ0
	srli s8,s8,1
	or s8,s8,s9 # ��ԭ�ȵĸ�λ���߼����ƺ�ĵ�λ���
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop4

arshift1: # ��������һλ
	xor s5,s5,s5
loop5:
	addi s5,s5,1
	lw s2,0x72(s1)
	andi s2,s2,0x0E0
	addi s3,zero,0x0E0
	bne s2,s3,funsel
	blt s5,s10,loop5
	
	xor s5,s5,s5
	and s9,s8,s0 # ��λ����
	lui s6,0x00008 
	and s6,s8,s6
	and s8,s8,s11 # ����λ����
	srli s8,s8,1
	beq s6,zero,next5 #������λΪ�㣬��ô�൱���߼����Ƹ�λ���ò�1
	xor s8,s8,s6
next5:
	and s8,s8,s11
	or s8,s8,s9
	sw s8,0x60(s1)
	sw s8,0x00(zero)
	jal loop5

