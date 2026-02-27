A = 1;
F = 100;
Fs = 10e3;
t = 0.1;
t_array = 0:1/Fs:t;
s1 = A*cos(2*pi*F*t_array);
s2 = A*cos(2*pi*F*t_array+0.5*pi);

%% Spectrum analyzer
s1_fft = fft (s1); %go to frequency domain
S1_fft_shifted = fftshift(s1_fft); % shift frequency offset
s1_fft_mod = abs(S1_fft_shifted/length(t_array)); %normalized magnitude in frequency domain
s1_fft_ang = atan(S1_fft_shifted); %

%% Complex Spectrum analyzer
s2_complex = A*exp(2*pi*F*t_array*1i); %complex sin-signal
 s2_complex = A*exp(2*pi*F*t_array*1i); %complex sin-signal
s2_complex_fft = fft (s2_complex); %go to frequency domain
S1_fft_shifted = fftshift(s1_fft); % shift frequency offset
s1_fft_mod = abs(S1_fft_shifted/length(t_array)); %normalized magnitude in frequency domain
s1_fft_ang = atan(S1_fft_shifted); 
s2_complex_fft = fft (s2_complex); %go to frequency domain
S2_complex_fft_shifted = fftshift(s2_complex_fft); % shift frequency offset
s2_complex_fft_mod = abs(S2_complex_fft_shifted/length(t_array)); %normalized magnitude in frequency domain
s2_complex_fft_ang = atan(S2_complex_fft_shifted);