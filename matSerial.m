%% 串口配置
delete(instrfindall); %删除所有串口
s = serial('com13', 'BaudRate', 115200, 'DataBits', 8, ...,
    'StopBits', 1', 'Parity', 'none', 'FlowControl', 'none');
s.ReadAsyncMode = 'continuous';
fopen(s);
fig = figure(1);

%% 相关变量
AxisMax = 65536;
AxisMin = -65536;
window_width = 800;

g_Count = 0;    %接收到的数据计数
SOF = 0;    %同步帧标志
AxisValue = 1;  %坐标值
RecDataDisp = zeros(1,1e5); %用来存储接收到的数据
RecData = zeros(1,100); %用来处理的数据
Axis = zeros(1,1e5);    %用来作为x轴

window = window_width * (-0.9); %作为x轴起始坐标
axis([window, window+window_width, AxisMin, AxisMax]);  %设置窗口坐标范围

%区域1显示串口上传的数据
subplot(2,1,1)
grid on;
title('串口数据接收');xlabel('时间');ylabel('数据');

%区域2显示波形的幅频响应
subplot(2,1,2)
grid on;
title('FFT');xlabel('频率');ylabel('幅值');

Fs = 100;   %采样频率
N = 50; %采样点数
n = 0:N-1;  %采样序列
f = n*Fs/N; %实际频率

%% 数据同步部分
SOF = 0;    %同步信号标志，1表示接收到同步帧
fwrite(s, 13);  %发送同步帧

bytes = get(s, 'BytesAvailable');    %判断是否有数据
if bytes == 0
    bytes = 1;
end

RecData = fread(s, bytes, 'uint8'); %读取下位机返回的所有数据
StartData = find(RecData == 13);    %检索下位机返回的数据是否含有字符$
%如果检索到$，读取10个字节的数据，对应5个u16数据
if(StartData >=1)
    RecData = fread(s, 5, 'uint16');
    SOF = 1;
    StartData = 0;
end

%% 显示串口数据
if(SOF == 1)
    %更新数据
    for lpi = 0:4
        RecDataDisp(AxisValue+lpi) = RecData(lpi+1);
    end
    %更新X轴
    for lpi = 0:4
        Axis(AxisValue+lpi) = AxisValue + lpi;
    end    
    %更新变量
    AxisValue = AxisValue + 5;
    g_Count = g_Count + 5;
    %绘制波形
    subplot(2,1,1)
    plot(Axis(1:AxisValue-1), RecDataDisp(1:AxisValue-1),'r');
    window = window + 5;
    axis([window, window+window_width, AxisMin, AxisMax]);
    grid on;
    title('串口数据接收'); xlabel('时间'); ylabel('数据');
    drawnow
end

%% 显示FFT数据，每次接收50个数据，进行一次FFT
if(g_Count == 50)
  subplot(2,1,2)
  y = fft(RecDataDisp(AxisValue-50:AxisValue-1), 50);
  Mag = abs(y)*2/N;
  plot(f, Mag, 'r');
  grid on;
  title('FFT'); xlabel('频率'); ylable('幅度');
  drawnow
end



