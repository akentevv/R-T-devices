A = 1; % Amplitude
Fs = 10e4; % Sampling rate
t = 0.1;
t_array = 0:1/Fs:t;
x_counts = 1:1:length(t_array); %values on the x-axis
numSignals = 20; % Number of tones
df=400/numSignals; % Frequency step
S = zeros(1,length(t_array)); % Signal array
S_fft = zeros(1,length(t_array));
S_fft_shifted = zeros(1,length(t_array));
S_fft_mod = zeros(1,length(t_array)); % Array of spectrum amplitudes
S_fft_ang = zeros(1,length(t_array));
for k = 1:numSignals % the cycle of setting k tones
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
S_fft_mod_db = 20*log10(S_fft_mod/A); % Conversion of amplitude to dB
figure(1);
plot(S);

figure(2);
plot(S_fft);

figure(3);
plot(S_fft_mod);

figure(4);
plot(S_fft_mod_db);

% Amplitude modulation
fc = 1e4;
m = 2;
S_mod = (1+m.*S).*cos(2*pi*fc*t_array);
S_mod_fft1 = fft(S_mod);
S_fft_mod1_db = 20*log10(S_mod_fft1/A);

figure(5);
plot(x_counts, S, x_counts, S_mod);
figure(6);
plot(x_counts, S_fft_mod_db, x_counts, S_fft_mod1_db);

% Frequency modulation
fcm = 1e4;
mf = 10;
S_mod_freq = (A*numSignals)*cos(2*pi*(fcm+S+mf).*t_array);
S_mod_freq_fft = fft(S_mod_freq);
S_mod_freq_fft_dB = 20*log10(S_mod_freq_fft/A);

figure(7);
plot(x_counts, S, x_counts, S_mod_freq);
figure(8);
plot(x_counts, S_fft_mod_db, x_counts, S_mod_freq_fft_dB);








