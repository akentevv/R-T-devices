clear all; close all; clc;

%% Параметры системы
Fs = 10000;           % Частота дискретизации (Гц)
sps = 8;              % Количество отсчетов на символ
beta = 0.35;          % Коэффициент сглаживания RRC фильтра
span = 8;             % Длительность импульсной характеристики RRC в символах
cutoffHz = Fs/(2*sps); % Частота среза для lowpass фильтра (половина символьной скорости)
numTaps = 101;        % Количество taps для lowpass фильтра

%% Функция QPSK модуляции
function symbols = qpsk_mod(bits)
    % QPSK модуляция с кодированием Грея
    bits = bits(:);

    % Проверяем четное количество битов
    if mod(length(bits), 2) ~= 0
        error('Количество битов должно быть четным');
    end

    bitPairs = reshape(bits, 2, []).';
    symbols = zeros(size(bitPairs, 1), 1);

    for k = 1:size(bitPairs, 1)
        b1 = bitPairs(k, 1);
        b2 = bitPairs(k, 2);

        if b1 == 0 && b2 == 0
            symbols(k) = 1 + 1j;
        elseif b1 == 0 && b2 == 1
            symbols(k) = -1 + 1j;
        elseif b1 == 1 && b2 == 1
            symbols(k) = -1 - 1j;
        elseif b1 == 1 && b2 == 0
            symbols(k) = 1 - 1j;
        end
    end

    symbols = symbols / sqrt(2);
end

%% Функция для апсемплинга и фильтрации
function filtered_signal = upsample_and_filter(symbols, filter_h, sps)
    % symbols - входные символы
    % filter_h - импульсная характеристика фильтра
    % sps - количество отсчетов на символ

    % Шаг 1: Апсемплинг (вставка нулей)
    N_symbols = length(symbols);
    N_upsampled = N_symbols * sps;
    upsampled = zeros(N_upsampled, 1);
    upsampled(1:sps:end) = symbols;

    % Шаг 2: Фильтрация через свертку
    filtered_signal = conv(upsampled, filter_h, 'full');

    % Опционально: обрезаем края для компенсации задержки фильтра
    % (убираем половину длины фильтра с каждого конца)
    filter_delay = floor(length(filter_h)/2);
    filtered_signal = filtered_signal(filter_delay+1:end-filter_delay);
end

%% Formation of the preamble 32 bit
preamble_bits = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 ...
                 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]';
preamble_symbols = qpsk_mod(preamble_bits);

%% Formation of a random signal
num_data_bits = 200;   % num of data bits
data_bits = randi([0, 1], num_data_bits, 1);

% Mixed signal
tx_bits = [preamble_bits; data_bits];

%% QPSK mod
tx_symbols = qpsk_mod(tx_bits);

%% RRC filter
rrc_h = rrc_filter(beta, span, sps);
tx_rrc_filtered = upsample_and_filter(tx_symbols, rrc_h, sps);

%% Lowpass filter
lowpass_h = simple_lowpass_fir(cutoffHz, Fs, numTaps);
tx_lowpass_filtered = upsample_and_filter(tx_symbols, lowpass_h, sps);

%% Создание сигнала без фильтрации (для сравнения)
% Простой апсемплинг без фильтрации
tx_unfiltered = zeros(length(tx_symbols) * sps, 1);
tx_unfiltered(1:sps:end) = tx_symbols;

%% Визуализация результатов

% 1. Символы QPSK на комплексной плоскости
figure('Position', [100, 100, 1200, 800]);

subplot(2, 2, 1);
plot(real(tx_symbols), imag(tx_symbols), 'bo', 'MarkerSize', 8, 'LineWidth', 2);
grid on; hold on;
plot(real(tx_symbols), imag(tx_symbols), 'r-', 'LineWidth', 0.5);
xlabel('I (синфазная)'); ylabel('Q (квадратурная)');
title('Сигнальное созвездие');
axis equal; axis([-1.5 1.5 -1.5 1.5]);
plot([-1.5 1.5], [0 0], 'k--', [0 0], [-1.5 1.5], 'k--');

% 2. Форма сигнала во временной области (первые 500 отсчетов)
samples_to_plot = min(500, length(tx_rrc_filtered));

subplot(2, 2, 2);
plot(real(tx_unfiltered(1:samples_to_plot)), 'b-', 'LineWidth', 1);
hold on;
plot(real(tx_rrc_filtered(1:samples_to_plot)), 'r-', 'LineWidth', 1);
plot(real(tx_lowpass_filtered(1:samples_to_plot)), 'g-', 'LineWidth', 1);
xlabel('Отсчеты'); ylabel('Амплитуда, дБ');
title('I-компонента (временная область)');
legend('Без фильтра', 'RRC фильтр', 'Lowpass фильтр', 'Location', 'best');
grid on;

subplot(2, 2, 3);
plot(imag(tx_unfiltered(1:samples_to_plot)), 'b-', 'LineWidth', 1);
hold on;
plot(imag(tx_rrc_filtered(1:samples_to_plot)), 'r-', 'LineWidth', 1);
plot(imag(tx_lowpass_filtered(1:samples_to_plot)), 'g-', 'LineWidth', 1);
xlabel('Отсчеты'); ylabel('Амплитуда, дБ');
title('Q-компонента (временная область)');
legend('Без фильтра', 'RRC фильтр', 'Lowpass фильтр', 'Location', 'best');
grid on;

% 3. Спектр сигналов
subplot(2, 2, 4);
NFFT = 4096;
f = Fs * (-NFFT/2:NFFT/2-1)/NFFT;

S_unfiltered = fftshift(fft(tx_unfiltered, NFFT));
S_rrc = fftshift(fft(tx_rrc_filtered, NFFT));
S_lowpass = fftshift(fft(tx_lowpass_filtered, NFFT));

% Нормализуем спектры
S_unfiltered_norm = abs(S_unfiltered) / max(abs(S_unfiltered));
S_rrc_norm = abs(S_rrc) / max(abs(S_rrc));
S_lowpass_norm = abs(S_lowpass) / max(abs(S_lowpass));

plot(f, 20*log10(S_unfiltered_norm + eps), 'b-', 'LineWidth', 1);
hold on;
plot(f, 20*log10(S_rrc_norm + eps), 'r-', 'LineWidth', 1);
plot(f, 20*log10(S_lowpass_norm + eps), 'g-', 'LineWidth', 1);
xlabel('Частота (Гц)'); ylabel('Нормированная мощность (дБ)');
title('Спектр сигналов');
legend('Без фильтра', 'RRC фильтр', 'Lowpass фильтр', 'Location', 'best');
grid on; axis([-Fs/2 Fs/2 -60 5]);


%% Визуализация преамбулы (отдельно)
figure('Position', [100, 100, 800, 400]);
preamble_filtered = upsample_and_filter(preamble_symbols, rrc_h, sps);
plot(real(preamble_filtered), 'b-', 'LineWidth', 1.5);
hold on;
plot(imag(preamble_filtered), 'r-', 'LineWidth', 1.5);
xlabel('Отсчеты'); ylabel('Амплитуда, дБ');
title('Преамбула после RRC фильтрации');
legend('I-компонента', 'Q-компонента', 'Location', 'best');
grid on;

%% Дополнительная проверка: сравнение спектральных характеристик
figure('Position', [100, 100, 800, 400]);

% Частотная характеристика RRC фильтра
H_rrc = fftshift(fft(rrc_h, 1024));
freq_axis = linspace(-Fs/2, Fs/2, 1024);

subplot(2, 1, 1);
plot(freq_axis, 20*log10(abs(H_rrc)/max(abs(H_rrc)) + eps), 'r-', 'LineWidth', 1.5);
xlabel('Частота (Гц)'); ylabel('Амплитуда (дБ)');
title('АЧХ RRC фильтра');
grid on;
xlim([-Fs/2 Fs/2]);
ylim([-60 5]);

% Частотная характеристика Lowpass фильтра
H_lp = fftshift(fft(lowpass_h, 1024));

subplot(2, 1, 2);
plot(freq_axis, 20*log10(abs(H_lp)/max(abs(H_lp)) + eps), 'g-', 'LineWidth', 1.5);
xlabel('Частота (Гц)'); ylabel('Амплитуда (дБ)');
title('АЧХ Lowpass фильтра');
grid on;
xlim([-Fs/2 Fs/2]);
ylim([-60 5]);

fprintf('\nМоделирование завершено успешно!\n');
