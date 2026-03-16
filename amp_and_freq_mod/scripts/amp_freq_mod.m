%% amplitude modulation
fs = 44100;
T = 1/fs;
t = 0:T:0.5;
f = 10;
fc = 1e4;
A = 1;
S = A*sin(2*pi*f*t);
m = 2;
S_mod = (1+m.*S).*cos(2*pi*fc*t);

plot(S);

figure
hold on;
plot(S_mod);
grid on
hold off;

%%frequency modulation

vm = 1;
vc = 1;
fm = 1000;
fcm = 1e1;
m = 1;
S_mod_freq = cos(2*pi*(fcm+cos(2*pi*fm*t)+m).*t);

figure
hold on;
plot(S_mod_freq);
grid on
hold off;



%%FIR
fir_coeff = 1/100*ones(100,1);
S_filtered = conv(S,fir_coeff,"same");
%%plot(S_filtered);

fir_coeff_freq = [0 1 0 0];
fir_coeff_time = ifftshift(ifft(fir_coeff_freq));
S_filtered_2 = conv(S,fir_coeff_time,"same");





