gen = [1 1 0 1];        %���ɶ���ʽ
data = [1 0 0 1 1];     %ԭʼ�ź�
[code_crc] = CRC_CODE (gen,data)

function [code_crc]=CRC_CODE (gen,data)
%���ɶ���ʽgen 
%ԭʼ�ź�data
glen = length(gen);     %ȡ���ɶ���ʽ�ĳ���

while gen(1) == 0       %��֤���ɶ���ʽ���λΪ1
    gen = gen(2:glen);  
    glen = length(gen);
end
data_back = data;       
for m = 1:glen-1        %���������ݱ������г����ɶ���ʽ��ߴ���
    data = [data 0];
end
dlen = length(data);    %��÷��Ͷ˳���

cr = data(1:glen-1);    %����ʽ��cr����ÿ�γ��������������
for p = glen:dlen       %ѭ�����㣬�õ�ÿһλ�ġ���������������ʽ�������
    cr(glen) = data(p); 
    if cr(1)            %���λ�����������λΪ1 �򽫡������������ģ������
        cr = xor(cr(2:glen),gen(2:glen));
    else                %���λ�����������λΪ0 �򽫡�����������һλ
        cr = cr(2:glen);
    end
end                     %ѭ�������ɵõ���������cr

code_crc = [data_back cr];
end