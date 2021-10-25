%% ��������
delete(instrfindall); %ɾ�����д���
s = serial('com13', 'BaudRate', 115200, 'DataBits', 8, ...,
    'StopBits', 1', 'Parity', 'none', 'FlowControl', 'none');
s.ReadAsyncMode = 'continuous';
fopen(s);
fig = figure(1);

%% ��ر���
AxisMax = 65536;
AxisMin = -65536;
window_width = 800;

g_Count = 0;    %���յ������ݼ���
SOF = 0;    %ͬ��֡��־
AxisValue = 1;  %����ֵ
RecDataDisp = zeros(1,1e5); %�����洢���յ�������
RecData = zeros(1,100); %�������������
Axis = zeros(1,1e5);    %������Ϊx��

window = window_width * (-0.9); %��Ϊx����ʼ����
axis([window, window+window_width, AxisMin, AxisMax]);  %���ô������귶Χ

%����1��ʾ�����ϴ�������
subplot(2,1,1)
grid on;
title('�������ݽ���');xlabel('ʱ��');ylabel('����');

%����2��ʾ���εķ�Ƶ��Ӧ
subplot(2,1,2)
grid on;
title('FFT');xlabel('Ƶ��');ylabel('��ֵ');

Fs = 100;   %����Ƶ��
N = 50; %��������
n = 0:N-1;  %��������
f = n*Fs/N; %ʵ��Ƶ��

%% ����ͬ������
SOF = 0;    %ͬ���źű�־��1��ʾ���յ�ͬ��֡
fwrite(s, 13);  %����ͬ��֡

bytes = get(s, 'BytesAvailable');    %�ж��Ƿ�������
if bytes == 0
    bytes = 1;
end

RecData = fread(s, bytes, 'uint8'); %��ȡ��λ�����ص���������
StartData = find(RecData == 13);    %������λ�����ص������Ƿ����ַ�$
%���������$����ȡ10���ֽڵ����ݣ���Ӧ5��u16����
if(StartData >=1)
    RecData = fread(s, 5, 'uint16');
    SOF = 1;
    StartData = 0;
end

%% ��ʾ��������
if(SOF == 1)
    %��������
    for lpi = 0:4
        RecDataDisp(AxisValue+lpi) = RecData(lpi+1);
    end
    %����X��
    for lpi = 0:4
        Axis(AxisValue+lpi) = AxisValue + lpi;
    end    
    %���±���
    AxisValue = AxisValue + 5;
    g_Count = g_Count + 5;
    %���Ʋ���
    subplot(2,1,1)
    plot(Axis(1:AxisValue-1), RecDataDisp(1:AxisValue-1),'r');
    window = window + 5;
    axis([window, window+window_width, AxisMin, AxisMax]);
    grid on;
    title('�������ݽ���'); xlabel('ʱ��'); ylabel('����');
    drawnow
end

%% ��ʾFFT���ݣ�ÿ�ν���50�����ݣ�����һ��FFT
if(g_Count == 50)
  subplot(2,1,2)
  y = fft(RecDataDisp(AxisValue-50:AxisValue-1), 50);
  Mag = abs(y)*2/N;
  plot(f, Mag, 'r');
  grid on;
  title('FFT'); xlabel('Ƶ��'); ylable('����');
  drawnow
end



