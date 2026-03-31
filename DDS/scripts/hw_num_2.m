%% Задание 2 Исследование шага перестройки по частоте
Fclk = 100e6;
Nacc = [8 16 32 45 60]
dF = Fclk ./ (2 .^ Nacc);
dF_log = log10(dF);

figure(1);
plot(Nacc, dF);
figure(2);
plot(Nacc, dF_log);


