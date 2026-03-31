%% Функция Lowpass фильтра
function h = simple_lowpass_fir(cutoffHz, Fs, numTaps)
    % Обычный FIR низкопропускной на основе sinc функции
    n = (0:numTaps-1).' - (numTaps-1)/2;
    fcNorm = cutoffHz / Fs;
    h = 2 * fcNorm * sinc(2 * fcNorm * n);
    w = cos(2 * pi * (0:numTaps-1).'/(numTaps-1));
    h = h .* w;
    h = h / sum(h);
end
