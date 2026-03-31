%%Task 1. Сalculation of the frequency tuning (phase increment) word
% for DDS and next parameters
clear; clc;
Fclk = 125e6;
Fout = [1e6 7.5e6 10e6 32e6]
Nacc = 24;

phase_mod = 2^Nacc;
% phase increment
ftw = round(Fout * phase_mod / Fclk);

% Расчет фактической выходной частоты
Fout_real = ftw * Fclk / 2^Nacc;

% Расчет ошибки
error = Fout_real - Fout;

% Вывод результатов в виде таблицы
fprintf('  Желаемая     FTW         Фактическая     Ошибка\n');
fprintf('  частота  (экспон.формат)   частота        (Гц)\n' );
fprintf('  [МГц]                       [МГц]\n'              );
fprintf('-------------------------------------------------------------\n');

for i = 1:length(Fout)
    fprintf('  %3.3f       %10.3e     %10.8f     %+8.3f\n', ...
            Fout(i)/1e6, ftw(i), Fout_real(i)/1e6, error(i));
end

fprintf('=============================================================\n\n');

% анализ
fprintf('  - Ошибка возникает из-за округления FTW до целого числа\n');

