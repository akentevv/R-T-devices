A = 1; % Амплитуда сигнала
Fs = 10e4; % Частота дискретизации
t = 0.1;
t_array = 0:1/Fs:t;
points = 1:1:length(t_array);
numSignals = 20; % Количество тонов
df=300/numSignals; % Шаг частоты
S = zeros(1,length(t_array)); % Массив сигнала
S_fft = zeros(1,length(t_array));
S_fft_shifted = zeros(1,length(t_array));
S_fft_mod = zeros(1,length(t_array)); % Массив амплитуд спектров
S_fft_ang = zeros(1,length(t_array));
for k = 1:numSignals
   St = A*exp(2*pi*t_array*1i*k*df);
   S = S + St;
   St_fft = fft(St);
   S_fft = S_fft + St_fft;
   St_fft_shifted = fftshift(St_fft);
   S_fft_shifted = S_fft_shifted + St_fft_shifted;
   St_fft_mod = abs(St_fft_shifted/length(St_fft_shifted));
   S_fft_mod = S_fft_mod + St_fft_mod;
   St_fft_ang = atan(St_fft_shifted);
   S_fft_ang = S_fft_ang + St_fft_ang;
   k = k + 1;
  end;
S_fft_mod_db = 20*log10(S_fft_mod/A); % Перевод амплитуды спектра в децибелы
figure(1);
plot(points, S);

%figure(2);
%plot(S_fft);

%figure(3);
%plot(S_fft_mod);

%figure(4);
%plot(S_fft_mod_db);

fc = 1e4;
m = 2;
S_mod = (1+m.*S).*cos(2*pi*fc*t_array); % Амплитудная модуляция

figure(5);
plot(points, S, points, S_mod);

fcm = 1e4;
mf = 10;
S_mod_freq = (A*tones)*cos(2*pi*(fcm+S+mf).*t_array); % Частотная модуляция

figure(6);
plot(points, S, points, S_mod_freq);









