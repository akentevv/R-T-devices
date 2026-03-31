function h = simple_lowpass_fir(IpfCutoffHz, Fs, IpfNumTaps)
    % Обычный фир низкопропускной основанный на потопляемой функции
    n = (0 : numTaps - 1).' - (numTaps - 1)/2;
    fcNorm = cutoffHz / Fs;
    h = 2 * fcNorm * sinc(2 * fcNorm * n);
    w = cos(2 * pi * (0:numTaps - 1).'/(numTaps - 1));
    h = h.* w;
    h = h / sum(h);
end

Rs = 1000; % Symbol rate
sps = 8;  % Сэмплы в символ
Fs = Rs * sps; % Sample rate
IpfCutoffHz = 0.75 * Rs;
IpfNumTaps = 129;
Ipf = simple_lowpass_fir(IpfCutoffHz, Fs, IpfNumTaps);

plot(Ipf);
