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
plot(x,A1); ylim([-0.2 1.2]);title('ԭʼ���������Ʋ���')%ԭ������
figure;
subplot(7,1,1);plot(x,A2); ylim([-1.5 1.5]);title('ԭʼ�����Ʋ����˫���Բ���')%˫����
subplot(7,1,2);plot(x,carry); ylim([-1.2 1.2]);title('���Ͷ��ز�')%�ز�
subplot(7,1,3);plot(x,psk); ylim([-1.2 1.2]);title('�ѵ���')%���Ʋ� 
subplot(7,1,4);plot(x,rec_cay); ylim([-1.2 1.2]);title('���ն��ز�')%�����ز�
subplot(7,1,5);plot(x,sov1); ylim([-1.2 1.2]);title('��ɽ��ʱ�Ĳ���')%
subplot(7,1,6);plot(x,sov2); title('��ͨ�˲���Ĳ���')%
subplot(7,1,7);plot(x,sov3); ylim([-1.5 1.5]);title('�������о��ָ�����˫���Բ��Σ���Ϊ����룩')%

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
   y=fft(s,len);  % ���ź���len��FFT�任  
    f=Fs*(0:len/2 - 1)/len;  
    figure(2);plot(f,abs(y(1:len/2)));grid; 
end

function [Bf] = fli(s,Fs)
    % 3. IIR�˲������  
    N=0; % ����  
    Fp=1000; % ͨ����ֹƵ��50Hz  
    Fc=3000; % �����ֹƵ��100Hz  
    Rp=5; % ͨ���������˥��Ϊ1dB  
    Rs=50; % ���˥��Ϊ60dB  

    % 3.0 ������С�˲�������  
    na=sqrt(10^(0.1*Rp)-1);  
    ea=sqrt(10^(0.1*Rs)-1);  
    N=ceil(log10(ea/na)/log10(Fc/Fp));  

    % 3.1 ������˹�˲���  
    Wn=Fp*2/Fs;  
    [Bb Ba]=butter(N,Wn,'low'); % ����MATLAB butter������������˲���  
    [BH,BW]=freqz(Bb,Ba); % ����Ƶ����Ӧ����  
    Bf=filter(Bb,Ba,s); % ���е�ͨ�˲�  

end
