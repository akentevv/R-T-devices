%% Setting and displaying a signal of 20 tones
A = 5;
A_dB = db(A);
F = 100;
Fs = 10e3;
t = 0.1;
t_array = 0:1/Fs:t;

numSignals = 20;  % number of signal tones
signals = zeros(length(t_array), numSignals); 

for i = 1:numSignals % Cycles with signal tones
    frequency = i * 0.18*pi; % frequency surge
    signals(:, i) = A_dB*sin(2*pi*F_dB* t_array + frequency); % recording tones in array columns
end

figure;
hold on;

for i = 1:numSignals
    plot( signals(:, i), 'LineWidth', 1);
end

title('20 tones of a sinusoidal signal');
xlabel('Time, sec');
ylabel('Amplitude, dB');
grid on;
hold off;
%% Fast fourier transform
signals_fft = fft(signals);

figure;
hold on;

for i = 1:numSignals
    plot( signals_fft(:, i), 'LineWidth', 1);
end

title('Fast fourier transform');
xlabel('X');
ylabel('Y');
grid on;
hold off;
%% Signal spectrum


signals_fft_mod= abs(signals_fft); % shift frequency offset

figure;
hold on;

for i = 1:numSignals
    plot( signals_fft_mod(:, i), 'LineWidth', 1);
end

title('20-signal spectrum');
xlabel('frequency');
ylabel('Amplitude, dB');
grid on;
hold off;