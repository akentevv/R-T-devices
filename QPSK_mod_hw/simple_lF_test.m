


Rs = 1000; % Symbol rate
sps = 8;  % Сэмплы в символ
Fs = Rs * sps; % Sample rate
cutoffHz = 0.75 * Rs;
numTaps = 129;
Ipf = simple_lowpass_fir(cutoffHz, Fs, numTaps);

plot(Ipf);
