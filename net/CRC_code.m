gen = [1 1 0 1];        %生成多项式
data = [1 0 0 1 1];     %原始信号
[code_crc] = CRC_CODE (gen,data)

function [code_crc]=CRC_CODE (gen,data)
%生成多项式gen 
%原始信号data
glen = length(gen);     %取生成多项式的长度

while gen(1) == 0       %保证生成多项式最高位为1
    gen = gen(2:glen);  
    glen = length(gen);
end
data_back = data;       
for m = 1:glen-1        %将发送数据比特序列乘生成多项式最高次幂
    data = [data 0];
end
dlen = length(data);    %求得发送端长度

cr = data(1:glen-1);    %列竖式，cr储存每次除法相减所得余数
for p = glen:dlen       %循环计算，得到每一位的“余数”（仿照竖式运算规则）
    cr(glen) = data(p); 
    if cr(1)            %如该位“余数”最高位为1 则将“余数”与除数模二运算
        cr = xor(cr(2:glen),gen(2:glen));
    else                %如该位“余数”最高位为0 则将“余数”左移一位
        cr = cr(2:glen);
    end
end                     %循环结束可得到最终余数cr

code_crc = [data_back cr];
end