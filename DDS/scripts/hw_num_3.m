%%Task 3. The effect phase quantization

clear; close all; clc;
% DDS parameters
Fclk = 100e6;        % Clock frequency [Hz]
Fout = 11.3e6;       % frequency out [Hz]
Nacc = 32;           % Phase battery discharge
Nsamp = 8192;        % Number of counts
Nlut = [14, 12, 10, 8]; % The bit depth of the sine table

% phase increment
dphase = round((Fout / Fclk) * 2^Nacc);

% Signal generation
phase = mod((0:Nsamp-1) * dphase, 2^Nacc);
phase_norm = 2 * pi * phase / 2^Nacc;
sin_signal = sin(phase_norm);

% Creating graphs
figure('Position', [100, 100, 1000, 800]);

for i = 1:length(Nlut)
    nbits = Nlut(i);
    levels = 2^nbits;

    % Signal quantization
    signal = round(sin_signal * (levels/2 - 1)) / (levels/2 - 1);

    % Spectrum (Fast Fourier Transform)
    spectrum = fft(signal) / Nsamp;
    spectrum = spectrum(1:Nsamp/2+1);
    amp_dB = 20 * log10(abs(spectrum));
    freq = (0:Nsamp/2) * (Fclk / Nsamp);

    % Plotting a graph
    subplot(2, 2, i);
    plot(freq/1e6, amp_dB, 'blue');
    grid on;
    xlabel('Частота [МГц]');
    ylabel('Амплитуда [дБ]');
    title(sprintf('Спектр DDS, N_{LUT} = %d бит', nbits));
    xlim([0, 50]);  % Ограничим до 50 МГц для наглядности
    ylim([-100, 10]);
end
