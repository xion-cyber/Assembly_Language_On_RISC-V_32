#����������������������������������������������������
# һλ�˳��򣬼�����ɺ���밴����������ܽ�����һ������
# ���룺1-15��SW[3:0]��������ѡ�����SW[23]��������SW[22]��ƽ�����������SW[21]
# ʱ�䣺2021/6/29
# ���ߣ�Ҷ����
#����������������������������������������������������	
	lui s1,0xFFFFF #ƫ�Ƶ�ַ

	
numoperation:

	lw s0,0x70(s1) #��ȡ���뿪�ص�λ
	andi s0,s0,0x00F #ȡs0����λ
	lw s2,0x72(s1) #��ȡ���뿪�ظ�λ
	andi s2,s2,0x0C0 #ȡ���뿪�ظ�λ23,22�ſ���
	beq s2,zero,numoperation #��������Ϊ�㣬�������������
	add s3,s0,zero #�ж�����
	add s4,s0,zero #�����洢����
	xor s0,s0,s0 #��s0���㣬�����洢���
	addi s5,zero,4 #count = 4

squreloop:
	andi s6,s3,0x001 #������λ�Ƿ�Ϊ1,�����Ϊ1����ô��S0
	beq s6,zero,squrenext
	add s0,s0,s4

squrenext:
	slli s4,s4,1 #�����߼�����һλ 
	srli s3,s3,1 #�ж���������һλ
	addi s5,s5,-1 #count-1
	bne s5,zero,squreloop #���s5��Ϊ0����ô����ѭ��
	
	andi s2,s2,0x080 #�ж�s2�Ƿ�Ϊ�����������������ô����ô���Ų���
	beq s2,zero,endoperation
	
	srli s4,s4,4 #ƽ����ɺ󽫼�����ԭ
	add s3,zero,s4 #��S4��ֵ��S3��S3��Ϊ�����ӵ��ж�����
	add s4,zero,s0 #��ƽ����S0��ֵ��S4��S4��Ϊ����
	xor s0,s0,s0 #��S0���㣬��Ϊ���ֻ��Ľ��
	addi s5,zero,4 #count=4

cubicloop:
	andi s6,s3,0x001 #������λ�Ƿ�Ϊ1,�����Ϊ1����ô��S0
	beq s6,zero,cubicnext
	add s0,s0,s4 #�����Ϊ�㣬��ô�������ӵ����ֻ�S0��
cubicnext:
	slli s4,s4,1 #�����߼�����һλ 
	srli s3,s3,1 #�ж���������һλ
	addi s5,s5,-1 #count-1
	bne s5,zero,cubicloop #���s5��Ϊ0����ô����ѭ��
	
	
endoperation:
	sw s0,0x60(s1) #�����д��LED��
	srli s0,s0,16
	sw s0,0x62(s1)
wait:
	lw s6,0x72(s1) #ȡSW�߰�λ
	andi s6,s6,0x020 #��SW�߰�λ��0010 0000���룬���Ϊ�㣬����δ���������
	beq s6,zero,wait #��ʱ�����ȴ���������
	sw zero,0x60(s1) #��LED���
	sw zero,0x62(s1)
	jal numoperation #��ת���׵�ַ
		
	
