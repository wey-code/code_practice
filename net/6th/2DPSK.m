clc
clear all 
close all
step = 10e-6;
sig_length = 1/1000;
sig_num = 9;
len = sig_length * sig_num;
dot_num = sig_length/step;
cay_fre = 2000;

x=step:step:len;
A=ones(1,dot_num);
B=zeros(1,dot_num);
A1=[B A A A B B A B A];
A2=[A -A -A -A A A -A A -A];
carry = sin(2*pi*cay_fre*x);
psk = A2.*carry;
rec_cay = -carry;
sov1 = rec_cay.*psk;
sov2 = fli(sov1,1/step);
sov3 = judge(sov2,dot_num,9);

%fft_2(sov2,1/step);

figure;
plot(x,A1); ylim([-0.2 1.2]);title('原始差分码二进制波形')%原二进制
figure;
subplot(7,1,1);plot(x,A2); ylim([-1.5 1.5]);title('原始二进制差分码双极性波形')%双极性
subplot(7,1,2);plot(x,carry); ylim([-1.2 1.2]);title('发送端载波')%载波
subplot(7,1,3);plot(x,psk); ylim([-1.2 1.2]);title('已调波')%调制波 
subplot(7,1,4);plot(x,rec_cay); ylim([-1.2 1.2]);title('接收端载波')%接收载波
subplot(7,1,5);plot(x,sov1); ylim([-1.2 1.2]);title('相干解调时的波形')%
subplot(7,1,6);plot(x,sov2); title('低通滤波后的波形')%
subplot(7,1,7);plot(x,sov3); ylim([-1.5 1.5]);title('经采样判决恢复出的双极性波形（仍为差分码）')%

function [output] = judge(input,len,num)
    output = [];
    A=ones(1,len);
    for i = 1:1:num
        if(input(i*len)>0)
            output = [output A];
        else
            output = [output -A];
        end
    end
end

function [] = fft_2(s,Fs)
    len = 2^15;
   y=fft(s,len);  % 对信号做len点FFT变换  
    f=Fs*(0:len/2 - 1)/len;  
    figure(2);plot(f,abs(y(1:len/2)));grid; 
end

function [Bf] = fli(s,Fs)
    % 3. IIR滤波器设计  
    N=0; % 阶数  
    Fp=1000; % 通带截止频率50Hz  
    Fc=3000; % 阻带截止频率100Hz  
    Rp=5; % 通带波纹最大衰减为1dB  
    Rs=50; % 阻带衰减为60dB  

    % 3.0 计算最小滤波器阶数  
    na=sqrt(10^(0.1*Rp)-1);  
    ea=sqrt(10^(0.1*Rs)-1);  
    N=ceil(log10(ea/na)/log10(Fc/Fp));  

    % 3.1 巴特沃斯滤波器  
    Wn=Fp*2/Fs;  
    [Bb Ba]=butter(N,Wn,'low'); % 调用MATLAB butter函数快速设计滤波器  
    [BH,BW]=freqz(Bb,Ba); % 绘制频率响应曲线  
    Bf=filter(Bb,Ba,s); % 进行低通滤波  

end
