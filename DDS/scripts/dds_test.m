%% DDS generator test

Fclk = 100e6;
Fout = [1e6 7.5e6 10e6 30e6]
Nacc = 24;
Nlut = 10;
Nsamp = 4096;
amp_bits = 12;

phase_mod = 2^Nacc;
lut_size = 2^Nlut;

% phase increment calculation
ftw = round(Fout * phase_mod / Fclk);

% Phase accimulator
n = 0:(Nsamp-1);
phase_acc = mod(n.*ftw, phase_mod);

%Phase quantization
phase_index = floor(phase_acc / 2^(Nacc - Nlut));

%sine LUT
lut = sin(2*pi* (0:(lut_size - 1)) / lut_size);

%plot(lut);

% Amplitude quantization

levels = 2^(amp_bits - 1) -1 ;

lut_q = round(lut * levels) / levels;



%Syntezed sin
y = lut_q(phase_index + 1);
plot(y);


%[y, phase_acc, ftw, phase_index] = dds_core(Fclk, Fout, Nacc, Nlut, Nsamp, amp_bits);

Fout_real = ftw * Fclk / 2^Nacc;
delta_freq = Fout - Fout_real;
dF = Fclk / 2^Nacc;







